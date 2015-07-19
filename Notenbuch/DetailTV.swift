//
//  DetailTVViewController.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 17.07.15.
//  Copyright © 2015 Tom Kumschier. All rights reserved.
//

import UIKit
import CoreData

class DetailTV: UIViewController {
    
    @IBOutlet weak var schulaufgabeSwitch: UISwitch!
    @IBOutlet weak var kurzarbeitenSwitch: UISwitch!
    @IBOutlet weak var extempoaleSwitch: UISwitch!
    @IBOutlet weak var fachreferatSwitch: UISwitch!
    @IBOutlet weak var mundlicheNoteSwitch: UISwitch!
    
    
    var currentNotensatz: Notensatz!
    let scrollView = UIScrollView()
    var einstellungenView = UIView()
    var einstellungSwitchEnabeld = false
    var navigationBar = UINavigationBar()
    var currentNotenitem: Notenitem!
    var nameLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "goBack")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
        
        start()
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
        // this gives you access to notifications about rotations
    }
    func orientationChanged(sender: NSNotification)
    {
        self.view.removeAllSubviews()
        self.scrollView.removeAllSubviews()
        self.einstellungenView.removeAllSubviews()
        self.setzeScrollView()
        self.setzeNameLabel()
        self.setzeNotenLabel(self.currentNotensatz)
        self.setzeEinstellungen()
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)  //Tastatur wird eingefahren
    }
    
    func save () {
        let dialog = UIAlertController(title: "Achtung", message: "Eventuell eingegebene Noten werden gelöscht", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Abbruch", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "Lösche und Weiter", style: .Default) { (action) -> Void in
            navigationController?.popToRootViewControllerAnimated(true)
        }
        dialog.addAction(cancel)
        dialog.addAction(ok)
        presentViewController(dialog, animated: true, completion: nil)
    }
    func goBack() {
        //      navigationController?.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController! = {
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
    
}

extension DetailTV {
    
    private func start() {
        
        setzeScrollView()
        setzeNameLabel()
        setzeNotenLabel(currentNotensatz)
        
        setzeEinstellungen()
    }
    
    
    private func setzeScrollView(animationDuration: NSTimeInterval = 0) {
        UIView.animateWithDuration(animationDuration) {
            self.scrollView.frame = CGRectMake(CGFloat(0), CGFloat(72), UIScreen.mainScreen().bounds.width, self.currentNotensatz.getHight())
            self.scrollView.backgroundColor = UIColor.lightGrayColor()
            
//            let arrays = Notenitem.makeArrays(self.fetchedResultsController)
//            let maxValue = max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count])
            self.scrollView.contentSize.width = CGFloat(1000)
            self.view.addSubview(self.scrollView)
        }
    }
    
