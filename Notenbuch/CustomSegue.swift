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
        let sourceViewController = self.sourceViewController as UIViewController
        sourceViewController.navigationController?.popViewControllerAnimated(true)
    }
}