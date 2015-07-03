//: Playground - noun: a place where people can play

import UIKit

let dateFormatter = NSDateFormatter()

// Year, Month, Day, Hour, Minute, Seconds and Milliseconds
dateFormatter.dateFormat = "yyMMddHHmmssSSS"
var value = dateFormatter.stringFromDate(NSDate())

value.toInt()
