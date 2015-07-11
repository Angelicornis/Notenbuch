//
//  Notensatz Extension.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 07.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit
import CoreData

extension Notensatz {
    
    
    static func addNotensatz(name: String, fachart: String) -> Notensatz {
        let notensatz = NSEntityDescription.insertNewObjectForEntityForName(kNotensatz, inManagedObjectContext: context) as! Notensatz
        notensatz.name = name
        notensatz.fachart = fachart
        notensatz.order = AppDelegate.minIntegerValueForEntitiy(kNotensatz, attributeName: kOrder) - 1
        context.save(nil)
        return notensatz
    }
    
    func getHight() ->CGFloat {
//        
//        let schulaufgabe = self.valueForKey(kSchulaufgaben) as! Bool
//        let kurzabreiten = self.valueForKey(kKurzarbeiten) as! Bool
//        let extempolare = self.valueForKey(kExtemporale) as! Bool
//        let fachreferat = self.valueForKey(kFachreferat) as! Bool
//        let mundlicheNote = self.valueForKey(kMundlicheNote) as! Bool
//        
//        
//        
//        var anzahlDerTrues = 0
//        if schulaufgabe { ++anzahlDerTrues }
//        if kurzabreiten { ++anzahlDerTrues }
//        if extempolare { ++anzahlDerTrues }
//        if false { ++anzahlDerTrues }
//        if mundlicheNote { ++anzahlDerTrues }
//        
//        
//        switch anzahlDerTrues {
//        case 1: return CGFloat(78)
//        case 2: return CGFloat(116)
//        case 3: return CGFloat(154)
//        case 4: return CGFloat(192)
//        case 5: return CGFloat(230)
//        default: return CGFloat(110)
//        }
        return 170
    }
}

let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
