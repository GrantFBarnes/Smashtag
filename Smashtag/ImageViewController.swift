//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Grant Barnes on 4/7/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.contentMode = UIViewContentMode.ScaleToFill
            let imageViewSize = imageView.bounds.size
            let scrollViewSize = scrollView?.bounds.size
            if let svs = scrollViewSize {
                let widthScale = svs.width / imageViewSize.width
                let heightScale = svs.height / imageViewSize.height

                scrollView?.zoomScale = max(widthScale,heightScale)
                scrollView?.minimumZoomScale = min(widthScale,heightScale)
                scrollView?.maximumZoomScale = max(widthScale,heightScale)*2
            }
            
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
}
