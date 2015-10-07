//
//  CalculateTVC.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 03.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit
import CoreData

class CalculateTVC: UIViewController, NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //MARK: Variablendeklaration
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var jahresfortgangsnoteTF: UITextField!
    @IBOutlet weak var schriftlichePrufungDerzeitTF: UITextField!
    @IBOutlet weak var mundlichePrufungDerzeitTF: UITextField!
    @IBOutlet weak var zeugnisspunkteDerzeitTF: UITextField!
    @IBOutlet weak var gerundeteZeugnisspunkteTF: UITextField!
    @IBOutlet weak var entsprichtDieNoteTF: UITextField!
    @IBOutlet weak var nachstbesserePunkteTF: UITextField!
    @IBOutlet weak var erreichbarMitTF: UITextField!
    @IBOutlet weak var pflichtMundlichePrufung: UISwitch!
    
    @IBOutlet weak var mundlichePrufungDerzeitLabel: UILabel!
    @IBOutlet weak var ubernachstePunkteTF: UITextField!
    @IBOutlet weak var ubernachstePunkteErreichbarMitTF: UITextField!
    
    @IBOutlet weak var nachstePunkteView: UIView!
    @IBOutlet weak var ubernachstePunkteView: UIView!
    @IBOutlet weak var prufungsView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    var segueRecognizerNachstePunkte: UITapGestureRecognizer!
    var segueRecognizerUbernachstePunkte: UITapGestureRecognizer!
    
    var daten:[calculateWithData] = []
    var dataFromHistory: calculateWithData!
    
    var hinzugefugtUm: NSDate!
    var delayIntervall: Double = 20
    var data: [[String: String]]!
    var name = ""
    
    
    //MARK: - Obligatorische Funktionen
    override func viewDidLoad() {
//        self.viewDidLoad()
        pflichtMundlichePrufung.on = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "performSegueToHistoryCalculateTVC")
        
        jahresfortgangsnoteTF.delegate = self
        schriftlichePrufungDerzeitTF.delegate = self
        mundlichePrufungDerzeitTF.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapGestureRecognizer:"))
        segueRecognizerNachstePunkte = UITapGestureRecognizer(target: self, action: "performSegueToNotenUbersicht:")
        segueRecognizerUbernachstePunkte = UITapGestureRecognizer(target: self, action: "performSegueToNotenUbersicht:")
        nachstePunkteView.addGestureRecognizer(segueRecognizerNachstePunkte)
        ubernachstePunkteView.addGestureRecognizer(segueRecognizerUbernachstePunkte)
    }
    
    override func viewDidAppear(animated: Bool) {
        berechneDataFromHistory()
        mundlichePrufungEnabled(false)
        if data == nil { return }
        name = data[0]["Name"]!
        jahresfortgangsnoteTF.text = data[0]["Ergebnis"]
    }

    
    func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        berechnung()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        berechnung()
        return false
    }

    //MARK: - PickerView
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: data[row]["Name"]!, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 10)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return attributedString
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]["Name"] ?? nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard var dataGuard = data else { return }
        jahresfortgangsnoteTF.text = dataGuard[row]["Ergebnis"]
        name = dataGuard[row]["Name"]!
    }
    




//MARK: - Segues
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "notenUbersichtNachstePunkte" {
        (segue.destinationViewController as! notenUbersicht).jahresfortgangsnote = jahresfortgangsnoteTF.text!.toDouble()! ?? 0
        (segue.destinationViewController as! notenUbersicht).schriftlichePrufung = schriftlichePrufungDerzeitTF.text?.toInt() ?? 0
        (segue.destinationViewController as! notenUbersicht).pflichtMundlichePrufung = mundlichePrufungDerzeitTF.text?.toInt() ?? 0
        (segue.destinationViewController as! notenUbersicht).zeugnissnote = zeugnisspunkteDerzeitTF.text!.toDouble() ?? 0
    } else if segue.identifier == "historySegueCalculate" {
        (segue.destinationViewController as! historyCalculateTVC).daten = daten.reverse()
    }
}
    
    func performSegueToNotenUbersicht(sender: UIPanGestureRecognizer) {
        if jahresfortgangsnoteTF.text != "" && schriftlichePrufungDerzeitTF.text != "" && mundlichePrufungDerzeitTF != "" && zeugnisspunkteDerzeitTF != "" {
            performSegueWithIdentifier("notenUbersichtNachstePunkte", sender: self)
        }
    }
    func performSegueToHistoryCalculateTVC() {
        performSegueWithIdentifier("historySegueCalculate", sender: self)
    }
