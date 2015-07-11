//
//  Notensatz.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 07.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import Foundation
import CoreData

@objc(Notensatz)
class Notensatz: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var fachart: String
    @NSManaged var order: NSNumber
    @NSManaged var notensatz: NSSet

}
