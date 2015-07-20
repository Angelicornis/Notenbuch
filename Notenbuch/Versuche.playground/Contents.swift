////
////  Extension.swift
////  Benzin Calc
////
////  Created by Tom Kumschier on 27.04.15.
////  Copyright (c) 2015 Administrator. All rights reserved.
////
//
import Foundation
import UIKit
////: ## Extensions & Funktions
////:
////: ### Small Funktions
//
func delayOnQueue(time: NSTimeInterval, queue: dispatch_queue_t, closure: () ->Void) {
    let timeDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
    dispatch_after(timeDelay, queue, closure)
}
func delayOnMainQueue(time: NSTimeInterval, closure: () ->Void) {
    delayOnQueue(time, queue: dispatch_get_main_queue(), closure: closure)
}

func max(array: [Int]) ->Int {
    
    var maxValue = 0
    
    
    for i in 0..<array.count - 1 {
        maxValue = max(maxValue, array[i])
    }
    return maxValue
}
func average(nums: [Double]) -> Double {
    if nums.count == 0 {return 0}
    var total = 0.0
    var numsCount = nums.count
    for vote in nums{
        if vote == 0 { numsCount -= 1 }
        total += Double(vote)
        
    }
    
    let votesTotal = Double(numsCount)
    let average = total/votesTotal
    return average
}
func average(nums: [Int]) -> Double {
    if nums.count == 0 {return 0}
    var numsCount = nums.count
    var total = 0
    for vote in nums{
        if vote == 0 { numsCount -= 1 }
        total += vote
        
    }
    
    let votesTotal = Double(numsCount)
    let average = Double(total)/votesTotal
    return average
}

/**
Utility method to return an NSRegularExpression object given a pattern.

:param: pattern Regex pattern
:param: ignoreCase If true the NSRegularExpression is created with the NSRegularExpressionOptions.CaseInsensitive flag
:returns: NSRegularExpression object
*/



//// MARK:  Functions
///**
//Returns a new NSDate object representing the date calculated by adding the values
//*/
//public func createDate(year year:Int, #month:Int, #day:Int, #hour:Int, #minute:Int, #second:Int) -> NSDate {
//    var c = NSDateComponents()
//    c.year = year
//    c.month = month
//    c.day = day
//    c.hour = hour
//    c.minute = minute
//    c.second = second
//
//    var gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
//    var date = gregorian!.dateFromComponents(c)
//    return date!
//}
//
//: ### String
// MARK: Extension
public extension String {
    /**
    Returns the lenght of the element
    */
    func length() ->Int {
        return self.characters.count
    }
    subscript (range: Range<Int>) -> String? {
        if range.startIndex < 0 || range.endIndex > self.length() {
            return nil
        }
        let range = Range(start: advance(startIndex, range.startIndex), end: advance(startIndex, range.endIndex))
        return self[range]
    }
    subscript (range: Int) -> String? {
        let range = Range(start: advance(startIndex, range), end: advance(startIndex, range+1))
        return self[range]
    }
    /**
    Returns a Optional String, with contains the elements in the range
    */
    public func gibStringZurück (range range: Range<Int>) -> String? {
        if range.startIndex < 0 || range.endIndex > self.length() {
            return nil
        }
        
        let range = Range(start: advance(startIndex, range.startIndex), end: advance(startIndex, range.endIndex))
        
        return self[range]
    }
    /**
    Create a Range<String.Index> from the startvalue and endvalue
    */
    func createRange (startwerstartwert startwert : Int, var endwert: Int) ->Range<String.Index>? {
        if endwert>0 {
            if endwert>self.length() {
                return nil
            }
            endwert = -(self.length()-endwert)
        } else {
            if -endwert>self.length() {
                return nil
            }
        }
        return Range<String.Index>(start: advance(self.startIndex, startwert), end: advance(self.endIndex, endwert))
    }
    /**
    Create a Range<String.Index> from a Range<Int>
    */
    public func createRange(range range: Range<Int>) -> Range<String.Index> {
        return Range<String.Index>(start: (advance(self.startIndex, range.startIndex)), end: (advance(startIndex, range.endIndex - range.startIndex)))
    }
    /**
    Replace the 'thisChar' Elements with 'with'
    */
    func replace (thisChar: Character, with: Character) ->String {
        var ergebnis = ""
        for i in self.characters {
            if i == thisChar {
                ergebnis = ergebnis + "\(with)"
            } else {
                ergebnis = ergebnis + "\(i)"
            }
        }
        return ergebnis
    }
    /**
    Convert the String to Double. Returns nil if failed
    */
    func toDouble() -> Double? {
        
        let scanner = NSScanner(string: self)
        var double: Double = 0
        
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
        
    }
    /**
    Convert the String to Int. Returns nil if failed
    */
    func toInt() -> Int? {
        return Int(self)
    }
    /// `true` iff `self` contains no characters.
    var isNotEmpty:Bool {
        return !self.isEmpty
    }
    /**
    Insert a newString to the current String at the place "atIndex"
    */
    mutating func insertString (newString: String, atIndex: Int) {
        let string1 = self.gibStringZurück(range: 0..<atIndex)!
        let string2 = self.gibStringZurück(range: (atIndex)..<self.length())!
        self = "\(string1)\(newString)\(string2)"
    }
    /**
    Controlls if the character is in the String
    */
    //    func contains (pattern: String, ignoreCase: Bool = false) -> Bool? {
    //        if let regex = ExSwift.regex(pattern, ignoreCase: ignoreCase) {
    //            let range = NSMakeRange(0, count(self))
    //            return regex.firstMatchInString(self, options: .allZeros, range: range) != nil
    //        }
    //
    //        return nil
    //    }
    /**
    Returns self as a String
    */
    func toString() ->String {
        return "\(self)"
    }
    /**
    Convert the String to a Bool. Return nil if failed
    */
    func toBool() ->Bool?{
        if (self.lowercaseString == "true") || (self.lowercaseString == "yes") {
            return true
        } else if (self.lowercaseString == "false") || (self.lowercaseString == "no") {
            return false
        } else {
            return nil
        }
    }
    /**
    Returns a new NSDate object representiong the date created by a string
    (optional Value: format; insert this opinion: yyyy - Year; MM - Month, dd - Day, mm - minutes, HH - hour, ZZ - Hour from UTC)
    */
    func toDate(format:String="yyyy-MM-dd") -> NSDate? {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(self)!
    }
}

