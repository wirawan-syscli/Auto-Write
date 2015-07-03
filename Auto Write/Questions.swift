//
//  Questions.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/3/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import Foundation
import CoreData

@objc(Questions)

class Questions: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var text: String
    @NSManaged var documentId: NSNumber
    @NSManaged var documents: Documents

}
