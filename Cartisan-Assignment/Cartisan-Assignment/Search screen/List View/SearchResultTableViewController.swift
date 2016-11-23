//
//  SearchResultTableViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UIViewController {
    
    var searchResults: [SearchResult]?
    
    //TODO:- need to check better solution
    var parentNavigationController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var searchResultTableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showList(onView view: UIView) {
        self.view.frame = view.frame
        view.addSubview(self.view)
    }
    
    func removeList() {
        view.alpha = 0
    }
    
    func showList() {
        view.alpha = 1
    }
    func refresh()  {
        searchResultTableView.reloadData()
    }
}

//MARK:- UITableViewDataSource methods
extension SearchResultTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = searchResults?[indexPath.row].name
        return cell
    }

}

//MARK:- UITableViewDelegate methods
extension SearchResultTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venueDetailsViewController = storyboard?.instantiateViewController(withIdentifier: String( describing: VenueDetailsViewController.self)) as! VenueDetailsViewController
        venueDetailsViewController.venueID = searchResults?[indexPath.row].id
        parentNavigationController?.pushViewController(venueDetailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

