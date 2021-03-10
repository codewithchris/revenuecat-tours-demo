//
//  ViewController.swift
//  revcat demo
//
//  Created by Christopher Ching on 2020-09-10.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import Purchases

class ViewController: UIViewController {
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var tourLabel: UILabel!
    
    @IBOutlet weak var proButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTours), name: NSNotification.Name("turned pro"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Check entitlements and show pro content
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                // User is "pro"
                
                self.showTours()
            }
        }
    }
    
    @objc func showTours() {
        
        self.proButton.removeFromSuperview()
        self.tourLabel.text = "Check out these recommended tours"
        
        // Create a label for the tours
        let label = UILabel()
        label.text = "Great Tour A"
        
        self.stackView.addArrangedSubview(label)
    }

}

