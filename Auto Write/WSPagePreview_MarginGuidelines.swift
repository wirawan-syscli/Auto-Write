//
//  WSPagePreview_MarginGuidelines.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/28/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

//
//  Margin Area Code
//
//
//  1 - width guideline (horizontal)
//  2 - height guideline (vertical)
//  3 - width size guideline
//  4 - height size guideline
//

extension WSPagePreview {
    
    func drawWidthMarginGuideline(textView: UITextView) -> CALayer? {
        
        guidelinesWidthMargin = CALayer()
        guidelinesWidthMargin!.frame = CGRectMake(
            textView.bounds.origin.x + resizedPageMargin!.left,
            -(containerMargin / 2 ),
            textView.frame.width - (resizedPageMargin!.left * 2.0),
            guidelinesStrokeSize
        )
        
        var horizontalLabel = UILabel()
        horizontalLabel.frame = CGRectMake(
            guidelinesWidthMargin!.bounds.width / 2 - guidelinesHeight + resizedPageMargin!.left,
            (guidelinesWidthMargin!.frame.origin.y) - 3.0,
            guidelinesHeight * 2.0,
            guidelinesHeight - 6.0
        )
        
        (guidelinesWidthMargin, horizontalLabel) = stylingGuideline(1, guideline: guidelinesWidthMargin!, label: horizontalLabel)
        
        textView.layer.addSublayer(guidelinesWidthMargin)
        textView.addSubview(horizontalLabel)
        
        return guidelinesWidthMargin
    }
    
    func drawHeightMarginGuideline(textView: UITextView) -> CALayer? {
        
        guidelinesHeightMargin = CALayer()
        guidelinesHeightMargin!.frame = CGRectMake(
            -(containerMargin / 2 ),
            textView.bounds.origin.y + resizedPageMargin!.top,
            guidelinesStrokeSize,
            textView.frame.height - (resizedPageMargin!.top * 2.0)
        )
        
        var verticalLabel = UILabel()
        verticalLabel.frame = CGRectMake(
            (guidelinesHeightMargin!.frame.origin.x * 2) - 1.0,
            guidelinesHeightMargin!.bounds.height / 2 - guidelinesHeight + resizedPageMargin!.top,
            guidelinesHeight * 2.2,
            guidelinesHeight
        )
        
        (guidelinesHeightMargin, verticalLabel) = stylingGuideline(2, guideline: guidelinesHeightMargin!, label: verticalLabel)
        
        textView.layer.addSublayer(guidelinesHeightMargin)
        textView.addSubview(verticalLabel)
        
        return guidelinesHeightMargin
    }
}
