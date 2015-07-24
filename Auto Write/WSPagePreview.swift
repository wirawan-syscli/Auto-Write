//
//  WSPagePreview.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/22/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

@objc protocol WSPagePreviewDelegate {
    
    func WSPagePreviewSetTextContent(pagePreview: WSPagePreview) -> String
    
    optional func WSPagePreviewShowPageControl(pagePreview: WSPagePreview, pageControl: UIPageControl)
}

class WSPagePreview: NSObject, UIScrollViewDelegate {
    
    var scrollView: UIScrollView?
    var scrollViewMargin: CGFloat = 20.0
    var pageControl: UIPageControl?
    
    var layoutManager = NSLayoutManager()
    var attrText: NSAttributedString?
    var fontSize: CGFloat?
    
    var delegate: WSPagePreviewDelegate?
    
    var pageSize: CGSize?
    var resizedPageSize: CGSize?
    
    var pageOrigin: CGPoint?
    var pageOriginOffsetX: CGFloat?
    
    var pageMargin: UIEdgeInsets?
    var resizedPageMargin: UIEdgeInsets?
    
    var pages = [UITextView]()
    var pagesPrint = [UITextView]()
    
    var delimiter: CGFloat?
    
    
    init(pageSize: CGSize, pageMargin: UIEdgeInsets, fontSize: CGFloat) {
        self.pageSize = pageSize
        self.pageMargin = pageMargin
        self.resizedPageMargin = self.pageMargin
        self.fontSize = fontSize
        
        super.init()
    }
    
    convenience override init() {
        let pageSize = CGSize(width: 793.322834646, height: 1096.062992126)
        let pageMargin = UIEdgeInsetsZero
        let fontSize: CGFloat = 14.0
        
        self.init(pageSize: pageSize, pageMargin: pageMargin, fontSize: fontSize)
    }
    
    func initDefaultSettings(scrollView: UIScrollView) {
        
        self.scrollView = scrollView
        self.scrollView!.delegate = self
        
        updateSettings()
    }
    
    func setPageSize(size: CGSize){
        pageSize = size
        updateSettings()
    }
    
    func setPageMargin(margin: UIEdgeInsets, resizedMargin: UIEdgeInsets){
        pageMargin = margin
        resizedPageMargin = resizedMargin
        adjustPageMargin()
    }
    
    func setPageMarginHorizontally(left: CGFloat, right: CGFloat) {
        let resizedMargin = UIEdgeInsets(top: pageMargin!.top, left: left * delimiter!, bottom: pageMargin!.bottom, right: right * delimiter!)
        let margin = UIEdgeInsets(top: pageMargin!.top, left: left, bottom: pageMargin!.bottom, right: right)
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setPageMarginVertically(top: CGFloat, bottom: CGFloat) {
        let resizedMargin = UIEdgeInsets(top: top * delimiter!, left: pageMargin!.left, bottom: bottom * delimiter!, right: pageMargin!.right)
        let margin = UIEdgeInsets(top: top, left: pageMargin!.left, bottom: bottom, right: pageMargin!.right)
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setFontSize(fontSize: CGFloat) {
        initTextContent(fontSize)
    }
    
    func updateSettings() {
        
        if pageControl != nil {
            pageControl?.removeFromSuperview()
        }
        
        let pageControlFrame = CGRectMake(scrollView!.frame.origin.x, scrollView!.frame.origin.y, scrollView!.frame.width, 20.0)
        pageControl = UIPageControl(frame: pageControlFrame)
        
        var pageSizeScale = pageSize!
        if pageSizeScale.width > scrollView!.bounds.width - scrollViewMargin ||
            pageSizeScale.height > scrollView!.bounds.height - scrollViewMargin {
                
                let highestSize = max(pageSize!.width, pageSize!.height)
                let scrollViewFrame = min(scrollView!.frame.width, scrollView!.frame.height) - scrollViewMargin
                delimiter = CGFloat(scrollViewFrame / highestSize)
                
                pageSizeScale.width = delimiter! * pageSizeScale.width
                pageSizeScale.height = delimiter! * pageSizeScale.height
        }
        resizedPageSize = pageSizeScale
        
        pageOrigin = CGPoint(x: scrollView!.bounds.width - resizedPageSize!.width, y: (scrollView!.bounds.height - resizedPageSize!.height) / 2)
        pageOriginOffsetX = pageOrigin!.x / 2
        
        initTextContent(fontSize!)
    }
    
    func initTextContent(fontSize: CGFloat) {
        
        self.fontSize = fontSize
        let adjustedFontSize = self.fontSize! * delimiter!
        let text = delegate!.WSPagePreviewSetTextContent(self)
        
        let font = UIFont.systemFontOfSize(adjustedFontSize)
        attrText = NSAttributedString(string: text, attributes: [NSFontAttributeName : font])
        
        adjustPageMargin()
    }
    
    func adjustPageMargin() {
        
        if pages.count > 0 {
            for page in pages {
                page.removeFromSuperview()
            }
            pages = [UITextView]()
        }
        let textStorage = NSTextStorage(attributedString: attrText!)
        layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        var lastRenderedGlyph: Int = 0
        var index = 0
        
        while (lastRenderedGlyph < layoutManager.numberOfGlyphs) {

            let pageOriginX = pageOriginOffsetX! + (pageOrigin!.x + resizedPageSize!.width) * CGFloat(index++)
            let textContainer = NSTextContainer(size: CGSize(width: resizedPageSize!.width - (pageMargin!.left + pageMargin!.right), height: resizedPageSize!.height - (pageMargin!.top + pageMargin!.bottom)))
            layoutManager.addTextContainer(textContainer)
            
            setPrintPreviewPages(textContainer, pageOriginX: pageOriginX)
            setPrintFormatPages(pageOriginX)
            
            // Set TEXTVIEW
            lastRenderedGlyph = NSMaxRange(layoutManager.glyphRangeForTextContainer(textContainer))
        }
        
        scrollView!.contentSize = CGSize(width: pages.first!.frame.origin.x + pages.last!.frame.width + pages.last!.frame.origin.x, height: scrollView!.frame.height)
        scrollView!.pagingEnabled = true
        
        pageControl!.numberOfPages = pages.count
        delegate?.WSPagePreviewShowPageControl?(self, pageControl: pageControl!)
    }
    
    func setPrintPreviewPages(textContainer: NSTextContainer, pageOriginX: CGFloat) {
        
        let textView = UITextView(frame: CGRectMake(pageOriginX, pageOrigin!.y, resizedPageSize!.width, resizedPageSize!.height), textContainer: textContainer)
        textView.textContainerInset = UIEdgeInsets(top: resizedPageMargin!.top, left: resizedPageMargin!.left, bottom: resizedPageMargin!.bottom, right: resizedPageMargin!.right)
        textView.scrollEnabled = false
        
        pages.append(textView)
        scrollView!.addSubview(textView)
    }
    
    func setPrintFormatPages(pageOriginX: CGFloat) {
        
        let printPreview = pages.last!
        
        let textView = UITextView(frame: CGRectMake(pageOriginX, pageOrigin!.y, resizedPageSize!.width, resizedPageSize!.height))
        textView.text = printPreview.text
        textView.textContainerInset = UIEdgeInsets(top: pageMargin!.top, left: pageMargin!.left, bottom: pageMargin!.bottom, right: pageMargin!.right)
        textView.scrollEnabled = false
        
        pagesPrint.append(textView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentPage = Int(floor(scrollView.contentOffset.x / 375))
        pageControl!.currentPage = currentPage
    }
}

