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
    var scrollViewMargin: CGFloat = 30.0
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
    var horizontalGuidelines: CALayer?
    var verticalGuidelines: CALayer?
    var guidelinesOffset: CGFloat = 10.0
    var guidelinesStrokeSize: CGFloat = 13.0
    var showPageMarginGuidelines: Bool = true
    var cm: CGFloat = 37.79527559
    
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
                
                pageSizeScale.width = delimiter! * pageSizeScale.width - scrollViewMargin
                pageSizeScale.height = delimiter! * pageSizeScale.height - scrollViewMargin
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
        
        scrollView!.contentSize = CGSize(width: pages.first!.frame.origin.x + pages.last!.frame.width + pages.last!.frame.origin.x, height: scrollView!.frame.height)
        scrollView!.pagingEnabled = true
        
        pageControl!.numberOfPages = pages.count
        delegate?.WSPagePreviewShowPageControl?(self, pageControl: pageControl!)
    }
    
    func setPrintPreviewPages(textContainer: NSTextContainer, pageOriginX: CGFloat) {
        
        let textView = UITextView(frame: CGRectMake(pageOriginX, pageOrigin!.y, resizedPageSize!.width, resizedPageSize!.height), textContainer: textContainer)
        textView.textContainerInset = UIEdgeInsets(top: resizedPageMargin!.top, left: resizedPageMargin!.left, bottom: resizedPageMargin!.bottom, right: resizedPageMargin!.right)
        textView.scrollEnabled = false
        textView.clipsToBounds = false
        
        if showPageMarginGuidelines {
            
            if horizontalGuidelines != nil {
                horizontalGuidelines!.removeFromSuperlayer()
            }
            if verticalGuidelines != nil {
                verticalGuidelines!.removeFromSuperlayer()
            }
            
            drawHorizontalGuidelines(textView)
            drawVerticalguidelines(textView)
        }
        
        pages.append(textView)
        scrollView!.addSubview(textView)
    }
    
    func drawHorizontalGuidelines(textView: UITextView) {
        
        let horizontalLine = CALayer()
        horizontalLine.frame = CGRectMake(
            textView.bounds.origin.x + resizedPageMargin!.left,
            -(scrollViewMargin / 2 ),
            textView.frame.width - (resizedPageMargin!.left * 2.0),
            0.5)
        horizontalLine.backgroundColor = UIColor.blackColor().CGColor
        textView.layer.addSublayer(horizontalLine)
        
        let horizontalLabel = UILabel(frame: CGRectMake(
            horizontalLine.bounds.width / 2 - guidelinesStrokeSize + resizedPageMargin!.left,
            (horizontalLine.frame.origin.y) - 1.0,
            guidelinesStrokeSize * 2.0,
            guidelinesStrokeSize - 6.0))
        let horizontalUnit = String(format: "%.2f", pageMargin!.left / cm)
        
        horizontalLabel.text = "\(horizontalUnit)"
        horizontalLabel.font = UIFont.systemFontOfSize(10)
        horizontalLabel.textAlignment = NSTextAlignment.Center
        horizontalLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        textView.addSubview(horizontalLabel)
    }
    
    func drawVerticalguidelines(textView: UITextView) {
        
        let verticalLine = CALayer()
        verticalLine.frame = CGRectMake(
            -(scrollViewMargin / 2 ),
            textView.bounds.origin.y + resizedPageMargin!.top,
            0.5,
            textView.frame.height - (resizedPageMargin!.top * 2.0))
        verticalLine.backgroundColor = UIColor.blackColor().CGColor
        textView.layer.addSublayer(verticalLine)
        
        let verticalLabel = UILabel(frame: CGRectMake(
            (verticalLine.frame.origin.x * 2) - 1.0,
            verticalLine.bounds.height / 2 - guidelinesStrokeSize + resizedPageMargin!.top,
            guidelinesStrokeSize * 2.2,
            guidelinesStrokeSize))
        let verticalUnit = String(format: "%.2f", pageMargin!.top / cm)
        
        verticalLabel.text = "\(verticalUnit)"
        verticalLabel.font = UIFont.systemFontOfSize(10)
        verticalLabel.textAlignment = NSTextAlignment.Center
        verticalLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        textView.addSubview(verticalLabel)
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

