//
//  ViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/9/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit
import MapKit

class CenterSearchViewController: UITableViewController, GoBackButtonDelegate, SocketDelegate {

    // vars
    let socket = SocketIOClient(socketURL: "http://localhost:7000")
    var availCenters = [Int]()
    var availCentersNames = [String]()
    var availCentersDistances = [Double]()
    
    
    // get distances
    let currentCoord = CLLocationCoordinate2DMake(47.6098383, -122.1986874)
    
    func getDistances(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Double {
        let request0 = MKDirectionsRequest()
        request0.source = MKMapItem(placemark: MKPlacemark(coordinate: start, // currentCoord
            addressDictionary: nil))
        request0.destination = MKMapItem(placemark: MKPlacemark(coordinate: end,  // Hospital.location[0]..[4]
            addressDictionary: nil))
        request0.transportType = .Automobile
        request0.departureDate = NSDate()
        let directions = MKDirections(request: request0)
        directions.calculateETAWithCompletionHandler{ response, error in
            if error == nil {
                if let res = response {
                    let eta = Double(res.expectedTravelTime/60)
                    return eta
                } // res
            } // callback
        } // ETA
    } // end func
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // connecting socket 
        socket.connect()
        socket.emit("embulanceLogged", "")
        socket.on("updateHospitalAv") { data, ack in
            print("update", data)
            // updating the availability of hospitals
            for idx in 0..<data[0].count {
                if (Int((data[0][idx])! as! NSNumber) == 1){
                Hospital.available[idx] = true
                    print(data[0][idx])
                } else {
                    Hospital.available[idx] = false
                }
            }
            self.tableView.reloadData()
        }
        socket.on("hospitalResponse"){ data, ack in
            print(data)
            
        }
        
        socket.on("connect") { data, ack in
            print("socket from the center search view", data)
            self.socket.emit("embulanceLogged", "")
        }
        
        // create array of available centers indices
        for var index = 0; index < Hospital.name.count; ++index {
            if Hospital.available[index] {
                availCenters.append(index)
            }
        }
        // update available names
        for var index = 0; index < availCenters.count; ++index {
            availCentersNames.append(Hospital.name[availCenters[index]])
        }
        // update available distances
        for var index = 0; index < availCenters.count; ++index {
            availCentersDistances.append(Hospital.distance[availCenters[index]])
        }
    }

    // didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TABLE METHODS
    // define number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availCenters.count
    }

    // define cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCellWithIdentifier("AvailCentersCell")! as! AvailCentersCell
        cell.CenterDistanceLabel.text = String(availCentersDistances[indexPath.row])
        cell.CenterNameLabel.text = availCentersNames[indexPath.row]
        return cell
    }
    
    
    // segue
    // set goBackButtonDelegate on segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let controller = navigationController.topViewController as! CenterDetailViewController
        controller.goBackButtonDelegate = self
    }
    
    // if details button clicked, initiate detailsSegue
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            // update selected

        Hospital.selected = indexPath.row
        performSegueWithIdentifier("DetailsSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // go back (from details view)
    // cancel button protocol
    func goBackButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func accessingSocketFrom (controller: UIViewController) {
        // accessing socket from the other view
    }

}

