//
//  MapController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let initLocation =  CLLocation(latitude: 43.7714, longitude: -79.4988) // SENECA
    var radius : CLLocationDistance = 1000 // 100KM
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        mapCenter(location: initLocation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set the center
    func mapCenter(location : CLLocation){
        let coorRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        mapView.setRegion(coorRegion, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
