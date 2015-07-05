//
//  CalculateTVC.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 03.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class CalculateTVC: UIViewController {
    
    //MARK: Variablendeklaration
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
    
    @IBOutlet weak var ubernachstePunkteView: UIView!
    @IBOutlet weak var prufungsView: UIView!
    
    @IBOutlet weak var segueBTN1: UIButton!
    @IBOutlet weak var segueBTN2: UIButton!
    
    
    var daten:[calculateWithData] = []
    var dataFromHistory: calculateWithData!
    var dataFromHistoryStatus = false
    var hinzugefugtUm: NSDate!
    
    
    //MARK: - Obligatorische Funktionen
    override func viewDidLoad() {
        pflichtMundlichePrufung.on = false
        if !pflichtMundlichePrufung.on {
            mundlichePrufungDerzeitTF.enabled = false
        }
        //
        //        jahresfortgangsnoteTF.text = "7.7"
        //        schriftlichePrufungDerzeitTF.text = "8"
        //        zeugnisspunkteDerzeitTF.text = "7.85"
        //        gerundeteZeugnisspunkteTF.text = zeugnisspunkteDerzeitTF.text.toDouble()!.toInt().toString()
        //        entsprichtDieNoteTF.text = "3"
        //        if !jahresfortgangsnoteTF.text.isEmpty && !mundlichePrufungDerzeitTF.text.isEmpty {
        //            berechnung(false, mündlicheNote: nil)
        //            nachstBessereNote(7.85)
        //            zweitBessereNote(7.85)
        //        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if dataFromHistoryStatus {
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
            dataFromHistoryStatus = false
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "notenUbersichtNachstePunkte" || segue.identifier == "notenUbersichtUbernachstePunkte" {
            addCurrentDataToHistory()
            (segue.destinationViewController as! notenUbersicht).jahresfortgangsnote = jahresfortgangsnoteTF.text.toDouble()! ?? 0
            (segue.destinationViewController as! notenUbersicht).schriftlichePrufung = schriftlichePrufungDerzeitTF.text.toInt() ?? 0
            (segue.destinationViewController as! notenUbersicht).pflichtMundlichePrufung = mundlichePrufungDerzeitTF.text.toInt() ?? 0
            (segue.destinationViewController as! notenUbersicht).zeugnissnote = zeugnisspunkteDerzeitTF.text.toDouble() ?? 0
        } else if segue.identifier == "historySegueCalculate" {
            (segue.destinationViewController as! historyCalculateTVC).daten = daten.reverse()
        }
    }
    
    //MARK: Funktioen
    func addCurrentDataToHistory() {
        println(daten.count)
        var vorhanden = false
        var newHistory = calculateWithData(name: "", jahresfortgangsnote: jahresfortgangsnoteTF.text, mitMundlicherPrufung: pflichtMundlichePrufung.on, schriftlichePrufung: schriftlichePrufungDerzeitTF.text, mundlichePrufung: mundlichePrufungDerzeitTF.text, zeugnisspunkte: zeugnisspunkteDerzeitTF.text, gerundeteZeugnisspunkte: gerundeteZeugnisspunkteTF.text, entsprichtNote: entsprichtDieNoteTF.text, nachstbessereNote: nachstbesserePunkteTF.text, erreichbarMit: erreichbarMitTF.text, ubernachstbessereNote: ubernachstePunkteTF.text, ubernachstbessereNoteErreichbarMit: ubernachstePunkteErreichbarMitTF.text)
        if daten.count == 0 { daten.append(newHistory); hinzugefugtUm = NSDate() }
        if !contains(daten, newHistory) {
            var current = NSDate()
            var intervall = current.timeIntervalSinceDate(hinzugefugtUm)
            println(intervall)
            if intervall.toString().toDouble()?.absolute < 30 {
                daten.removeLast()
            }
            
            daten.append(newHistory)
            hinzugefugtUm = NSDate()
        }
    }
    
    func mundlichePrufungEnabled(enabled: Bool) {
        mundlichePrufungDerzeitTF.hidden = !enabled
        mundlichePrufungDerzeitLabel.hidden = !enabled
        if enabled {
            println("an")
            UIView.animateWithDuration(0.5) {
                self.ubernachstePunkteView.frame = CGRectMake(0, self.ubernachstePunkteView.bounds.origin.y, self.ubernachstePunkteView.frame.width, self.ubernachstePunkteView.frame.height)
            }
        } else {
            println("aus")
            UIView.animateWithDuration(0.5) {
                self.ubernachstePunkteView.bounds = CGRectMake(0, self.ubernachstePunkteView.bounds.origin.y + 30, self.ubernachstePunkteView.frame.width, self.ubernachstePunkteView.frame.height)
            }
        }
        
        //        prufungsView.frame = CGRectMake(CGFloat(0), CGFloat(126), prufungsView.frame.width, CGFloat(97))
        //        if enabled {prufungsView.frame = CGRectMake(CGFloat(0), CGFloat(126), prufungsView.frame.width, CGFloat(97))}
        //        else { prufungsView.frame = CGRectMake(CGFloat(0), CGFloat(126), prufungsView.frame.width, CGFloat(135)) }
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
    
    
    func berechnung() {
        if !jahresfortgangsnoteTF.text.isEmpty && !schriftlichePrufungDerzeitTF.text.isEmpty && (!mundlichePrufungDerzeitTF.text.isEmpty || !pflichtMundlichePrufung.on) {
            var zeugnisspunkteDerzeit = berechnungDerZeugnisspunkte(pflichtMundlichePrufung.on, mündlicheNote: mundlichePrufungDerzeitTF.text.toInt())
            zeugnisspunkteDerzeitTF.text = zeugnisspunkteDerzeit.toString()
            gerundeteZeugnisspunkteTF.text = zeugnisspunkteDerzeit.toInt().toString()
            entsprichtDieNoteTF.text = umrechnenInNote(zeugnisspunkteDerzeit).toString()
            var besserePunkte = nachstBessereNote(zeugnisspunkteDerzeit)
            erreichbarMitTF.text = besserePunkte.erreichbarMit.toString()
            nachstbesserePunkteTF.text = besserePunkte.nachstbesserePunkte.toString()
            var zweitBesserePunkte = zweitBessereNote(zeugnisspunkteDerzeit)
            ubernachstePunkteErreichbarMitTF.text = zweitBesserePunkte.erreichbarMit.toString()
            ubernachstePunkteTF.text = zweitBesserePunkte.nachstbesserePunkte.toString()
            segueBTN1.enabled = true
            segueBTN2.enabled = true
            addCurrentDataToHistory()
        } else {
            segueBTN1.enabled = false
            segueBTN2.enabled = false
        }
    }
    
    
    
    
    func berechnungDerZeugnisspunkte(mitMündlich: Bool, mündlicheNote: Int?) ->Double {
        var prufungsergebnis: Double!
        
        if mitMündlich {
            prufungsergebnis = ((schriftlichePrufungDerzeitTF.text.toDouble()! * 2) + mündlicheNote!.toDouble()) / 3
        } else {
            prufungsergebnis = schriftlichePrufungDerzeitTF.text.toDouble()!
        }
        
        return ((jahresfortgangsnoteTF.text.toDouble()! + prufungsergebnis) / 2).setLenghtOfTheNumberAfterPointTo(2)!
    }
    func nachstBessereNote(vonPunktanzahl: Double) ->(nachstbesserePunkte: Int, erreichbarMit: Int) {
        var nachsteNotenpunkte = vonPunktanzahl.toInt() + 1
        for i in 0...15 {
            var aktuellesErgebnis = berechnungDerZeugnisspunkte(true, mündlicheNote: i).toInt()
            if aktuellesErgebnis == nachsteNotenpunkte {
                return (nachsteNotenpunkte, i)
            }
        }
        return (0, 0)
    }
    func zweitBessereNote(vonPunktanzahl: Double) ->(nachstbesserePunkte: Int, erreichbarMit: Int) {
        var nachsteNotenpunkte = vonPunktanzahl.toInt() + 2
        for i in 0...15 {
            var aktuellesErgebnis = berechnungDerZeugnisspunkte(true, mündlicheNote: i).toInt()
            if aktuellesErgebnis == nachsteNotenpunkte {
                return (nachsteNotenpunkte, i)
            }
        }
        //        ubernachstePunkteView.hidden = true
        return (0, 0)
    }
    
    
    
    
    
    //MARK: - Actions
    @IBAction func pflichtMundlichePrufung(sender: UISwitch) {
        mundlichePrufungEnabled(pflichtMundlichePrufung.on)
        berechnung()
    }
    @IBAction func jahresfortgangsnoteTF(sender: UITextField) {
        berechnung()
    }
    
    @IBAction func schriftlichePrufungDerzeitTF(sender: UITextField) {
        berechnung()
    }
    
    @IBAction func mundlichePrufungDerzeitTF(sender: UITextField) {
        berechnung()
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




