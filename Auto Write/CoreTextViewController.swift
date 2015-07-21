//
//  CoreTextViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/19/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit
import CoreText
import CoreGraphics

class CoreTextViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pages = [UIView]()
    
    var textContainer: NSTextContainer?
    var layoutManager: NSLayoutManager?
    var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("sampleText", ofType: ".txt")
        let string = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        let textStorage = NSTextStorage(string: String(string!))
        layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager!)
        
        layoutTextContainers()
    }
    
    func layoutTextContainers() {
        
        var lastRenderedGlyph: Int = 0
        let currentXOffset: CGFloat = 0
        
        let pageSize = CGSize(width: 300.0, height: 400.0)
        let originX = view.bounds.size.width - pageSize.width
        let originStartX = originX / 2
        
        let originY = (view.bounds.size.height - pageSize.height) / 2
        var index = 0
        
        while (lastRenderedGlyph < layoutManager!.numberOfGlyphs) {
            let pageOriginX = originStartX + (originX + pageSize.width) * CGFloat(index)
            
            textContainer = NSTextContainer(size: CGSize(width: pageSize.width, height: pageSize.height))
            layoutManager!.addTextContainer(textContainer!)
            textView = UITextView(frame: CGRectMake(pageOriginX, originY, pageSize.width, pageSize.height), textContainer: textContainer)
            textView!.scrollEnabled = false
            scrollView.addSubview(textView!)
            
            index++
            lastRenderedGlyph = NSMaxRange(layoutManager!.glyphRangeForTextContainer(textContainer!))
            pages.append(textView!)
        }
        
        // Need to update the scrollView size
        scrollView.contentSize = CGSize(width: pages.first!.frame.origin.x + pages.last!.frame.origin.x + pages.last!.frame.width, height: scrollView.frame.height)
        scrollView.pagingEnabled = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentPage = Int(floor(scrollView.contentOffset.x / 375))
        
        pageControl.currentPage = currentPage
    }
}
