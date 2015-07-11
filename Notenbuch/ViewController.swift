//
//  ViewController.swift
//  EigenesMenu
//
//  Created by Udemy on 27.02.15.
//  Copyright (c) 2015 benchr. All rights reserved.
//

import UIKit
import CoreData

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Variablendeklaration
    var visible: Bool = false
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tv: UITableView!
    var newData = (name: "", fachart: "", schulaufgaben: false, kurzarbeiten: false, extemporale: false, fachreferat: false, mundlicheNote: false)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: - Obligatorische Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.width = 600
        var moveMenu = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "moveMenu")
        navigationItem.rightBarButtonItems = [moveMenu, editButtonItem()]
    }
    override func viewDidAppear(animated: Bool) {
        //              moveMenu()
    }
    
    //MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calculate" {
            delayOnMainQueue(1) { Void in
                self.moveMenu()
            }
        }
    }
    @IBAction func backToTheStartFromAdd(segue: UIStoryboardSegue) {
        
        segue.sourceViewController as! AddNewFach
        Notensatz.addNotensatz(newData.name, fachart: newData.fachart)
        
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("notenubersichtCell") as! UITableViewCell
//        if let dataAtIndexPath = (fetchedResultsController.objectAtIndexPath(indexPath) as? Notensatz)?.valueForKey(kSchulaufgaben) as? String {
//            cell.textLabel?.text = dataAtIndexPath
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = tableView.dequeueReusableCellWithIdentifier("notenubersichtCell") as! notenCell
        
        let currentNotensatz = fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
        
        return currentNotensatz.getHight()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//TODO: Löschen
        }
    }
    
    // MARK: - CoreData
    private lazy var fetchedResultsController: NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kNotensatz)
        request.sortDescriptors = [NSSortDescriptor(key: kOrder, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        return fetchedResultsController
        } ()
    
    
    
    //    //MARK: - Menu
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if visible {
            /*
            let translation = recognizer.translationInView(self.menuView).x
            var maxX = view.frame.width + 10
            var minX = view.frame.width-100
            var newX = menuView.frame.origin.x + translation
            if newX >= minX && newX <= maxX {
            menuView.frame = CGRectMake(CGFloat(newX), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            }
            if newX >= menuView.frame.origin.x {
            menuView.frame = CGRectMake(CGFloat(newX), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            }
            if newX < maxX {
            visible = true
            moveMenu()
            }
            */
            let translation = recognizer.translationInView(self.menuView).x
            if translation > 0 {
                visible = true
                moveMenu()
            }
            recognizer.setTranslation(CGPointZero, inView: self.menuView)
        }
    }
    
    
    func moveMenu() {
        UIView.animateWithDuration(0.5) {
            if self.visible {
                //View ist Sichtbar -> View einfahren
                self.menuView.frame = CGRectMake(CGFloat(self.view.bounds.width), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            } else {
                //View ist unsichtbar -> View ausfahren
                self.menuView.frame = CGRectMake(CGFloat(self.view.bounds.width-100), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            }
        }
        visible = !visible
        return
    }
}



extension ViewController: NSFetchedResultsControllerDelegate {
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        switch type {
//        case .Insert:
//            tv.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
//        case .Delete:
//            tv.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
//        case .Move:
//            tv.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
//        case .Update:
//            tv.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
//        }
//    }
//
//    
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        tv.beginUpdates()
//    }
//    
//    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        tv.endUpdates()
//    }
}


