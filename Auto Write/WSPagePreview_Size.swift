//
//  WSPagePreview_Size.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/28/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

extension WSPagePreview {
    
    func setPageSize(size: CGSize){
        
        pageSize = size
        
        updateSettings()
    }
    
    func adjustPageSize() {
        
        var contentSize = pageSize!
        if contentSize.width  > container!.bounds.width  - containerMargin ||
            contentSize.height > container!.bounds.height - containerMargin * 2.0 {
                
                contentSize = calculateResizedPageSize(container!.frame.size, contentSize: pageSize!)
        }
        
        resizedPageSize = contentSize
        
        pageOrigin = CGPoint(x: container!.bounds.width - resizedPageSize!.width, y: (container!.bounds.height - resizedPageSize!.height) / 2 + containerMargin / 2)
        pageOriginOffsetX = pageOrigin!.x / 2
    }
    
    func calculateResizedPageSize(containerSize: CGSize, contentSize: CGSize) -> CGSize {
        
        var contentSize = contentSize
        let maxSize = max(contentSize.width, contentSize.height)
        let containerMaxSize = max(containerSize.width, containerSize.height) - containerMargin
        let containerMinSize = min(containerSize.width, containerSize.height) - containerMargin
        var containerSize = containerMaxSize
        
        func scalingContentSize(contentSize: CGSize) -> CGSize {
            var scaledContentSize = contentSize
            delimiter = CGFloat(containerSize / maxSize)
            
            scaledContentSize.width = delimiter! * contentSize.width - containerMargin
            scaledContentSize.height = delimiter! * contentSize.height - (containerMargin * 2.0)
            
            return scaledContentSize
        }
        
        var scaledContentSize = scalingContentSize(contentSize)
        if containerMinSize < min(scaledContentSize.width, scaledContentSize.height) {
            containerSize = containerMinSize
            scaledContentSize = scalingContentSize(contentSize)
        }
        
        return scaledContentSize
    }
}
