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
    
//    @IBOutlet weak var schulaufgabeSwitch: UISwitch!
//    @IBOutlet weak var kurzarbeitenSwitch: UISwitch!
//    @IBOutlet weak var extempoaleSwitch: UISwitch!
//    @IBOutlet weak var fachreferatSwitch: UISwitch!
//    @IBOutlet weak var mundlicheNoteSwitch: UISwitch!
    
    
    var currentNotensatz: Notensatz!
    var scrollView = UIScrollView()
    var einstellungenView = UIView()
    var ubersichtsViewKlein = UIView()
    var ubersichtsView = UIView()
    var notenLabelsView = UIView()
    var einstellungSwitchEnabeld = false
    var navigationBar = UINavigationBar()
    var currentNotenitem: Notenitem!
    var nameLabelView: UILabel!
    var arrays:(schulaufgaben: [Int], kurzarbeiten: [Int], extemporalen: [Int], mundlicheNoten: [Int], fachreferat: [Int])! = nil
    var shortNames = true
    let recognizer = UIPanGestureRecognizer()
    var visible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentNotensatz.name

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "goBack")
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
        
        
        arrays = Notenitem.makeArrays(fetchedResultsController)
        start()
        
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
        // this gives you access to notifications about rotations
    }
    
    func gestureRecognizer(sender: UIPanGestureRecognizer) {
        if self.view.frame.height <= einstellungenView.frame.maxY {
        
        let translation = sender.translationInView(einstellungenView)
        var newY = min(92 + self.scrollView.frame.height, einstellungenView.frame.origin.y + translation.y)
        newY = max(view.frame.height - 203, newY)
        einstellungenView.frame.origin.y = newY
        if newY != view.frame.height - 60 { visible = true }
        sender.setTranslation(CGPointZero, inView: einstellungenView)
        }
    }
    
    func orientationChanged(sender: NSNotification)
    {
        
        removeAllViews()
        start()
    }
    func removeAllViews() {
        self.notenLabelsView.removeAllSubviews()
        self.ubersichtsViewKlein.removeAllSubviews()
        self.ubersichtsView.removeAllSubviews()
        self.scrollView.removeAllSubviews()
        self.notenLabelsView.removeAllSubviews()
        self.einstellungenView.removeAllSubviews()
        self.view.removeAllSubviews()
        
        notenLabelsView = UIView()
        ubersichtsViewKlein = UIView()
        scrollView = UIScrollView()
        ubersichtsView = UIView()
        einstellungenView = UIView()
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
        setzeNotenLabel()
        
        recognizer.addTarget(self, action: "gestureRecognizer:")
        einstellungenView.addGestureRecognizer(recognizer)
        
        setzeEinstellungen()
    }
    
    
    private func setzeScrollView(animationDuration: NSTimeInterval = 0) {
        UIView.animateWithDuration(animationDuration) {
            
            if self.shortNames { self.notenLabelsView.frame = CGRectMake(0, 72, 45, self.currentNotensatz.getHight() + 30 )
            } else { self.notenLabelsView.frame = CGRectMake(0, 72, 153, self.currentNotensatz.getHight() + 30 )}
            self.notenLabelsView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(self.notenLabelsView)

            self.scrollView.frame = CGRectMake(self.notenLabelsView.frame.width, CGFloat(72), UIScreen.mainScreen().bounds.width, self.currentNotensatz.getHight() + 30 )
//            self.scrollView.backgroundColor = UIColor.darkGrayColor()
            self.scrollView.contentSize.width = CGFloat(1000)
            self.view.addSubview(self.scrollView)
            
            self.ubersichtsView.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 67, CGFloat(72), CGFloat(66), self.currentNotensatz.getHight() + 30 )
            self.ubersichtsView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(self.ubersichtsView)

            self.ubersichtsViewKlein.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 116, self.currentNotensatz.getHight() + 52 , 99, 30 )
