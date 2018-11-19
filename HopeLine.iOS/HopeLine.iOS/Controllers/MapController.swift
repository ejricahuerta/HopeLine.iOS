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

class MapController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var alert : UIAlertController?
    
    @IBOutlet weak var notifLabel: UILabel!
    let initLocation =  CLLocation(latitude: 43.7714, longitude: -79.4988) // SENECA
    
    var radius : CLLocationDistance = 1000 // 100KM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CLLocationManager.locationServicesEnabled() {
            self.alert = UIAlertController(title: "Location Access", message: "Allow HopeLine to use your location?", preferredStyle: UIAlertControllerStyle.alert)
            self.alert?.addAction(UIAlertAction(title: "Enable", style: UIAlertActionStyle.default, handler: { (action) in
                self.notifLabel.isHidden = true
                self.mapView.isHidden = false
            }))
            self.alert?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                self.mapView.isHidden = true
            }))
            self.present(self.alert!, animated: true, completion: nil)
        }
        else {
            self.notifLabel.isHidden = true
            self.mapView.isHidden = false
        }
        //mapCenter(location: initLocation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //set the center
//    func mapCenter(location : CLLocation){
//        let coorRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
//        mapView.setRegion(coorRegion, animated: true)
//    }

}
extension MapController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}

