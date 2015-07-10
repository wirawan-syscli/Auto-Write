//
//  DownloadDocumentViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/7/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit
import Parse

// MARK: CLASS INIT
class DownloadDocumentViewController: UIViewController {

    var savedDocuments: [Documents]!
    var documents = [[Int: String]]()
    var downloadedDocument: Documents?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBar: UIView!
    
    var hud: MBProgressHUD?
    var tapGesture: UITapGestureRecognizer?
    var reach: Reachability?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchTextField.delegate = self
        
        addShadowToSearchBar()
        initTapGestureRecognizer()
        checkForConnection()
        }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addShadowToSearchBar() {
        
        let RGBColor = CGFloat(220.0 / 255.0)
        let borderColor = UIColor(red: RGBColor, green: RGBColor, blue: RGBColor, alpha: 1.0).CGColor
        searchBar.layer.borderColor = borderColor
        searchBar.layer.borderWidth = 1.0
    }
    
    func initTapGestureRecognizer() {
        
        tapGesture = UITapGestureRecognizer(target: self, action: Selector("viewDidTapped:"))
        view.addGestureRecognizer(tapGesture!)
        tapGesture?.enabled = false
    }
}

// MARK: FETCHING DATA CONTROLLER
extension DownloadDocumentViewController {
    
    func checkForConnection() {
        
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud!.mode = .AnnularDeterminate
        self.hud?.color = UIColor.orangeColor()
        self.hud!.labelText = "Scanning.."
    
        reach = Reachability(hostname: "www.google.com")
        
        reach!.reachableBlock = { (reachability) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSearchingDocuments(nil)
            })
        }
        reach!.unreachableBlock = { (reachability) in
            self.hud!.hide(true)
            self.showAlertFromNoConnection()
        }
        
        reach!.startNotifier()
    }
    
    func performSearchingDocuments(keyword: String?){
        
        var downloadedDocuments = [[Int: String]]()
        var query = PFQuery()
        
        if let keyword = keyword {
            let predicate = NSPredicate(format: "title = '\(keyword)'")
            query = PFQuery(className: "Documents", predicate: predicate)
        } else {
            query = PFQuery(className: "Documents")
        }
        
        query.findObjectsInBackgroundWithBlock { (queryResults: [AnyObject]?, error: NSError?) -> Void in
            
            var PFObjects = [PFObject]()
            if let extractedResults = queryResults {
                let results = extractedResults as! [PFObject]
                PFObjects = results
            }
            
            if PFObjects.count > 0 {
                
                for savedDocument in self.savedDocuments {
                    for index in 0..<PFObjects.count {
                        if savedDocument.id == PFObjects[index]["documentId"] as! Int {
                            PFObjects.removeAtIndex(index)
                            break
                        }
                    }
                }
                
                for index in 0..<PFObjects.count {
                    
                    var progress: Float = Float(index/PFObjects.count)
                    self.hud!.progress = progress;
                    
                    let id = PFObjects[index]["documentId"] as! Int
                    let title = PFObjects[index]["title"] as! String
                    var downloadedDocument = [Int: String]()
                    downloadedDocument[id] = title
                    
                    downloadedDocuments.append(downloadedDocument)
                }
            }
            self.hud!.hide(true)
            self.documents = downloadedDocuments
            self.collectionView.reloadData()
        }
    }
}

// MARK: DOWNLOADING DATA CONTROLLER
extension DownloadDocumentViewController {
    
    func performDownloadingDocument(id: Int) {
        println(id)
        viewWillPerformUnwind()
    }
}

// MARK: UITEXTVIEW CONTROLLER
extension DownloadDocumentViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        tapGesture?.enabled = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        tapGesture?.enabled = false
        
        if count(textField.text) < 1 {
            performSearchingDocuments(nil)
        } else {
            performSearchingDocuments(textField.text)
        }
        
        return true
    }
    
    func viewDidTapped(tapGesture: UITapGestureRecognizer) {
        
        searchTextField.resignFirstResponder()
        tapGesture.enabled = false
        
        if count(searchTextField.text) < 1 {
            performSearchingDocuments(nil)
        } else {
            performSearchingDocuments(searchTextField.text)
        }
    }
}

// MARK: UICOLLECTIONVIEW CONTROLLER
extension DownloadDocumentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return documents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("documentCell", forIndexPath: indexPath) as! DownloadDocumentCollectionViewCell
        
        cell.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        let document = documents[indexPath.row]
        let title = document.values.first
        cell.titleLabel.text = title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let height = collectionView.frame.width
        let percentage = height * 0.3
        return CGSizeMake(percentage, 140.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        let height = collectionView.frame.width
        let percentage = height * 0.025
        return percentage
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let document = documents[indexPath.row]
        showAlertBeforeDownloadingDocument(document.values.first!, documentId: document.keys.first!)
    }
}

// MARK: SEGUE CONTROLLER
extension DownloadDocumentViewController {
    
    func viewWillPerformUnwind() {
        
        self.performSegueWithIdentifier("unwindFromDownloadDocument", sender: self)
    }
}

// MARK: ALERT CONTROLLER
extension DownloadDocumentViewController {
    
    func showAlertBeforeDownloadingDocument(documentTitle: String, documentId: Int) {
        
        let alert = UIAlertController(title: "Downloading \(documentTitle)", message: "Press Begin to start downloading the document\r Downloaded document will be added into application data", preferredStyle: .Alert)
        let begin = UIAlertAction(title: "Begin", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.performDownloadingDocument(documentId)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in }
        alert.addAction(begin)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertFromNoConnection() {
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Internet connection is required to view this page", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.reach!.stopNotifier()
            self.performSegueWithIdentifier("unwindFromDownloadDocument", sender: self)
        }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}