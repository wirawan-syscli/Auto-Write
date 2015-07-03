//
//  DocumentDB.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/29/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

//class DocumentDB: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
//    
//    class func dynamoDBTableName() -> String! {
//        return "Documents"
//    }
//    
//    class func hashKeyAttribute() -> String! {
//        return "id"
//    }
//    
//    let id              : NSData
//    let title           : String
//    let subject         : String
//    let grade           : Int
//    let totalQuestions  : Int
//    
//    init(document: DocumentOld) {
//        let id = NSKeyedArchiver.archivedDataWithRootObject(document.id)
//        
//        self.id             = id
//        self.title          = document.title
//        self.subject        = document.subject
//        self.grade          = document.grade
//        self.totalQuestions = document.totalQuestions
//        
//        super.init()
//    }
//
//    required init!(coder: NSCoder!) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