func berechneDataFromHistory() {
    if dataFromHistory != nil {
        jahresfortgangsnoteTF.text = dataFromHistory.jahresfortgangsnote
        schriftlichePrufungDerzeitTF.text = dataFromHistory.schriftlichePrufung
        zeugnisspunkteDerzeitTF.text = dataFromHistory.zeugnisspunkte
        gerundeteZeugnisspunkteTF.text = dataFromHistory.gerundeteZeugnisspunkte
        entsprichtDieNoteTF.text = dataFromHistory.entsprichtNote
        nachstbesserePunkteTF.text = dataFromHistory.nachstbessereNote
        erreichbarMitTF.text = dataFromHistory.erreichbarMit
        
        if dataFromHistory.ubernachstbessereNote != nil {
            ubernachstePunkteTF.text = dataFromHistory.ubernachstbessereNote
            ubernachstePunkteErreichbarMitTF.text = dataFromHistory.ubernachstbessereNoteErreichbarMit
        } else {
            ubernachstePunkteView.hidden = true
        }
        dataFromHistory = nil
    }
}
func addCurrentDataToHistory() {
    let newHistory = calculateWithData(name: name, jahresfortgangsnote: jahresfortgangsnoteTF.text!, mitMundlicherPrufung: pflichtMundlichePrufung.on, schriftlichePrufung: schriftlichePrufungDerzeitTF.text!, mundlichePrufung: mundlichePrufungDerzeitTF.text, zeugnisspunkte: zeugnisspunkteDerzeitTF.text!, gerundeteZeugnisspunkte: gerundeteZeugnisspunkteTF.text!, entsprichtNote: entsprichtDieNoteTF.text!, nachstbessereNote: nachstbesserePunkteTF.text!, erreichbarMit: erreichbarMitTF.text!, ubernachstbessereNote: ubernachstePunkteTF.text, ubernachstbessereNoteErreichbarMit: ubernachstePunkteErreichbarMitTF.text)
    if daten.count == 0 { daten.append(newHistory); hinzugefugtUm = NSDate() }
    if !contains(daten, this: newHistory) {
        let current = NSDate()
        let intervall = current.timeIntervalSinceDate(hinzugefugtUm)
        if intervall.toString().toDouble()?.absolute < delayIntervall {
            daten.removeLast()
        }
        
        daten.append(newHistory)
        hinzugefugtUm = NSDate()
        name = ""
    }
}

@IBAction func backTo_CalculateTVC_From_HistoryCalculateTVC(segue: UIStoryboardSegue) {
    segue.sourceViewController as! historyCalculateTVC
}

//MARK: Funktionen
func mundlichePrufungEnabled(enabled: Bool) {
    mundlichePrufungDerzeitTF.hidden = !enabled
    mundlichePrufungDerzeitLabel.hidden = !enabled
    if enabled {
        //            print("an")
        //            UIView.animateWithDuration(0.5) {
        //                self.ubernachstePunkteView.frame = CGRectMake(0, self.ubernachstePunkteView.bounds.origin.y, self.ubernachstePunkteView.frame.width, self.ubernachstePunkteView.frame.height)
        //            }
    } else {
        //            print("aus")
        //            UIView.animateWithDuration(0.5) {
        //                self.ubernachstePunkteView.bounds = CGRectMake(0, self.ubernachstePunkteView.bounds.origin.y + 30, self.ubernachstePunkteView.frame.width, self.ubernachstePunkteView.frame.height)
        //            }
    }
    
    //        prufungsView.frame = CGRectMake(CGFloat(0), CGFloat(126), prufungsView.frame.width, CGFloat(97))
    //        if enabled {prufungsView.frame = CGRectMake(CGFloat(0), CGFloat(126), prufungsView.frame.width, CGFloat(97))}
    //        else { prufungsView.frame = CGRectMake(CGFloat(0), CGFloat(126), prufungsView.frame.width, CGFloat(135)) }
}

