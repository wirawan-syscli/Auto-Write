//
//  PrintingViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/16/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: CLASS INIT
class PrintingViewController: UIViewController {

    var document: Documents?
    var printPreviewPage: UIView?
    var paperSizeOption = [(String, Double, Double)]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var configPicker: UIPickerView!
    @IBOutlet weak var paperSizeOptionView: UIView!
    @IBOutlet weak var paperSizePicker: UIPickerView!
    
    var currentOriginY: CGFloat = 0
    var hasNotPlayed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDefaultSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        if hasNotPlayed {
            initPrintPreview("A4",  paperWidth: 793.322834646, paperHeight: 1096.062992126)
            hasNotPlayed = false
        }
    }
    
    func initDefaultSettings() {
        
        navigationItem.title = document?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("configurePrintingSettings"))
        
        initTapGestureRecognition()
        initPaperSizeOption()
    }
}

// MARK: UISCROLL + PRINT PAGE PREVIEW
extension PrintingViewController: UIScrollViewDelegate {
    
    func initPrintPreview(paperType: String, paperWidth: Double, paperHeight: Double) {
        
        if let lastPreviewPage = printPreviewPage {
            lastPreviewPage.removeFromSuperview()
        }
        
        printPreviewPage = UIView(frame: CGRectMake(0.0, 0.0, CGFloat(paperWidth), CGFloat(paperHeight)))
        printPreviewPage?.backgroundColor = UIColor.whiteColor()
        
        scrollView.addSubview(printPreviewPage!)
        scrollView.contentSize = printPreviewPage!.frame.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        
        initContent()
        setCenterPositionToPreviewPage()
        insertShadowToPreviewPage()
    }
    
    func initContent() {
        for question in document!.questions {
            currentOriginY = insertContentToPreviewPage(question as! Questions, currentOriginY: currentOriginY)
        }
        currentOriginY = 0.0
    }
    
    func insertContentToPreviewPage(question: Questions, currentOriginY: CGFloat) -> CGFloat {
        
        let textLabel = UILabel(frame: CGRectMake(20.0, currentOriginY + 20.0, printPreviewPage!.frame.width, printPreviewPage!.frame.height))
        textLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.text = question.text
        textLabel.sizeToFit()
        printPreviewPage?.addSubview(textLabel)
        
        return textLabel.frame.origin.y + textLabel.frame.height
    }
    
    func setCenterPositionToPreviewPage() {
        
        let boundsSize = scrollView.bounds.size
        var contentsFrame = printPreviewPage!.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        printPreviewPage!.frame = contentsFrame
    }
    
    func insertShadowToPreviewPage() {
        
        let shadow = UIBezierPath(rect: printPreviewPage!.bounds)
        printPreviewPage!.layer.masksToBounds = false
        printPreviewPage!.layer.shadowColor = UIColor.darkGrayColor().CGColor
        printPreviewPage!.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        printPreviewPage!.layer.shadowOpacity = 0.25
        printPreviewPage!.layer.shadowPath = shadow.CGPath
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return printPreviewPage
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        setCenterPositionToPreviewPage()
    }
}

// MARK: GESTURE RECOGNITION
extension PrintingViewController {
    
    func initTapGestureRecognition() {
    
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
    
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
    
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.locationInView(printPreviewPage)
        
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
}

// MARK: PAPER SIZE OPTION
extension PrintingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func initPaperSizeOption() {
        
        paperSizeOption.append(("A3", 1122.519685039, 1591.181102362))
        paperSizeOption.append(("A4",  793.322834646, 1096.062992126))
        paperSizeOption.append(("A5",  559.748031496,  793.322834646))
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return paperSizeOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let (paperType, _, _) = paperSizeOption[row]
        
        return paperType
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let (paperType, paperWidth, paperHeight) = paperSizeOption[row]
        
        initPrintPreview(paperType, paperWidth: paperWidth, paperHeight: paperHeight)
    }
}

// MARK: PRINTING
extension PrintingViewController: UIPrintInteractionControllerDelegate {
    
    func configurePrintingSettings() {
        
        let printObject = UIPrintInteractionController.sharedPrintController()
        let printInfo = UIPrintInfo.printInfo()
        let content = document?.questions.firstObject as! Questions
        let printFormatter = UISimpleTextPrintFormatter(text: content.text)
        
        printObject?.printInfo = printInfo
        printObject?.printFormatter = printFormatter
        printObject?.delegate = self
        
        printObject?.presentAnimated(true, completionHandler: { (printObject: UIPrintInteractionController!, success: Bool, error: NSError!) -> Void in
            if success {
                println("printing success")
            } else if (error != nil){
                println("printing error: \(error.userInfo)")
            }
            
            println(printObject)
        })
    }

    func printInteractionControllerWillStartJob(printInteractionController: UIPrintInteractionController) {
        
        println("printing start")
    }
    
    func printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController) {
        
        println("printing stop")
    }
}
