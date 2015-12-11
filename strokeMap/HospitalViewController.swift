//
//  CenterDetailViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/10/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit

class HospitalDetailViewController: UIViewController {
    // variable delaration
    var requestEmb = ""
    var logged = false
    var hospitalIdx = 0
    @IBOutlet var responseStackView: UIStackView!
    @IBOutlet var logoutButton: UIButton!
    let socket = SocketIOClient(socketURL: "https://stroke-map.herokuapp.com")
    @IBAction func logoutButtonPressed(sender: UIButton) {
        self.login(false)
    }
    @IBOutlet var loginName: UITextField!

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

    @IBOutlet var requestLabel: UILabel!
    @IBOutlet var availabilityStackView: UIStackView!
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var loginStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLabel.text = "N/A"
        if (logged == false){
            availabilityStackView.hidden = true
            hospitalNameLabel.hidden = true
            currentRequestStackView.hidden = true
            logoutButton.hidden = true
            responseStackView.hidden = true
        } else {
            loginStackView.hidden = true
        }
        socket.connect()
        socket.on("connect") { data, ack in
            print("socket from hospital view controller")
        }
        socket.on("notifySentToHospital"){ data, ack in
            print("notify sent to all hospitals", data)
            if self.hospitalIdx == Int((data[0][0])! as! NSNumber) {
                self.requestLabel.text = "request sent from an embulance"
                self.requestEmb = String(data[0][1])
                self.responseStackView.hidden = false
            }
            
        }
    }
    @IBAction func acceptButtonPressed(sender: UIButton) {
        let response = [1, requestEmb]
        socket.emit("responseForRequest", response)
        responseStackView.hidden = true
        requestLabel.text = "Accepted response"
    }
    @IBAction func declineButtonPressed(sender: UIButton) {
        let response = [0, requestEmb]
        socket.emit("responseForRequest", response)
        responseStackView.hidden = true
        requestLabel.text = "Declined response"
    }
    @IBAction func availableSwitchPressed(sender: UISwitch) {
        print("switch toggled", sender.on)
        Hospital.available[hospitalIdx] = sender.on
        let update = [Hospital.key[hospitalIdx], sender.on]
        socket.emit("availability", update)
        
    }
    @IBOutlet var currentRequestStackView: UIStackView!
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
            self.requestEmb = ""
            self.responseStackView.hidden = true
            self.requestLabel.text = "N/A"
            self.availabilityStackView.hidden = true
            self.hospitalNameLabel.hidden = true
            self.currentRequestStackView.hidden = true
            self.loginStackView.hidden = false
            self.logoutButton.hidden = true
        }
    }
    // memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
