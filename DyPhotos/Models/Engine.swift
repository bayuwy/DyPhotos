//
//  Engine.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit
import CoreLocation

typealias CompletionHandler = (result: AnyObject?, error: NSError?) -> ()

var engineInitialized = false

class Engine: NSObject, CLLocationManagerDelegate {
    
    private var location: CLLocation?
    private lazy var locationManager: CLLocationManager =  {
        
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        
        return manager
    }()
    
    class var shared: Engine {
        struct Static {
            static let instance: Engine = Engine()
        }
        return Static.instance
    }
    
    
    func myFeed(maxId: String?, completion: CompletionHandler) {
        
        var accessToken = ""
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) {
            accessToken = token
        }
        
        var urlString = "https://api.instagram.com/v1/users/self/feed?access_token=\(accessToken)"
        if let maxId = maxId { urlString += "&max_id=\(maxId)" }
        
        if let url = NSURL(string: urlString) {
            
            let request = NSURLRequest(URL: url)
            
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                if let data = data {
                    do {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! [String: AnyObject]
                        
                        var photos = [Photo]()
                        if let data = JSON["data"] as? [[String: AnyObject]] {
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            let moc = appDelegate.managedObjectContext
                            
                            for d in data {
                                if let photo = Photo.photoWithData(d, inManagedObjectContext: moc) {
                                    photos.append(photo)
                                }
                            }
                            
                            appDelegate.saveContext()
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(result: photos, error: nil)
                        })
                    }
                    catch let jsonError as NSError {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(result: nil, error: jsonError)
                        })
                    }
                }
                else if let error = error {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: nil, error: error)
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: nil, error: nil)
                    })
                }
                
            }).resume()
        }
    }
    
    func searchLocations(completion: CompletionHandler) {
        
        if let location = location {
            
            var accessToken = ""
            if let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) {
                accessToken = token
            }
            
            let latString = NSString(format: "%+.6f", location.coordinate.latitude)
            let lngString = NSString(format: "%+.6f", location.coordinate.longitude)
            
            let urlString = "https://api.instagram.com/v1/locations/search?lat=\(latString)&lng=\(lngString)&access_token=\(accessToken)"
            
            if let url = NSURL(string: urlString) {
                
                let request = NSURLRequest(URL: url)
                
                let session = NSURLSession.sharedSession()
                session.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                    
                    if let data = data {
                        do {
                            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! [String: AnyObject]
                            
                            if let data = JSON["data"] as? [[String: AnyObject]] {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(result: data, error: nil)
                                })
                            }
                        }
                        catch let jsonError as NSError {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(result: nil, error: jsonError)
                            })
                        }
                    }
                    else if let error = error {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(result: nil, error: error)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(result: nil, error: nil)
                        })
                    }
                }).resume()
            }
        }
        else {
            completion(result: nil, error: nil)
            locationManager.startUpdatingLocation()
        }
    }
    
    func photosAroundLocation(locatioId: String, maxId: String?, completion: CompletionHandler) {
        
        var accessToken = ""
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) {
            accessToken = token
        }
        
        var urlString = "https://api.instagram.com/v1/locations/\(locatioId)/media/recent?access_token=\(accessToken)"
        if let maxId = maxId { urlString += "&max_id=\(maxId)" }
        
        if let url = NSURL(string: urlString) {
            
            let request = NSURLRequest(URL: url)
            
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                if let data = data {
                    do {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! [String: AnyObject]
                        
                        var photos = [PhotoAroundLocation]()
                        if let data = JSON["data"] as? [[String: AnyObject]] {
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            let moc = appDelegate.managedObjectContext
                            
                            for d in data {
                                if let photo = PhotoAroundLocation.photoWithData(d, inManagedObjectContext: moc) {
                                    photos.append(photo)
                                }
                            }
                            
                            appDelegate.saveContext()
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(result: photos, error: nil)
                        })
                    }
                    catch let jsonError as NSError {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(result: nil, error: jsonError)
                        })
                    }
                }
                else if let error = error {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: nil, error: error)
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: nil, error: nil)
                    })
                }
                
            }).resume()
        }
    }
    
    
    
    func downloadImageWithUrl(url: NSURL, completion: CompletionHandler) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fileUrl = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent(url.absoluteString.md5)
        
        if let imageData = NSData(contentsOfURL: fileUrl) {
            
            let image = UIImage(data: imageData)
            completion(result: image, error: nil)
        }
        else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                let imageData = NSData(contentsOfURL: url)
                imageData?.writeToURL(fileUrl, atomically: false)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        completion(result: image, error: nil)
                    }
                    else {
                        completion(result: nil, error: nil)
                    }
                })
            })
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations[0]
        location = newLocation
        
        NSNotificationCenter.defaultCenter().postNotificationName(kLocationDidUpdateNotification, object: nil, userInfo: nil)
    }
}
