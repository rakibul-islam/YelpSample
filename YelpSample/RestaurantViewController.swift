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
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var restaurant: Restaurant!
    lazy var yelpServices: YelpServicesProtocol = YelpServices()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Restaurant"
        nameLabel.text = restaurant.name
        addressButton.setTitle(restaurant.displayMultilineAddress(), for: .normal)
        ratingLabel.text = "\(restaurant.rating ?? 0)"
        priceLabel.text = restaurant.price
        phoneButton.setTitle(restaurant.displayPhone, for: .normal)
        yelpServices.loadImageFrom(urlString: restaurant.photoUrl, completionHandler: { (image) in
            DispatchQueue.main.async { [unowned self] in
                self.photoImageView.image = image
            }
        })
    }
    
    @IBAction func addressButtonClicked(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!), let googleMapsURL = restaurant.getGoogleMapsURL() {
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else if let appleMapsURL = restaurant.getAppleMapsURL() {
            UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func phoneButtonTapped(_ sender: Any) {
        if let telUrl = URL(string: "tel://\(restaurant.phone ?? "")") {
            UIApplication.shared.open(telUrl, options: [:], completionHandler: nil)
        }
    }
}