//            self.ubersichtsViewKlein.backgroundColor = UIColor.()
            self.view.addSubview(self.ubersichtsViewKlein)
        
        }
    }
    
    
    
    private func setzeNotenLabel(animationDuration: NSTimeInterval = 0) {
        func plaziereNotenLabelPlaziere(TFName: String, zeile: Int, withTag: Int) {
            struct nameTF {
                var name: String!
                var tag: Int!
                var x: CGFloat!
                var y: CGFloat!
            }
            
            var nameTFInstanz = nameTF(name: TFName, tag: withTag, x: 8.toCGFloat(), y: nil)
            switch zeile {
            case 1: nameTFInstanz.y = 20.toCGFloat()
            case 2: nameTFInstanz.y = 49.toCGFloat()
            case 3: nameTFInstanz.y = 78.toCGFloat()
            case 4: nameTFInstanz.y = 107.toCGFloat()
            case 5: nameTFInstanz.y = 136.toCGFloat()
            case 6: nameTFInstanz.y = 165.toCGFloat()
            default: return
            }
            nameLabelView = UILabel()
            nameLabelView.text = nameTFInstanz.name
            nameLabelView.tag = nameTFInstanz.tag
            nameLabelView.layer.borderColor = UIColor.blackColor().CGColor
            nameLabelView.layer.borderWidth = CGFloat(1)
            
            if TFName == "∅" {
//                nameLabelView.frame = CGRect(x: self.scrollView.contentSize.width - 124, y: nameTFInstanz.y + 1, width: 50.toCGFloat(), height: 30.toCGFloat())

                nameLabelView.frame = CGRect(x: 0, y: 0, width: 50.toCGFloat(), height: 30.toCGFloat())
                self.nameLabelView.textAlignment = .Center
                self.ubersichtsViewKlein.addSubview(nameLabelView)
                setzteUbersichtCellen(nameLabelView)
                return
            }
            nameLabelView.frame = CGRect(x: nameTFInstanz.x, y: nameTFInstanz.y, width: self.notenLabelsView.frame.width - nameTFInstanz.x, height: 30.toCGFloat())
            self.notenLabelsView.addSubview(nameLabelView)
            
            setzeNotenCellen(nameLabelView)
            setzteUbersichtCellen(nameLabelView)
        }
        func setzeNotenCellen(firstNameCell: UILabel) {
            //            let allNumberOfObjets = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).numberOfObjects
            var allNumberOfObjets = 0
            if max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count]) != 0 {
                allNumberOfObjets = max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count])
            }
            
            var nameTFViewX = CGFloat(0)
            for i in 0...allNumberOfObjets {
                nameTFViewX = CGFloat(i * 50 - i)
                let cellTFView = UITextField()
                
                switch firstNameCell.tag {
                case 0: cellTFView.tag = i;          if i < arrays.schulaufgaben.count { cellTFView.text = arrays.schulaufgaben[i].toString()}
                case 1: cellTFView.tag = 100 + i;    if i < arrays.kurzarbeiten.count { cellTFView.text = arrays.kurzarbeiten[i].toString()}
                case 2: cellTFView.tag = 200 + i ;   if i < arrays.extemporalen.count { cellTFView.text = arrays.extemporalen[i].toString()}
                case 3: cellTFView.tag = 300 + i; if i < arrays.mundlicheNoten.count { cellTFView.text = arrays.mundlicheNoten[i].toString()}
                case 4: cellTFView.tag = 400 + i;     if i < arrays.fachreferat.count { cellTFView.text = arrays.fachreferat[i].toString()}
                default: break
                }
                
                cellTFView.frame = CGRect(x: nameTFViewX , y: firstNameCell.frame.minY, width: 50.toCGFloat(), height: 30.toCGFloat())
                cellTFView.addTarget(self, action: Selector("changeNote:"), forControlEvents: UIControlEvents.EditingDidEnd)
                cellTFView.keyboardType = UIKeyboardType.NumberPad
                cellTFView.borderStyle = UITextBorderStyle.Line
                cellTFView.textAlignment = .Center
                self.scrollView.addSubview(cellTFView)
            }
            if shortNames { self.scrollView.contentSize.width = CGFloat( 180 ) + nameTFViewX }
            else { self.scrollView.contentSize.width = CGFloat( 277 ) + nameTFViewX }
        }
        
        func setzteUbersichtCellen(firstNameCell: UILabel) {
            //                nameLabelView.frame = CGRect(x: self.scrollView.contentSize.width - 124, y: nameTFInstanz.y + 1, width: 50.toCGFloat(), height: 30.toCGFloat())

            let celle = UILabel(frame: CGRectMake(CGFloat(0), firstNameCell.frame.minY, CGFloat(50), CGFloat(30)))
            celle.layer.borderColor = UIColor.blackColor().CGColor
            celle.textAlignment = .Center
            celle.layer.borderWidth = CGFloat(1)
            
            switch firstNameCell.tag {
            case 0: celle.text = average(arrays.schulaufgaben).setLenghtOfTheNumberAfterPointTo(1)!.toString()
            case 1: celle.text = average(arrays.kurzarbeiten).setLenghtOfTheNumberAfterPointTo(1)!.toString()
            case 2: celle.text = average(arrays.extemporalen).setLenghtOfTheNumberAfterPointTo(1)!.toString()
            case 3: celle.text = average(arrays.mundlicheNoten).setLenghtOfTheNumberAfterPointTo(1)!.toString()
            case 4: celle.text = average(arrays.fachreferat).setLenghtOfTheNumberAfterPointTo(1)!.toString()
            case 5 :
                celle.frame = CGRectMake(49, 0, 50, 30)
                var durchschnittMundliche = average([average(arrays.kurzarbeiten), average(arrays.extemporalen), average(arrays.mundlicheNoten)])
                if arrays.fachreferat.count != 0 {
                    durchschnittMundliche = durchschnittMundliche * 2 + Double(arrays.fachreferat[0]) / 3
                }
            
                if arrays.schulaufgaben.count == 1 {
                    celle.text = average([average(arrays.schulaufgaben), durchschnittMundliche]).setLenghtOfTheNumberAfterPointTo(2)!.toString()
                } else if arrays.schulaufgaben.count > 1 {
                    celle.text = ((average(arrays.schulaufgaben) * 2 + durchschnittMundliche) / 3).setLenghtOfTheNumberAfterPointTo(2)!.toString()
                }
                else if arrays.schulaufgaben.count < 1 {
                    celle.text = durchschnittMundliche.toString()
                }
                self.ubersichtsViewKlein.addSubview(celle)
                return
            default: break
            }
            self.ubersichtsView.addSubview(celle)
        }
        
        //MARK: Setze NotenLabel Start
        var zeile = 0
        
        if shortNames {
            if currentNotensatz.schulaufgabeEnabeld == true {
                ++zeile
                plaziereNotenLabelPlaziere(" SA", zeile: zeile, withTag: 0)
            }
            if currentNotensatz.kurzabeitenEnabeld == true {
                ++zeile
                plaziereNotenLabelPlaziere(" KA", zeile: zeile, withTag: 1)
            }
            if currentNotensatz.extemporaleEnabeld == true {
                ++zeile
                plaziereNotenLabelPlaziere(" EX", zeile: zeile, withTag: 2)
            }
            if currentNotensatz.mundlicheNotenEnabeld == true {
                ++zeile
                plaziereNotenLabelPlaziere(" MN", zeile: zeile, withTag: 3)
            }
            if currentNotensatz.fachreferatEnabeld == true {
                ++zeile
                plaziereNotenLabelPlaziere(" FR", zeile: zeile, withTag: 4)
            }
        } else {
        if currentNotensatz.schulaufgabeEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Schulaufgabe", zeile: zeile, withTag: 0)
        }
        if currentNotensatz.kurzabeitenEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Kurzarbeiten", zeile: zeile, withTag: 1)
        }
        if currentNotensatz.extemporaleEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Extemporalen", zeile: zeile, withTag: 0)
        }
        if currentNotensatz.mundlicheNotenEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Mündliche Noten", zeile: zeile, withTag: 0)
        }
        if currentNotensatz.fachreferatEnabeld == true {
            ++zeile
            plaziereNotenLabelPlaziere(" Fachreferat", zeile: zeile, withTag: 0)
        }
        }
        plaziereNotenLabelPlaziere("∅", zeile: zeile + 1, withTag: 5)
    }
    
    func changeNote(sender: UITextField) {
        
        
        if sender.text!.isNotEmpty {
            if sender.tag<100 { Notenitem.addNotenitemSchulaufgabe(currentNotensatz, schulaufgabe: sender.text!.toInt()!) }
            else if sender.tag<200 { Notenitem.addNotenitemKurzarbeit(currentNotensatz, kurzarbeit: sender.text!.toInt()!) }
            else if sender.tag<300 { Notenitem.addNotenitemExtemporale(currentNotensatz, extemporale: sender.text!.toInt()!) }
            else if sender.tag<400 { Notenitem.addNotenitemMundlicheNote(currentNotensatz, mundlicheNote: sender.text!.toInt()!) }
            else if sender.tag<500 { Notenitem.addNotenitemFachreferat(currentNotensatz, fachreferat: sender.text!.toInt()!) }
            
            
        }
        else {
            
            
            
            let notenitems = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).objects
            
            if sender.tag<100 {
                if arrays.schulaufgaben.count - 1 >= sender.tag {
                    var schulaufgabe: [Notenitem] = []
                    guard let notenitemsUnwrepped = notenitems else {return}
                    
                    for i in notenitemsUnwrepped {
                        if (i as! Notenitem).schulaufgaben != nil {
                            schulaufgabe.append(i as! Notenitem)
                        }
                    }
                    
                    schulaufgabe[sender.tag].delete()
                }
            } else if sender.tag<200 {
                if arrays.kurzarbeiten.count - 1 >= sender.tag - 100 {
                    
                    var kurzarbeiten: [Notenitem] = []
                    guard let notenitemsUnwrepped = notenitems else {return}
                    
                    for i in notenitemsUnwrepped {
                        if (i as! Notenitem).kurzarbeiten != nil {
                            kurzarbeiten.append(i as! Notenitem)
                        }
                    }
                    kurzarbeiten[sender.tag - 100].delete()
                    
                }
            } else if sender.tag<300 {
                
                if arrays.extemporalen.count - 1 >= sender.tag - 200 {
                    var extemporalen: [Notenitem] = []
                    guard let notenitemsUnwrepped = notenitems else {return}
                    
                    for i in notenitemsUnwrepped {
                        if (i as! Notenitem).extemporale != nil {
                            extemporalen.append(i as! Notenitem)
                        }
                    }
                    extemporalen[sender.tag - 200].delete()
                }
            } else if sender.tag<400 {
                if arrays.mundlicheNoten.count - 1 >= sender.tag - 300 {
                    var mundlicheNoten: [Notenitem] = []
                    guard let notenitemsUnwrepped = notenitems else {return}
                    
                    for i in notenitemsUnwrepped {
                        if (i as! Notenitem).mundlicheNote != nil {
                            mundlicheNoten.append(i as! Notenitem)
                        }
                    }
                    mundlicheNoten[sender.tag - 300].delete()
                }
            } else if sender.tag<500 {
                if arrays.fachreferat.count - 1 >= sender.tag - 400 {
                    var fachreferat: [Notenitem] = []
                    guard let notenitemsUnwrepped = notenitems else {return}
                    
                    for i in notenitemsUnwrepped {
                        if (i as! Notenitem).fachreferat != nil {
                            fachreferat.append(i as! Notenitem)
                        }
                    }
                    fachreferat[sender.tag - 400].delete()
                }
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
        
        self.notenLabelsView.removeAllSubviews()
        self.ubersichtsViewKlein.removeAllSubviews()
        self.ubersichtsView.removeAllSubviews()
        self.scrollView.removeAllSubviews()
        self.notenLabelsView.removeAllSubviews()
        self.einstellungenView.removeAllSubviews()
        self.view.removeAllSubviews()
        
        
        self.setzeScrollView(0)
        self.setzeNotenLabel()
        self.setzeEinstellungen(0.3)
        
        
    }
}


extension DetailTV: NSFetchedResultsControllerDelegate {
    // MARK: - CoreData
    
    
    
    
    
    
}



