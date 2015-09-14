//
//  AddNewFach.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 05.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class AddNewFach: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var schulaufgaben: UISwitch!
    @IBOutlet weak var kurzarbeiten: UISwitch!
    @IBOutlet weak var extemporale: UISwitch!
    @IBOutlet weak var fachreferat: UISwitch!
    @IBOutlet weak var mundlicheNote: UISwitch!
    @IBOutlet weak var fachart: UIPickerView!
    
//    @IBOutlet weak var FachnameView: UIView!
    
    
    var fachartHistory: [String] = []
    var pickerData = ["Hauptfach", "Nebenfach", "Seminarfach"]
    var currentPicker = "Hauptfach"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .Plain, target: self, action: "goBackSenderAddNewFach")
        
        fachart.delegate = self
        fachart.dataSource = self
        
//        nameTF.text = "Physik"
        fachart.layer.cornerRadius = 10
        //        fachart.rowSizeForComponent(2)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 10)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return attributedString
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPicker = pickerData[row]
    }
    
    
    func goBackSenderAddNewFach () {
        
        let promptController = UIAlertController(title: "Achtung", message: "Eingegebene Daten wurden nicht gesichert.", preferredStyle: .Alert)
        let defaultButton = UIAlertAction(title: "Speichern", style: .Default, handler: { (action) -> Void in
            //            self.nameButtonHistory.append(self.nameButton.text!)
            Notensatz.addNotensatz(self.nameTF.text!, inFachart: self.currentPicker, schulaufgaben: self.schulaufgaben.on, kurzarbeiten: self.kurzarbeiten.on, extemporalen: self.extemporale.on, mundlicheNoten: self.mundlicheNote.on, fachreferat: self.fachreferat.on)
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        let destructiveButton = UIAlertAction(title: "Verwerfen", style: .Destructive) { (action) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        let cancelButton = UIAlertAction(title: "Weiter Bearbeiten", style: .Default) { (_) -> Void in }
        
        promptController.addAction(cancelButton)
        promptController.addAction(defaultButton)
        promptController.addAction(destructiveButton)
        presentViewController(promptController, animated: true, completion: nil)
        
    }
    
//    func addButtons(thisButtons: [String], inView: UIView) {
//        let button   = UIButton(type: .System)
//        button.frame = CGRectMake(8, 46, 100, 25)
//        button.setTitle("Button", forState: UIControlState.Normal)
//        button.backgroundColor = UIColor.lightGrayColor()
//        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        button.layer.cornerRadius = 5
//        FachnameView.addSubview(button)
//        
//        
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UIBarItem {
            (segue.destinationViewController as! ViewController).newData = (name: nameTF.text!, fachart: currentPicker, schulaufgaben: schulaufgaben.on, kurzarbeiten: kurzarbeiten.on, extemporale: extemporale.on, fachreferat: fachreferat.on, mundlicheNote: mundlicheNote.on)
        }
    }
    @IBAction func nameButtonPressed(sender: UIButton) {
        navigationController!.popViewControllerAnimated(true)
    }
}
