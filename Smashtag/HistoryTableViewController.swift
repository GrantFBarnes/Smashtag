//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/7/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    
    var history: String = "" {
        didSet {
            if searchHistory.count < 100 {
                searchHistory += [history]
            } else {
                searchHistory += [history]
                searchHistory.removeFirst()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var searchHistory: [String] {
        get { return defaults.objectForKey("search") as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: "search")
        tableView.reloadData()
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "searchNewTerm":
                let cell = sender as! HistoryTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let tvc = segue.destinationViewController as! TweetTableViewController
                    tvc.newSearchTerm = searchHistory[indexPath.row]
                }
            default: break
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchHistory.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> HistoryTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyRow", forIndexPath: indexPath) as! HistoryTableViewCell
        
        cell.history = searchHistory
        cell.index = indexPath
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            searchHistory.removeAtIndex(indexPath.row)
        }
    }
}
