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
    if numsCount == 0 { return 0.0 }

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
    if numsCount == 0 { return 0.0 }
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



func == (left: calculateWithData, right: calculateWithData) ->Bool {
    let a = left.entsprichtNote == right.entsprichtNote
    let b = left.gerundeteZeugnisspunkte == right.gerundeteZeugnisspunkte
    let c = left.jahresfortgangsnote == right.jahresfortgangsnote
    let d = left.mitMundlicherPrufung == right.mitMundlicherPrufung
    let e = left.mundlichePrufung == right.mundlichePrufung
    let f = left.name == right.name
    let g = left.schriftlichePrufung == right.schriftlichePrufung
    let h = left.zeugnisspunkte == right.zeugnisspunkte
    
    if a && b && c && d && e && f && g && h {
        return true
    } else {
        return false
    }
}



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
func contains (inArray: [calculateWithData], this: calculateWithData) ->Bool {
    for i in inArray {
        if i == this {
            return true
        }
    }
    return false
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

////: ### NSDate
//public extension NSDate {
//    /**
//    Returns a new NSDate object representing the date calculated by adding the amount specified to self date
//
//    :param: seconds number of seconds to add
//    :param: minutes number of minutes to add
//    :param: hours number of hours to add
//    :param: days number of days to add
//    :param: weeks number of weeks to add
//    :param: months number of months to add
//    :param: years number of years to add
//    :returns: the NSDate computed
//    */
//    public func add(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> NSDate {
//        var calendar = NSCalendar.currentCalendar()
//        let version = floor(NSFoundationVersionNumber)
//        if ( version <= 1153.0 || version <= NSFoundationVersionNumber10_9_2  ) {
//            var component = NSDateComponents()
//            component.setValue(seconds, forComponent: .CalendarUnitSecond)
//
//            var dateInIf : NSDate! = calendar.dateByAddingComponents(component, toDate: self, options: nil)!
//            component = NSDateComponents()
//            component.setValue(minutes, forComponent: .CalendarUnitMinute)
//            dateInIf = calendar.dateByAddingComponents(component, toDate: dateInIf, options: nil)!
//
//            component = NSDateComponents()
//            component.setValue(hours, forComponent: .CalendarUnitHour)
//            dateInIf = calendar.dateByAddingComponents(component, toDate: dateInIf, options: nil)!
//
//            component = NSDateComponents()
//            component.setValue(days, forComponent: .CalendarUnitDay)
//            dateInIf = calendar.dateByAddingComponents(component, toDate: dateInIf, options: nil)!
//
//            component = NSDateComponents()
//            component.setValue(weeks, forComponent: .CalendarUnitWeekOfMonth)
//            dateInIf = calendar.dateByAddingComponents(component, toDate: dateInIf, options: nil)!
//
//            component = NSDateComponents()
//            component.setValue(months, forComponent: .CalendarUnitMonth)
//            dateInIf = calendar.dateByAddingComponents(component, toDate: dateInIf, options: nil)!
//
//            component = NSDateComponents()
//            component.setValue(years, forComponent: .CalendarUnitYear)
//            dateInIf = calendar.dateByAddingComponents(component, toDate: dateInIf, options: nil)!
//            return dateInIf
//        }
//
//        var date : NSDate! = calendar.dateByAddingUnit(.CalendarUnitSecond, value: seconds, toDate: self, options: nil)
//        date = calendar.dateByAddingUnit(.CalendarUnitMinute, value: minutes, toDate: date, options: nil)
//        date = calendar.dateByAddingUnit(.CalendarUnitDay, value: days, toDate: date, options: nil)
//        date = calendar.dateByAddingUnit(.CalendarUnitHour, value: hours, toDate: date, options: nil)
//        date = calendar.dateByAddingUnit(.CalendarUnitWeekOfMonth, value: weeks, toDate: date, options: nil)
//        date = calendar.dateByAddingUnit(.CalendarUnitMonth, value: months, toDate: date, options: nil)
//        date = calendar.dateByAddingUnit(.CalendarUnitYear, value: years, toDate: date, options: nil)
//        return date
//    }
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of seconds to self date
//
//    :param: seconds number of seconds to add
//    :returns: the NSDate computed
//    */
//    public func addSeconds (seconds: Int) -> NSDate {
//        return add(seconds: seconds)
//    }
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of minutes to self date
//
//    :param: minutes number of minutes to add
//    :returns: the NSDate computed
//    */
//    public func addMinutes (minute: Int) -> NSDate {
//        return add(minutes: minute)
//    }
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of hours to self date
//
//    :param: hours number of hours to add
//    :returns: the NSDate computed
//    */
//    public func addHours(hours: Int) -> NSDate {
//        return add(hours: hours)
//    }
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of days to self date
//
//    :param: days number of days to add
//    :returns: the NSDate computed
//    */
//    public func addDays(days: Int) -> NSDate {
//        return add(days: days)
//    }
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of weeks to self date
//
//    :param: weeks number of weeks to add
//    :returns: the NSDate computed
//    */
//    public func addWeeks(weeks: Int) -> NSDate {
//        return add(weeks: weeks)
//    }
//
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of months to self date
//
//    :param: months number of months to add
//    :returns: the NSDate computed
//    */
//
//    public func addMonths(months: Int) -> NSDate {
//        return add(months: months)
//    }
//
//    /**
//    Returns a new NSDate object representing the date calculated by adding an amount of years to self date
//
//    :param: years number of year to add
//    :returns: the NSDate computed
//    */
//    public func addYears(years: Int) -> NSDate {
//        return add(years: years)
//    }
//
//    //  Date comparison
//
//    /**
//    Checks if self is after input NSDate
//
//    :param: date NSDate to compare
//    :returns: True if self is after the input NSDate, false otherwise
//    */
//    public func isAfter(date: NSDate) -> Bool{
//        return (self.compare(date) == NSComparisonResult.OrderedDescending)
//    }
//
//    /**
//    Checks if self is before input NSDate
//
//    :param: date NSDate to compare
//    :returns: True if self is before the input NSDate, false otherwise
//    */
//    public func isBefore(date: NSDate) -> Bool{
//        return (self.compare(date) == NSComparisonResult.OrderedAscending)
//    }
//
//
//    // Getter
//
//    /**
//    Date year
//    */
//    public var year : Int {
//        get {
//            return getComponent(.CalendarUnitYear)
//        }
//    }
//
//    /**
//    Date month
//    */
//    public var month : Int {
//        get {
//            return getComponent(.CalendarUnitMonth)
//        }
//    }
//
//    /**
//    Date weekday
//    */
//    public var weekday : Int {
//        get {
//            return getComponent(.CalendarUnitWeekday)
//        }
//    }
//
//    /**
//    Date weekMonth
//    */
//    public var weekMonth : Int {
//        get {
//            return getComponent(.CalendarUnitWeekOfMonth)
//        }
//    }
//
//
//    /**
//    Date days
//    */
//    public var days : Int {
//        get {
//            return getComponent(.CalendarUnitDay)
//        }
//    }
//
//    /**
//    Date hours
//    */
//    public var hours : Int {
//
//        get {
//            return getComponent(.CalendarUnitHour)
//        }
//    }
//
//    /**
//    Date minuts
//    */
//    public var minutes : Int {
//        get {
//            return getComponent(.CalendarUnitMinute)
//        }
//    }
//
//    /**
//    Date seconds
//    */
//    public var seconds : Int {
//        get {
//            return getComponent(.CalendarUnitSecond)
//        }
//    }
//
//    /**
//    Returns the value of the NSDate component
//
//    :param: component NSCalendarUnit
//    :returns: the value of the component
//    */
//    public func getComponent (component : NSCalendarUnit) -> Int {
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(component, fromDate: self)
//
//        return components.valueForComponent(component)
//    }
//    //    class func toDate(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate{
//    //        var formatter = NSDateFormatter()
//    //        formatter.dateFormat = format
//    //        return formatter.dateFromString(dateString)!
//    //    }
//
//    /**
//    Convert the NSDate to Int. You have to transfer the format of the NSDate Object
//    */
//    func toString(format: String = "HH:mm:ss dd.MM.yyyy") -> String{
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = format
//        return formatter.stringFromDate(self)
//    }
//    /**
//    Returns the Current date with current time
//    */
//    func heute () -> NSDate {
//        return NSDate()
//    }
//}
//extension NSDate: Strideable {
//    public func distanceTo(other: NSDate) -> NSTimeInterval {
//        return other - self
//    }
//
//    public func advancedBy(n: NSTimeInterval) -> Self {
//        return self.dynamicType(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
//    }
//}
//
//extension UIView {
//    func rotateStart(duration: CFTimeInterval = 1.0)
//    {
//        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
//
//        rotateAnimation.fromValue = 0.0
//        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
//
//        rotateAnimation.duration = duration
//
//        rotateAnimation.fillMode = kCAFillModeForwards
//        rotateAnimation.removedOnCompletion = false
//        rotateAnimation.cumulative = true
//
//        rotateAnimation.repeatCount = Float.infinity
//
//        self.layer.addAnimation(rotateAnimation, forKey: "rotate")
//    }
//
//    func rotateStop()
//    {
//        self.layer.removeAnimationForKey("rotate")
//    }
//}
//
