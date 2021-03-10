//
//  ProViewController.swift
//  revcat demo
//
//  Created by Christopher Ching on 2020-10-01.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import Purchases

class ProViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    var packagesAvailableForPurchase = [Purchases.Package]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch the offerings from RC and create buttons for each product
        Purchases.shared.offerings { (offerings, error) in
            if let offerings = offerings {
              
                let offer = offerings.current
                let packages = offer?.availablePackages
                
                guard packages != nil else {
                    return
                }
                
                // Loop through packages
                for i in 0...packages!.count - 1 {
                    
                    // Get a reference to the package
                    let package = packages![i]
                    
                    // Store a reference to the package at the same index as we're going to tag the button with
                    self.packagesAvailableForPurchase.append(package)
                    
                    // Get a reference to the product
                    let product = package.product
                    
                    // Product title
                    let title = product.localizedTitle
                    
                    // Product price
                    let price = product.price
                    
                    // Product duration
                    var duration = ""
                    let subscriptionPeriod = product.subscriptionPeriod
                    
                    switch subscriptionPeriod!.unit {
                    
                    case SKProduct.PeriodUnit.month:
                        duration = "\(subscriptionPeriod!.numberOfUnits) Month"
                    
                    case SKProduct.PeriodUnit.year:
                        duration = "\(subscriptionPeriod!.numberOfUnits) Year"
                    
                    default:
                        duration = ""
                    }
                    
                    // Create a button
                    let button = UIButton(type: .system)
                    button.tintColor = .white
                    button.backgroundColor = .purple
                    button.setTitle(title + " " + duration + " " + price.stringValue, for: .normal)
                    button.tag = i
                    
                    // Add a tap handler
                    button.addTarget(self, action: #selector(self.purchaseTapped(sender:)), for: .touchUpInside)
                    
                    // Add it to the view
                    self.stackView.addArrangedSubview(button)
                    
                    // Position and size it
                    let height = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 90)
                    
                    button.addConstraint(height)
                    
                    let width = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.stackView, attribute: .width, multiplier: 1, constant: 0)
                    
                    self.stackView.addConstraint(width)
                }
          }
        }
    }
    
    
    @objc func purchaseTapped(sender:UIButton) {
        
        let package = self.packagesAvailableForPurchase[sender.tag]
        
        Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
            
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                
                // Send notification
                NotificationCenter.default.post(name: NSNotification.Name("turned pro"), object: nil)
                
                // Dismiss the pro view controller
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}
