//
//  Notenitem.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 17.07.15.
//  Copyright © 2015 Tom Kumschier. All rights reserved.
//

import Foundation
import CoreData

@objc(Notenitem)
class Notenitem: NSManagedObject {

    static func addNotenitem(inNotensatz notensatz: Notensatz, schulaufgaben: Int, kurzarbeiten: Int, extemporale: Int, mundlicheNote: Int, fachreferat: Int) -> Notenitem {
        let notenitem = NSEntityDescription.insertNewObjectForEntityForName(kNotenitem, inManagedObjectContext: context) as! Notenitem
        notenitem.notensatz = notensatz
        notenitem.schulaufgaben = schulaufgaben
        notenitem.kurzarbeiten = kurzarbeiten
        notenitem.extemporale = extemporale
        notenitem.mundlicheNote = mundlicheNote
        notenitem.fachreferat = fachreferat
        notenitem.order = AppDelegate.minIntegerValueForEntitiy(kNotenitem, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notenitem
    }
    
    func delete() {
        context.deleteObject(self)
        do {
            try context.save()
        } catch {
            print("Fehler beim löschen von \n \(self)")
            //TODO: Errorhandling
        }
    }
    
    static func makeArrays(fetchedResultsController: NSFetchedResultsController) -> (schulaufgaben: [Int], kurzarbeiten: [Int], extemporalen: [Int], mundlicheNoten: [Int], fachreferat: [Int]) {
        var schulaufgaben: [Int] = []
        var kurzarbeiten: [Int] = []
        var extemporalen: [Int] = []
        var mundlicheNoten: [Int] = []
        var fachreferat: [Int] = []
        
        (((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).objects as! [Notenitem]).each { element -> () in
            if element.schulaufgaben != nil { schulaufgaben.append(element.schulaufgaben! as Int) }
            if element.kurzarbeiten != nil { kurzarbeiten.append(element.kurzarbeiten! as Int) }
            if element.extemporale != nil { extemporalen.append(element.extemporale! as Int) }
            if element.mundlicheNote != nil { mundlicheNoten.append(element.mundlicheNote! as Int) }
            if element.fachreferat != nil { fachreferat.append(element.fachreferat! as Int) }
        }
        return (schulaufgaben: schulaufgaben, kurzarbeiten: kurzarbeiten, extemporalen: extemporalen, mundlicheNoten: mundlicheNoten, fachreferat: fachreferat)
    }
    
    static func addNotenitemSchulaufgabe(notensatz: Notensatz, schulaufgabe: Int) ->Notenitem {
        let notenitem = NSEntityDescription.insertNewObjectForEntityForName(kNotenitem, inManagedObjectContext: context) as! Notenitem
        notenitem.schulaufgaben = schulaufgabe
        notenitem.notensatz = notensatz
        notenitem.order = AppDelegate.minIntegerValueForEntitiy(kNotenitem, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notenitem
    }
    
    static func addNotenitemKurzarbeit(notensatz: Notensatz, kurzarbeit: Int) ->Notenitem {
        let notenitem = NSEntityDescription.insertNewObjectForEntityForName(kNotenitem, inManagedObjectContext: context) as! Notenitem
        notenitem.kurzarbeiten = kurzarbeit
        notenitem.notensatz = notensatz
        notenitem.order = AppDelegate.minIntegerValueForEntitiy(kNotenitem, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notenitem
    }
    
    static func addNotenitemExtemporale(notensatz: Notensatz, extemporale: Int) ->Notenitem {
        let notenitem = NSEntityDescription.insertNewObjectForEntityForName(kNotenitem, inManagedObjectContext: context) as! Notenitem
        notenitem.extemporale = extemporale
        notenitem.notensatz = notensatz
        notenitem.order = AppDelegate.minIntegerValueForEntitiy(kNotenitem, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notenitem
    }
    
    static func addNotenitemMundlicheNote(notensatz: Notensatz, mundlicheNote: Int) ->Notenitem {
        let notenitem = NSEntityDescription.insertNewObjectForEntityForName(kNotenitem, inManagedObjectContext: context) as! Notenitem
        notenitem.mundlicheNote = mundlicheNote
        notenitem.notensatz = notensatz
        notenitem.order = AppDelegate.minIntegerValueForEntitiy(kNotenitem, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notenitem
    }
    
    static func addNotenitemFachreferat(notensatz: Notensatz, fachreferat: Int) ->Notenitem {
        let notenitem = NSEntityDescription.insertNewObjectForEntityForName(kNotenitem, inManagedObjectContext: context) as! Notenitem
        notenitem.fachreferat = fachreferat
        notenitem.notensatz = notensatz
        notenitem.order = AppDelegate.minIntegerValueForEntitiy(kNotenitem, attributeName: kOrder) - 1
        do {
            try context.save()
        } catch {
            //TODO: Errorhandling
        }
        return notenitem
    }
    
    
}
