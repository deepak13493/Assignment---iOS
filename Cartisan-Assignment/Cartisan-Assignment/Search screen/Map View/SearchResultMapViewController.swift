//
//  SearchResultMapViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit
import MapKit

class SearchResultMapViewController: UIViewController,CLLocationManagerDelegate {
    
    var searchResults: [SearchResult]?
    var serachResultDataManager = SearchResultDataManager()
    var locationManager: CLLocationManager!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadData() {
        //used it for debugging need to remove it
        let dict = [("ll", "18.56,73.95"), ("v", "20161120")]
        serachResultDataManager.fetch(forData: dict) { [weak self](searchResults) in
            DispatchQueue.main.async {
                if let searchResults = searchResults {
                    self?.searchResults = searchResults
                    
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please check your Network, If it is ok", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                        self?.loadData()
                        
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
       
    }
    
    
    //MARK:- CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude:18.56, longitude: 73.95)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = region.center
        annotation.title = "Current Location"
       // mapView.setRegion(region, animated: false)
        //locationManager.stopUpdatingLocation()
        
    }
}