//MARK: ### Int
public extension Int {
    /**
    Iterates function, with an Int index argument, self times.
    */
    //    func times <T> (function: Void -> T) {
    //        (0..<self).each { _ in function(); return }
    //    }
    /**
    Iterates function, with an Int index argument, self times.
    */
    //    func times (function: Void -> Void) {
    //        (0..<self).each { _ in function(); return }
    //    }
    /**
    Return the lenght of self
    */
    func lenght() -> Int {
        return self.toString().length()
    }
    /**
    Returns self as a String
    */
    func toString() ->String {
        return "\(self)"
    }
    /**
    Returns self as a String
    */
    func toDouble() ->Double {
        return Double(self)
    }
    /**
    Returns self as a CGFloat
    */
    func toCGFloat() ->CGFloat {
        return CGFloat(self)
    }
}

//: ### Double
public extension Double {
    
    /**
    Returns the total number of self
    */
    var absolute:Double {
        get {
            if self < 0 {
                return -self
            } else {
                return self
            }
        }
    }
    
    /**
    Returns self as a String
    */
    func toString() ->String {
        return "\(self)"
    }
    /**
    Returns self as a Integer
    */
    func toInt() ->Int {
        let asStringArray = self.toString().componentsSeparatedByString(".")
        let temp = asStringArray.last![0]!.toInt()!
        if temp < 5 {
            return asStringArray.first!.toInt()!
        } else {
            return asStringArray.first!.toInt()! + 1
        }
    }
    /**
    Create a expotental function. self = Basic; exponent = exponent
    */
    func exp(exponent: Double) ->Double{
        return pow(self, exponent)
    }
    /**
    Set the lenght of the Number after the Point to the transferred "lenght"
    */
    func setLenghtOfTheNumberAfterPointTo(lenght: Int) ->Double? {
        //        if self == nan { return }
        var geparst = "\(self)".componentsSeparatedByString(".")
        var nachKommaUnbearbeitet = geparst[1]
        if geparst[1].length() <= lenght {
            let ergebnis = geparst[0] + "." + geparst[1]
            return ergebnis.toDouble()
        }
        
        var nachKomma = ""
        let
        
        nachKommaUnbearbeitetLänge = nachKommaUnbearbeitet.gibStringZurück(range: lenght...lenght)!
        if nachKommaUnbearbeitetLänge == "9" {
            var nachKommaGültigeZiffern = nachKommaUnbearbeitet[0..<lenght]!.toInt()!
            let längeVorInterrieren = nachKommaGültigeZiffern.lenght()
            ++nachKommaGültigeZiffern
            let längeNachInterrieren = nachKommaGültigeZiffern.lenght()
            if längeNachInterrieren > längeVorInterrieren {
                geparst[0] = "\(geparst[0].toInt()! + 1)"
                nachKomma = 0.toString()
            } else {
                nachKomma = nachKommaGültigeZiffern.toString()
            }
        } else if nachKommaUnbearbeitetLänge.toInt()! == 0 {
            nachKomma = geparst[1]
        } else if nachKommaUnbearbeitetLänge.toInt()! > 4 {
            let range = 0..<lenght-1
            let lenghtMinus1 = lenght-1
            let nachKommaUnbearbeitetLängeMinus1 = "\(nachKommaUnbearbeitet.gibStringZurück(range: lenghtMinus1...lenghtMinus1)!)"
            let nachKommaTeil1 = nachKommaUnbearbeitet[range]
            let nachKommaTeil2 = nachKommaUnbearbeitetLängeMinus1.toInt()! + 1
            nachKomma = nachKommaTeil1! + "\(nachKommaTeil2)"
        } else {
            let range = 0..<lenght
            nachKomma = nachKommaUnbearbeitet[range]!
        }
        
        let ergebnis = geparst[0] + "." + nachKomma
        return ergebnis.toDouble()
    }
    
