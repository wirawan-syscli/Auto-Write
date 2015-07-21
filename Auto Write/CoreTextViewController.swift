//
//  CoreTextViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/19/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class CoreTextViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var pages = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        let center = scrollView.center
        let pageSize = CGSize(width: 300.0, height: 400.0)
        let pageOrigin = CGPoint(x: center.x - (pageSize.width / 2), y: center.y - (pageSize.height / 2))
        let offsetX = pageOrigin.x + pageSize.width
        
        for index in 0...10 {
        
            let pageOriginOffsetX = offsetX * CGFloat(index) + pageOrigin.x
            
            let page = UIView(
                            frame: CGRectMake(
                                pageOriginOffsetX,
                                pageOrigin.y,
                                pageSize.width,
                                pageSize.height
                            )
                        )
            page.backgroundColor = UIColor.whiteColor()
        
            scrollView.addSubview(page)
            pages.append(page)
        }
        
        scrollView.contentSize = CGSize(width: pages.first!.frame.origin.x + pages.last!.frame.origin.x + pages.last!.frame.width, height: scrollView.frame.height)
        scrollView.pagingEnabled = true
    }
}
