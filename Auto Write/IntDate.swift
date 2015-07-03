//
//  IntDate.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/3/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class IntDate: NSObject {
    
    class func convert(date: NSDate) -> Int {
        let dateFormatter = NSDateFormatter()
        
        // Year, Month, Day, Hour, Minute, Seconds and Milliseconds
        dateFormatter.dateFormat = "yyMMddHHmmssSSS"
        let value = dateFormatter.stringFromDate(NSDate())
        
        return value.toInt()!
    }
}
