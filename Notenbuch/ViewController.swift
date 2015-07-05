//
//  ViewController.swift
//  EigenesMenu
//
//  Created by Udemy on 27.02.15.
//  Copyright (c) 2015 benchr. All rights reserved.
//

import UIKit

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Variablendeklaration
    var visible: Bool = false
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tv: UITableView!
    
    
    //MARK: - Obligatorische Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "moveMenu")
    }
    override func viewDidAppear(animated: Bool) {
        moveMenu()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calculate" {
            delayOnMainQueue(1) { Void in
                self.moveMenu()
            }
        }
    }
    
   //Mark: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.textLabel?.text = "hallo"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    
//    //MARK: - Menu
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if visible {
            /*
            let translation = recognizer.translationInView(self.menuView).x
            var maxX = view.frame.width + 10
            var minX = view.frame.width-100
            var newX = menuView.frame.origin.x + translation
            if newX >= minX && newX <= maxX {
                menuView.frame = CGRectMake(CGFloat(newX), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            }
            if newX >= menuView.frame.origin.x {
                menuView.frame = CGRectMake(CGFloat(newX), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            }
            if newX < maxX {
                visible = true
                moveMenu()
            }
*/
            let translation = recognizer.translationInView(self.menuView).x
            if translation > 0 {
                visible = true
                moveMenu()
            }
            recognizer.setTranslation(CGPointZero, inView: self.menuView)
        }
    }

    
    func moveMenu() {
        UIView.animateWithDuration(0.5) {
            if self.visible {
                //View ist Sichtbar -> View einfahren
                self.menuView.frame = CGRectMake(CGFloat(self.view.bounds.width), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            } else {
                //View ist unsichtbar -> View ausfahren
                self.menuView.frame = CGRectMake(CGFloat(self.view.bounds.width-100), CGFloat(64), CGFloat(100), CGFloat(self.view.bounds.height))
            }
        }
        visible = !visible
        return
    }
}

