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
    
    @IBOutlet weak var einstellungenView: UIView!
    @IBOutlet weak var verhaltnis_SchulaufgabenMundlich_Label: UILabel!
    @IBOutlet weak var verhaltnis_SchulaufgabenMundlich_Schulaufgaben: UITextField!
    @IBOutlet weak var verhaltnis_Schulaufgaben_Mundlich_Mundlich: UITextField!
    
    @IBOutlet weak var verhaltnis_Kurzarbeiten_Exen: UILabel!
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
//        verhaltnis_SchulaufgabenMundlich_Schulaufgaben.addConstraint(NSLayoutConstraint(item: verhaltnis_SchulaufgabenMundlich_Schulaufgaben, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: einstellungenView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
//        setzeVerhaltnisSchulaufgaben_Mundlich()
}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
            verhältnis_SchulaufgabenMündlich_Schulaufgaben: (self.verhaltnis_SchulaufgabenMundlich_Schulaufgaben.text! != "") ? (self.verhaltnis_SchulaufgabenMundlich_Schulaufgaben.text!.toInt()!) : nil,
            verhältnis_SchulaufgabenMündlich_Mündlich: (self.verhaltnis_Schulaufgaben_Mundlich_Mundlich.text! != "") ? (self.verhaltnis_Schulaufgaben_Mundlich_Mundlich.text!.toInt()!) : nil,
            verhaltnis_Kurzarbeit_Exen_Kurzarbeit: (self.verhaltnis_Kurzarbeit_Exen_Kurzarbeit.text! != "") ? (self.verhaltnis_Kurzarbeit_Exen_Kurzarbeit.text!.toInt()!) : nil,
            verhaltnis_Kurzarbeit_Exen_Exen: (self.verhaltnis_Kurzarbeit_Exen_Exen.text! != "") ? (self.verhaltnis_Kurzarbeit_Exen_Exen.text!.toInt()!) : nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

//MARK: - Actions
extension AddNewFach {
    
    @IBAction func verhaltnis_Schulaufgaben_Mundlich(sender: UISwitch) {
        verhaltnis_SchulaufgabenMundlich_Label.hidden = !sender.on
        verhaltnis_SchulaufgabenMundlich_Schulaufgaben.hidden = !sender.on
        verhaltnis_Schulaufgaben_Mundlich_Mundlich.hidden = !sender.on
        setzeVerhaltnis_Kurzarbeien_Exen()
    }

    @IBAction func verhaltnis_Kurzarbeiten_Exen(sender: UISwitch) {
        verhaltnis_Kurzarbeiten_Exen.hidden = !sender.on
        verhaltnis_Kurzarbeit_Exen_Kurzarbeit.hidden = !sender.on
        verhaltnis_Kurzarbeit_Exen_Exen.hidden = !sender.on
        setzeVerhaltnis_Kurzarbeien_Exen()
    }
 
    func setzeVerhaltnisSchulaufgaben_Mundlich () {
            verhaltnis_SchulaufgabenMundlich_Label.frame = CGRectMake(16, fachreferat.frame.maxY + 16, view.frame.width, 30)
            verhaltnis_SchulaufgabenMundlich_Schulaufgaben.frame = CGRectMake(view.frame.width / 2 - 58, verhaltnis_SchulaufgabenMundlich_Label.frame.maxY + 8, 50, 30)
            verhaltnis_Schulaufgaben_Mundlich_Mundlich.frame = CGRectMake(view.frame.width / 2 + 8, verhaltnis_SchulaufgabenMundlich_Schulaufgaben.frame.minY, verhaltnis_SchulaufgabenMundlich_Schulaufgaben.frame.width, verhaltnis_SchulaufgabenMundlich_Schulaufgaben.frame.height)
        setzeVerhaltnis_Kurzarbeien_Exen()
    }
    func setzeVerhaltnis_Kurzarbeien_Exen () {
        if schulaufgaben.on {
//            verhaltnis_Kurzarbeiten_Exen.frame = CGRectMake(16, verhaltnis_SchulaufgabenMundlich_Schulaufgaben.frame.maxY + 16, view.frame.width, 30)
//            verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame = CGRectMake(view.frame.width / 2 - 58, verhaltnis_Kurzarbeiten_Exen.frame.maxY + 8, 50, 30)
//            verhaltnis_Kurzarbeit_Exen_Exen.frame = CGRectMake(view.frame.width / 2 + 8,verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame.minY, verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame.width, verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame.height)
            verhaltnis_Kurzarbeiten_Exen.enabled = schulaufgaben.on
        } else {
            verhaltnis_Kurzarbeiten_Exen.frame = CGRectMake(16, fachreferat.frame.maxY + 16, view.frame.width, 30)
            verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame = CGRectMake(view.frame.width / 2 - 58, verhaltnis_Kurzarbeiten_Exen.frame.maxY + 8, 50, 30)
            verhaltnis_Kurzarbeit_Exen_Exen.frame = CGRectMake(view.frame.width / 2 + 8,verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame.minY, verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame.width, verhaltnis_Kurzarbeit_Exen_Kurzarbeit.frame.height)
        }
//        einstellungenView.frame = CGRectMake(einstellungenView.frame.minX, einstellungenView.frame.minY, einstellungenView.frame.width, verhaltnis_Kurzarbeiten_Exen.frame.maxY + 8)
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


