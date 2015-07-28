//
//  WSSliderNavbar.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/18/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

@objc protocol WSSliderNavbarDelegate {
    
    optional func WSSliderNavbarSubMenuWillShow(sliderNavbar: WSSliderNavbar, index: Int)
}

class WSSliderNavbar: NSObject {
    
    var items = [UIView]()
    var buttonItems = [UIButton]()
    var detailItems = [UIView]()
    var detailItemsOption = [UIView]()
    
    var scrollView: UIScrollView
    var size: CGSize
    
    var currentDetailItem: UIView?
    var animationDuration: NSTimeInterval = 1.0
    
    var delegate: WSSliderNavbarDelegate?
    
    static func createButtonWithText(title: String, color: UIColor, highlightedColor: UIColor) -> UIButton {
        
        var button = UIButton(frame: CGRectZero)
        button.setTitle(title, forState: .Normal)
        button = buttonWithColor(button, color: color, highlightedColor: highlightedColor)
        
        return button
    }
    
    static func createButtonWithImage(image: UIImage, color: UIColor, highlightedColor: UIColor) -> UIButton {
        
        var button = UIButton(frame: CGRectZero)
        button.setImage(image, forState: .Normal)
        button = buttonWithColor(button, color: color, highlightedColor: highlightedColor)
        
        return button
    }
    
    static func buttonWithColor(button: UIButton, color: UIColor, highlightedColor: UIColor) -> UIButton {
        
        button.setTitleColor(color, forState: .Normal)
        button.setTitleColor(color, forState: .Highlighted)
        
        return button
    }
    
    init(size: CGSize, scrollView: UIScrollView, buttons: [UIButton]) {
        
        self.scrollView = scrollView
        self.size = size
        
        super.init()
        
        for index in 0..<buttons.count {
            
            let button = buttons[index]
            button.frame = CGRectMake(0.0, 0.0, size.width, size.height)
            button.tag = index
            button.addTarget(self, action: Selector("buttonDidPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let view = UIView(frame: CGRectMake(CGFloat(index) * size.width, 0.0, size.width, size.height))
            view.addSubview(button)
            
            items.append(view)
            buttonItems.append(button)
            
            self.scrollView.addSubview(view)
        }
        
        let newScrollViewContentSize = CGSize(width: items.last!.frame.width + items.last!.frame.origin.x, height: items.last!.frame.height)
        self.scrollView.contentSize = newScrollViewContentSize
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        
        createDetailItems()
        
    }
    
    func createDetailItems() {
        
        for item in items {
            
            let offsetX = item.frame.width + item.frame.origin.x
            let detailItem = UIView(frame: CGRectMake(offsetX, 0.0, 0.0, item.frame.height))
            detailItem.alpha = 0
            detailItem.clipsToBounds = true
            detailItems.append(detailItem)
        }
    }
    
    func buttonDidPressed(sender: UIButton) {
        
        let index = sender.tag
        let item = items[index]
        let detailItem = detailItems[index]
        var detailItemOption: UIView?
        let detailItemWidth = scrollView.bounds.width - size.width
        
        if detailItemsOption.count > index {
            detailItemOption = detailItemsOption[index]
        }
        
        if !scrollView.scrollEnabled {
            
            detailItem.alpha = 0.0
            detailItem.frame = CGRectMake(detailItem.frame.origin.x, detailItem.frame.origin.y, 0.0, detailItem.frame.height)
            scrollView.scrollEnabled = true
            
            currentDetailItem?.removeFromSuperview()
            
        } else {
            
            scrollView.addSubview(detailItem)
        
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            
                detailItem.alpha = 1.0
                detailItem.frame = CGRectMake(detailItem.frame.origin.x, detailItem.frame.origin.y, detailItemWidth, detailItem.frame.height)
                
                if let option = detailItemOption {
                    option.frame = CGRectMake(0.0, option.frame.origin.y, detailItemWidth, option.frame.height)
                }
                
                }) { (error: Bool) -> Void in
            
                    self.currentDetailItem = detailItem
            }
        
            scrollView.setContentOffset(CGPointMake(item.frame.origin.x, item.frame.origin.y), animated: true)
            
            scrollView.scrollEnabled = false
        }
        
        delegate!.WSSliderNavbarSubMenuWillShow!(self, index: index)
    }
    
    func insertCustomViewIntoItem(customView: UIView, index: Int, color: UIColor) {
        
        var detailItem = detailItems[index]
        var offsetY: CGFloat = 0.0
        var customViewHeight = detailItem.frame.height
        
        if customView.frame.height > detailItem.frame.height {
            offsetY = -(customView.frame.height - detailItem.frame.height) / 2
            customViewHeight = customView.frame.height
        }
        
        customView.frame = CGRectMake(0.0, offsetY, 0.0, customViewHeight)
        
        detailItem.backgroundColor = color
        detailItem.addSubview(customView)
        detailItemsOption.append(customView)
    }
}
