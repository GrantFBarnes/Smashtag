//
//  HistoryTableViewCell.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/7/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    var history: [String]? {
        didSet {
            updateUI()
        }
    }
    
    var index: NSIndexPath? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var historyLabel: UILabel!
    
    private func updateUI() {
        historyLabel?.text = nil
        
        if let idx = index {
            if idx.row < history!.count {
                historyLabel?.text = history?[idx.row]
            }
        }
        
        if let text = historyLabel.text {
            if text[text.startIndex] == "#" {
                historyLabel.textColor = UIColor.blueColor()
            }
            if text[text.startIndex] == "@" {
                historyLabel.textColor = UIColor.cyanColor()
            }
        }
    }
}
