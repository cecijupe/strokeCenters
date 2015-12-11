//
//  CenterDetailViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/10/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit

class HospitalDetailViewController: UIViewController {
    let socket = SocketIOClient(socketURL: "http://localhost:7000")
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        print("button")
        logged = true
//        tableView.reloadData()
        for idx in 1...4{
            print(Hospital.key[idx])
            
        }
        availabilityStackView.hidden = false
        hospitalNameLabel.hidden = false
        currentRequestStackView.hidden = false
        loginStackView.hidden = true
    }
    var logged = false
    @IBOutlet var availabilityStackView: UIStackView!
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var loginStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (logged == false){
            availabilityStackView.hidden = true
            hospitalNameLabel.hidden = true
            currentRequestStackView.hidden = true
        } else {
            loginStackView.hidden = true
        }
        socket.connect()
        socket.on("connect") { data, ack in
            print("iOS::WE ARE USING SOCKETS!")
        }
    }
    @IBAction func availableSwitchPressed(sender: UISwitch) {
        socket.emit("availability")
        
    }
    @IBOutlet var currentRequestStackView: UIStackView!
    
    // memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
