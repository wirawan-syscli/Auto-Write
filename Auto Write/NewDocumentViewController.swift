//
//  ViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/23/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

protocol NewDocumentViewControllerDelegate {
    
    func NewDocumentWillNavigateToDashboard(newDocument: NewDocumentViewController)
}

// MARK: INIT
class NewDocumentViewController: UIViewController{

    @IBOutlet weak var textView: UITextView!
    
    var delegate: NewDocumentViewControllerDelegate?
    
    // CORE DATA
    var document: Documents!
    var questions: NSMutableOrderedSet = NSMutableOrderedSet()
    var question: Questions?
    var currentQuestion: Int = 1
    
    // NSOPERATION
    var operationQueue: NSOperationQueue!
    
    // VIEW
    var saveBarButtonItem: UIBarButtonItem!
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NewDocumentViewControllerPreparingSettingForNewQuestion()
        saveBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: Selector("textViewSaveEditing"))
        textView.delegate = self
        navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        delegate?.NewDocumentWillNavigateToDashboard(self)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func NewDocumentViewControllerPreparingSettingForNewQuestion() {
    
        navigationItem.title = "Question #\(currentQuestion)"
        textView.text = ""
        operationQueue = NSOperationQueue()
    }
}

// MARK: UIIMAGEPICKER
extension NewDocumentViewController: UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate{
    
    @IBAction func imagePickerUsingCamera(sender: AnyObject) {
        
        imagePickerInitWithType(.Camera)
    }
    
    @IBAction func imagePickerUsingPhotoLibrary(sender: AnyObject) {
        
        imagePickerInitWithType(.PhotoLibrary)
    }
    
    func imagePickerInitWithType(sourceType: UIImagePickerControllerSourceType) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismissViewControllerAnimated(true, completion: nil)
        navigationItem.rightBarButtonItem = nil
        performRecognizingText(image)
    }
    
}

// MARK: G8TESSERACTOCR & MBProgressHUD
extension NewDocumentViewController { //: G8TesseractDelegate {
    
    func performRecognizingText(image: UIImage) {
        
//        let imageBW = image.g8_blackAndWhite()
//        
//        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//        hud!.mode = .AnnularDeterminate
//        hud?.color = UIColor.orangeColor()
//        hud!.labelText = "Scanning.."
//        
//        autoreleasepool { () -> () in
//            var operation = G8RecognitionOperation(language: "eng+jpn")
//            operation.delegate = self
//            operation.tesseract.engineMode = G8OCREngineMode.TesseractOnly
//            operation.tesseract.pageSegmentationMode = G8PageSegmentationMode.AutoOnly
//            operation.tesseract.image = imageBW
//            operation.recognitionCompleteBlock = { (tesseract: G8Tesseract!) in
//                
//                // GUIDE_1: Go to below
//                self.performRecognizingTextIsCompleted(tesseract)
//                operation = nil
//            }
//            
//            operationQueue.addOperation(operation)
//        }
    }
    
//    // GUIDE_1: From top
//    func performRecognizingTextIsCompleted(tesseract: G8Tesseract) {
//        
//        hud!.hide(true)
//        
//        self.navigationItem.rightBarButtonItem = self.saveBarButtonItem
//        self.textView.text = tesseract.recognizedText
//        
//        // release unused object to reduce memory usage
//        G8Tesseract.clearCache()
//    }
//    
//    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
//        
//        return false
//    }
//    
//    func progressImageRecognitionForTesseract(tesseract: G8Tesseract!) {
//        
//        var progress: Float = Float(tesseract.progress) / 100.0
//        hud!.progress = progress;
//    }
}

// MARK: UITEXTVIEW
extension NewDocumentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        var doneEditingButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("textViewDoneEditing"))
        self.navigationItem.rightBarButtonItem = doneEditingButton
    }
    
    func textViewDoneEditing() {
        
        textView.resignFirstResponder()
        
        if count(textView.text) > 0 {
            navigationItem.rightBarButtonItem = saveBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func textViewSaveEditing() {
        
        if count(textView.text) > 0 {
            
            initObjectContext()
            
        } else {
            showAlert()
        }
    }
}

// MARK: OBJECT CONTEXT
extension NewDocumentViewController {
    
    func initObjectContext() {
        
        createObjectContext()
        
        if currentQuestion <= Int(document.totalQuestions) {
            self.showAlertBeforePresentingNewQuestion()
        } else {
            self.saveObjectContext()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func createObjectContext() {
        
        question = Questions.MR_createEntity()
        question?.id = IntDate.convert(NSDate())
        question?.documentId = document.id
        question?.text = textView.text
        questions.addObject(question!)
        
        self.currentQuestion++
    }
    
    func saveObjectContext() {
        
        document.questions = questions
        
        var defaultContext = NSManagedObjectContext.MR_defaultContext()
        defaultContext.MR_saveToPersistentStoreWithCompletion { (success: Bool, error: NSError!) -> Void in
            if success == true {
            } else if error != nil {
                self.showAlertFromCoreDataErrorBeforePresentingOldQuestion()
            }
        }
    }
    
}

// MARK: ALERT SETTINGS
extension NewDocumentViewController {
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Empty Question",
                                      message: "Please fill out the following Question",
                                      preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertBeforePresentingNewQuestion() {
        
        let alert = UIAlertController(title: "Question saved",
                                      message: "Question has been saved and preparing for next question form.\r Click OK to start.",
                                      preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in
            self.NewDocumentViewControllerPreparingSettingForNewQuestion()
        }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertFromCoreDataErrorBeforePresentingOldQuestion() {
        
        let alert = UIAlertController(title: "Question cannot be saved",
            message: "An error has occured so the question cannot be saved.  \rpreparing for new question form.\r Click OK to begin.",
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in
            self.currentQuestion--
            self.NewDocumentViewControllerPreparingSettingForNewQuestion()
        }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

