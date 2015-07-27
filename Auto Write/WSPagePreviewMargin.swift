//
//  WSPagePreviewMargin.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/27/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

extension WSPagePreview {
    
    
    func setPageMargin(margin: UIEdgeInsets, resizedMargin: UIEdgeInsets){
        
        pageMargin = margin
        resizedPageMargin = resizedMargin
        
        adjustPageMargin()
    }
    
    func setPageMarginVertically(top: CGFloat, bottom: CGFloat) {
        
        let resizedMargin = UIEdgeInsets(top: top * delimiter!, left: pageMargin!.left * delimiter!, bottom: bottom * delimiter!, right: pageMargin!.right * delimiter!)
        let margin = UIEdgeInsets(top: top, left: pageMargin!.left, bottom: bottom, right: pageMargin!.right)
        
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setPageMarginHorizontally(left: CGFloat, right: CGFloat) {
        
        let resizedMargin = UIEdgeInsets(top: pageMargin!.top * delimiter!, left: left * delimiter!, bottom: pageMargin!.bottom * delimiter!, right: right * delimiter!)
        let margin = UIEdgeInsets(top: pageMargin!.top, left: left, bottom: pageMargin!.bottom, right: right)
        
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setPageMarginTop(top: CGFloat) {
        
        let resizedMargin = UIEdgeInsets(top: top * delimiter!, left: pageMargin!.left * delimiter!, bottom: pageMargin!.bottom * delimiter!, right: pageMargin!.right * delimiter!)
        let margin = UIEdgeInsets(top: top, left: pageMargin!.left, bottom: pageMargin!.bottom, right: pageMargin!.right)
        
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setPageMarginLeft(left: CGFloat) {
        
        let resizedMargin = UIEdgeInsets(top: pageMargin!.top * delimiter!, left: left * delimiter!, bottom: pageMargin!.bottom * delimiter!, right: pageMargin!.right * delimiter!)
        let margin = UIEdgeInsets(top: pageMargin!.top, left: left, bottom: pageMargin!.bottom, right: pageMargin!.right)
        
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setPageMarginBottom(bottom: CGFloat) {
        
        let resizedMargin = UIEdgeInsets(top: pageMargin!.top * delimiter!, left: pageMargin!.left * delimiter!, bottom: bottom * delimiter!, right: pageMargin!.right * delimiter!)
        let margin = UIEdgeInsets(top: pageMargin!.top, left: pageMargin!.left, bottom: bottom, right: pageMargin!.right)
        
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func setPageMarginRight(right: CGFloat) {
        
        let resizedMargin = UIEdgeInsets(top: pageMargin!.top * delimiter!, left: pageMargin!.left * delimiter!, bottom: pageMargin!.bottom * delimiter!, right: right * delimiter!)
        let margin = UIEdgeInsets(top: pageMargin!.top, left: pageMargin!.left, bottom: pageMargin!.bottom, right: right * delimiter!)
        
        setPageMargin(margin, resizedMargin: resizedMargin)
    }
    
    func getUnitMetrics() -> UIEdgeInsets {
        
        let cmUnit: CGFloat = 37.79527559
        
        let pageMarginInCm = UIEdgeInsetsMake(pageMargin!.top / cmUnit, pageMargin!.left / cmUnit, pageMargin!.bottom / cmUnit, pageMargin!.right / cmUnit)
        
        return pageMarginInCm
    }
    
    func showPageMarginGuidelines(option: Bool) {
        
        showPageMarginGuidelines = option
    }
}
