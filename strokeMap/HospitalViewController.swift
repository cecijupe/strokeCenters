//
//  CenterDetailViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/10/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit

class HospitalDetailViewController: UIViewController {
    @IBOutlet var logoutButton: UIButton!
    let socket = SocketIOClient(socketURL: "http://localhost:7000")
    @IBAction func logoutButtonPressed(sender: UIButton) {
        self.login(false)
    }
    @IBOutlet var loginName: UITextField!
    func login(status: Bool){
        if status == true {
            self.logged = true
            self.availabilityStackView.hidden = false
            self.hospitalNameLabel.hidden = false
            self.currentRequestStackView.hidden = false
            self.loginStackView.hidden = true
            self.logoutButton.hidden = false
        } else {
            self.logged = false
            self.availabilityStackView.hidden = true
            self.hospitalNameLabel.hidden = true
            self.currentRequestStackView.hidden = true
            self.loginStackView.hidden = false
            self.logoutButton.hidden = true
        }
    }
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        print("button")
//        tableView.reloadData()
        for idx in 0...Hospital.key.count-1 {
            print(Hospital.key[idx], loginName.text!)
            if Hospital.key[idx] == loginName.text! {
                self.login(true)
                self.hospitalIdx = idx
            }
        }
        loginName.text = ""

    }
    var logged = false
    var hospitalIdx = 0
    @IBOutlet var availabilityStackView: UIStackView!
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var loginStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (logged == false){
            availabilityStackView.hidden = true
            hospitalNameLabel.hidden = true
            currentRequestStackView.hidden = true
            logoutButton.hidden = true
        } else {
            loginStackView.hidden = true
        }
        socket.connect()
//        socket.on("connect") { data, ack in
//            print("iOS::WE ARE USING SOCKETS!")
//        }
    }
    @IBAction func availableSwitchPressed(sender: UISwitch) {
        print("switch toggled", sender.on)
        Hospital.available[hospitalIdx] = sender.on
        let update = [Hospital.key[hospitalIdx], sender.on]
        socket.emit("availability", update)
        
    }
    @IBOutlet var currentRequestStackView: UIStackView!
    
    // memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
