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
    @IBOutlet weak var tableView: UITableView!
    var newData = (name: "", fachart: "", schulaufgaben: false, kurzarbeiten: false, extemporale: false, fachreferat: false, mundlicheNote: false)
    var indexPath = NSIndexPath()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: - Obligatorische Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        //        scrollView.contentSize.width = 600
        let moveMenu = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "moveMenu")
        let reload = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reload")
        //        let edit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: editButtonItem())
        navigationItem.rightBarButtonItems = [moveMenu, editButtonItem(), reload]
        //        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
        // this gives you access to notifications about rotations
    }
    func orientationChanged(sender: NSNotification)
    {
        tableView.reloadData()
        /* // Here check the orientation using this:
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) { // Landscape }
        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) { // Portrait }
        // Now once only allow the portrait one to go in that conditional part of the view. If you're using a navigation controller push the vc otherwise just use presentViewController:animated:
        */
    }
    
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        fetchedResultsController = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if visible {
            moveMenu()
        }
    }
    
    
    //MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print(sender)
//        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        visible = false
        if segue.identifier == "calculate" {
            delayOnMainQueue(1) { Void in
                self.moveMenu()
            }
        } else if segue.identifier == "detailTV" {
            (segue.destinationViewController as! DetailTV).currentNotensatz = fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
        }
    }
    
    
    @IBAction func backToTheStartFromAdd(segue: UIStoryboardSegue) {
        segue.sourceViewController as! AddNewFach
        Notensatz.addNotensatz(newData.name, inFachart: newData.fachart, schulaufgaben: newData.schulaufgaben, kurzarbeiten: newData.kurzarbeiten, extemporalen: newData.extemporale, mundlicheNoten: newData.mundlicheNote, fachreferat: newData.fachreferat)
        //        Notenitem.addNotenitem(inNotensatz: notensatz, schulaufgaben: newData.schulaufgaben, kurzarbeiten: newData.kurzarbeiten, extemporale: newData.extemporale, mundlicheNote: newData.mundlicheNote, fachreferat: newData.fachreferat)
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstTitel = fetchedResultsController.sectionIndexTitles[section]
        switch firstTitel {
        case "H": return "Hauptfach"
        case "N": return "Nebenfach"
        case "S": return "Seminarfach"
        default: return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((fetchedResultsController.sections?[section])! as NSFetchedResultsSectionInfo).numberOfObjects ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notenubersichtCell")! as! notenCell
        let currentNotensatz = fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
        cell.currentNotensatz = currentNotensatz
        cell.indexPath = indexPath
        return cell
    }
    
    //MARK: TableView Editing
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currentNotensatz = fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
        return currentNotensatz.getHightWithNameLabel()
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
          
//            let currentNotensatz = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz

            self.indexPath = indexPath
            self.performSegueWithIdentifier("detailTV", sender: nil)
            
            
//            let detailTV = self.storyboard!.instantiateViewControllerWithIdentifier("DetailTVController") as! DetailTV
////            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailTVController") as UIViewController
//
//            detailTV.currentNotensatz = currentNotensatz
//            self.presentViewController(detailTV, animated: true, completion: nil)
            
            return
        }
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            let currentNotensatz = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
            let dialog = UIAlertController(title: "Löschen", message: "Wollen Sie '\(currentNotensatz.name!)' wirklich löschen?", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "Abbruch", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "Löschen", style: .Default) { (action) -> Void in
                currentNotensatz.delete()
            }
            dialog.addAction(cancel)
            dialog.addAction(ok)
            self.presentViewController(dialog, animated: true, completion: nil)
            return
        })
        
        return [deleteAction, shareAction]
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - CoreData
    private lazy var fetchedResultsController: NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kNotensatz)
        request.sortDescriptors = [NSSortDescriptor(key: kFachart, ascending: true) ,NSSortDescriptor(key: kOrder, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: kFachart, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            //TODO: Errorhandling
        }
        
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
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}


