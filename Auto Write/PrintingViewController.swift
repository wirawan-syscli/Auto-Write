//
//  PrintingViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/16/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

enum GuidelineColor {
    
    case DefaultColor, HighlightedColor
    
    mutating func change() {
        switch self {
        case DefaultColor:
            self = HighlightedColor
        case HighlightedColor:
            self = DefaultColor
        }
    }
}

// MARK: CLASS INIT
class PrintingViewController: UIViewController {

    var document: Documents?
    var printPreviewPage: UIScrollView?
    
    var pagePreview: WSPagePreview?
    var sliderNavbar: WSSliderNavbar?
    
    var pageText: NSTextContainer?
    var paperSizePicker = UIPickerView()
    var paperSizeOption = [(String, Double, Double)]()
    var horizontalSlider = UISlider()
    var verticalSlider = UISlider()
    var guidelineColor = GuidelineColor.HighlightedColor
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
        //pagePreview?.setPageSize(CGSize(width: 500.0, height: 500.0))
    }
    
    func initDefaultSettings() {
        
        navigationItem.title = document?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("configurePrintingSettings"))
        
        initSliderNavbar()
    }
}

// MARK: WSPAGEPREVIEW
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

// MARK: WSSLIDERNAVBAR
extension PrintingViewController: WSSliderNavbarDelegate {
    
    func initSliderNavbar() {
        
        let size = CGSizeMake(130.0, 60.0)
        let paperSize = WSSliderNavbar.createButtonWithImage(UIImage(named: "Page_size")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        let horizontalMargin = WSSliderNavbar.createButtonWithImage(UIImage(named: "Horizontal_margin")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        let verticalMargin = WSSliderNavbar.createButtonWithImage(UIImage(named: "Vertical_margin")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        let utility = WSSliderNavbar.createButtonWithImage(UIImage(named: "Header_include")!, color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        
        let buttons = [paperSize, horizontalMargin, verticalMargin, utility]
        
        sliderNavbar = WSSliderNavbar(size: size, scrollView: sliderNavbarContainer, buttons: buttons)
        sliderNavbar?.delegate = self
        
        addConfigToPaperSize()
        addConfigToHorizontalMargin()
        addConfigToVerticalMargin()
        addConfigToUtility()
    }
    
    func WSSliderNavbarSubMenuWillShow(sliderNavbar: WSSliderNavbar, index: Int) {
        
        var color = UIColor.lightGrayColor().CGColor
        
        switch guidelineColor {
        case .DefaultColor:
            
            switch index {
            case 1:
                pagePreview?.setGuidelinesHighlightTintColor(WSGuidelineArea.Top, color: color)
                break
            case 2:
                pagePreview?.setGuidelinesHighlightTintColor(WSGuidelineArea.Left, color: color)
                break
            default:
                break
            }
            break
        case .HighlightedColor:
            
            color = ColorsPallete.orangeDark().CGColor
            
            switch index {
            case 1:
                pagePreview?.setGuidelinesHighlightTintColor(WSGuidelineArea.Top, color: color)
                break
            case 2:
                pagePreview?.setGuidelinesHighlightTintColor(WSGuidelineArea.Left, color: color)
                break
            default:
                break
            }
            break
        }
        
        guidelineColor.change()
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
        let pageMargin = pagePreview?.getMetricUnit()
        
        showPageMarginInUnitMetrics(pageMargin!)
    }
    
    func showPageMarginInUnitMetrics(margin: UIEdgeInsets) {
        
        let marginTop = String(format: "%.2f", margin.top)
        let marginLeft = String(format: "%.2f", margin.left)
        let marginBottom = String(format: "%.2f", margin.bottom)
        let marginRight = String(format: "%.2f", margin.right)
        
        println("margin: \(marginTop)cm, \(marginLeft)cm, \(marginBottom)cm, \(marginRight)cm")
    }
}

// MARK: VERTICAL MARGIN OPTION
extension PrintingViewController {
    
    func addConfigToVerticalMargin() {
        
        // 0.1 cm = 3.779527559 px
        
        verticalSlider.minimumValue = 0.0
        verticalSlider.maximumValue = 5.0
        verticalSlider.value = 0.0
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
        let pageMargin = pagePreview?.getMetricUnit()
        
        showPageMarginInUnitMetrics(pageMargin!)
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
        
        let printFormatter = pagePreview!.pagesPrint.first!.viewPrintFormatter()
        
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
    
    func printInteractionController(printInteractionController: UIPrintInteractionController, choosePaper paperList: [AnyObject]) -> UIPrintPaper? {
        let paper = UIPrintPaper.bestPaperForPageSize(pagePreview!.pageSize!, withPapersFromArray: paperList)
        return paper
    }

    func printInteractionControllerWillStartJob(printInteractionController: UIPrintInteractionController) {
        
        println("printing start")
    }
    
    func printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController) {
        
        println("printing stop")
    }
}