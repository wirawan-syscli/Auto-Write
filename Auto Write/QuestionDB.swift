//
//  QuestionDB.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/29/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

//class QuestionDB: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
//    
//    class func dynamoDBTableName() -> String! {
//        return "Questions"
//    }
//    
//    class func hashKeyAttribute() -> String! {
//        return "id"
//    }
//    
//    let id         : Int
//    let documentId : NSData
//    let text       : String
//    
//    init(question: QuestionOld, currentQuestion: Int) {
//        let documentId = NSKeyedArchiver.archivedDataWithRootObject(question.id)
//        
//        self.id = currentQuestion + 1
//        self.documentId   = documentId
//        self.text = question.text
//        
//        super.init()
//    }
//    
//    required init!(coder: NSCoder!) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
