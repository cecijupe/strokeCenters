//
//  ViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/9/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class CenterSearchViewController: UITableViewController, CLLocationManagerDelegate, GoBackButtonDelegate, SocketDelegate {

    // vars

    let socket = SocketIOClient(socketURL: "https://stroke-map.herokuapp.com")
    var availCenters = [Int]()
    var availCentersNames = [String]()
    var availCentersDistances = [Double]()
    var locationManager: CLLocationManager!
    var currentCoord = CLLocationCoordinate2D()
    var distance = Double()
    var currentLat = Double()
    var currentLong = Double()
    
    // get distances
    func getDistances( idx: Int) -> Double {
        let request0 = MKDirectionsRequest()
        request0.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong), // currentCoord
            addressDictionary: nil))
        request0.destination = MKMapItem(placemark: MKPlacemark(coordinate: Hospital.location[idx],  // Hospital.location[0]..[4]
            addressDictionary: nil))
        request0.requestsAlternateRoutes = true
        request0.transportType = .Automobile
//        request0.departureDate = NSDate()
        let directions = MKDirections(request: request0)
//        print(directions, "dirctions and request", request0)
        var travelTime: Double = 0
        directions.calculateETAWithCompletionHandler{ response, error in
        print(response,"response for the calculating ETA")
        guard let res = response else { return print("no response")}
            print(Double(res.distance)/5280)
            let eta = Double(res.expectedTravelTime/60)
            print(eta)
            Hospital.distance[idx] = Double(Int(res.distance/52.80)/100)
            Hospital.timeTo[idx] = Int(eta)
            travelTime = eta
            self.tableView.reloadData()
        } // ETA
        return travelTime
    } // end func
    //location 
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        currentCoord = location.coordinate
        currentLat = location.coordinate.latitude
        currentLong = location.coordinate.longitude
        print(currentCoord, "current coordinate")
        
        
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // location manager
        if(CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
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
            self.updateArray()
            print(self.availCenters)
            self.tableView.reloadData()
        }

        
        socket.on("connect") { data, ack in
            print("socket from the center search view", data)
            self.socket.emit("embulanceLogged", "")
        }
        updateArray()

    }
    func updateArray() {
        availCenters = []
        availCentersNames = []
        availCentersDistances = []
        // create array of available centers indices
        for var index = 0; index < Hospital.name.count; ++index {
            if Hospital.available[index] {
                availCenters.append(index)
            }
        }
        // update available names
        for var index = 0; index < availCenters.count; ++index {
            availCentersNames.append(Hospital.name[availCenters[index]])
            getDistances(index)
        }
        // update available distances
        
        
        print(self.distance, "??????????????????????????????)")
        for var index = 0; index < availCenters.count; ++index {
            availCentersDistances.append(Hospital.distance[availCenters[index]])
        }
                    print(self.availCenters)
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

