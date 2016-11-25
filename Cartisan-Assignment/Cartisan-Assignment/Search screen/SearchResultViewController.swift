//
//  SearchResultViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit
import MapKit

enum SearchedResultView: Int {
    case Map,List
}


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
    var selectedView = SearchedResultView.Map
    var searchResultMapViewController: SearchResultMapViewController!
    var searchResultTableViewController: SearchResultTableViewController!

    
    lazy var datFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
    }
    
        //MARK:- IBActions
    @IBAction func showListView(_ sender: Any) {
        showSelectedView(sender)
    }
    @IBAction func showMapView(_ sender: Any) {
        showSelectedView(sender)
    }
    
    @IBAction func show(_ sender: AnyObject) {
        categoryPickerViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CategoryPickerViewController.self)) as? CategoryPickerViewController
        categoryPickerViewController?.showPicker(onViewController: self)
        categoryPickerViewController?.delegate = self
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
        var serachResultDataManager = SearchResultDataManager()
        serachResultDataManager.fetch(forData: parameters) { [weak self](searchResults) in
            DispatchQueue.main.async {
                if let searchResults = searchResults {
                    self?.searchResults = searchResults
                    self?.show(searchedResultData: searchResults)
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
        self.categoryID = categoryID ?? Category(rawValue: 0)?.id
        if let long = longitude, let lat = latitude {
            loadData(forLatitude: lat, andLongitude: long, withCategory: self.categoryID)
        }
    }

    
   // MARK:- private helper methods
    
    private func show(searchedResultData searchedData: [SearchResult]) {
        switch selectedView {
        case .Map:
            displayMapView(forResults: searchedData)
        case .List:
            displayListView(forResults: searchedData)
       
        }
        categoryPickerViewController?.removePicker()
    }
    
   private func displayMapView(forResults searchedResults: [SearchResult]) {
         DispatchQueue.main.async {[weak self] in
            self?.searchResultTableViewController.removeList()
            self?.searchResultMapViewController?.showMap()
            self?.searchResultMapViewController?.showDetailsOnPlacemark(forSearchedResults: searchedResults)
        }
    }
    
    private func displayListView(forResults searchedResults: [SearchResult]) {
        DispatchQueue.main.async {[weak self] in
            self?.searchResultMapViewController.removeMap()
            self?.searchResultTableViewController.searchResults = self!.searchResults
            self?.searchResultTableViewController?.showList()
            self?.searchResultTableViewController?.refresh()
        }
    }
    
    private func prepareView() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // create list view
        searchResultTableViewController = storyboard?.instantiateViewController(withIdentifier: String( describing: SearchResultTableViewController.self)) as? SearchResultTableViewController
        searchResultTableViewController.parentNavigationController = navigationController
        searchResultTableViewController?.showList(onView: containerView)
        
        // create map view
        searchResultMapViewController = storyboard?.instantiateViewController(withIdentifier: String( describing: SearchResultMapViewController.self)) as? SearchResultMapViewController
        searchResultMapViewController.parentNavigationController = navigationController
        searchResultMapViewController?.showMap(onView: containerView)
        
        //create pickerView
        categoryPickerViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CategoryPickerViewController.self)) as? CategoryPickerViewController
        categoryPickerViewController?.showPicker(onViewController: self)
        categoryPickerViewController?.delegate = self
        
    }
    
    private func createPicker() {
        categoryPickerViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CategoryPickerViewController.self)) as? CategoryPickerViewController
        categoryPickerViewController?.showPicker(onViewController: self)
        categoryPickerViewController?.delegate = self
    }

    private func showSelectedView(_ sender: Any) {
        let button = (sender as! UIButton)
        if button.state == .selected {
            button.backgroundColor = UIColor.darkGray
        } else {
            button.backgroundColor = UIColor.lightGray
        }
        selectedView = SearchedResultView(rawValue: button.tag)!
        if let searchResults = searchResults {
            show(searchedResultData: searchResults)
            
        }
    }
}
