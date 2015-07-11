//
//  notenCell.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 07.07.15.
//  Copyright (c) 2015 Tom Kumschier. All rights reserved.
//

import UIKit

class notenCell: UITableViewCell {
    
    var data: (name: String, fachart: String, schulaufgaben: Bool, kurzarbeiten: Bool, extemporale: Bool, fachreferat: Bool, mundlicheNote: Bool)!
    var cell: UITableViewCell!
}

//struct currentCell {
//    var data: (name: String, fachart: String, schulaufgaben: Bool, kurzarbeiten: Bool, extemporale: Bool, fachreferat: Bool, mundlicheNote: Bool)
//    var cell: UITableViewCell
//}