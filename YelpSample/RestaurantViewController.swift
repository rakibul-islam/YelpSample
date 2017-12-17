//
//  RestaurantViewController.swift
//  YelpSample
//
//  Created by Rakibul Islam on 4/13/16.
//  Copyright © 2016 Rakibul Islam. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let restaurant = restaurant {
            navigationItem.title = "Restaurant"
            nameLabel.text = restaurant.name
            addressLabel.text = restaurant.displayMultilineAddress()
            reviewTextView.text = restaurant.latestReview
            if let photoUrl = restaurant.photoUrl {
                YelpServices.loadImageFromUrl(photoUrl, completionHandler: { (image) in
                    if image != nil {
                        self.photoImageView.image = image
                    }
                })
            }
            if let ratingImgUrl = restaurant.ratingImageUrl {
                YelpServices.loadImageFromUrl(ratingImgUrl, completionHandler: { (image) in
                    if image != nil {
                        self.ratingImageView.image = image
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
