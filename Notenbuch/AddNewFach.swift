//
//  AddNewFach.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 05.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class AddNewFach: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    //MARK: Variablendeklaration
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var schulaufgaben: UISwitch!
    @IBOutlet weak var kurzarbeiten: UISwitch!
    @IBOutlet weak var extemporale: UISwitch!
    @IBOutlet weak var fachreferat: UISwitch!
    @IBOutlet weak var mundlicheNote: UISwitch!
    @IBOutlet weak var fachart: UIPickerView!
    
    @IBOutlet weak var verhältnis_SchulaufgabenMündlich_Schulaufgaben: UITextField!
    @IBOutlet weak var verhaltnis_Schulaufgaben_Mundlich_Mundlich: UITextField!
    
    @IBOutlet weak var verhaltnis_Kurzarbeit_Exen_Kurzarbeit: UITextField!
    @IBOutlet weak var verhaltnis_Kurzarbeit_Exen_Exen: UITextField!
//    @IBOutlet weak var FachnameView: UIView!
    
    
    var fachartHistory: [String] = []
    var pickerData = ["Hauptfach", "Nebenfach", "Seminarfach"]
    var currentPicker = "Hauptfach"
    
}


//MARK: - Obligatorische Funktionen
extension AddNewFach {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .Plain, target: self, action: "goBackSenderAddNewFach")
        
        fachart.delegate = self
        fachart.dataSource = self
        nameTF.delegate = self
        fachart.layer.cornerRadius = 10
        //        fachart.rowSizeForComponent(2)
    }
    
    override func viewDidAppear(animated: Bool) {
        print(verhältnis_SchulaufgabenMündlich_Schulaufgaben.text!)
        print(verhältnis_SchulaufgabenMündlich_Schulaufgaben.text! != "" ? "1" : "2")
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - PickerView
extension AddNewFach {
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
}

//MARK: - CoreData
extension AddNewFach {
    func goBackSenderAddNewFach () {
        
        let promptController = UIAlertController(title: "Achtung", message: "Eingegebene Daten wurden nicht gesichert.", preferredStyle: .Alert)
        let defaultButton = UIAlertAction(title: "Speichern", style: .Default, handler: { (action) -> Void in
            self.save()
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
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        save()
    }
    func save() {
        Notensatz.addNotensatz(
            self.nameTF.text!,
            inFachart: self.currentPicker,
            schulaufgaben: self.schulaufgaben.on,
            kurzarbeiten: self.kurzarbeiten.on,
            extemporalen: self.extemporale.on,
            mundlicheNoten: self.mundlicheNote.on,
            fachreferat: self.fachreferat.on,
            verhältnis_SchulaufgabenMündlich_Schulaufgaben: (self.verhältnis_SchulaufgabenMündlich_Schulaufgaben.text! != "") ? (self.verhältnis_SchulaufgabenMündlich_Schulaufgaben.text!.toInt()!) : nil,
            verhältnis_SchulaufgabenMündlich_Mündlich: (self.verhaltnis_Schulaufgaben_Mundlich_Mundlich.text! != "") ? (self.verhaltnis_Schulaufgaben_Mundlich_Mundlich.text!.toInt()!) : nil,
            verhaltnis_Kurzarbeit_Exen_Kurzarbeit: (self.verhaltnis_Kurzarbeit_Exen_Kurzarbeit.text! != "") ? (self.verhaltnis_Kurzarbeit_Exen_Kurzarbeit.text!.toInt()!) : nil,
            verhaltnis_Kurzarbeit_Exen_Exen: (self.verhaltnis_Kurzarbeit_Exen_Exen.text! != "") ? (self.verhaltnis_Kurzarbeit_Exen_Exen.text!.toInt()!) : nil)
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
}
