//
//  TableViewCell.swift
//  ToDo
//
//  Created by Julian Grosshauser on 15/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    func configure<Item where Item: BaseObject, Item: CustomStringConvertible>(item: Item) {
        textLabel?.text = String(item)
    }
}
