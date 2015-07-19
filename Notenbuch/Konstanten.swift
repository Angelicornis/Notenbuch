//
//  Konstanten.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 07.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext


var kExtemporale = "extemporale"
var kFachreferat = "fachreferat"
var kKurzarbeiten = "kurzarbeiten"
var kMundlicheNote = "mundlicheNote"
var kSchulaufgaben = "schulaufgaben"
var kNotenitem = "Notenitem"


var kName = "name"
var kFachart = "fachart"
var kOrder = "order"
var kNotensatz = "Notensatz"

class Helper {
    static func checkCircle (checked: Bool, radius: CGFloat, lineWidth: CGFloat = 1, uncheckedBackgroundColor: UIColor = UIColor.redColor(), checkedBackgroundColor: UIColor = UIColor.greenColor(), strockeColor: UIColor = UIColor.blackColor()) -> UIImage {
        
        let center = CGPointMake(radius, radius)
        let size = CGSizeMake(2 * radius, 2 * radius)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius - lineWidth, startAngle: CGFloat(0), endAngle: CGFloat(M_PI), clockwise: true)
        
        if checked {
            checkedBackgroundColor.setFill()
        } else {
            uncheckedBackgroundColor.setFill()
        }
        
        strockeColor.setStroke()
        circlePath.fill()
        circlePath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func checkCircleWithDuration (checked: Bool, radius: CGFloat, lineWidth: CGFloat = 1, uncheckedBackgroundColor: UIColor = UIColor.redColor(), checkedBackgroundColor: UIColor = UIColor.greenColor(), strockeColor: UIColor = UIColor.blackColor(), endAngle: CGFloat = CGFloat(M_PI), duration: Double) -> UIImage {
        
        let center = CGPointMake(radius, radius)
        let size = CGSizeMake(2 * radius, 2 * radius)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius - lineWidth, startAngle: CGFloat(0), endAngle: endAngle, clockwise: true)
        
        if checked {
            checkedBackgroundColor.setFill()
        } else {
            uncheckedBackgroundColor.setFill()
        }
        
        strockeColor.setStroke()
        circlePath.fill()
        circlePath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


