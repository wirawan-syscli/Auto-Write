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
    
    @IBOutlet weak var newDocumentView: UIView!
    @IBOutlet weak var showDocumentView: UIView!
    @IBOutlet weak var downloadDocumentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToViews()
        initUIGestureRecognizer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        fetchAllData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addShadowToViews() {
        
        let RGBColor = CGFloat(220.0 / 255.0)
        let borderColor = UIColor(red: RGBColor, green: RGBColor, blue: RGBColor, alpha: 1.0).CGColor
        newDocumentView.layer.borderColor = borderColor
        newDocumentView.layer.borderWidth = 1.0
        showDocumentView.layer.borderColor = borderColor
        showDocumentView.layer.borderWidth = 1.0
        downloadDocumentView.layer.borderColor = borderColor
        downloadDocumentView.layer.borderWidth = 1.0
    }
}

// MARK: PERFORM FETCH REQUEST
extension DashboardViewController  {
    
    func fetchAllData() {
        self.documents = Documents.MR_findAllSortedBy("id", ascending: true) as! [Documents]
    }
}

// MARK: PERFORM GESTURE RECOGNIZER
extension DashboardViewController: UIGestureRecognizerDelegate {
    
    func initUIGestureRecognizer() {
        initTapGestureRecognitionForNewDocument()
        initTapGestureRecognitionForShowDocument()
        initTapGestureRecognitionForDownloadDocument()
    }
    
    func initTapGestureRecognitionForNewDocument() {
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("performTapGestureOnNewDocument:"))
        tapGesture.delegate = self
        newDocumentView.addGestureRecognizer(tapGesture)
    }
    
    func performTapGestureOnNewDocument(recognizer: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("showNewDocumentSettings", sender: self)
    }
    
    func initTapGestureRecognitionForShowDocument() {
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("performTapGestureOnShowDocument:"))
        tapGesture.delegate = self
        showDocumentView.addGestureRecognizer(tapGesture)
    }
    
    func performTapGestureOnShowDocument(recognizer: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("showListDocument", sender: self)
    }
    
    func initTapGestureRecognitionForDownloadDocument() {
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("performTapGestureOnDownloadDocument:"))
        tapGesture.delegate = self
        downloadDocumentView.addGestureRecognizer(tapGesture)
    }
    
    func performTapGestureOnDownloadDocument(recognizer: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("showDownloadDocument", sender: self)
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