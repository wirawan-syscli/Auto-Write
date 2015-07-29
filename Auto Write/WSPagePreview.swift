//
//  WSPagePreview.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/22/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit


class WSPagePreview: NSObject {
    
    // UIScrollView
    
    var container                  : UIScrollView?
    var containerPage              = UIView()
    var containerMargin            : CGFloat       = 30.0
    
    // UIPageControl
    
    var pageControl                : UIPageControl?
    var currentPage                : Int           = 0
    
    // WSPagePreview
    
    var layoutManager              = NSLayoutManager()
    var attrText                   : NSAttributedString?
    var fontSize                   : CGFloat?
    
    var pageOrigin                 : CGPoint?
    var pageOriginOffsetX          : CGFloat?
    
    var delegate                   : WSPagePreviewDelegate?
    
    // WSPagePreview_Size
    
    var pageSize                   : CGSize?
    var resizedPageSize            : CGSize?
    
    // WSPagePreview_Margin
    
    var pageMargin                 : UIEdgeInsets?
    var resizedPageMargin          : UIEdgeInsets?
    
    // WSPagePreview_SizeGuidelines
    // WSPagePreview_MarginGuidelines
    
    var guidelinesWidthMargin      = [CALayer?]()
    var guidelinesHeightMargin     = [CALayer?]()
    var guidelinesOffset           : CGFloat       = 10.0
    var guidelinesHeight           : CGFloat       = 13.0
    var guidelinesStrokeSize       : CGFloat       = 0.5
    var guidelinesFontSize         : CGFloat       = 10
    var guidelinesTopTintColor                     = UIColor.lightGrayColor().CGColor
    var guidelinesLeftTintColor                    = UIColor.lightGrayColor().CGColor
    var showPageMarginIndicators   : Bool          = true
    var cmUnit                     : CGFloat       = 37.79527559
    var delimiter                  : CGFloat?
    
    // WSPagePreview_Print
    var pages                      = [UITextView]()
    var pagesPrint                 = [UITextView]()
    
    
    init(pageSize: CGSize, pageMargin: UIEdgeInsets, fontSize: CGFloat) {
        self.pageSize = pageSize
        self.pageMargin = pageMargin
        self.resizedPageMargin = self.pageMargin
        self.fontSize = fontSize
        
        super.init()
    }
    
    convenience init(fontSize: CGFloat) {
        let pageSize = CGSize(width: 793.322834646, height: 1096.062992126)
        let pageMargin = UIEdgeInsetsZero
        
        self.init(pageSize: pageSize, pageMargin: pageMargin, fontSize: fontSize)
    }
    
    convenience override init() {
        let pageSize = CGSize(width: 793.322834646, height: 1096.062992126)
        let pageMargin = UIEdgeInsetsZero
        let fontSize: CGFloat = 14.0
        
        self.init(pageSize: pageSize, pageMargin: pageMargin, fontSize: fontSize)
    }
}

extension WSPagePreview {
    
    func initDefaultSettings(scrollView: UIScrollView) {
        
        self.container = scrollView
        self.container!.delegate = self
        
        updateSettings()
    }
    
    func updateSettings() {
        
        adjustPageControl()
        adjustPageSize()
        adjustTextContent(fontSize!)
    }
    
    func adjustPageMargin() {
        
        if pages.count > 0 {
            for page in pages {
                page.removeFromSuperview()
            }
            pages = [UITextView]()
            pagesPrint = [UITextView]()
        }
        
        let textStorage = NSTextStorage(attributedString: attrText!)
        layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        var lastRenderedGlyph: Int = 0
        var index = 0
        
        while (lastRenderedGlyph < layoutManager.numberOfGlyphs) {
            
            let pageOriginX = pageOriginOffsetX! + (pageOrigin!.x + resizedPageSize!.width) * CGFloat(index++)
            let textContainer = NSTextContainer(size: CGSize(width: resizedPageSize!.width - (resizedPageMargin!.left + resizedPageMargin!.right), height: resizedPageSize!.height - (resizedPageMargin!.top + resizedPageMargin!.bottom)))
            layoutManager.addTextContainer(textContainer)
            
            setPrintPreviewPages(textContainer, pageOriginX: pageOriginX)
            setPrintFormatPages(pageOriginX)
            
            // Set TEXTVIEW
            lastRenderedGlyph = NSMaxRange(layoutManager.glyphRangeForTextContainer(textContainer))
        }
        
        containerPage.frame.size = CGSize(width: pages.first!.frame.origin.x + pages.last!.frame.width + pages.last!.frame.origin.x, height: container!.frame.height)
        
        container?.addSubview(containerPage)
        container?.minimumZoomScale = 1.0
        container?.maximumZoomScale = 4.0
        container?.zoomScale = 1.0
        container?.contentSize = containerPage.frame.size
        container?.pagingEnabled = true
        
        pageControl!.numberOfPages = pages.count
        delegate?.WSPagePreviewShowPageControl?(self, pageControl: pageControl!)
    }
    
    func setPrintPreviewPages(textContainer: NSTextContainer, pageOriginX: CGFloat) {
        
        let textView = UITextView(frame: CGRectMake(pageOriginX, pageOrigin!.y, resizedPageSize!.width, resizedPageSize!.height), textContainer: textContainer)
        textView.textContainerInset = UIEdgeInsets(top: resizedPageMargin!.top, left: resizedPageMargin!.left, bottom: resizedPageMargin!.bottom, right: resizedPageMargin!.right)
        textView.scrollEnabled = false
        textView.clipsToBounds = false
        
        if showPageMarginIndicators {
            
            guidelinesWidthMargin.append(drawWidthMarginGuideline(textView))
            guidelinesHeightMargin.append(drawHeightMarginGuideline(textView))
            drawWidthSizeGuideline(textView)
            drawHeightSizeGuideline(textView)
        }
        
        pages.append(textView)
        containerPage.addSubview(textView)
    }
}

