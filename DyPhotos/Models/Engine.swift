//
//  Engine.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit
import CoreLocation

typealias CompletionHandler = (_ result: Any?, _ error: Error?) -> ()

var engineInitialized = false

class Engine: NSObject {
    
    class var shared: Engine {
        struct Static {
            static let instance: Engine = Engine()
        }
        return Static.instance
    }
    
    func myFeed(_ maxId: String?, completion: @escaping CompletionHandler) {
        
        var accessToken = ""
        if let token = UserDefaults.standard.string(forKey: kAccessTokenKey) {
            accessToken = token
        }
        
        var urlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)"
        if let maxId = maxId { urlString += "&max_id=\(maxId)" }
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                
                if let data = data {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                        
                        var photos = [Photo]()
                        if let data = JSON["data"] as? [[String: AnyObject]] {
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let moc = appDelegate.managedObjectContext
                            
                            for d in data {
                                if let photo = Photo.photoWithData(d, inManagedObjectContext: moc) {
                                    photos.append(photo)
                                }
                            }
                            
                            appDelegate.saveContext()
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(photos as AnyObject, nil)
                        })
                    }
                    catch let jsonError as NSError {
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(nil, jsonError)
                        })
                    }
                }
                else if let error = error {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(nil, error as NSError)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(nil, nil)
                    })
                }
                
            }).resume()
        }
    }
    
    func recentMedia(_ maxId: String?, completion: @escaping CompletionHandler) {
        
        var accessToken = ""
        if let token = UserDefaults.standard.string(forKey: kAccessTokenKey) {
            accessToken = token
        }
        
        var urlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)"
        if let maxId = maxId { urlString += "&max_id=\(maxId)" }
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                
                completion(data, error)
                
            }).resume()
        }
    }
    
    func mapPhotos(from json: [String: AnyObject]) -> [Photo] {
        
        var photos = [Photo]()
        if let data = json["data"] as? [[String: AnyObject]] {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let moc = appDelegate.managedObjectContext
            
            for d in data {
                if let photo = Photo.photoWithData(d, inManagedObjectContext: moc) {
                    photos.append(photo)
                }
            }
            
            appDelegate.saveContext()
        }
        
        return photos
    }
    
    
    
    func searchLocations(_ latitude: Double, longitude: Double, completion: @escaping CompletionHandler) {
        
        var accessToken = ""
        if let token = UserDefaults.standard.string(forKey: kAccessTokenKey) {
            accessToken = token
        }
        
        let latString = NSString(format: "%+.6f", latitude)
        let lngString = NSString(format: "%+.6f", longitude)
        
        let urlString = "https://api.instagram.com/v1/locations/search?lat=\(latString)&lng=\(lngString)&access_token=\(accessToken)"
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                
                if let data = data {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                        
                        if let data = JSON["data"] as? [[String: AnyObject]] {
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                completion(data as AnyObject, nil)
                            })
                        }
                        else {
                            var errorMessage = "Ooppss! Something wrong..."
                            if let message = JSON["meta"]?["error_message"] as? String {
                                errorMessage = message
                            }
                            
                            let error = NSError(domain: "DYPHOTOS", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            DispatchQueue.main.async(execute: { () -> Void in
                                completion(nil, error)
                            })
                        }
                    }
                    catch let jsonError as NSError {
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(nil, jsonError)
                        })
                    }
                }
                else if let error = error {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(nil, error as NSError)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(nil, nil)
                    })
                }
            }).resume()
        }
    }

    func photosAroundLocation(_ locatioId: String, maxId: String?, completion: @escaping CompletionHandler) {
        
        var accessToken = ""
        if let token = UserDefaults.standard.string(forKey: kAccessTokenKey) {
            accessToken = token
        }
        
        var urlString = "https://api.instagram.com/v1/locations/\(locatioId)/media/recent?access_token=\(accessToken)"
        if let maxId = maxId { urlString += "&max_id=\(maxId)" }
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                
                if let data = data {
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                        
                        var photos = [PhotoAroundLocation]()
                        if let data = JSON["data"] as? [[String: AnyObject]] {
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let moc = appDelegate.managedObjectContext
                            
                            for d in data {
                                if let photo = PhotoAroundLocation.photoWithData(d, inManagedObjectContext: moc) {
                                    photos.append(photo)
                                }
                            }
                            
                            appDelegate.saveContext()
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(photos as AnyObject, nil)
                        })
                    }
                    catch let jsonError as NSError {
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(nil, jsonError)
                        })
                    }
                }
                else if let error = error {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(nil, error as NSError)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(nil, nil)
                    })
                }
                
            }).resume()
        }
    }
    
    func downloadImageWithUrl(_ url: URL, completion: @escaping CompletionHandler) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fileUrl = appDelegate.applicationDocumentsDirectory.appendingPathComponent(url.absoluteString.md5)
        
        if let imageData = try? Data(contentsOf: fileUrl) {
            
            let image = UIImage(data: imageData)
            completion(image, nil)
        }
        else {
            
            DispatchQueue.global(qos: .default).async(execute: { () -> Void in
                
                let imageData = try? Data(contentsOf: url)
                try? imageData?.write(to: fileUrl, options: [])
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        completion(image, nil)
                    }
                    else {
                        completion(nil, nil)
                    }
                })
            })
        }
    }
}
