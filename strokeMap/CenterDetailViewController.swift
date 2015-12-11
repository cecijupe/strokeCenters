//
//  CenterDetailViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/10/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit

class CenterDetailViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = Centers.name[Centers.selected]
        timeLabel.text = "\(Centers.timeTo[Centers.selected]) min"
        distanceLabel.text = "\(Centers.distance[Centers.selected]) mi"
        statusLabel.text = "\(Centers.available[Centers.selected])"
    }
    
    // memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
