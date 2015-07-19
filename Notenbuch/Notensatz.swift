//
//  Notensatz.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 17.07.15.
//  Copyright © 2015 Tom Kumschier. All rights reserved.
//

import UIKit
import CoreData

@objc(Notensatz)
class Notensatz: NSManagedObject {
    
    static func addNotensatz(name: String, inFachart: String, schulaufgaben: Bool, kurzarbeiten: Bool, extemporalen: Bool, mundlicheNoten: Bool, fachreferat: Bool) -> Notensatz {
        let notensatz = NSEntityDescription.insertNewObjectForEntityForName(kNotensatz, inManagedObjectContext: context) as! Notensatz
        notensatz.name = name
        notensatz.fachart = inFachart
        notensatz.schulaufgabeEnabeld = schulaufgaben
        notensatz.kurzabeitenEnabeld = kurzarbeiten
        notensatz.extemporaleEnabeld = extemporalen
        notensatz.mundlicheNotenEnabeld = mundlicheNoten
        notensatz.fachreferatEnabeld = fachreferat
        notensatz.order = AppDelegate.minIntegerValueForEntitiy(kNotensatz, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notensatz
    }
    
    func delete() {
        context.deleteObject(self)
        do {
            try context.save()
        } catch {
            print("Fehler beim löschen von \n \(self.name)")
            //TODO: Errorhandling
        }
    }
    
    func getHight() -> CGFloat {
        var zeile = 0
        if self.schulaufgabeEnabeld == true {
            ++zeile
        }
        if self.kurzabeitenEnabeld == true {
            ++zeile
        }
        if self.extemporaleEnabeld == true {
            ++zeile
        }
        if self.mundlicheNotenEnabeld == true {
            ++zeile
        }
        if self.fachreferatEnabeld == true {
            ++zeile
        }
        
        switch zeile {
        case 1: return  87
        case 2: return 116
        case 3: return 145
        case 4: return 174
        case 5: return 203
        default: return CGFloat(37)
        }
    }
}