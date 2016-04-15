//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/7/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "searchNewHashtag":
                let cell = sender as! TweetDetailTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let tvc = segue.destinationViewController as! TweetTableViewController
                    tvc.newSearchTerm = tweet?.hashtags[indexPath.row].keyword
                }
            case "searchNewUser":
                let cell = sender as! TweetDetailTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let tvc = segue.destinationViewController as! TweetTableViewController
                    tvc.newSearchTerm = tweet?.userMentions[indexPath.row].keyword
                }
            case "showImage":
                let cell = sender as! TweetDetailTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    let ivc = segue.destinationViewController as! ImageViewController
                    ivc.imageURL = tweet?.media[indexPath.row].url
                }
            default: break
            }
        }
    }
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    internal enum tweetDetails {
        case hashtags(Int, [String])
        case users(Int, [String])
        case urls(Int,[String])
        case images(Int,[NSURL])
        
        var size: Int {
            get {
                switch self {
                case .hashtags(let size,_):
                    return size
                case .users(let size,_):
                    return size
                case .urls(let size,_):
                    return size
                case .images(let size, _):
                    return size
                }
            }
        }
        
        var list: [AnyObject] {
            get {
                switch self {
                case .hashtags(_,let l):
                    return l
                case .users(_,let l):
                    return l
                case .urls(_,let l):
                    return l
                case .images(_,let l):
                    return l
                }
            }
        }
    }
    
    
    private var details = [Int:tweetDetails]()
    
    
    private func startUp() {
        func learnDetail(sect: Int, detail: tweetDetails) {
            details[sect] = detail
        }
        
        var hashtags = [String]()
        var urls = [String]()
        var users = [String]()
        var images = [NSURL]()
        let numHashtags = tweet?.hashtags.count
        let numURLS = tweet?.urls.count
        let numUsers = tweet?.userMentions.count
        let numImages = tweet?.media.count
        
        for x in 0..<tweet!.hashtags.count {
            hashtags.append(tweet!.hashtags[x].keyword)
        }
        
        for x in 0..<tweet!.userMentions.count {
            users.append(tweet!.userMentions[x].keyword)
        }
        
        for x in 0..<tweet!.urls.count {
            urls.append(tweet!.urls[x].keyword)
        }
        
        for x in 0..<tweet!.media.count {
            images.append(tweet!.media[x].url)
        }
        
        learnDetail(1, detail: tweetDetails.hashtags(numHashtags!, hashtags))
        learnDetail(2, detail: tweetDetails.users(numUsers!, users))
        learnDetail(3, detail: tweetDetails.urls(numURLS!, urls))
        learnDetail(0, detail: tweetDetails.images(numImages!, images))
        
    }

    
    
    private func getSections() -> [Int:String] {
        var rows = [Int:String]()
        var current = 0
        
        if tweet?.media.count > 0 {
            rows[current] = "Images"
            current += 1
        }
        if tweet?.hashtags.count > 0 {
            rows[current] = "Hashtag"
            current += 1
        }
        if tweet?.userMentions.count > 0 {
            rows[current] = "Users"
            current += 1
        }
        if tweet?.urls.count > 0 {
            rows[current] = "urls"
            current += 1
        }
        
        return rows
    }

    // MARK: - Table view data source
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        startUp()
        
        var numSections = 0
        for i in 0..<4 {
            if (details[i]?.size)! > 0 {
                numSections += 1
            }
        }

        return numSections
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        startUp()
        
        var sections = [Int:String]()
        for i in 0..<4 {
            if (details[i]?.size)! > 0 {
                if i == 0 {
                    sections[sections.count] = "Images"
                }
                if i == 1 {
                    sections[sections.count] = "Hashtags"
                }
                if i == 2 {
                    sections[sections.count] = "Users"
                }
                if i == 3 {
                    sections[sections.count] = "URLs"
                }
            }
        }
        
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.8 //make the header transparent
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        startUp()
        
        var sections = [Int:Int]()
        for i in 0..<4 {
            if (details[i]?.size)! > 0 {
                sections[sections.count] = (details[i]?.size)!
            } else {
                sections[sections.count] = 0
            }
        }
        
        if section >= 4 {
            return 0
        }
        
        let rows = getSections()
        
        let checkValue = rows[section]
        let sectionInt = ["Images":0,"Hashtag":1,"Users":2,"urls":3]
        
        return sections[sectionInt[checkValue!]!]!
        
    }

    
    private struct Storyboard {
        static let CellReuseIdentifierHT = "TweetDetailCellHashtag"
        static let CellReuseIdentifierUser = "TweetDetailCellUser"
        static let CellReuseIdentifierURL = "TweetDetailCellURL"
        static let CellReuseIdentifierImage = "TweetDetailCellImage"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TweetDetailTableViewCell {

        let rows = getSections()
        
        let checkValue = rows[indexPath.section]
        
        if checkValue == "Images" {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifierImage, forIndexPath: indexPath) as! TweetDetailTableViewCell
            
            cell.tweet = tweet
            cell.section = "Image"
            cell.index = indexPath
            return cell
        }
        
        if checkValue == "Hashtag" {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifierHT, forIndexPath: indexPath) as! TweetDetailTableViewCell
            
            cell.tweet = tweet
            cell.section = "Hashtag"
            cell.index = indexPath
            return cell
        }
        
        if checkValue == "Users" {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifierUser, forIndexPath: indexPath) as! TweetDetailTableViewCell
            
            cell.tweet = tweet
            cell.section = "User"
            cell.index = indexPath
            return cell
        }
        
        if checkValue == "urls" {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifierURL, forIndexPath: indexPath) as! TweetDetailTableViewCell
            
            cell.tweet = tweet
            cell.section = "URL"
            cell.index = indexPath
            return cell
        }
    

        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifierHT, forIndexPath: indexPath) as! TweetDetailTableViewCell
        
        cell.tweet = tweet
        cell.section = "Hashtag"
        cell.index = indexPath
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rows = getSections()
        let checkValue = rows[indexPath.section]
        
        if checkValue == "urls" {
            let url = NSURL(string: (tweet?.urls[indexPath.row].keyword)!)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rows = getSections()
        
        let checkValue = rows[indexPath.section]
        
        if checkValue == "Images" {

            let tableWidth = tableView.bounds.width
            
            return tableWidth / CGFloat(tweet!.media[indexPath.row].aspectRatio)

        }
        return UITableViewAutomaticDimension
    }
}
