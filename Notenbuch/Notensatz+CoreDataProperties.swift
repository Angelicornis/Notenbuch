//
//  Notensatz+CoreDataProperties.swift
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

extension Notensatz {

    @NSManaged var extemporaleEnabeld: NSNumber?
    @NSManaged var fachart: String?
    @NSManaged var fachreferatEnabeld: NSNumber?
    @NSManaged var kurzabeitenEnabeld: NSNumber?
    @NSManaged var mundlicheNotenEnabeld: NSNumber?
    @NSManaged var name: String?
    @NSManaged var order: NSNumber?
    @NSManaged var schulaufgabeEnabeld: NSNumber?
    @NSManaged var verhaltnis_Kurzarbeit_Exen_Kurzarbeit: NSNumber?
    @NSManaged var verhaltnis_Kurzarbeit_Exen_Exen: NSNumber?
    @NSManaged var verhaltnis_Schulaufgaben_Mundlich_Mundlich: NSNumber?
    @NSManaged var verhaltnis_Schulaufgaben_Mundlich_Schulaufgaben: NSNumber?
    @NSManaged var notenitem: NSSet?

}
