//
//  Document.swift
//  
//
//  Created by wirawan sanusi on 6/24/15.
//
//

import UIKit
import CoreData

class Document: NSObject, AWSDynamoDBModeling {
    
    class func dynamoDBTableName() -> String! {
        
        return "Document"
    }
    
    class func hashKeyAttribute() -> String! {
        
        return "id"
    }
    
    let id              : NSDate
    let title           : String
    let subject         : String
    let grade           : Int
    let totalQuestions  : Int
    var questions       : [Question]
    
    init(id: NSDate, title: String, subject: String, grade: Int, totalQuestions: Int){
        
        self.id = id
        self.title = title
        self.subject = subject
        self.grade = grade
        self.totalQuestions = totalQuestions
        self.questions = Array()
    }
    
    convenience init(title: String, subject: String, grade: Int, totalQuestions: Int){
        
        var id = NSDate()
        self.init(id: id, title: title, subject: subject, grade: grade, totalQuestions: totalQuestions)
    }
    
    func save() -> NSError? {
        
        let manageContext = NSManagedObjectContext.MR_defaultContext()
        let document: Document = Document.MR_
        var error: NSError?
        
        MagicalRecord.saveWithBlock({ (manageContext: NSManagedObjectContext!) -> Void in
            
            let document: Document = document.MR
            
            }, completion: { (success: Bool, saveError: NSError!) -> Void in
                if error != nil {
                    error = saveError
                }
        })
        
        return error
        
        
//        let entity = NSEntityDescription.entityForName("Document", inManagedObjectContext: manageContext)
//        let document = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
//        
//        document.setValue(id,             forKey: "id"            )
//        document.setValue(title,          forKey: "title"         )
//        document.setValue(subject,        forKey: "subject"       )
//        document.setValue(grade,          forKey: "grade"         )
//        document.setValue(totalQuestions, forKey: "totalQuestions")
//        
//        var error:NSError?
//        if !manageContext.save(&error) {
//            return error
//        }
//        
//        return nil
    }
    
    func remove(index: Int) -> NSError? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Document", inManagedObjectContext: manageContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var error: NSError?
        var results: NSArray = NSArray(array: manageContext.executeFetchRequest(fetchRequest, error: &error)!)
        
        var document: NSManagedObject = results.objectAtIndex(index) as! NSManagedObject
        manageContext.deleteObject(document)
        
        if !manageContext.save(&error) {
            return error
        }
        return nil
    }
}
