//
//  NewDocumentSettingsTableViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/24/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: INIT
class NewDocumentSettingsTableViewController: UITableViewController {
    
    var document: Documents?
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var totalQuestionsLabel: UILabel!
    @IBOutlet weak var gradeStepper: UIStepper!
    @IBOutlet weak var totalQuestionsStepper: UIStepper!
    
    var gradeValue: Int = 1
    var totalQuestionsValue: Int = 1
    var textFieldHolder: UITextField?
    var currentQuestion: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.delegate = self
        titleLabel.borderStyle = .None
        subjectLabel.delegate = self
        subjectLabel.borderStyle = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetAllSettings() {
        
        titleLabel.text = ""
        subjectLabel.text = ""
        gradeStepper.value = 1
        gradeLabel.text = "1"
        totalQuestionsStepper.value = 1
        totalQuestionsLabel.text = "1"
    }
}

// MARK: NEWDOCUMENT VIEW DELEGATE
extension NewDocumentSettingsTableViewController: NewDocumentViewControllerDelegate {
    
    func NewDocumentWillNavigateToDashboard(newDocument: NewDocumentViewController) {
        
        resetAllSettings()
        tabBarController?.selectedIndex = 0
    }
}

// MARK: UITEXTFIELD
extension NewDocumentSettingsTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textFieldHolder = textField
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func viewDidTapped(sender: AnyObject) {
        if let textField = textFieldHolder {
            textField.resignFirstResponder()
        }
    }
}

// MARK: UISTEPPER
extension NewDocumentSettingsTableViewController {
    
    @IBAction func UIStepperUpdateGradeValue(sender: AnyObject) {
        let stepper = sender as! UIStepper
        gradeValue = Int(stepper.value)
        gradeLabel.text = "\(gradeValue)"
        
    }
  
    @IBAction func UIStepperUpdateTotalQuestionsValue(sender: AnyObject) {
        let stepper = sender as! UIStepper
        totalQuestionsValue = Int(stepper.value)
        totalQuestionsLabel.text = "\(totalQuestionsValue)"
    }
    
}

// MARK: PRESENTING DESTINATION VIEW CONTROLLER
extension NewDocumentSettingsTableViewController {
    
    @IBAction func NewDocumentSettingsWillPresentNewDocumentViewController(sender: AnyObject) {
        
        if count(titleLabel.text)   > 0 && count(subjectLabel.text) > 0 &&
           gradeValue               > 0 && totalQuestionsValue      > 0 {
            
            document = Documents.MR_createEntity()
            document?.id = IntDate.convert(NSDate())
            document?.title = titleLabel.text
            document?.subject = subjectLabel.text
            document?.grade = gradeValue
            document?.totalQuestions = totalQuestionsValue
            
            NewDocumentSettingsIsPresentingNewDocumentViewController()

        } else {
            showAlert()
        }
    }
    
    func NewDocumentSettingsIsPresentingNewDocumentViewController() {
        
        self.performSegueWithIdentifier("showNewDocument", sender: self)
    }
}

// MARK: SEGUE SETTINGS
extension NewDocumentSettingsTableViewController {
    
    // FIXME: SEGUE ERROR
    // Unbalanced calls to begin/end appearance transitions for <Auto_Write.NewDocumentSettingsTableViewController: 0x14d502f90>.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNewDocument" {
            let navigation: UINavigationController = segue.destinationViewController as! UINavigationController
            let source: NewDocumentViewController = navigation.topViewController as! NewDocumentViewController
            source.delegate = self
            source.document = document
        }
    }
}

// MARK: ALERT SETTINGS
extension NewDocumentSettingsTableViewController {
    
    func showAlert() {
        let alert = UIAlertController(title: "Incomplete Form",
                                      message: "Please fill out the following form",
                                      preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
