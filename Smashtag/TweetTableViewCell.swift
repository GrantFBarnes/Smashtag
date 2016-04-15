//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/4/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI() {

        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                
                let myMutableString = tweetTextLabel!.attributedText as? NSMutableAttributedString
                for hash in tweet.hashtags {
                    myMutableString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: hash.nsrange)
                }

                for u in tweet.urls {
                    myMutableString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.brownColor(), range: u.nsrange)
                }
        
                for user in tweet.userMentions {
                    myMutableString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.cyanColor(), range: user.nsrange)
                }
                
                tweetTextLabel!.attributedText = myMutableString

            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        self.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
            
        }
    }
}
