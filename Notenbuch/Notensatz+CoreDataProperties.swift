//
//  Notensatz+CoreDataProperties.swift
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

extension Notensatz {

    @NSManaged var fachart: String?
    @NSManaged var name: String?
    @NSManaged var order: NSNumber?
    @NSManaged var schulaufgabeEnabeld: NSNumber?
    @NSManaged var kurzabeitenEnabeld: NSNumber?
    @NSManaged var extemporaleEnabeld: NSNumber?
    @NSManaged var mundlicheNotenEnabeld: NSNumber?
    @NSManaged var fachreferatEnabeld: NSNumber?
    @NSManaged var notenitem: NSSet?

}
