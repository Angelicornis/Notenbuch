//
//  Notenitem+CoreDataProperties.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 17.07.15.
//  Copyright © 2015 Tom Kumschier. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Notenitem {

    @NSManaged var extemporale: NSNumber?
    @NSManaged var fachreferat: NSNumber?
    @NSManaged var kurzarbeiten: NSNumber?
    @NSManaged var mundlicheNote: NSNumber?
    @NSManaged var order: NSNumber?
    @NSManaged var schulaufgaben: NSNumber?
    @NSManaged var notensatz: Notensatz?

}
