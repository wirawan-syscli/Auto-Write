//
//  ShowDocumentDetailViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/25/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit
import Parse

// MARK: INIT
class ShowDocumentDetailViewController: UIViewController {

    var document: Documents!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var totalQuestionsLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var hud: MBProgressHUD?
    
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
        
        let RGBColor = CGFloat(220.0 / 255.0)
        let borderColor = UIColor(red: RGBColor, green: RGBColor, blue: RGBColor, alpha: 1.0).CGColor
        cell.layer.borderColor = borderColor
        cell.layer.borderWidth = 0.5
        
        let question = document.questions.objectAtIndex(indexPath.row) as! Questions
        cell.questionTextView.text = question.text
        cell.numberLabel.text = numberFormat
        cell.backgroundColor = UIColor(red: 240.0, green: 240.0, blue: 240.0, alpha: 1)
        cell.questionTextView.tag = indexPath.row
        
        // saving textview into dictionary
        textViews[indexPath] = cell.questionTextView
        cell.questionTextView.delegate = self
        
        return cell
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let height = textViewHeightForRowAt(indexPath)
//        
//        if(textViewsHeight[indexPath] == nil || textViewsHeight[indexPath] < height) {
//            textViewsHeight[indexPath] = height
//        }
//        
//        return textViewsHeight[indexPath]!
//    }
//    
//    func textViewHeightForRowAt(indexPath: NSIndexPath) -> CGFloat {
//        var textView: UITextView? = textViews[indexPath]
//        var textViewWidth: CGFloat = 346.0
//        var textViewHeight: CGFloat = CGFloat(FLT_MAX)
//        if textView?.attributedText != nil {
//            textViewWidth = textView!.frame.size.width
//            textViewHeight = textView!.frame.size.height
//        }else {
//            textView = UITextView()
//            let question = document.questions.objectAtIndex(indexPath.row) as! Questions
//            let attributedText = NSAttributedString(string: question.text)
//            textView!.attributedText = attributedText
//            textViewWidth = 346
//        }
//
//        let size: CGSize = textView!.sizeThatFits(CGSize(width: textViewWidth, height: textViewHeight))
//        return size.height
//    }
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
//      document.question.text = currentTextView!.text as String
//        if let error = document.question.update(indexPath) {
//            showAlertFromCoreDataErrorFromQuestion()
//        }
        
        currentTextView = nil
    }
}

// MARK: SAVE TO DATABASE SERVER
extension ShowDocumentDetailViewController {
    
    @IBAction func documentDetailViewWillSaveDocumentIntoDatabase(sender: AnyObject) {
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud!.mode = .AnnularDeterminate
        hud!.labelText = "Uploading.."
        
        let PFDocument = PFObject(className: "Documents")
        PFDocument["documentId"] = document.id
        PFDocument["title"] = document.title
        PFDocument["subject"] = document.subject
        PFDocument["grade"] = document.grade
        PFDocument["totalQuestions"] = document.totalQuestions

        documentDetailViewWillSaveQuestionsIntoDatabase(PFDocument)
    }
    
    func documentDetailViewWillSaveQuestionsIntoDatabase(PFDocument: PFObject) {
        
        let totalQuestions: Int = Int(document.totalQuestions) - 1
        for index in 0...totalQuestions {
            
            hud!.progress = Float(index / totalQuestions);
            
            let PFQuestion = PFObject(className: "Questions")
            PFQuestion["questionId"] = document.questions[index].id
            PFQuestion["documentId"] = document.id
            PFQuestion["text"] = document.questions[index].text
            PFQuestion["parent"] = PFDocument
            PFQuestion.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    self.hud!.hide(true)
                    self.showAlertWithSuccessNotification()
                } else {
                    self.showAlertWithFailureNotification()
                }
            })
        }
    }
}

// MARK: ALERT SETTINGS
extension ShowDocumentDetailViewController {
    
    func showAlertWithSuccessNotification() {
        
        let alert = UIAlertController(title: "Upload Successfully", message: "Document uploaded successfully to the server.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertWithFailureNotification() {
        
        let alert = UIAlertController(title: "Upload Failure", message: "Document cannot be uploaded, \r please try again.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertFromCoreDataErrorFromQuestion(){
        
        let alert = UIAlertController(title: "Cannot be saved into database", message: "An error has occured when trying to communicate with the application database.", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
