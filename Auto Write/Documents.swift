//
//  Documents.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/3/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import Foundation
import CoreData

@objc(Documents)

class Documents: NSManagedObject {

    @NSManaged var grade: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var subject: String
    @NSManaged var title: String
    @NSManaged var totalQuestions: NSNumber
    @NSManaged var questions: NSOrderedSet

}
