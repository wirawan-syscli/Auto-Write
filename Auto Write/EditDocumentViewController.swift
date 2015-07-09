//
//  EditDocumentViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/6/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: CLASS INIT
class EditDocumentViewController: UIViewController {
    
    var document: Documents!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    var currentTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.text = document.title
        subjectTextField.text = document.subject
        
        titleTextField.delegate = self
        subjectTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITEXTFIELD
extension EditDocumentViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func viewDidTapped(sender: AnyObject) {
        currentTextField?.resignFirstResponder()
    }
    
}

// MARK: SEGUE
extension EditDocumentViewController {
    
    @IBAction func didPressUpdateDocumentButton(sender: AnyObject) {
        document.title = titleTextField.text
        document.subject = subjectTextField.text
        
        let defaultContext = NSManagedObjectContext.MR_defaultContext()
        defaultContext.MR_saveToPersistentStoreWithCompletion { (success: Bool, error: NSError!) -> Void in
            if !success {
                self.showErrorFromUpdatingDocument()
            }
            self.performSegueWithIdentifier("unwindFromEditDocument", sender: self)
        }
        
    }
}

// MARK: ALERT
extension EditDocumentViewController {
    
    func showErrorFromUpdatingDocument() {
        let alert = UIAlertController(title: "Cannot Update Document", message: "An error has occcured and the system could not updated the document, please try again", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}