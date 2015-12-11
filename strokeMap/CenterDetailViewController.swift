//
//  CenterDetailViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/10/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit

class CenterDetailViewController: UIViewController {
    
    // instance vars
    weak var goBackButtonDelegate: GoBackButtonDelegate?
    weak var socketDelegate: SocketDelegate?
    
    // outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // actions
    @IBAction func goBackButtonPressed(sender: UIBarButtonItem) {
        goBackButtonDelegate?.goBackButtonPressedFrom(self)
    }
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = Hospital.name[Hospital.selected]
        timeLabel.text = "\(Hospital.timeTo[Hospital.selected]) min"
        distanceLabel.text = "\(Hospital.distance[Hospital.selected]) mi"
        statusLabel.text = "\(Hospital.available[Hospital.selected])"
    }
    
    // memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
