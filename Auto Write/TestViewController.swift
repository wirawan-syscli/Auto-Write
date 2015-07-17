//
//  TestViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/17/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var options = [UIView]()
    var detailOptions = [UIView]()
    var currentDetailOption:
    UIView?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTapGestureRecognition()

        let option1 = UIView(frame: CGRectMake(0.0, 0.0, 150.0, 60.0))
        let buttonOption1 = UIButton(frame: CGRectMake(0.0, 0.0, option1.bounds.width, option1.bounds.height))
        buttonOption1.addTarget(self, action: Selector("scrollTo:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonOption1.setTitle("Page Size", forState: UIControlState.Normal)
        buttonOption1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOption1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        buttonOption1.tag = 0
        option1.addSubview(buttonOption1)
        
        let option2 = UIView(frame: CGRectMake(150.0, 0.0, 150.0, 60.0))
        let buttonOption2 = UIButton(frame: CGRectMake(0.0, 0.0, option2.bounds.width, option2.bounds.height))
        buttonOption2.addTarget(self, action: Selector("scrollTo:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonOption2.setTitle("Margin", forState: UIControlState.Normal)
        buttonOption2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOption2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        buttonOption2.tag = 1
        option2.addSubview(buttonOption2)
        
        let option3 = UIView(frame: CGRectMake(300.0, 0.0, 150.0, 60.0))
        let buttonOption3 = UIButton(frame: CGRectMake(0.0, 0.0, option3.bounds.width, option3.bounds.height))
        buttonOption3.addTarget(self, action: Selector("scrollTo:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonOption3.setTitle("Utility", forState: UIControlState.Normal)
        buttonOption3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOption3.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        buttonOption3.tag = 2
        option3.addSubview(buttonOption3)
        
        options = [option1, option2, option3]
        
        for option in options {
        
            scrollView.addSubview(option)
        }
        scrollView.contentSize = CGSize(width: options.last!.frame.width + options.last!.frame.origin.x, height: 60)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        let detailOption1 = UIView(frame: CGRectMake(150.0, 0.0, 0.0, 60.0))
        detailOption1.backgroundColor = ColorsPallete.orangeDark()
        detailOption1.alpha = 0.0
        
        let detailOption2 = UIView(frame: CGRectMake(300.0, 0.0, 0.0, 60.0))
        detailOption2.backgroundColor = ColorsPallete.orangeDark()
        detailOption2.alpha = 0.0
        
        let detailOption3 = UIView(frame: CGRectMake(450.0, 0.0, 0.0, 60.0))
        detailOption3.backgroundColor = ColorsPallete.orangeDark()
        detailOption3.alpha = 0.0
        
        detailOptions = [detailOption1, detailOption2, detailOption3]
    }
    
    func scrollTo(sender: UIButton) {
        
        let origin = sender.superview!.frame.origin
        scrollView.setContentOffset(CGPoint(x: origin.x , y: origin.y), animated: true)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            if !self.scrollView.scrollEnabled {
                self.dismissCurrentDetailOption()
            } else {
                let detailOption = self.detailOptions[sender.tag]
                self.scrollView.addSubview(detailOption)
                self.scrollView.scrollEnabled = false
            
                detailOption.alpha = 1.0
                detailOption.frame = CGRectMake(detailOption.frame.origin.x, detailOption.frame.origin.y, self.scrollView.frame.width - 150.0, detailOption.frame.height)
            }
            
            }) { (success: Bool) -> Void in
                
                if !self.scrollView.scrollEnabled {
                    self.currentDetailOption = self.detailOptions[sender.tag]
                }
            }
    }
    
    func dismissCurrentDetailOption() {
        
        if let detailOption = self.currentDetailOption {
            detailOption.alpha = 0.0
            detailOption.frame = CGRectMake(detailOption.frame.origin.x, detailOption.frame.origin.y, 0.0, detailOption.frame.size.height)
            detailOption.removeFromSuperview()
            self.scrollView.scrollEnabled = true
        }
    }
    
    func initTapGestureRecognition() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissCurrentDetailOption"))
        tapGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
