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

class SearchResultMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    //TODO:- need to check better solution
    var parentNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func showMap(onView view: UIView) {
        self.view.frame = view.frame
        view.addSubview(self.view)
    }
    
    func removeMap() {
        view.alpha = 0
    }
    func showMap()  {
        view.alpha = 1

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
            parentNavigationController?.pushViewController(venueDetailsViewController, animated: true)
            
        }
    }
    
   
}

