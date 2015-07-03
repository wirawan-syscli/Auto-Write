//
//  Document.swift
//  
//
//  Created by wirawan sanusi on 6/24/15.
//
//

import UIKit
import CoreData

class DocumentOld: NSObject {
    
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
    var questions       : [QuestionOld]
    
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
        var error: NSError?
        
        MagicalRecord.saveWithBlock({ (manageContext: NSManagedObjectContext!) -> Void in
            
            }, completion: { (success: Bool, saveError: NSError!) -> Void in
                if error != nil {
                    error = saveError
                }
        })
        
        return error
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
