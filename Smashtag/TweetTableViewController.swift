//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/4/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "showTweetDetail":
                let cell = sender as! TweetTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let TDTVC = segue.destinationViewController as! TweetDetailTableViewController
                    TDTVC.tweet = tweets[indexPath.section][indexPath.row]
                }
                default: break
            }
        }
    }
    
    var tweets = [[Tweet]]()
    
    var newSearchTerm: String? {
        didSet {
            searchText = newSearchTerm
        }
    }
    
    var searchText: String? = "#luthercollege" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    // MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var searchHistory: [String] {
        get { return defaults.objectForKey("search") as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: "search") }
    }
    
    var history: String = "" {
        didSet {
            if searchHistory.count < 100 {
                searchHistory = [history] + searchHistory
            } else {
                searchHistory = [history] + searchHistory
                searchHistory.removeLast()
            }
        }
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    

    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {

            history = searchText!
            var idx = 0
            for i in 1..<searchHistory.count {
                if searchHistory[i] == searchText! {
                    idx = i
                }
            }
            if idx > 0 {
                searchHistory.removeAtIndex(idx)
            }
            
            if let request = nextRequestToAttempt {
                request.fetchTweets  { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccessfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                        }
                        
                        sender?.endRefreshing()
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
            
            history = searchText!
            var idx = 0
            for i in 1..<searchHistory.count {
                if searchHistory[i] == searchText! {
                    idx = i
                }
            }
            if idx > 0 {
                searchHistory.removeAtIndex(idx)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TweetTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }
    

}
