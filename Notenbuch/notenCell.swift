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
    var currentNotenitem: Notenitem!
    var cell: UITableViewCell!
    var indexPath: NSIndexPath!
    @IBOutlet weak var view: UIView!
    
    var currentNotensatz: Notensatz! {
        didSet {
            fetchedResultsController = nil
            cellDidLoad()
        }
    }
    
    func cellDidLoad () {
        
        view.subviews.map({ $0.removeFromSuperview() })
        setzeZeilen(currentNotensatz)
        
        
    }
    func orientationChanged(sender: NSNotification){
        cellDidLoad()
        /*
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            cellDidLoad()
        }
        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
            cellDidLoad()
        }
        // Now once only allow the portrait one to go in that conditional part of the view. If you're using a navigation controller push the vc otherwise just use presentViewController:animated:
*/
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    
    
    
    // MARK: - CoreData
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
    
    
    func setzeZeilen(currentNotensatz: Notensatz) {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        label.text = currentNotensatz.name!
        self.view.addSubview(label)
        
        var zeile = 0
        if currentNotensatz.schulaufgabeEnabeld == true {
            ++zeile
            plaziere(" Schulaufgabe", zeile: zeile)
        }
        if currentNotensatz.kurzabeitenEnabeld == true {
            ++zeile
            plaziere(" Kurzarbeiten", zeile: zeile)
        }
        if currentNotensatz.extemporaleEnabeld == true {
            ++zeile
            plaziere(" Extemporalen", zeile: zeile)
        }
        if currentNotensatz.mundlicheNotenEnabeld == true {
            ++zeile
            plaziere(" Mündliche Noten", zeile: zeile)
        }
        if currentNotensatz.fachreferatEnabeld == true {
            ++zeile
            plaziere(" Fachreferat", zeile: zeile)
        }
    }
    
    
    private func plaziere(TFName: String, zeile: Int) {
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
        
        let nameTFView = UITextField(frame: CGRect(x: nameTFInstanz.x, y: nameTFInstanz.y, width: 145.toCGFloat(), height: 30.toCGFloat()))
        nameTFView.text = nameTFInstanz.name
        nameTFView.borderStyle = UITextBorderStyle.Line
        nameTFView.enabled = false
        self.view.addSubview(nameTFView)
        
        plaziereNotenCellen(nameTFView)
        plaziereUbersichtCellen(nameTFView)
        
    }
    
    private func plaziereNotenCellen(firstNameCell: UITextField) {
        let allNumberOfObjets = ((fetchedResultsController.sections?[0])! as NSFetchedResultsSectionInfo).numberOfObjects
        var numberOfObjects = 0
        var schulaufgabe: [Int] = []
        var kurzarbeiten: [Int] = []
        var extemporalen: [Int] = []
        var mundlicheNoten: [Int] = []
        var fachreferat: [Int] = []

        
        if allNumberOfObjets != 0 {
            for i in 0..<allNumberOfObjets {

                currentNotenitem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? Notenitem

                numberOfObjects++
                if currentNotenitem.schulaufgaben != nil { schulaufgabe.append(currentNotenitem.schulaufgaben! as Int) }
                if currentNotenitem.kurzarbeiten != nil { kurzarbeiten.append(currentNotenitem.kurzarbeiten! as Int) }
                if currentNotenitem.extemporale != nil { extemporalen.append(currentNotenitem.extemporale! as Int) }
                if currentNotenitem.mundlicheNote != nil { mundlicheNoten.append(currentNotenitem.mundlicheNote! as Int) }
                if currentNotenitem.fachreferat != nil { fachreferat.append(currentNotenitem.fachreferat! as Int) }
            }
        }
        
        
        for i in 0...15 {
            let cellTFView = UITextField()
            let nameTFViewX = (firstNameCell.frame.maxX - CGFloat(1)) + CGFloat(i * 50 - i)
            cellTFView.frame = CGRect(x: nameTFViewX , y: firstNameCell.frame.minY, width: 50.toCGFloat(), height: 30.toCGFloat())
            

            
            
            
            if nameTFViewX > self.view.layer.frame.width - 116 {
                return
            }
            
            
            switch firstNameCell.text! {
            case " Schulaufgabe": if i < schulaufgabe.count { cellTFView.text = schulaufgabe[i].toString() }
            case " Kurzarbeiten": if i < kurzarbeiten.count { cellTFView.text = kurzarbeiten[i].toString() }
            case " Extemporalen": if i < extemporalen.count { cellTFView.text = extemporalen[i].toString() }
            case " Mündliche Noten": if i < mundlicheNoten.count { cellTFView.text = mundlicheNoten[i].toString() }
            case " Fachreferat": if i < fachreferat.count { cellTFView.text = fachreferat[i].toString() }
            default: break
            }
            
            cellTFView.borderStyle = UITextBorderStyle.Line
            cellTFView.textAlignment = NSTextAlignment.Center
            cellTFView.enabled = false
            self.view.addSubview(cellTFView)
        }
    }
    
    private func plaziereUbersichtCellen(firstNameCell: UITextField) {
        let celle = UITextField(frame: CGRect(x: self.view.frame.width - 66, y: firstNameCell.frame.minY, width: 50, height: 30))
        celle.borderStyle = UITextBorderStyle.Line
        celle.enabled = false
        self.view.addSubview(celle)
        
        
    }
    
}

