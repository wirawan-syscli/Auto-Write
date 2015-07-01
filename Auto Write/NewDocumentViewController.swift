//
//  ViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/23/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: INIT
class NewDocumentViewController: UIViewController{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!

    var saveBarButtonItem: UIBarButtonItem!
    var operationQueue: NSOperationQueue!
    var document: Document!
    var question: Question?
    var currentQuestion: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NewDocumentViewControllerPreparingSettingForNewQuestion()
        saveBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: Selector("textViewSaveEditing"))
        textView.delegate = self
        navigationItem.rightBarButtonItem = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func NewDocumentViewControllerPreparingSettingForOldQuestion() {
        currentQuestion--;
        NewDocumentViewControllerPreparingSettingForNewQuestion()
    }
    
    func NewDocumentViewControllerPreparingSettingForNewQuestion() {
        
        navigationItem.title = "Question #\(currentQuestion)"
        textView.text = ""
        loadingView.alpha = 0.0
        progressView.progress = 0.0
        operationQueue = NSOperationQueue()
    }
}

// MARK: UIIMAGEPICKER
extension NewDocumentViewController: UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate{
    
    @IBAction func imagePickerUsingCamera(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func imagePickerUsingPhotoLibrary(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismissViewControllerAnimated(true, completion: nil)
        navigationItem.rightBarButtonItem = nil
        performRecognizingText(image)
    }
    
}

// MARK: G8TESSERACTOCR
extension NewDocumentViewController: G8TesseractDelegate {
    
    func performRecognizingText(image: UIImage) {
        
        let imageBW = image.g8_blackAndWhite()
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.loadingView.alpha = 1.0
        })
        activityIndicator.startAnimating()
        
        autoreleasepool { () -> () in
            var operation = G8RecognitionOperation(language: "eng+jpn")
            operation.delegate = self
            operation.tesseract.engineMode = G8OCREngineMode.TesseractOnly
            operation.tesseract.pageSegmentationMode = G8PageSegmentationMode.AutoOnly
            operation.tesseract.image = imageBW
            operation.recognitionCompleteBlock = { (tesseract: G8Tesseract!) in
                
                // GUIDE_1: Go to below
                self.performRecognizingTextIsCompleted(tesseract)
                operation = nil
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    // GUIDE_1: From top
    func performRecognizingTextIsCompleted(tesseract: G8Tesseract) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.loadingView.alpha = 0.0
        })
        self.activityIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem = self.saveBarButtonItem
        self.textView.text = tesseract.recognizedText
        
        // release unused object to reduce memory usage
        self.operationQueue = nil
        G8Tesseract.clearCache()
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    func progressImageRecognitionForTesseract(tesseract: G8Tesseract!) {
        
        var progress: Float = Float(tesseract.progress) / 100.0
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.progressView.setProgress(progress, animated: true)
        })
    }
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
            question = Question(id: document.id, text: textView.text)
            if let question = self.question {
                if currentQuestion <= document.totalQuestions {
                    textViewPerformManageObjectContext()
                } else {
                    performSegueWithIdentifier("unwindFromNewDocument", sender: self)
                }
            } else {
                showAlert()
            }
        } else {
            showAlert()
        }
    }
    
    func textViewPerformManageObjectContext() {
        if let error = question?.save() {
            showAlertFromCoreDataErrorBeforePresentingOldQuestion()
        } else {
            self.document.questions.append(self.question!)
            currentQuestion++
            showAlertBeforePresentingNewQuestion()
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
    
    func showAlertFromCoreDataErrorBeforePresentingOldQuestion() {
        let alert = UIAlertController(title: "Could not saved question",
            message: "An error has occured. \r Resetting question.",
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction!) -> Void in
            self.NewDocumentViewControllerPreparingSettingForOldQuestion()
        }
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
}

