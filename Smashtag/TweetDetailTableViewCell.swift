//
//  TweetDetailTableViewCell.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/7/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class TweetDetailTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    var section: String? {
        didSet {
            updateUI()
        }
    }
    
    var index: NSIndexPath? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetDetailUserLabel: UILabel!
    @IBOutlet weak var tweetDetailHashtagLabel: UILabel!
    @IBOutlet weak var tweetDetailURLLabel: UILabel!
    
    @IBOutlet weak var tweetDetailImage: UIImageView!
    
    
    func updateUI() {

        tweetDetailHashtagLabel?.text = nil
        tweetDetailUserLabel?.text = nil
        tweetDetailURLLabel?.text = nil
        tweetDetailImage?.image = nil

        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {

            if tweet.media.count > 0 && section == "Image" {
                if let row = index?.row {
                    let url = tweet.media[row].url!
                    let imageData = NSData(contentsOfURL: url)
                    let pic = UIImage(data: imageData!)

                    tweetDetailImage.image = pic
                }
            }
            if tweet.hashtags.count > 0 && section == "Hashtag"{
                if let row = index?.row {
                    tweetDetailHashtagLabel?.text = tweet.hashtags[row].keyword
                }
            }
            if tweet.userMentions.count > 0 && section == "User" {
                if let row = index?.row {
                    tweetDetailUserLabel?.text = tweet.userMentions[row].keyword
                }
            }
            if tweet.urls.count > 0 && section == "URL" {
                if let row = index?.row {
                    tweetDetailURLLabel?.text = tweet.urls[row].keyword
                }
            }
        }
    }
}
