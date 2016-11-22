//
//  SearchResultMapViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 20/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit
import MapKit

private let resueID = "AnnotationViewID"
class SearchResultMapViewController: UIViewController,CLLocationManagerDelegate {
    
    var searchResults: [SearchResult]?
    var serachResultDataManager = SearchResultDataManager()
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    var categoryID: String?

    lazy var datFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        return dateFormatter
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var optionPickerView: UIPickerView!
    
    
    @IBAction func search(_ sender: AnyObject) {
        
        if let categoryID = categoryID, let long = longitude, let lat = latitude {
            loadData(forLatitude: lat, andLongitude: long, withCategory: categoryID)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadData(forLatitude latitude: Double, andLongitude longitude: Double, withCategory catrgoryID: String?) {
        //used it for debugging need to remove it
        var parameters = [("ll", String(latitude) + "," + String(longitude)), ("v", datFormatter.string(from: Date()))]
        if let catrgoryID = catrgoryID {
            parameters += [("categoryId", catrgoryID)]
        }
       //  let parameters = [("ll", "18.5528172,73.9091116"), ("v", datFormatter.string(from: Date())),("categoryId", catrgoryID)]
        
        serachResultDataManager.fetch(forData: parameters) { [weak self](searchResults) in
            DispatchQueue.main.async {
                if let searchResults = searchResults {
                    self?.searchResults = searchResults
                    self?.showDetailsOnPlacemark(forSearchedResults: self?.searchResults ?? [SearchResult]())
                    self?.optionPickerView.removeFromSuperview()
                    
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please check your Network, If it is ok", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                        self?.loadData(forLatitude: latitude, andLongitude: longitude,withCategory: catrgoryID)
                        
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
       
    }
    
    
    //MARK:- CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        
    }
    
    func showDetailsOnPlacemark(forSearchedResults searchedResults: [SearchResult]) {
        
        let annotations = searchedResults.map { searchedResult -> SearchResultMapAnnotation in
            return  SearchResultMapAnnotation(coordinate: CLLocationCoordinate2D(latitude: searchedResult.lat ?? 0.0 , longitude: searchedResult.lng ?? 0.0),
                title: searchedResult.name,
                searchedResultID: searchedResult.id)
            
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

//show details button on placemark
extension SearchResultMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: resueID)
        if let view = annotationView {
            view.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: resueID)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
             let selectedAnnotation = view.annotation as? SearchResultMapAnnotation
             let venueDetailsViewController = storyboard?.instantiateViewController(withIdentifier: String( describing: VenueDetailsViewController.self)) as! VenueDetailsViewController
            venueDetailsViewController.venueID = selectedAnnotation?.searchedResultID
            navigationController?.pushViewController(venueDetailsViewController, animated: true)
            
        }
    }
    
   
}


extension SearchResultMapViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension SearchResultMapViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category(rawValue: row)?.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryID = Category(rawValue: row)?.id
    }
}
