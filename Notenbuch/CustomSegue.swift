//
//  CustomSegue.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 11.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit


@objc(dismissSegue)
class dismissSegue: UIStoryboardSegue {
    override func perform() {
        
        var sourceViewController = self.sourceViewController as! UIViewController
        var destinationViewController = self.destinationViewController as! UIViewController
        
        sourceViewController.navigationController?.popViewControllerAnimated(true)
//        navigationController.popViewControllerAnimated(true)
    }
    
    
}