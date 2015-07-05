//
//  notenUbersicht.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 03.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class notenUbersicht: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ungerundet15TV: UILabel!
    @IBOutlet weak var ungerundet14TV: UILabel!
    @IBOutlet weak var ungerundet13TV: UILabel!
    @IBOutlet weak var ungerundet12TV: UILabel!
    @IBOutlet weak var ungerundet11TV: UILabel!
    @IBOutlet weak var ungerundet10TV: UILabel!
    @IBOutlet weak var ungerundet9TV: UILabel!
    @IBOutlet weak var ungerundet8TV: UILabel!
    @IBOutlet weak var ungerundet7TV: UILabel!
    @IBOutlet weak var ungerundet6TV: UILabel!
    @IBOutlet weak var ungerundet5TV: UILabel!
    @IBOutlet weak var ungerundet4TV: UILabel!
    @IBOutlet weak var ungerundet3TV: UILabel!
    @IBOutlet weak var ungerundet2TV: UILabel!
    @IBOutlet weak var ungerundet1TV: UILabel!
    @IBOutlet weak var ungerundet0TV: UILabel!
    
    
    @IBOutlet weak var gerundet15TV: UILabel!
    @IBOutlet weak var gerundet14TV: UILabel!
    @IBOutlet weak var gerundet13TV: UILabel!
    @IBOutlet weak var gerundet12TV: UILabel!
    @IBOutlet weak var gerundet11TV: UILabel!
    @IBOutlet weak var gerundet10TV: UILabel!
    @IBOutlet weak var gerundet9TV: UILabel!
    @IBOutlet weak var gerundet8TV: UILabel!
    @IBOutlet weak var gerundet7TV: UILabel!
    @IBOutlet weak var gerundet6TV: UILabel!
    @IBOutlet weak var gerundet5TV: UILabel!
    @IBOutlet weak var gerundet4TV: UILabel!
    @IBOutlet weak var gerundet3TV: UILabel!
    @IBOutlet weak var gerundet2TV: UILabel!
    @IBOutlet weak var gerundet1TV: UILabel!
    @IBOutlet weak var gerundet0TV: UILabel!
    
    @IBOutlet weak var mundlichePunkte15: UILabel!
    @IBOutlet weak var mundlichePunkte14: UILabel!
    @IBOutlet weak var mundlichePunkte13: UILabel!
    @IBOutlet weak var mundlichePunkte12: UILabel!
    @IBOutlet weak var mundlichePunkte11: UILabel!
    @IBOutlet weak var mundlichePunkte10: UILabel!
    @IBOutlet weak var mundlichePunkte9: UILabel!
    @IBOutlet weak var mundlichePunkte8: UILabel!
    @IBOutlet weak var mundlichePunkte7: UILabel!
    @IBOutlet weak var mundlichePunkte6: UILabel!
    @IBOutlet weak var mundlichePunkte5: UILabel!
    @IBOutlet weak var mundlichePunkte4: UILabel!
    @IBOutlet weak var mundlichePunkte3: UILabel!
    @IBOutlet weak var mundlichePunkte2: UILabel!
    @IBOutlet weak var mundlichePunkte1: UILabel!
    @IBOutlet weak var mundlichePunkte0: UILabel!
    
    
    
    var jahresfortgangsnote: Double!
    var schriftlichePrufung: Int!
    var pflichtMundlichePrufung: Int!
    var zeugnissnote: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "aktuelle Notepunkte \(zeugnissnote)"
        
        scrollView.contentSize.height = 591
        setzeLabel(berechnung(15), ungerundet14: berechnung(14), ungerundet13: berechnung(13), ungerundet12: berechnung(12), ungerundet11: berechnung(11), ungerundet10: berechnung(10), ungerundet9: berechnung(9), ungerundet8: berechnung(8), ungerundet7: berechnung(7), ungerundet6: berechnung(6), ungerundet5: berechnung(5), ungerundet4: berechnung(4), ungerundet3: berechnung(3), ungerundet2: berechnung(2), ungerundet1: berechnung(1), ungerundet0: berechnung(0))
    }
    
    func berechnung(mündlicheNote: Int) ->Double {
        var prufungsergebnis: Double!
        prufungsergebnis = ((schriftlichePrufung.toDouble() * 2) + mündlicheNote.toDouble()) / 3
        var ergebnis = ((jahresfortgangsnote + prufungsergebnis) / 2).setLenghtOfTheNumberAfterPointTo(2)!
        if ergebnis.toInt() == zeugnissnote.toInt() {
            dunkleEin(mündlicheNote, inColor: UIColor.lightGrayColor())
        } else if ergebnis.toInt() < zeugnissnote.toInt() {
            dunkleEin(mündlicheNote, inColor: UIColor.redColor(), alpha: 0.4)
        }
        return ergebnis
    }
    
    
    func dunkleEin(whichNumber: Int, inColor: UIColor, alpha: Double = 1) {
        switch whichNumber {
        case 0:
            ungerundet0TV.textColor = inColor; gerundet0TV.textColor = inColor; mundlichePunkte0.textColor = inColor
            ungerundet0TV.alpha = CGFloat(alpha); gerundet0TV.alpha = CGFloat(alpha); mundlichePunkte0.alpha = CGFloat(alpha)
        case 1:
            ungerundet1TV.textColor = inColor; gerundet1TV.textColor = inColor; mundlichePunkte1.textColor = inColor
            ungerundet1TV.alpha = CGFloat(alpha); gerundet1TV.alpha = CGFloat(alpha); mundlichePunkte1.alpha = CGFloat(alpha)
        case 2:
            ungerundet2TV.textColor = inColor; gerundet2TV.textColor = inColor; mundlichePunkte2.textColor = inColor
            ungerundet2TV.alpha = CGFloat(alpha); gerundet2TV.alpha = CGFloat(alpha); mundlichePunkte2.alpha = CGFloat(alpha)
        case 3:
            ungerundet3TV.textColor = inColor; gerundet3TV.textColor = inColor; mundlichePunkte3.textColor = inColor
            ungerundet3TV.alpha = CGFloat(alpha); gerundet3TV.alpha = CGFloat(alpha); mundlichePunkte3.alpha = CGFloat(alpha)
        case 4:
            ungerundet4TV.textColor = inColor; gerundet4TV.textColor = inColor; mundlichePunkte4.textColor = inColor
            ungerundet4TV.alpha = CGFloat(alpha); gerundet4TV.alpha = CGFloat(alpha); mundlichePunkte4.alpha = CGFloat(alpha)
        case 5:
            ungerundet5TV.textColor = inColor; gerundet5TV.textColor = inColor; mundlichePunkte5.textColor = inColor
            ungerundet5TV.alpha = CGFloat(alpha); gerundet5TV.alpha = CGFloat(alpha); mundlichePunkte5.alpha = CGFloat(alpha)
        case 6:
            ungerundet6TV.textColor = inColor; gerundet6TV.textColor = inColor; mundlichePunkte6.textColor = inColor
            ungerundet6TV.alpha = CGFloat(alpha); gerundet6TV.alpha = CGFloat(alpha); mundlichePunkte6.alpha = CGFloat(alpha)
        case 7:
            ungerundet7TV.textColor = inColor; gerundet7TV.textColor = inColor; mundlichePunkte7.textColor = inColor
            ungerundet7TV.alpha = CGFloat(alpha); gerundet7TV.alpha = CGFloat(alpha); mundlichePunkte7.alpha = CGFloat(alpha)
        case 8:
            ungerundet8TV.textColor = inColor; gerundet8TV.textColor = inColor; mundlichePunkte8.textColor = inColor
            ungerundet8TV.alpha = CGFloat(alpha); gerundet8TV.alpha = CGFloat(alpha); mundlichePunkte8.alpha = CGFloat(alpha)
        case 9:
            ungerundet9TV.textColor = inColor; gerundet9TV.textColor = inColor; mundlichePunkte9.textColor = inColor
            ungerundet9TV.alpha = CGFloat(alpha); gerundet9TV.alpha = CGFloat(alpha); mundlichePunkte9.alpha = CGFloat(alpha)
        case 10:
            ungerundet10TV.textColor = inColor; gerundet10TV.textColor = inColor; mundlichePunkte10.textColor = inColor
            ungerundet10TV.alpha = CGFloat(alpha); gerundet10TV.alpha = CGFloat(alpha); mundlichePunkte10.alpha = CGFloat(alpha)
        case 11:
            ungerundet11TV.textColor = inColor; gerundet11TV.textColor = inColor; mundlichePunkte11.textColor = inColor
            ungerundet11TV.alpha = CGFloat(alpha); gerundet11TV.alpha = CGFloat(alpha); mundlichePunkte11.alpha = CGFloat(alpha)
        case 12:
            ungerundet12TV.textColor = inColor; gerundet12TV.textColor = inColor; mundlichePunkte12.textColor = inColor
            ungerundet12TV.alpha = CGFloat(alpha); gerundet12TV.alpha = CGFloat(alpha); mundlichePunkte12.alpha = CGFloat(alpha)
        case 13:
            ungerundet13TV.textColor = inColor; gerundet13TV.textColor = inColor; mundlichePunkte13.textColor = inColor
            ungerundet14TV.alpha = CGFloat(alpha); gerundet14TV.alpha = CGFloat(alpha); mundlichePunkte14.alpha = CGFloat(alpha)
        case 14:
            ungerundet14TV.textColor = inColor; gerundet14TV.textColor = inColor; mundlichePunkte14.textColor = inColor
            ungerundet14TV.alpha = CGFloat(alpha); gerundet14TV.alpha = CGFloat(alpha); mundlichePunkte14.alpha = CGFloat(alpha)
        case 15:
            ungerundet15TV.textColor = inColor; gerundet15TV.textColor = inColor; mundlichePunkte15.textColor = inColor
            ungerundet15TV.alpha = CGFloat(alpha); gerundet15TV.alpha = CGFloat(alpha); mundlichePunkte15.alpha = CGFloat(alpha)
        default: break
        }
    }
    
    
    func setzeLabel(ungerundet15: Double, ungerundet14: Double, ungerundet13: Double, ungerundet12: Double, ungerundet11: Double, ungerundet10: Double, ungerundet9: Double, ungerundet8: Double, ungerundet7: Double, ungerundet6: Double, ungerundet5: Double, ungerundet4: Double, ungerundet3: Double, ungerundet2: Double, ungerundet1: Double, ungerundet0: Double) {
        ungerundet15TV.text = ungerundet15.toString()
        ungerundet14TV.text = ungerundet14.toString()
        ungerundet13TV.text = ungerundet13.toString()
        ungerundet12TV.text = ungerundet12.toString()
        ungerundet11TV.text = ungerundet11.toString()
        ungerundet10TV.text = ungerundet10.toString()
        ungerundet9TV.text = ungerundet9.toString()
        ungerundet8TV.text = ungerundet8.toString()
        ungerundet7TV.text = ungerundet7.toString()
        ungerundet6TV.text = ungerundet6.toString()
        ungerundet5TV.text = ungerundet5.toString()
        ungerundet4TV.text = ungerundet4.toString()
        ungerundet3TV.text = ungerundet3.toString()
        ungerundet2TV.text = ungerundet2.toString()
        ungerundet1TV.text = ungerundet1.toString()
        ungerundet0TV.text = ungerundet0.toString()
        
        gerundet15TV.text = ungerundet15.toInt().toString()
        gerundet14TV.text = ungerundet14.toInt().toString()
        gerundet13TV.text = ungerundet13.toInt().toString()
        gerundet12TV.text = ungerundet12.toInt().toString()
        gerundet11TV.text = ungerundet11.toInt().toString()
        gerundet10TV.text = ungerundet10.toInt().toString()
        gerundet9TV.text = ungerundet9.toInt().toString()
        gerundet8TV.text = ungerundet8.toInt().toString()
        gerundet7TV.text = ungerundet7.toInt().toString()
        gerundet6TV.text = ungerundet6.toInt().toString()
        gerundet5TV.text = ungerundet5.toInt().toString()
        gerundet4TV.text = ungerundet4.toInt().toString()
        gerundet3TV.text = ungerundet3.toInt().toString()
        gerundet2TV.text = ungerundet2.toInt().toString()
        gerundet1TV.text = ungerundet1.toInt().toString()
        gerundet0TV.text = ungerundet0.toInt().toString()
    }
}

