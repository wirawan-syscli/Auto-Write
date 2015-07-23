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
    var printPreviewPage: UIScrollView?
    
    var pagePreview: WSPagePreview?
    var sliderNavbar: WSSliderNavbar?
    
    var paperSizePicker = UIPickerView()
    var paperSizeOption = [(String, Double, Double)]()
    var horizontalSlider = UISlider()
    var verticalSlider = UISlider()
    var headerSwitch: UISwitch?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sliderNavbarContainer: UIScrollView!
    
    var currentOriginY: CGFloat = 0
    var hasNotPlayed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagePreview = WSPagePreview()
        pagePreview?.delegate = self
        initDefaultSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        pagePreview?.initDefaultSettings(scrollView)
    }
    
    func initDefaultSettings() {
        
        navigationItem.title = document?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("configurePrintingSettings"))
        
        let size = CGSizeMake(130.0, 60.0)
        let paperSize = WSSliderNavbar.createButtonWithImage(UIImage(named: "Page_size")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        let horizontalMargin = WSSliderNavbar.createButtonWithImage(UIImage(named: "Horizontal_margin")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        let verticalMargin = WSSliderNavbar.createButtonWithImage(UIImage(named: "Vertical_margin")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        let utility = WSSliderNavbar.createButtonWithImage(UIImage(named: "Header_include")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
    
        let buttons = [paperSize, horizontalMargin, verticalMargin, utility]
        
        sliderNavbar = WSSliderNavbar(size: size, scrollView: sliderNavbarContainer, buttons: buttons)
        
        addConfigToPaperSize()
        addConfigToHorizontalMargin()
        addConfigToVerticalMargin()
        addConfigToUtility()
    }
}

// MARK: UISCROLL + PRINT PAGE PREVIEW
extension PrintingViewController: UIScrollViewDelegate, WSPagePreviewDelegate {
    
    func WSPagePreviewSetTextContent(pagePreview: WSPagePreview) -> String {
        let question = document!.questions.firstObject as! Questions
        return question.text
    }
    
    func WSPagePreviewShowPageControl(pagePreview: WSPagePreview, pageControl: UIPageControl) {
        pageControl.currentPageIndicatorTintColor = ColorsPallete.orangeDark()
        pageControl.pageIndicatorTintColor = ColorsPallete.orangeLight()
        
        view.addSubview(pageControl)
    }
}

// MARK: PAPER SIZE OPTION
extension PrintingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func addConfigToPaperSize() {
        
        paperSizePicker.delegate = self
        paperSizePicker.dataSource = self
        
        paperSizeOption.append(("A3", 1122.519685039, 1591.181102362))
        paperSizeOption.append(("A4",  793.322834646, 1096.062992126))
        paperSizeOption.append(("A5",  559.748031496,  793.322834646))
        
        sliderNavbar!.insertCustomViewIntoItem(paperSizePicker, index: 0, color: ColorsPallete.orangeDark())
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
        let size = CGSize(width: paperWidth, height: paperHeight)
        
        pagePreview?.setPageSize(size)
    }
}

// MARK: HORIZONTAL MARGIN OPTION
extension PrintingViewController {
    
    func addConfigToHorizontalMargin() {
        
        // 0.1 cm = 3.779527559 px
        
        horizontalSlider.minimumValue = 0.0
        horizontalSlider.maximumValue = 5.0
        horizontalSlider.value = 0.0
        horizontalSlider.addTarget(self, action: Selector("horizontalSliderValueChanged:"), forControlEvents: .ValueChanged)
        
        sliderNavbar!.insertCustomViewIntoItem(horizontalSlider, index: 1, color: ColorsPallete.orangeDark())
    }
    
    func horizontalSliderValueChanged(sender: UISlider) {
        
        let centimeters = sender.value
        let pixels = CGFloat(centimeters * 37.79527559)
        
        setPrintPreviewPageHorizontalMargin(pixels)
    }
    
    func setPrintPreviewPageHorizontalMargin(pixels: CGFloat) {
        
        pagePreview?.setPageMarginHorizontally(pixels, right: pixels)
    }
}

// MARK: VERTICAL MARGIN OPTION
extension PrintingViewController {
    
    func addConfigToVerticalMargin() {
        
        // 0.1 cm = 3.779527559 px
        
        verticalSlider.minimumValue = 0.0
        verticalSlider.maximumValue = 5.0
        verticalSlider.value = 2.0
        verticalSlider.addTarget(self, action: Selector("verticalSliderValueChanged:"), forControlEvents: .ValueChanged)
        
        sliderNavbar!.insertCustomViewIntoItem(verticalSlider, index: 2, color: ColorsPallete.orangeDark())
    }
    
    func verticalSliderValueChanged(sender: UISlider) {
        
        let centimeters = sender.value
        let pixels = CGFloat(centimeters * 37.79527559)
        
        setPrintPreviewPageVerticalMargin(pixels)
    }
    
    func setPrintPreviewPageVerticalMargin(pixels: CGFloat) {
        pagePreview?.setPageMarginVertically(pixels, bottom: pixels)
    }
}

// MARK: UTILITY OPTION
extension PrintingViewController {
    
    func addConfigToUtility() {
        
        headerSwitch = UISwitch(frame: CGRectMake(10.0, 15.0, 50.0, 60.0))
        headerSwitch?.on = false
        
        let headerLabel = UILabel(frame: CGRectMake(headerSwitch!.frame.origin.x + headerSwitch!.frame.width + 10.0, 0.0, 140.0, 60.0))
        headerLabel.text = "Include header"
        
        let headerView = UIView(frame: CGRectMake(0.0, 0.0, 210.0, 60.0))
        headerView.addSubview(headerSwitch!)
        headerView.addSubview(headerLabel)
        
        sliderNavbar!.insertCustomViewIntoItem(headerView, index: 3, color: ColorsPallete.orangeDark())
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
        })
    }

    func printInteractionControllerWillStartJob(printInteractionController: UIPrintInteractionController) {
        
        println("printing start")
    }
    
    func printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController) {
        
        println("printing stop")
    }
}
