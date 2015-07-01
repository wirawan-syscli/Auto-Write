//
//  ShowDocumentDetailTableViewCell.swift
//  Auto Write
//
//  Created by wirawan sanusi on 6/26/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class ShowDocumentDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
