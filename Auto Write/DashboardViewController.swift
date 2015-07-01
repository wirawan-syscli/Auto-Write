//
//  DashboardViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/24/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {

    var documents: [Document] = Array()
    
    @IBOutlet weak var newDocumentView: UIView!
    @IBOutlet weak var showDocumentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUIGestureRecognizer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext!
        
        if let documents = dashboardViewControllerPerformDocumentFetchRequest(manageContext) {
            self.documents = documents
            
            if let questions = dashboardViewControllerPerformQuestionFetchRequest(manageContext) {
                
                for question in questions {
                    for var index = 0; index < self.documents.count; index++ {
                        var document = self.documents[index] as Document
                        if question.id == document.id {
                            self.documents[index].questions.append(question)
                        }
                    }
                }
            } else {
                showAlertFromCoreDataErrorBeforePresentingNewQuestion()
            }
        } else {
            showAlertFromCoreDataErrorBeforePresentingNewDocument()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DashboardViewController  {
    
    func dashboardViewControllerPerformDocumentFetchRequest(manageContext: NSManagedObjectContext) -> [Document]? {
        let fetchRequest = NSFetchRequest(entityName: "Document")
        
        var error: NSError?
        let fetchResult = manageContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let results = fetchResult {
            var documents: [Document] = Array()
            for result in results {
                var id = result.valueForKey("id") as! NSDate
                var title = result.valueForKey("title") as! String
                var subject = result.valueForKey("subject") as! String
                var grade = result.valueForKey("grade") as! Int
                var totalQuestions = result.valueForKey("totalQuestions") as! Int
                
                var document = Document(id: id, title: title, subject: subject, grade: grade, totalQuestions: totalQuestions)
                documents.append(document)
            }
            return documents
        }
        
        return nil
    }
    
    func dashboardViewControllerPerformQuestionFetchRequest(manageContext: NSManagedObjectContext) -> [Question]? {
        let fetchRequest = NSFetchRequest(entityName: "Question")
        
        var error: NSError?
        let fetchResult = manageContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let results = fetchResult {
            var questions: [Question] = Array()
            for result in results {
                var id = result.valueForKey("id") as! NSDate
                var text = result.valueForKey("text") as! String
                
                var question = Question(id: id, text: text)
                questions.append(question)
            }
            return questions
        }
        
        return nil
    }
}


extension DashboardViewController: UIGestureRecognizerDelegate {
    
    func initUIGestureRecognizer() {
        initTapGestureRecognitionForNewDocument()
        initTapGestureRecognitionForShowDocument()
    }
    
    func initTapGestureRecognitionForNewDocument() {
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("performTapGestureOnNewDocument:"))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        newDocumentView.addGestureRecognizer(tapGesture)
    }
    
    func performTapGestureOnNewDocument(recognizer: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("showNewDocumentSettings", sender: self)
    }
    
    func initTapGestureRecognitionForShowDocument() {
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("performTapGestureonShowDocument:"))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        showDocumentView.addGestureRecognizer(tapGesture)
    }
    
    func performTapGestureonShowDocument(recognizer: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("showListDocument", sender: self)
    }
}

extension DashboardViewController {
    
    @IBAction func unwindFromNewDocument(segue: UIStoryboardSegue) {
        
        let source: NewDocumentViewController = segue.sourceViewController as! NewDocumentViewController
        documents.append(source.document!)
    }
}

extension DashboardViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showListDocument" {
            let destination: ShowDocumentTableViewController = segue.destinationViewController as! ShowDocumentTableViewController
            destination.documents = documents
        }
    }
}

extension DashboardViewController {
    
    func showAlertFromCoreDataErrorBeforePresentingNewDocument() {
        let alert = UIAlertController(title: "Could not retrieved document",
            message: "An error has occured. \r Preparing blank document.",
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertFromCoreDataErrorBeforePresentingNewQuestion() {
        let alert = UIAlertController(title: "Could not retrieved question",
            message: "An error has occured. \r Preparing blank question.",
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}