    private func setzeNameLabel () {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 800, height: 21))
        label.text = currentNotensatz.name!
        self.scrollView.addSubview(label)
    }
    
    private func setzeNotenLabel(currentNotensatz: Notensatz, animationDuration: NSTimeInterval = 0) {
        func plaziereNotenLabelPlaziere(TFName: String, zeile: Int) {
            struct nameTF {
                var name: String!
                var x: CGFloat!
                var y: CGFloat!
            }
            
            
            var nameTFInstanz = nameTF(name: TFName, x: 8.toCGFloat(), y: nil)
            switch zeile {
            case 1: nameTFInstanz.y = 40.toCGFloat()
            case 2: nameTFInstanz.y = 69.toCGFloat()
            case 3: nameTFInstanz.y = 98.toCGFloat()
            case 4: nameTFInstanz.y = 127.toCGFloat()
            case 5: nameTFInstanz.y = 156.toCGFloat()
            default: return
            }
            
            nameLabelView = UILabel()
            nameLabelView.frame = CGRect(x: nameTFInstanz.x, y: nameTFInstanz.y, width: 145.toCGFloat(), height: 30.toCGFloat())
            nameLabelView.text = nameTFInstanz.name
            nameLabelView.layer.borderColor = UIColor.blackColor().CGColor
            nameLabelView.layer.borderWidth = CGFloat(1)
            self.scrollView.addSubview(nameLabelView)
            
            setzeNotenCellen(nameLabelView)
            setzteUbersichtCellen(nameLabelView)
        }
        func setzeNotenCellen(firstNameCell: UILabel) {
//            let allNumberOfObjets = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).numberOfObjects
            let arrays = Notenitem.makeArrays(fetchedResultsController)
            var allNumberOfObjets = 0
            if max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count]) != 0 {
                allNumberOfObjets = max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count])
            }
            print(allNumberOfObjets)
            print(max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count]))
            
            var nameTFViewX = CGFloat(0)
            for i in 0...allNumberOfObjets {
                nameTFViewX = (firstNameCell.frame.maxX - CGFloat(1)) + CGFloat(i * 50 - i)
                let cellTFView = UITextField()
                
                switch firstNameCell.text! {
                case " Schulaufgabe": if i < arrays.schulaufgaben.count { cellTFView.text = arrays.schulaufgaben[i].toString() ; cellTFView.tag = i}
                case " Kurzarbeiten": if i < arrays.kurzarbeiten.count { cellTFView.text = arrays.kurzarbeiten[i].toString() ; cellTFView.tag = 100 + i }
                case " Extemporalen": if i < arrays.extemporalen.count { cellTFView.text = arrays.extemporalen[i].toString() ; cellTFView.tag = 200 + i }
                case " Mündliche Noten": if i < arrays.mundlicheNoten.count { cellTFView.text = arrays.mundlicheNoten[i].toString() ; cellTFView.tag = 300 + i }
                case " Fachreferat": if i < arrays.fachreferat.count { cellTFView.text = arrays.fachreferat[i].toString() ; cellTFView.tag = 400 + i }
                default: break
                }
                
                
                cellTFView.frame = CGRect(x: nameTFViewX , y: firstNameCell.frame.minY, width: 50.toCGFloat(), height: 30.toCGFloat())
                cellTFView.addTarget(self, action: Selector("changeNote:"), forControlEvents: UIControlEvents.EditingDidEnd)
                cellTFView.keyboardType = UIKeyboardType.NumberPad
                cellTFView.borderStyle = UITextBorderStyle.Line
                self.scrollView.addSubview(cellTFView)
            }
            self.scrollView.contentSize.width = nameTFViewX + CGFloat (50 + 8 + 50 + 8 + 8)
        }
        
        func setzteUbersichtCellen(firstNameCell: UILabel) {
            let celle = UILabel(frame: CGRect(x: self.scrollView.contentSize.width - 66, y: firstNameCell.frame.minY, width: 50, height: 30))
            celle.layer.borderColor = UIColor.blackColor().CGColor
            celle.layer.borderWidth = CGFloat(1)
            self.scrollView.addSubview(celle)
        }
        
        var zeile = 0
        
        if currentNotensatz.schulaufgabeEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Schulaufgabe", zeile: zeile)
        }
        if currentNotensatz.kurzabeitenEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Kurzarbeiten", zeile: zeile)
        }
        if currentNotensatz.extemporaleEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Extemporalen", zeile: zeile)
        }
        if currentNotensatz.mundlicheNotenEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Mündliche Noten", zeile: zeile)
        }
        if currentNotensatz.fachreferatEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Fachreferat", zeile: zeile)
        }
    }
    
    func changeNote(sender: UITextField) {
        
        
        if !sender.text!.isEmpty {
            var platzX = 0.toCGFloat()
            let allNumberOfObjets = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).numberOfObjects
            platzX = sender.frame.minX - (nameLabelView.frame.minX + nameLabelView.frame.width) + 1
            
            
            for i in 0...100 {
                if platzX == 0 {
                    
                    
                    
                    break
                }
                platzX -= 49
            }
            switch sender.tag {
            case 0: Notenitem.addNotenitemSchulaufgabe(currentNotensatz, schulaufgabe: sender.text!.toInt()!)
            case 1: Notenitem.addNotenitemKurzarbeit(currentNotensatz, kurzarbeit: sender.text!.toInt()!)
            case 2: Notenitem.addNotenitemExtemporale(currentNotensatz, extemporale: sender.text!.toInt()!)
            case 3: Notenitem.addNotenitemMundlicheNote(currentNotensatz, mundlicheNote: sender.text!.toInt()!)
            case 4: Notenitem.addNotenitemFachreferat(currentNotensatz, fachreferat: sender.text!.toInt()!)
            default: break
            }
            
            let aaa = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! Notenitem
            
        } else {
            var platzX = 0.toCGFloat()
//            let allNumberOfObjets = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).numberOfObjects
            platzX = sender.frame.minX - (nameLabelView.frame.minX + nameLabelView.frame.width) + 1
            
            let arrays = Notenitem.makeArrays(fetchedResultsController)
            
//            var schulaufgaben: [Int] = []
//            var kurzarbeiten: [Int] = []
//            var extemporalen: [Int] = []
//            var mundlicheNoten: [Int] = []
//            var fachreferat: [Int] = []
//            
//            (((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).objects as! [Notenitem]).each { element -> () in
//                if element.schulaufgaben != nil { schulaufgaben.append(element.schulaufgaben! as Int) }
//                if element.kurzarbeiten != nil { kurzarbeiten.append(element.kurzarbeiten! as Int) }
//                if element.extemporale != nil { extemporalen.append(element.extemporale! as Int) }
//                if element.mundlicheNote != nil { mundlicheNoten.append(element.mundlicheNote! as Int) }
//                if element.fachreferat != nil { fachreferat.append(element.fachreferat! as Int) }
//            }

            for i in 0...100 {
                if platzX == 0 {

                    switch sender.tag {
                    case 0: if arrays.schulaufgaben.count <= i  {
                        let deleteNotenitem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! Notenitem
                        deleteNotenitem.delete()
                        }
                    case 1:  if arrays.kurzarbeiten.count <= i + 1 {
                        let deleteNotenitem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! Notenitem
                        deleteNotenitem.delete()
                        }
                    case 2:  if arrays.extemporalen.count <= i + 1 {
                        let deleteNotenitem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! Notenitem
                        deleteNotenitem.delete()
                        }
                    case 3:  if arrays.mundlicheNoten.count <= i + 1 {
                        let deleteNotenitem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! Notenitem
                        deleteNotenitem.delete()
                        }
                    case 4:  if arrays.fachreferat.count <= i + 1 {
                        let deleteNotenitem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! Notenitem
                        deleteNotenitem.delete()
                        }
                    default: break
                    }
                    
                    
                    break
                }
                platzX -= 49
            }
        }
        
    }
    private func setzeEinstellungen(animationDuration: NSTimeInterval = 0) {
        UIView.animateWithDuration(animationDuration) {
            self.einstellungenView.frame = CGRectMake(CGFloat(0), CGFloat(92 + self.scrollView.frame.height), UIScreen.mainScreen().bounds.width, CGFloat(203))
            self.einstellungenView.backgroundColor = UIColor.darkGrayColor()
            self.view.addSubview(self.einstellungenView)
        }
        
        let labelNamen = ["Schulaufgaben", "Kurzarbeiten", "Extemporalen", "MündlicheNoten", "Fachreferat"]
        
        let label = UILabel()
        label.frame = CGRectMake(8, 8, 140, 31)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Left
        label.text = labelNamen[0]
        self.einstellungenView.addSubview(label)
        
        let label1 = UILabel()
        label1.frame = CGRectMake(8, 47, 140, 31)
        label1.textColor = UIColor.whiteColor()
        label1.textAlignment = NSTextAlignment.Left
        label1.text = labelNamen[1]
        self.einstellungenView.addSubview(label1)
        
        let label2 = UILabel()
        label2.frame = CGRectMake(8, 86, 140, 31)
        label2.textColor = UIColor.whiteColor()
        label2.textAlignment = NSTextAlignment.Left
        label2.text = labelNamen[2]
        self.einstellungenView.addSubview(label2)
        
        let label3 = UILabel()
        label3.frame = CGRectMake(8, 125, 140, 31)
        label3.textColor = UIColor.whiteColor()
        label3.textAlignment = NSTextAlignment.Left
        label3.text = labelNamen[3]
        self.einstellungenView.addSubview(label3)
        
        let label4 = UILabel()
        label4.frame = CGRectMake(8, 164, 140, 31)
        label4.textColor = UIColor.whiteColor()
        label4.textAlignment = NSTextAlignment.Left
        label4.text = labelNamen[4]
        self.einstellungenView.addSubview(label4)
        
        
        
        let switch0 = UISwitch()
        switch0.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 59, 8, 140, 31)
        switch0.on = (self.currentNotensatz.schulaufgabeEnabeld?.boolValue)!
        switch0.tag = 0
        switch0.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.einstellungenView.addSubview(switch0)
        
        let switch1 = UISwitch()
        switch1.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 59, 47, 140, 31)
        switch1.on = (self.currentNotensatz.kurzabeitenEnabeld?.boolValue)!
        switch1.tag = 1
        switch1.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.einstellungenView.addSubview(switch1)
        
        let switch2 = UISwitch()
        switch2.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 59, 86, 140, 31)
        switch2.on = (self.currentNotensatz.extemporaleEnabeld?.boolValue)!
        switch2.tag = 2
        switch2.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.einstellungenView.addSubview(switch2)
        
        let switch3 = UISwitch()
        switch3.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 59, 125, 140, 31)
        switch3.on = (self.currentNotensatz.mundlicheNotenEnabeld?.boolValue)!
        switch3.tag = 3
        switch3.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.einstellungenView.addSubview(switch3)
        
        let switch4 = UISwitch()
        switch4.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 59, 164, 140, 31)
        switch4.on = (self.currentNotensatz.fachreferatEnabeld?.boolValue)!
        switch4.tag = 4
        switch4.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.einstellungenView.addSubview(switch4)
        
    }
    func stateChanged(switchState: UISwitch) {
        if switchState.tag == 0 { currentNotensatz.schulaufgabeEnabeld = switchState.on }
        if switchState.tag == 1 { currentNotensatz.kurzabeitenEnabeld = switchState.on }
        if switchState.tag == 2 { currentNotensatz.extemporaleEnabeld = switchState.on }
        if switchState.tag == 3 { currentNotensatz.mundlicheNotenEnabeld = switchState.on }
        if switchState.tag == 4 { currentNotensatz.fachreferatEnabeld = switchState.on }
        
        
        self.view.removeAllSubviews()
        self.scrollView.removeAllSubviews()
        self.einstellungenView.removeAllSubviews()
        self.setzeScrollView(0.3)
        self.setzeNameLabel()
        self.setzeNotenLabel(self.currentNotensatz)
        self.setzeEinstellungen(0.3)
        
        
    }
}


extension DetailTV: NSFetchedResultsControllerDelegate {
    // MARK: - CoreData
    
    
    
    
    
    
}



