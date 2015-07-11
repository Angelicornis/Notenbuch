//
//  AddNewFach.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 05.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class AddNewFach: UIViewController {
    @IBOutlet weak var nameButton: UITextField!
    @IBOutlet weak var Fachart: UITextField!
    @IBOutlet weak var schulaufgaben: UISwitch!
    @IBOutlet weak var kurzarbeiten: UISwitch!
    @IBOutlet weak var extemporale: UISwitch!
    @IBOutlet weak var fachreferat: UISwitch!
    @IBOutlet weak var mundlicheNote: UISwitch!

    @IBOutlet weak var FachnameView: UIView!
    
    var nameButtonHistory: [String] = ["hi", "superdrouper"]
    var fachartHistory: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        nameButton.text = "Physik"
        Fachart.text = "Hauptfach"
//        addButtons(nameButtonHistory, inView: FachnameView)
//        for i in enumerate(nameButtonHistory) {
//            var nameButtonHistoryButton: UIButton!
//            nameButtonHistoryButton.setTitle(nameButtonHistory[i.index], forState: UIControlState.Normal)
//            view.addSubview(nameButtonHistoryButton)
//            
//        }
        
    }
    func addButtons(thisButtons: [String], inView: UIView) {
        
        var button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(8, 46, 100, 25)
        button.setTitle("Button", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 5
        //        button.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        FachnameView.addSubview(button)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if !nameButton.text.isEmpty {
            nameButtonHistory.append(nameButton.text)
        }
        if !Fachart.text.isEmpty {
            fachartHistory.append(Fachart.text)
        }
        
        if let senderButton = sender as? UIBarItem {
            (segue.destinationViewController as! ViewController).newData = (name: nameButton.text, fachart: Fachart.text, schulaufgaben: schulaufgaben.on, kurzarbeiten: kurzarbeiten.on, extemporale: extemporale.on, fachreferat: fachreferat.on, mundlicheNote: mundlicheNote.on)
        }
    }
    @IBAction func nameButtonPressed(sender: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
    }
}
