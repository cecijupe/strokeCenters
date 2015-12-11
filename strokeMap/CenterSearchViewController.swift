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
    var centers = Hospital.name
    var availCenters = ["Swedish", "Cherry Hill", "Harborview"]
    var distances = ["0.1 mi", "2.3 mi", "3.4 mi"]
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        cell.CenterDistanceLabel.text = distances[indexPath.row]
        cell.CenterNameLabel.text = availCenters[indexPath.row]
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

