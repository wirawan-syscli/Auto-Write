//
//  Question.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/24/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit
import CoreData

class Question: NSObject {
    
    let id   : NSDate
    var text : String
    
    init(id: NSDate, text: String) {
        self.id = id
        self.text = text
    }
    
    func save() -> NSError? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Question", inManagedObjectContext: manageContext)
        let question = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
        
        question.setValue(id,   forKey: "id"  )
        question.setValue(text, forKey: "text")
        
        var error: NSError?
        if !manageContext.save(&error) {
            return error
        }
        
        return nil
    }
    
    func update(index: Int) -> NSError? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Question", inManagedObjectContext: manageContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var error: NSError?
        let results: NSArray = NSArray(array: manageContext.executeFetchRequest(fetchRequest, error: &error)!)
    
        let question: NSManagedObject = results.objectAtIndex(index) as! NSManagedObject
        println(question.valueForKey("text"))
        question.setValue(text, forKey: "text")
        
        if !manageContext.save(&error) {
            return error
        }
        
        return nil
    }
}
