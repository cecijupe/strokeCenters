//
//  Centers.swift
//  strokeMap
//
//  Created by Jane Hall on 12/10/15.
//  Copyright © 2015 Jane Hall Consulting. All rights reserved.
//

import Foundation

class Centers: NSObject {
    static var key = ["UW", "VMMC", "SMC", "SMCCH", "HMC"]
    
    static var name = ["UW Medicine/Northwest", "Virginia Mason Medical Center", "Swedish Medical Center", "Swedish Medical Center/Cherry Hill", "Harborview Medical Center"]
    
    static var available = [false, false, false, false, false]
    
    static var address = ["4333 Brooklyn Ave NE, Seattle, WA 98105", "925 Seneca St, Seattle, WA 98101", "700 Minor Ave, Seattle, WA 98104", "500 17th Ave, Seattle, WA 98122", "325 9th Ave, Seattle, WA 98104"]
    
    static var location = [(47.660662, -122.314684), (47.610067, -122.326706), (47.608008, -122.322027), (47.607046, -122.311392), (47.604135, -122.324545)]
    
    static var distance = [Float]()
    
    static var timeTo = [Int]()

    }