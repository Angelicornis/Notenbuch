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
    
    static func addNotensatz(name: String, inFachart: String, schulaufgaben: Bool, kurzarbeiten: Bool, extemporalen: Bool, mundlicheNoten: Bool, fachreferat: Bool, verhältnis_SchulaufgabenMündlich_Schulaufgaben: Int?, verhältnis_SchulaufgabenMündlich_Mündlich: Int?, verhaltnis_Kurzarbeit_Exen_Kurzarbeit: Int?, verhaltnis_Kurzarbeit_Exen_Exen: Int?) -> Notensatz {
        let notensatz = NSEntityDescription.insertNewObjectForEntityForName(kNotensatz, inManagedObjectContext: context) as! Notensatz
        notensatz.name = name
        notensatz.fachart = inFachart
        notensatz.schulaufgabeEnabeld = schulaufgaben
        notensatz.kurzabeitenEnabeld = kurzarbeiten
        notensatz.extemporaleEnabeld = extemporalen
        notensatz.mundlicheNotenEnabeld = mundlicheNoten
        notensatz.fachreferatEnabeld = fachreferat
        notensatz.verhaltnis_Schulaufgaben_Mundlich_Schulaufgaben = verhältnis_SchulaufgabenMündlich_Schulaufgaben
        notensatz.verhaltnis_Schulaufgaben_Mundlich_Mundlich = verhältnis_SchulaufgabenMündlich_Mündlich
        notensatz.verhaltnis_Kurzarbeit_Exen_Kurzarbeit = verhaltnis_Kurzarbeit_Exen_Kurzarbeit
        notensatz.verhaltnis_Kurzarbeit_Exen_Exen = verhaltnis_Kurzarbeit_Exen_Exen
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
            NSLog("Fehler beim löschen von: %@ _: %@ Class: %@ func: %@ line: %@", "\n", self.name! , NSURL(fileURLWithPath: __FILE__).lastPathComponent!, __FUNCTION__, __FUNCTION__)
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
        case 1: return 70
        case 2: return 99
        case 3: return 128
        case 4: return 157
        case 5: return 186
        default: return CGFloat(37)
        }
    }
    func getHightWithNameLabel() -> CGFloat {
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
        case 1: return 87
        case 2: return 116
        case 3: return 145
        case 4: return 174
        case 5: return 203
        default: return CGFloat(37)
        }
    }
}