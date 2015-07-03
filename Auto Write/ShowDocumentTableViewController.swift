//
//  ShowDocumentTableViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/24/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: INIT CLASS
class ShowDocumentTableViewController: UITableViewController {
    
    var documents: [Documents]!
    var selectedDocument: Documents?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: TABLE VIEW DATA SOURCE
extension ShowDocumentTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("documentCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = documents[indexPath.row].title
        cell.detailTextLabel?.text = documents[indexPath.row].subject
        
        println(documents[indexPath.row].questions)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedDocument = documents[indexPath.row]
        performSegueWithIdentifier("showDocumentDetail", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            documents[indexPath.row].MR_deleteEntity()
            documents.removeAtIndex(indexPath.row)
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            
            tableView.reloadData()
        }
    }
}

// MARK: PREPARE SEGUE
extension ShowDocumentTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDocumentDetail" {
            let destination: ShowDocumentDetailViewController = segue.destinationViewController as! ShowDocumentDetailViewController
            if let document = selectedDocument {
                destination.document = document
            }
        }
    }
}
