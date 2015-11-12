//
//  LocationsViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

class LocationsViewController: UITableViewController {

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPhotos" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    
                    let location = locations[indexPath.row]
                    let viewController = segue.destinationViewController as! PhotosViewController
                    viewController.location = location
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func locationDidUpdate(sender: NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kLocationDidUpdateNotification, object: nil)
        loadLocations()
    }
    
    func loadLocations() {
        
        Engine.shared.searchLocations { (result, error) -> () in
            
            self.refreshControl?.endRefreshing()
            
            if let response = result as? [[String: AnyObject]] {
                
                self.locations = response
                self.tableView.reloadData()
            }
            if let _ = error {
                
            }
            else {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("locationDidUpdate:"), name: kLocationDidUpdateNotification, object: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func refresh(sender: UIRefreshControl) {
        loadLocations()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCellId", forIndexPath: indexPath)
        
        // Configure the cell...
        let location = locations[indexPath.row]
        if let name = location["name"] as? String {
            cell.textLabel?.text = name
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("showPhotos", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
}
