//
//  historyCalculateTVC.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 04.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class historyCalculateTVC: UITableViewController {
    
    var daten:[calculateWithData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if daten == nil {
            return 0
        } else {
            return self.daten.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as UITableViewCell

        if daten[indexPath.row].name.isEmpty {
           daten[indexPath.row].name = "Eingegebene Daten"
        }
        
        cell.textLabel?.text = daten[indexPath.row].name
        let jahresfortangsnote =  "Jahresfortgangsnote: " + daten[indexPath.row].jahresfortgangsnote
        let schriftlichePrufung = "schriftliche Prüfung: " + daten[indexPath.row].schriftlichePrufung
        cell.detailTextLabel?.text = "\(jahresfortangsnote) \n\(schriftlichePrufung)"
        cell.detailTextLabel?.numberOfLines = 2
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }


    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let row = tableView.indexPathForCell(sender as! UITableViewCell)!.row
            (segue.destinationViewController as! CalculateTVC).dataFromHistory = daten[row]
        
    }
}
