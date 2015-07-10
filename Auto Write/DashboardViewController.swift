//
//  DashboardViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/24/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: INIT CLASS
class DashboardViewController: UIViewController {
    
    var documents: [Documents] = Array()
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoView.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        fetchAllData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addShadowToViews(cell: DashboardTableViewCell) -> DashboardTableViewCell {
        
        let RGBColor = CGFloat(220.0 / 255.0)
        let borderColor = UIColor(red: RGBColor, green: RGBColor, blue: RGBColor, alpha: 1.0).CGColor
        cell.layer.borderColor = borderColor
        cell.layer.borderWidth = 1.0
        cell.selectionStyle = .None
        
        return cell
    }
}

// MARK: PERFORM FETCH REQUEST
extension DashboardViewController  {
    
    func fetchAllData() {
        self.documents = Documents.MR_findAllSortedBy("id", ascending: true) as! [Documents]
    }
}

// MARK: UITABLEVIEW
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: DashboardTableViewCell = tableView.dequeueReusableCellWithIdentifier("dashboardCell", forIndexPath: indexPath) as! DashboardTableViewCell
        
        switch indexPath.row{
        case 0:
            cell.menuTextLabel.text = "Create New Document"
            break;
        case 1:
            cell.menuTextLabel.text = "Show All Document"
            break;
        case 2:
            cell.menuTextLabel.text = "Download Document"
            break;
        default :
            break;
        }
        
        cell = addShadowToViews(cell)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("showNewDocumentSettings", sender: self)
            break;
        case 1:
            performSegueWithIdentifier("showListDocument", sender: self)
            break;
        case 2:
            performSegueWithIdentifier("showDownloadDocument", sender: self)
            break;
        default:
            break;
        }
    }
}

// MARK: PREPARE SEGUE
extension DashboardViewController {
    
    @IBAction func unwindFromNewDocument(segue: UIStoryboardSegue) {
        
        let source: NewDocumentViewController = segue.sourceViewController as! NewDocumentViewController
        documents.append(source.document!)
    }
    
    @IBAction func unwindFromDownloadDocument(segue: UIStoryboardSegue) {
        
        //let source: DownloadDocumentViewController = segue.sourceViewController as! DownloadDocumentViewController
        //documents.append(source.downloadedDocument!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showListDocument" {
            let destination: ShowDocumentViewController = segue.destinationViewController as! ShowDocumentViewController
            destination.documents = documents
        }
        
        if segue.identifier == "showDownloadDocument" {
            let destination: DownloadDocumentViewController = segue.destinationViewController as! DownloadDocumentViewController
            destination.savedDocuments = documents
        }
    }
}