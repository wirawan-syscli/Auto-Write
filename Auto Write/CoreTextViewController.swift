//
//  CoreTextViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/19/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class CoreTextViewController: UIViewController, WSPagePreviewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var pagePreview: WSPagePreview?
    
    var size: CGSize?
    var margin: UIEdgeInsets?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagePreview = WSPagePreview()
        pagePreview!.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pagePreview!.initDefaultSettings(scrollView)
        
        //doSomething()
    }
    
    func doSomething() {
        size = CGSize(width: 500, height: 500)
        pagePreview?.setPageSize(size!)
    }
    
    func WSPagePreviewSetTextContent(pagePreview: WSPagePreview) -> String {
        
        let path = NSBundle.mainBundle().pathForResource("sampleText", ofType: ".txt")
        let string = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        return String(string!)
    }
    
    func WSPagePreviewShowPageControl(pagePreview: WSPagePreview, pageControl: UIPageControl) {
        
        view.addSubview(pageControl)
    }
}

