//
//  SearchResultViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit
import MapKit

class SearchResultViewController: UIViewController,
                                  CLLocationManagerDelegate,
                                  CategoryPickerViewControllerDelegate {

    @IBOutlet var containerView: UIView!
    
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    var categoryID: String?
    var categoryPickerViewController: CategoryPickerViewController?
    var searchResults: [SearchResult]?
    var serachResultDataManager = SearchResultDataManager()
    var selectedView = SearchedResultView.Map
    
    lazy var datFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        categoryPickerViewController = storyboard?.instantiateViewController(withIdentifier: String( describing: CategoryPickerViewController.self)) as? CategoryPickerViewController
        categoryPickerViewController?.showPicker(onViewController: self)
        categoryPickerViewController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func showListView(_ sender: Any) {
        
    }
    @IBAction func showMapView(_ sender: Any) {
        
        
    }
    
    
    //MARK:- CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        
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
//                    self?.showDetailsOnPlacemark(forSearchedResults: self?.searchResults ?? [SearchResult]())
                    self?.categoryPickerViewController?.removePicker()
                    //self?.optionPickerView.removeFromSuperview()
                    
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
    
    func serachResults(forCategory categoryID: String?) {
        self.categoryID = categoryID
        if let categoryID = categoryID, let long = longitude, let lat = latitude {
            loadData(forLatitude: lat, andLongitude: long, withCategory: categoryID)
        }
    }

    
   // MARK:- private helper methods
    
    func showMapView(forResults searchedResults: [SearchResult]) {
        
    }
    
}
