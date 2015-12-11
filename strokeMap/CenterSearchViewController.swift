//
//  ViewController.swift
//  strokeMap
//
//  Created by Jane Hall on 12/9/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import UIKit

class CenterSearchViewController: UITableViewController {

    // vars
    var availCenters = [Int]()
    var availCentersNames = [String]()
    var availCentersDistances = [Double]()
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
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
    // if details button clicked, initiate editTask segue
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            // update selected

        Hospital.selected = indexPath.row
        performSegueWithIdentifier("DetailsSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
}

