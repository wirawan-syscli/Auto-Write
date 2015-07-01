//
//  ShowDocumentTableViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/24/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class ShowDocumentTableViewController: UITableViewController {
    
    var documents: [Document]!
    var selectedDocument: Document?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
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

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedDocument = documents[indexPath.row]
        performSegueWithIdentifier("showDocumentDetail", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if let error = documents[indexPath.row].remove(indexPath.row){
                println("error")
            }
            
            documents.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
        }
    }
}

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
