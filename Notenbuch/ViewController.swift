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
    var currentNotensatz: Notensatz!
    
    
    //MARK: - Obligatorische Funktionen
    override func viewDidLoad() {
//        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "skipTutorial")
        super.viewDidLoad()
        let moveMenu = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "moveMenu")
        let edit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "doEdit:")
//        let reload = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reload")
        navigationItem.rightBarButtonItems = [moveMenu, edit]
        
//        
//        print("currentDevice\t\t \(UIDevice.currentDevice())")
//        print("systemName\t\t \(UIDevice.currentDevice().systemName)")
//        print("systemVersion\t\t \(UIDevice.currentDevice().systemVersion)")
//        print("name\t\t\t\t \(UIDevice.currentDevice().name)")
//        print("model\t\t\t \(UIDevice.currentDevice().model)")
//        print("batterystate\t\t \(UIDevice.currentDevice().batteryState.rawValue)")
//        print("VersionNumber\t\t \(NSBundle.applicationVersionNumber)")
//        print("BuildNumber\t\t \(NSBundle.applicationBuildNumber)")
//        print(UIDevice.currentDevice().userInterfaceIdiom.rawValue)

//        print(hardwareDescription())
//        print(__FILE__ + " [\(__LINE__)]: " + __FUNCTION__)
//        print(NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String)
        
        
        
        
        
        
        
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
        // this gives you access to notifications about rotations
    }
    
    var editingg = true
    func doEdit(sender: AnyObject) {
        print(editingg)
        fetchedResultsController = nil
        self.tableView.setEditing(editingg, animated: true)
        editingg = !editingg
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
        reload()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if visible {
            moveMenu()
        }
    }

    
    //MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        visible = false
        if segue.identifier == "calculate" {
            do {
                (segue.destinationViewController as! CalculateTVC).data = try prepareCoreData()
            } catch {}

            
        } else if segue.identifier == "detailTV" {
            (segue.destinationViewController as! DetailTV).currentNotensatz = fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
            (segue.destinationViewController as! DetailTV).tableView = self.tableView

        }
    }
    enum CoreDataError: ErrorType {
        case PrepareCoreData_NoSectionsInFetchedResultsController
    }
    
    @IBAction func backToTheStartFromAdd(segue: UIStoryboardSegue) {
        segue.sourceViewController as! AddNewFach
        Notensatz.addNotensatz(newData.name, inFachart: newData.fachart, schulaufgaben: newData.schulaufgaben, kurzarbeiten: newData.kurzarbeiten, extemporalen: newData.extemporale, mundlicheNoten: newData.mundlicheNote, fachreferat: newData.fachreferat)
        //        Notenitem.addNotenitem(inNotensatz: notensatz, schulaufgaben: newData.schulaufgaben, kurzarbeiten: newData.kurzarbeiten, extemporale: newData.extemporale, mundlicheNote: newData.mundlicheNote, fachreferat: newData.fachreferat)
    }
    
    
    func prepareCoreData() throws ->[[String: String]] {
        var arrays:(schulaufgaben: [Int], kurzarbeiten: [Int], extemporalen: [Int], mundlicheNoten: [Int], fachreferat: [Int])! = nil
        var data: [[String: String]] = []
        guard let sectionCount = fetchedResultsController.sections?.count else {
            throw CoreDataError.PrepareCoreData_NoSectionsInFetchedResultsController
        }
        for i in 0..<sectionCount {
            let notensatzeInSection = (fetchedResultsController.sections![i] as NSFetchedResultsSectionInfo).objects as! [Notensatz]
            
            let section = fetchedResultsController.sections![i]
            let sectionCount = section.numberOfObjects
            let sectionTitel = fetchedResultsController.sectionIndexTitles[i]
            
            if sectionTitel == "H" {
                for a in 0..<sectionCount {
                    currentNotensatz = notensatzeInSection[a]
                    fetchedResultsControllerForNotenitem = nil
                    arrays = Notenitem.makeArrays(fetchedResultsControllerForNotenitem)
                    data.append(berechneDurchschnitt(arrays))
                }
            }
        }
        return data
    }
    func berechneDurchschnitt(arrays: (schulaufgaben: [Int], kurzarbeiten: [Int], extemporalen: [Int], mundlicheNoten: [Int], fachreferat: [Int])) ->[String: String] {
        var ergebnis = ""
        var durchschnittMundliche = average([average(arrays.kurzarbeiten), average(arrays.extemporalen), average(arrays.mundlicheNoten)])
        if arrays.fachreferat.count != 0 {
            durchschnittMundliche = durchschnittMundliche * 2 + Double(arrays.fachreferat[0]) / 3
        }
        
        if arrays.schulaufgaben.count == 1 {
            ergebnis = average([average(arrays.schulaufgaben), durchschnittMundliche]).setLenghtOfTheNumberAfterPointTo(2)!.toString()
        } else if arrays.schulaufgaben.count > 1 {
            ergebnis = ((average(arrays.schulaufgaben) * 2 + durchschnittMundliche) / 3).setLenghtOfTheNumberAfterPointTo(2)!.toString()
        }
        else if arrays.schulaufgaben.count < 1 {
            ergebnis = durchschnittMundliche.toString()
        }
        return ["Name": currentNotensatz.name!, "Ergebnis": ergebnis]
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
//        cell.fetchedResultsController = nil
//        cell.removeAllViews()
        return cell
    }
    
    //MARK: TableView Editing
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currentNotensatz = fetchedResultsController.objectAtIndexPath(indexPath) as! Notensatz
        return currentNotensatz.getHightWithNameLabel() + 30
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        AppDelegate.move(kNotensatz, orderAttributeName: kOrder, source: fetchedResultsController.objectAtIndexPath(sourceIndexPath), toDestination: fetchedResultsController.objectAtIndexPath(destinationIndexPath))
    }
    
    
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        return .None
//    }

    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
        fetchedResultsController = nil
        fetchedResultsControllerForNotenitem = nil
        
        let cell = tableView.dequeueReusableCellWithIdentifier("notenubersichtCell")! as! notenCell
        cell.fetchedResultsController = nil
//        cell.removeAllViews()
        
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
    
    
    private lazy var fetchedResultsControllerForNotenitem: NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kNotenitem)
        request.sortDescriptors = [NSSortDescriptor(key: kOrder, ascending: false)]
        
        request.predicate = NSPredicate(format: "notensatz = %@", self.currentNotensatz)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
            reload()
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
    

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
}


