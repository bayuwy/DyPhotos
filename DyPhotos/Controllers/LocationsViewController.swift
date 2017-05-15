//
//  LocationsViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UITableViewController, CLLocationManagerDelegate {
    
    fileprivate var location: CLLocation?
    fileprivate lazy var locationManager: CLLocationManager =  {
        
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        
        return manager
    }()
    
    var locations = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        loadLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotos" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    
                    let location = locations[indexPath.row]
                    let viewController = segue.destination as! PhotosViewController
                    viewController.location = location
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func locationDidUpdate(_ sender: Notification) {
        
        NotificationCenter.default.removeObserver(self, name: kLocationDidUpdateNotification, object: nil)
        loadLocations()
    }
    
    func loadLocations() {
        
        if let location = location {
            Engine.shared.searchLocations(location.coordinate.latitude, longitude: location.coordinate.longitude) { (result, error) -> () in
                
                self.refreshControl?.endRefreshing()
                
                if let response = result as? [[String: AnyObject]] {
                    
                    self.locations = response
                    self.tableView.reloadData()
                }
                else if let error = error {
                    
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    NotificationCenter.default.addObserver(self, selector: #selector(LocationsViewController.locationDidUpdate(_:)), name: kLocationDidUpdateNotification, object: nil)
                }
            }
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        loadLocations()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCellId", for: indexPath)
        
        // Configure the cell...
        let location = locations[indexPath.row]
        if let name = location["name"] as? String {
            cell.textLabel?.text = name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPhotos", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations[0]
        location = newLocation
        
        loadLocations()
        manager.stopUpdatingLocation()
    }
}
