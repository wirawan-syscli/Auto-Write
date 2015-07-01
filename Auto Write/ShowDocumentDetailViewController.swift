//
//  ShowDocumentDetailViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/25/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: INIT
class ShowDocumentDetailViewController: UIViewController {

    var document: Document!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var totalQuestionsLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    // Custom View
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalUploadItems = 0
    var uploadedItems = 0
    var textViews = [NSIndexPath: UITextView]()
    var textViewsHeight = [NSIndexPath: CGFloat]()
    var currentTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        titleLabel.text = document.title
        subjectLabel.text = document.subject
        totalQuestionsLabel.text = "\(document.totalQuestions) Question"
        gradeLabel.text = "Grade \(document.grade)"
        loadingView.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //tableView.reloadData()
        //tableView.setNeedsLayout()
        //tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: TABLE VIEW DATA SOURCE
extension ShowDocumentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ShowDocumentDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as! ShowDocumentDetailTableViewCell
        let number = indexPath.row + 1
        let numberFormat = NSString(format: "%02d", number ) as String + "."
        
        cell.questionTextView.text = document.questions[indexPath.row].text
        cell.numberLabel.text = numberFormat
        cell.backgroundColor = UIColor(red: 240.0, green: 240.0, blue: 240.0, alpha: 1)
        cell.questionTextView.tag = indexPath.row
        
        // saving textview into dictionary
        textViews[indexPath] = cell.questionTextView
        cell.questionTextView.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = textViewHeightForRowAt(indexPath)
        
        if(textViewsHeight[indexPath] == nil || textViewsHeight[indexPath] < height) {
            textViewsHeight[indexPath] = height
        }
        
        return textViewsHeight[indexPath]!
    }
    
    func textViewHeightForRowAt(indexPath: NSIndexPath) -> CGFloat {
        var textView: UITextView? = textViews[indexPath]
        var textViewWidth: CGFloat = 346.0
        var textViewHeight: CGFloat = CGFloat(FLT_MAX)
        if textView?.attributedText != nil {
            textViewWidth = textView!.frame.size.width
            textViewHeight = textView!.frame.size.height
        }else {
            textView = UITextView()
            let attributedText = NSAttributedString(string: document.questions[indexPath.row].text)
            textView!.attributedText = attributedText
            textViewWidth = 346
        }

        let size: CGSize = textView!.sizeThatFits(CGSize(width: textViewWidth, height: textViewHeight))
        return size.height
    }
}

// MARK: UITEXTVIEW
extension ShowDocumentDetailViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        currentTextView = textView
        
        var doneEditingButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("textViewDoneEditing"))
        navigationItem.rightBarButtonItem = doneEditingButton
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
    }
    
    // MARK: UPDATE DATA INTO COREDATA
    func textViewDoneEditing() {
        navigationItem.rightBarButtonItem = nil
        
        currentTextView?.resignFirstResponder()
        
        let indexPath = currentTextView!.tag
        document.questions[indexPath].text = currentTextView!.text as String
        if let error = document.questions[indexPath].update(indexPath) {
            showAlertFromCoreDataErrorFromQuestion()
        }
        
        currentTextView = nil
    }
}

// MARK: SAVE TO DATABASE SERVER
extension ShowDocumentDetailViewController: AWSDynamoDBDelegate {
    
    @IBAction func documentDetailViewWillSaveDocumentIntoDatabase(sender: AnyObject) {
        let document = DocumentDB(document: self.document)
        
        var database = AWSDynamoDB()
        database.delegate = self
        database.save(document)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.loadingView.alpha = 1.0
        })
        activityIndicator.startAnimating()
        
        documentDetailViewWillSaveQuestionsIntoDatabase()
    }
    
    func documentDetailViewWillSaveQuestionsIntoDatabase() {
        totalUploadItems = document.questions.count + 1
        
        for var index = 0; index < document.questions.count; index++ {
            let question = QuestionDB(question: document.questions[index], currentQuestion: index)
            
            var database = AWSDynamoDB()
            database.delegate = self
            database.save(question)
        }
    }
    
    func AWSDynamoDBDidFailedToSaveData(database: AWSDynamoDB) {
        showAlertWithFailureNotification()
    }
    
    func AWSDynamoDBDidSuccessToSaveData(database: AWSDynamoDB) {
        uploadedItems++
        let currentProgress = Float(uploadedItems / totalUploadItems)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.progressView.setProgress(currentProgress, animated: true)
        })
        
        if uploadedItems == totalUploadItems {
            showAlertWithSuccessNotification()
        }
    }
}

// MARK: ALERT SETTINGS
extension ShowDocumentDetailViewController {
    
    func showAlertWithSuccessNotification() {
        
        let alert = UIAlertController(title: "Upload Successfully", message: "Document uploaded successfully to the server.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in self.showAlertWillDissapear() }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertWithFailureNotification() {
        
        let alert = UIAlertController(title: "Upload Failure", message: "Document cannot be uploaded, \r please try again.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in self.showAlertWillDissapear() }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertWillDissapear() {
        activityIndicator.stopAnimating()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.loadingView.alpha = 0.0
        })
    }
    
    func showAlertFromCoreDataErrorFromQuestion(){
        
        let alert = UIAlertController(title: "Cannot be saved into database", message: "An error has occured when trying to communicate with the application database.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in self.showAlertWillDissapear() }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