    mutating func mmInCm(){self = self/10}
    mutating func mmInDm(){self = self/100}
    mutating func mmInM(){self = self/1000}
    mutating func mmInKm(){self = self/1000000}
    
    mutating func cmInMm(){self = self*10}
    mutating func cmInDm(){self = self/10}
    mutating func cmInM(){self = self/100}
    mutating func cmInKm(){self = self/100000}
    
    mutating func DmInMm(){self = self*100}
    mutating func DmInCm(){self = self*10}
    mutating func DmInM(){self = self/10}
    mutating func DmInKm(){self = self/10000}
    
    mutating func mInMm(){self = self*1000}
    mutating func mInCm(){self = self*100}
    mutating func mInDm(){self = self*10}
    mutating func mInKm(){self = self/1000}
    
    mutating func KmInMm(){self = self*1000000}
    mutating func KmInCm(){self = self*100000}
    mutating func KmInDm(){self = self*10000}
    mutating func KmInM(){self = self*1000}
    
}

////: ### NSArray
//public extension NSArray {
//    /**
//    Returns the first object of the Array. If empty returns nil
//    */
//    func first() ->AnyObject? {return nil}
//    /**
//    Returns the last object of the Array. If empty returns nil
//    */
//    func last() ->AnyObject? {return nil}
//}
//
//: ### Array
extension Array {
    /**
    Returns the first object of the Array. If empty returns nil
    */
    func first() ->T {return self[0]}
    /**
    Returns the last object of the Array. If empty returns nil
    */
    func last() ->T? {return self[self.count-1]}
    private func typeIsOptional() -> Bool {
        return reflect(self[0]).disposition == .Optional
    }
    /**
    Iterates on each element of the array.
    
    :param: call Function to call for each element
    */
    func each (element call: (element: Element) -> ()) {
        
        for item in self {
            call(element: item)
        }
        
    }
    
    
    /**
    Controlls if the obj is a Object of the Array
    */
    func contains<U : Equatable>(obj: U) -> Bool {
        if isEmpty {
            return false
        }
        if (typeIsOptional()) {
            NSException(name:"Not supported", reason: "Optional Array types not supported", userInfo: nil).raise()
        }
        for item in self.map({ $0 as? U }) {
            if item == obj {
                return true
            }
        }
        return false
    }
    /**
    Controlls if the obj is a Object of the Array
    */
    func contains<U : Equatable>(obj: U?) -> Bool {
        if isEmpty {
            return false
        }
        if (typeIsOptional()) {
            NSException(name:"Not supported", reason: "Optional Array types not supported", userInfo: nil).raise()
        }
        return obj != nil && contains(obj!)
    }
}


//: ### Character
public extension Character{
    /**
    Convert the Character to Int. Returns nil if failed
    */
    public func toInt () -> Int? {return String(self).toInt()}
}

//: ### Range
internal extension Range {
    /**
    Calls for each value in the range
    */
    func times (function: () -> ()) {
        each { (current: T) -> () in
            function()
        }
    }
    /**
    Calls for each value in the range
    */
    func each (function: (T) -> ()) {
        for i in self {
            function(i)
        }
    }
}

extension UIView {
    func removeAllSubviews() {
        self.subviews.map({ $0.removeFromSuperview() })
    }
}




var x = 0 / 3









