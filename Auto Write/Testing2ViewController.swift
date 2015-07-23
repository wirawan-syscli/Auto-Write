//
//  Testing2ViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/18/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class Testing2ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var printLabel: UILabel!
    
    var picker: UIPickerView?
    var horizontalSlider: UISlider?
    var verticalSlider: UISlider?
    var headerSwitch: UISwitch?
    var sliderNavbar: WSSliderNavbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let button1 = WSSliderNavbar.createButtonWithText("Paper Size", color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        
        let button2 = WSSliderNavbar.createButtonWithText("Horizontal Margin", color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        
        let button3 = WSSliderNavbar.createButtonWithText("Vertical Margin", color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        
        let button4 = WSSliderNavbar.createButtonWithText("Utility", color: UIColor.whiteColor(), highlightedColor: UIColor.lightGrayColor())
        
        let buttons = [button1, button2, button3, button4]
        let size = CGSizeMake(160.0, 60.0)
        
        sliderNavbar = WSSliderNavbar(size: size, scrollView: scrollView, buttons: buttons)
        
        addConfigToPaperSize()
        addConfigToHorizontalMargin()
        addConfigToVerticalMargin()
        addConfigToUtility()
    }
}

extension Testing2ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func addConfigToPaperSize() {
        
        picker = UIPickerView()
        picker!.delegate = self
        picker!.dataSource = self
        
        sliderNavbar!.insertCustomViewIntoItem(picker!, index: 0, color: ColorsPallete.orangeDark())
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch row {
        case 0:
            return "A3"
        case 1:
            return "A4"
        case 2:
            return "A5"
        default:
            break
        }
        
        return "Not available"
    }
}

extension Testing2ViewController {
    
    func addConfigToHorizontalMargin() {
        
        // 0.1 cm = 3.779527559 px
        
        horizontalSlider = UISlider()
        horizontalSlider?.minimumValue = 0.0
        horizontalSlider?.maximumValue = 10.0
        horizontalSlider?.value = 2.0
        horizontalSlider?.addTarget(self, action: Selector("horizontalSliderValueChanged:"), forControlEvents: .ValueChanged)
    
        sliderNavbar!.insertCustomViewIntoItem(horizontalSlider!, index: 1, color: ColorsPallete.orangeDark())
    }
    
    func horizontalSliderValueChanged(sender: UISlider) {
        
        let centimeters = sender.value
        let pixels = CGFloat(centimeters * 3.779527559)
        
        printLabel.text = "Horizontal Margin: \(pixels)"
    }
}

extension Testing2ViewController {
    
    func addConfigToVerticalMargin() {
        
        // 0.1 cm = 3.779527559 px
        
        verticalSlider = UISlider()
        verticalSlider?.minimumValue = 0.0
        verticalSlider?.maximumValue = 10.0
        verticalSlider?.value = 2.0
        verticalSlider?.addTarget(self, action: Selector("verticalSliderValueChanged:"), forControlEvents: .ValueChanged)
        
        sliderNavbar!.insertCustomViewIntoItem(verticalSlider!, index: 2, color: ColorsPallete.orangeDark())
    }
    
    func verticalSliderValueChanged(sender: UISlider) {
        
        let centimeters = sender.value
        let pixels = CGFloat(centimeters * 3.779527559)
        
        printLabel.text = "Vertical Margin: \(pixels)"
    }
}

extension Testing2ViewController {
    
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
