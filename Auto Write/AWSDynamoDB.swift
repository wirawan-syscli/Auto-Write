//
//  AWSDynamoDB.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/29/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

//protocol AWSDynamoDBDelegate {
//
//    func AWSDynamoDBDidFailedToSaveData(database: AWSDynamoDB)
//    func AWSDynamoDBDidSuccessToSaveData(database: AWSDynamoDB)
//}
//
//class AWSDynamoDB: NSObject {
//    
//    var delegate: AWSDynamoDBDelegate?
//    
//    func save(entity: AWSDynamoDBObjectModel) {
//        let dynamoDBObjectMapper: AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
//        
//        dynamoDBObjectMapper.save(entity).continueWithBlock { (task: AWSTask!) -> AnyObject! in
//            if (task.error != nil) {
//                println(task.error)
//                if let delegate = self.delegate {
//                    delegate.AWSDynamoDBDidFailedToSaveData(self)
//                }
//            }
//            if (task.exception != nil) {
//                println(task.exception)
//                if let delegate = self.delegate {
//                    delegate.AWSDynamoDBDidFailedToSaveData(self)
//                }
//            }
//            if (task.result != nil) {
//                println(task.result)
//                if let delegate = self.delegate {
//                    delegate.AWSDynamoDBDidSuccessToSaveData(self)
//                }
//            }
//            return nil
//        }
//    }
//}
