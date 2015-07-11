//
//  Notenitem.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 07.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import Foundation
import CoreData

@objc(Notenitem)
class Notenitem: NSManagedObject {

    @NSManaged var extemporale: NSNumber
    @NSManaged var fachreferat: NSNumber
    @NSManaged var kurzarbeiten: NSNumber
    @NSManaged var mundlicheNote: NSNumber
    @NSManaged var schulaufgaben: NSNumber
    @NSManaged var notenitem: NSManagedObject

}
