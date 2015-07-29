//
//  WSPagePreview_UIScrollView.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/28/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

extension WSPagePreview: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        currentPage = Int(floor(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl!.currentPage = currentPage
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return containerPage
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        if scale == scrollView.minimumZoomScale {
            scrollView.pagingEnabled = true
        } else {
            scrollView.pagingEnabled = false
        }
    }
}