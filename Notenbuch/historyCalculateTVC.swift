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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if daten == nil {
            return 0
        } else {
            return self.daten.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "Jahresfortgangsnote: " + daten[indexPath.row].jahresfortgangsnote
        cell.detailTextLabel?.text = "schriftliche Prüfung: " + daten[indexPath.row].schriftlichePrufung
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var row = tableView.indexPathForCell(sender as! UITableViewCell)!.row
        (segue.destinationViewController as! CalculateTVC).dataFromHistory = daten[row]

    }
    

}
