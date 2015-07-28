//
//  WSPagePreview_GuidelineStyles.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/28/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

enum WSGuidelineArea {
    case Top, Left, Bottom, Right
}

extension WSPagePreview {
    
    func stylingGuideline(guidelineArea: Int, guideline: CALayer, label: UILabel) -> (CALayer?, UILabel) {
        
        guideline.backgroundColor = UIColor.lightGrayColor().CGColor
        
        var unit = "0.0"
        switch guidelineArea {
        case 1:
            unit = String(format: "%.2f", pageMargin!.left / cmUnit)
            guideline.backgroundColor = guidelinesTopDefaultColor
            break
        case 2:
            unit = String(format: "%.2f", pageMargin!.top / cmUnit)
            guideline.backgroundColor = guidelinesLeftDefaultColor
            break
        case 3:
            unit = String(format: "%.1f", pageSize!.width / cmUnit)
            break
        case 4:
            unit = String(format: "%.1f", pageSize!.height / cmUnit)
            break
        default:
            break
        }
        
        label.text = "\(unit)"
        label.font = UIFont.systemFontOfSize(guidelinesFontSize)
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return (guideline, label)
    }
    
    func resetGuidelineBackgroundColor(guidelineArea: WSGuidelineArea, color: CGColor){
        
        switch guidelineArea {
        case .Top:
            guidelinesTopDefaultColor = color
            guidelinesWidthMargin?.backgroundColor = color
            break
        case .Left:
            guidelinesLeftDefaultColor = color
            guidelinesHeightMargin?.backgroundColor = color
            break
        default:
            break
        }
    }
}
