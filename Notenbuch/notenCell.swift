//
//  notenCell.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 07.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit
import CoreData


class notenCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var view: UIView!
    
    var currentNotensatz: Notensatz! {
        didSet {
            cellDidLoad()
        }
    }
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
    
    func cellDidLoad() {
//        self.title = currentNotensatz.name
        
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

extension notenCell {
    
    private func start() {
        
        setzeView()
        setzeNotenLabel()
        
        recognizer.addTarget(self, action: "gestureRecognizer:")
        einstellungenView.addGestureRecognizer(recognizer)
        }
    
    
    private func setzeView(animationDuration: NSTimeInterval = 0) {
        UIView.animateWithDuration(animationDuration) {
            
            let nameLabel = UILabel(frame: CGRectMake(8, 8, self.view.frame.width, 21))
            nameLabel.text = self.currentNotensatz.name!
            self.view.addSubview(nameLabel)
            
            if self.shortNames { self.notenLabelsView.frame = CGRectMake(0, 29, 45, self.currentNotensatz.getHight() + 30 )
            } else { self.notenLabelsView.frame = CGRectMake(0, 72, 153, self.currentNotensatz.getHight() + 30 )}
            self.notenLabelsView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(self.notenLabelsView)
            
            self.scrollView.frame = CGRectMake(self.notenLabelsView.frame.width, 29, UIScreen.mainScreen().bounds.width, self.currentNotensatz.getHight() + 30 )
            //            self.scrollView.backgroundColor = UIColor.darkGrayColor()
            self.scrollView.contentSize.width = CGFloat(1000)
            self.view.addSubview(self.scrollView)
            
            self.ubersichtsView.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 67, 29, CGFloat(66), self.currentNotensatz.getHight() - 20 )
            self.ubersichtsView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(self.ubersichtsView)
            
            self.ubersichtsViewKlein.frame = CGRectMake(self.ubersichtsView.frame.minX - 49, self.ubersichtsView.frame.maxY - 1, 99, 30 )
//                        self.ubersichtsViewKlein.backgroundColor = UIColor.lightGrayColor()
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
            } else {
                nameLabelView.frame = CGRect(x: nameTFInstanz.x, y: nameTFInstanz.y, width: self.notenLabelsView.frame.width - nameTFInstanz.x, height: 30.toCGFloat())
                self.notenLabelsView.addSubview(nameLabelView)
                
                setzeNotenCellen(nameLabelView)
                setzteUbersichtCellen(nameLabelView)
            }
        }
        func setzeNotenCellen(firstNameCell: UILabel) {
            //            let allNumberOfObjets = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).numberOfObjects
            var allNumberOfObjets = 0
            if max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count]) != 0 {
                allNumberOfObjets = max([arrays.schulaufgaben.count, arrays.kurzarbeiten.count, arrays.extemporalen.count, arrays.mundlicheNoten.count, arrays.fachreferat.count])
            }
            
            var nameLabelViewX = CGFloat(0)
            for i in 0...allNumberOfObjets {
                nameLabelViewX = CGFloat(i * 50 - i)
                let cellLabelView = UILabel()
                
                switch firstNameCell.tag {
                case 0: cellLabelView.tag = i;          if i < arrays.schulaufgaben.count { cellLabelView.text = arrays.schulaufgaben[i].toString()}
                case 1: cellLabelView.tag = 100 + i;    if i < arrays.kurzarbeiten.count { cellLabelView.text = arrays.kurzarbeiten[i].toString()}
                case 2: cellLabelView.tag = 200 + i ;   if i < arrays.extemporalen.count { cellLabelView.text = arrays.extemporalen[i].toString()}
                case 3: cellLabelView.tag = 300 + i;    if i < arrays.mundlicheNoten.count { cellLabelView.text = arrays.mundlicheNoten[i].toString()}
                case 4: cellLabelView.tag = 400 + i;    if i < arrays.fachreferat.count { cellLabelView.text = arrays.fachreferat[i].toString()}
                default: break
                }
                
                cellLabelView.frame = CGRect(x: nameLabelViewX , y: firstNameCell.frame.minY, width: 50.toCGFloat(), height: 30.toCGFloat())
                cellLabelView.layer.borderColor = UIColor.blackColor().CGColor
                cellLabelView.textAlignment = .Center
                cellLabelView.layer.borderWidth = CGFloat(1)
                cellLabelView.textAlignment = .Center
                self.scrollView.addSubview(cellLabelView)
            }
            if shortNames { self.scrollView.contentSize.width = CGFloat( 180 ) + nameLabelViewX } // 180
            else { self.scrollView.contentSize.width = CGFloat( 277 ) + nameLabelViewX }
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
}

