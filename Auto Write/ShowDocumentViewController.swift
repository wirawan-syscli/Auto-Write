//
//  ShowDocumentViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/3/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: CLASS INIT
class ShowDocumentViewController: UIViewController {
    
    var documents: [Documents]!
    var selectedDocument: Documents?
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITABLEVIEW DATA SOURCES
extension ShowDocumentViewController: UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("documentCell", forIndexPath: indexPath) as! ShowDocumentTableViewCell
        
        cell.leftUtilityButtons = leftButtonPressed() as [AnyObject]
        cell.rightUtilityButtons = rightButtonPressed() as [AnyObject]
        cell.delegate = self
        
        let RGBColor = CGFloat(220.0 / 255.0)
        let borderColor = UIColor(red: RGBColor, green: RGBColor, blue: RGBColor, alpha: 1.0).CGColor
        cell.layer.borderColor = borderColor
        cell.layer.borderWidth = 0.5
        cell.selectionStyle = .None
        
        cell.titleLabel?.text = documents[indexPath.row].title
        
        cell.gradeLabel?.text = "\(documents[indexPath.row].grade)"
        cell.gradeLabel.layer.cornerRadius = 10
        cell.gradeLabel.layer.masksToBounds = true
        cell.gradeLabel.layer.borderColor = cell.gradeLabel.tintColor.CGColor
        cell.gradeLabel.layer.borderWidth = 1.25
        
        cell.totalQuestionsLabel.text = "\(documents[indexPath.row].totalQuestions)"
        cell.totalQuestionsLabel.layer.cornerRadius = 10
        cell.totalQuestionsLabel.layer.masksToBounds = true
        cell.totalQuestionsLabel.layer.borderColor = cell.totalQuestionsLabel.tintColor.CGColor
        cell.totalQuestionsLabel.layer.borderWidth = 1.25
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedDocument = documents[indexPath.row]
        performSegueWithIdentifier("showDocumentDetail", sender: self)
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            
//            documents[indexPath.row].MR_deleteEntity()
//            documents.removeAtIndex(indexPath.row)
//            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
//            
//            tableView.reloadData()
//        }
//    }
    
    func leftButtonPressed() -> NSMutableArray {
        let leftUtilityButtons = NSMutableArray()
        
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "A")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "B")
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "C")
        
        return leftUtilityButtons
    }
    
    func rightButtonPressed() -> NSMutableArray {
        let rightUtilityButtons = NSMutableArray()
        
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "A")
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "B")
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "C")
        
        return rightUtilityButtons
    }
}

// MARK: PREPARE SEGUE
extension ShowDocumentViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDocumentDetail" {
            let destination: ShowDocumentDetailViewController = segue.destinationViewController as! ShowDocumentDetailViewController
            if let document = selectedDocument {
                destination.document = document
            }
        }
    }
}