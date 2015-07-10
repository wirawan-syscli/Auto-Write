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
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, tableView.numberOfSections())), withRowAnimation: .None)
        
        titleLabel.text = document.title
        subjectLabel.text = document.subject
        totalQuestionsLabel.text = "\(document.totalQuestions) Question"
        gradeLabel.text = "Grade \(document.grade)"
        
        initNotificationSettings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
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
}

// MARK: NSNOTIFICATION CENTER
extension ShowDocumentDetailViewController {
    
    func initNotificationSettings() {
        
        let event = NSNotificationCenter.defaultCenter()
        event.addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        event.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let info: [NSObject: AnyObject] = notification.userInfo!
        
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! Int
        
        let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        var aRect = tableView.frame
        let activeField = currentTextView?.frame.origin
        aRect.size.height -= keyboardFrame.size.height
        if !CGRectContainsPoint(aRect, activeField!) {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: currentIndex!, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: UITEXTVIEW
extension ShowDocumentDetailViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        currentIndex = textView.tag
        currentTextView = textView
        
        var doneEditingButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("textViewDoneEditing"))
        navigationItem.rightBarButtonItem = doneEditingButton
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        currentTextView = textView
    }
    
    func textViewDoneEditing() {
        currentTextView?.resignFirstResponder()
        
        dataSavedIntoObjectContext()
        
        navigationItem.rightBarButtonItem = nil
        currentTextView = nil
        
    }
}

// MARK: CORE DATA
extension ShowDocumentDetailViewController {
    
    func dataSavedIntoObjectContext() {
        let indexPath = self.currentTextView!.tag
        let question = document.questions[indexPath] as! Questions
        let currentTextView = self.currentTextView?.text
        println(currentTextView)
        question.text = currentTextView!
        
        let defaultContext = NSManagedObjectContext.MR_defaultContext()
        defaultContext.MR_saveToPersistentStoreWithCompletion { (success: Bool, error: NSError!) -> Void in
            if !success {
                self.showAlertFromCoreDataErrorFromQuestion()
            }
        }
    }
    
    @IBAction func documentDetailViewWillSaveDocumentIntoDatabase(sender: AnyObject) {
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud!.mode = .AnnularDeterminate
        hud?.color = UIColor.orangeColor()
        hud!.labelText = "Uploading.."
        
        let predicate = NSPredicate(format: "documentId = \(document.id)")
        let query = PFQuery(className: "Documents", predicate: predicate)
        let results = query.findObjects()
        
        if results?.count == 0 {
            createDataIntoDatabase()
        } else {
            let PFDocument = results?.last as! PFObject
            updateDataIntoDatabase(PFDocument)
        }
    }
}

// MARK: CREATE NEW OBJECT TO DATABASE
extension ShowDocumentDetailViewController {
    
    func createDataIntoDatabase() {
        let PFDocument = createDocumentAndSaveIntoDatabase()
        createQuestionsAndSaveIntoDatabase(PFDocument)
    }
    
    func createDocumentAndSaveIntoDatabase() -> PFObject {
        
        let PFDocument = PFObject(className: "Documents")
        PFDocument["documentId"] = document.id
        PFDocument["title"] = document.title
        PFDocument["subject"] = document.subject
        PFDocument["grade"] = document.grade
        PFDocument["totalQuestions"] = document.totalQuestions
        
        return PFDocument
    }
    
    func createQuestionsAndSaveIntoDatabase(PFDocument: PFObject) {
        
        let totalQuestions = Int(document.totalQuestions)
        for index in 0..<totalQuestions {
            
            var indexProgress = index + 1
            hud!.progress = Float( indexProgress / totalQuestions )
            
            let PFQuestion = PFObject(className: "Questions")
            let question = document.questions[index] as! Questions
            PFQuestion["questionId"] = question.id
            PFQuestion["documentId"] = document.id
            PFQuestion["text"] = question.text
            PFQuestion["parent"] = PFDocument
            
            PFQuestion.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success{
                    if indexProgress == totalQuestions {
                        self.hud!.hide(true)
                        self.showAlertWithSuccessNotification()
                    }
                } else {
                    self.showAlertWithFailureNotification()
                }
            })
        }
    }
}

// MARK: UPDATE OLD OBJECT TO DATABASE
extension ShowDocumentDetailViewController {
    
    func updateDataIntoDatabase(PFDocument: PFObject) {
        
        let documentId = PFDocument["documentId"] as! Int
        
        let predicate = NSPredicate(format: "documentId = \(documentId)")
        let query = PFQuery(className: "Documents", predicate: predicate)
        var error: NSError?
        let results = query.findObjects(&error)
        
        if error != nil {
            println(error?.userInfo)
        } else {
            let PFDocument = results?.first as! PFObject
            PFDocument["title"] = document.title
            PFDocument["subject"] = document.subject
            
            PFDocument.save(&error)
            if error != nil {
                println(error?.userInfo)
            }
        }
        
        let totalQuestions = Int(document.totalQuestions)
        let questions = document.questions
        for index in 0..<totalQuestions {
            
            var indexProgress = index + 1
            hud!.progress = Float( indexProgress / totalQuestions )
            
            let question = questions[index] as! Questions
            let questionId = question.id as! Int
            
            let predicate = NSPredicate(format: "questionId = \(questionId)")
            let query = PFQuery(className: "Questions", predicate: predicate)
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                
                let PFQuestion = results?.first as! PFObject
                PFQuestion["text"] = questions[index].text
                
                PFQuestion.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        if indexProgress == totalQuestions {
                            self.hud!.hide(true)
                            self.showAlertWithSuccessNotification()
                        }
                    } else {
                        self.showAlertWithFailureNotification()
                    }
                })
            })
        }
    }
}

// MARK: ALERT SETTINGS
extension ShowDocumentDetailViewController {
    
    func showAlertWithSuccessNotification() {
        
        let alert = UIAlertController(title: "Upload Successfully", message: "Document uploaded successfully to the database server.", preferredStyle: UIAlertControllerStyle.Alert)
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