func berechnung() {
    if !jahresfortgangsnoteTF.text!.isEmpty && !schriftlichePrufungDerzeitTF.text!.isEmpty && (!mundlichePrufungDerzeitTF.text!.isEmpty || !pflichtMundlichePrufung.on) {
        let zeugnisspunkteDerzeit = berechnungDerZeugnisspunkte(pflichtMundlichePrufung.on, mündlicheNote: mundlichePrufungDerzeitTF.text!.toInt())
        zeugnisspunkteDerzeitTF.text = zeugnisspunkteDerzeit.toString()
        gerundeteZeugnisspunkteTF.text = zeugnisspunkteDerzeit.toInt().toString()
        entsprichtDieNoteTF.text = umrechnenInNote(zeugnisspunkteDerzeit).toString()
        let besserePunkte = nachstBessereNote(zeugnisspunkteDerzeit)
        erreichbarMitTF.text = besserePunkte.erreichbarMit.toString()
        nachstbesserePunkteTF.text = besserePunkte.nachstbesserePunkte.toString()
        let zweitBesserePunkte = zweitBessereNote(zeugnisspunkteDerzeit)
        ubernachstePunkteErreichbarMitTF.text = zweitBesserePunkte.erreichbarMit.toString()
        ubernachstePunkteTF.text = zweitBesserePunkte.nachstbesserePunkte.toString()
        
        addCurrentDataToHistory()
    }
}

func berechnungDerZeugnisspunkte(mitMündlich: Bool, mündlicheNote: Int?) ->Double {
    var prufungsergebnis: Double!
    
    if mitMündlich {
        prufungsergebnis = ((schriftlichePrufungDerzeitTF.text!.toDouble()! * 2) + mündlicheNote!.toDouble()) / 3
    } else {
        prufungsergebnis = schriftlichePrufungDerzeitTF.text!.toDouble()!
    }
    return ((jahresfortgangsnoteTF.text!.toDouble()! + prufungsergebnis) / 2).setLenghtOfTheNumberAfterPointTo(2)!
}
func nachstBessereNote(vonPunktanzahl: Double) ->(nachstbesserePunkte: Int, erreichbarMit: Int) {
    let nachsteNotenpunkte = vonPunktanzahl.toInt() + 1
    for i in 0...15 {
        let aktuellesErgebnis = berechnungDerZeugnisspunkte(true, mündlicheNote: i).toInt()
        if aktuellesErgebnis == nachsteNotenpunkte {
            return (nachsteNotenpunkte, i)
        }
    }
    return (0, 0)
}
func zweitBessereNote(vonPunktanzahl: Double) ->(nachstbesserePunkte: Int, erreichbarMit: Int) {
    let nachsteNotenpunkte = vonPunktanzahl.toInt() + 2
    for i in 0...15 {
        let aktuellesErgebnis = berechnungDerZeugnisspunkte(true, mündlicheNote: i).toInt()
        if aktuellesErgebnis == nachsteNotenpunkte {
            return (nachsteNotenpunkte, i)
        }
    }
    //        ubernachstePunkteView.hidden = true
    return (0, 0)
}
func umrechnenInNote(vonPunktanzahl: Double) ->Int {
    if vonPunktanzahl < 0.5 { return 6 }
    else if vonPunktanzahl < 3.5 { return 5 }
    else if vonPunktanzahl < 6.5 { return 4 }
    else if vonPunktanzahl < 9.5 { return 3 }
    else if vonPunktanzahl < 12.5 { return 2 }
    else if vonPunktanzahl < 15 { return 1 }
    else { return 0 }
}

override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    berechnung()
    self.view.endEditing(true)
}


//MARK: - Actions

@IBAction func pflichtMundlichePrufung(sender: UISwitch) {
    mundlichePrufungEnabled(pflichtMundlichePrufung.on)
}
@IBAction func jahresfortgangsnoteTF(sender: UITextField) {
    jahresfortgangsnoteTF.text = jahresfortgangsnoteTF.text!.replace(",", with: ".")
    name = ""
}

@IBAction func schriftlichePrufungDerzeitTF(sender: UITextField) {
    schriftlichePrufungDerzeitTF.text = schriftlichePrufungDerzeitTF.text?.replace(",", with: ".")
}

@IBAction func mundlichePrufungDerzeitTF(sender: UITextField) {
    mundlichePrufungDerzeitTF.text = mundlichePrufungDerzeitTF.text?.replace(",", with: ".")
}
}


struct calculateWithData {
    var name: String
    var jahresfortgangsnote: String
    var mitMundlicherPrufung: Bool
    var schriftlichePrufung: String
    var mundlichePrufung: String?
    var zeugnisspunkte: String
    var gerundeteZeugnisspunkte: String
    var entsprichtNote: String
    var nachstbessereNote: String
    var erreichbarMit: String
    var ubernachstbessereNote: String?
    var ubernachstbessereNoteErreichbarMit: String?
}




