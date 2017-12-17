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
    lazy var yelpServices: YelpServicesProtocol = YelpServices()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let restaurant = restaurant {
            navigationItem.title = "Restaurant"
            nameLabel.text = restaurant.name
            addressLabel.text = restaurant.displayMultilineAddress()
            reviewTextView.text = restaurant.latestReview ?? ""
            yelpServices.loadImageFrom(urlString: restaurant.photoUrl, completionHandler: { (image) in
                self.photoImageView.image = image
            })
            yelpServices.loadImageFrom(urlString: restaurant.ratingImageUrl, completionHandler: { (image) in
                self.ratingImageView.image = image
            })
        }
    }
}
