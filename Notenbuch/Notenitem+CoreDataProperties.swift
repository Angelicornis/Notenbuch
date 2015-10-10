//
//  Notenitem+CoreDataProperties.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 09.10.15.
//  Copyright © 2015 Tom Kumschier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
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
