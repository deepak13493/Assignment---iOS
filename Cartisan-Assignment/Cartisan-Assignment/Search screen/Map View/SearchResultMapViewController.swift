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
    
    lazy var datFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        return dateFormatter
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadData(forLatitude latitude: Double, andLongitude longitude: Double) {
        //used it for debugging need to remove it
        let dict = [("ll", String(latitude) + "," + String(longitude)), ("v", datFormatter.string(from: Date())),("categoryId", Category.Bakery.id)]
        serachResultDataManager.fetch(forData: dict) { [weak self](searchResults) in
            DispatchQueue.main.async {
                if let searchResults = searchResults {
                    self?.searchResults = searchResults
                    self?.showDetailsOnPlacemark(forSearchedResults: self?.searchResults ?? [SearchResult]())
                    
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please check your Network, If it is ok", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                        self?.loadData(forLatitude: latitude, andLongitude: longitude)
                        
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
       
    }
    
    
    //MARK:- CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        loadData(forLatitude: location.coordinate.latitude, andLongitude: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
    }
    
    func showDetailsOnPlacemark(forSearchedResults searchedResults: [SearchResult]) {
        
        let annotations = searchedResults.map { searchedResult -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = searchedResult.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: searchedResult.lat ?? 0.0 , longitude: searchedResult.lng ?? 0.0)
            return annotation
        }
        mapView.addAnnotations(annotations)
        
        // refactor code syntax
        var mapRect: MKMapRect? = nil
        for annotation in annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
            if mapRect == nil {
                mapRect = pointRect
            } else {
                mapRect = MKMapRectUnion(mapRect!, pointRect)

            }
        }
        mapView.visibleMapRect = mapRect!
        
    }
}

