//
//  User.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/6/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func userWithData(_ data: [String: AnyObject], inManagedObjectContext moc: NSManagedObjectContext) -> User? {
        
        var user: User?
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", data["id"] as! String)
        
        do {
            let users = try moc.fetch(fetchRequest) as! [User]
            if users.count > 0 {
                user = users.first
            }
            else {
                user = NSEntityDescription.insertNewObject(forEntityName: "User", into: moc) as? User
                user?.userId = data["id"] as? String
                
                if let username = data["username"] as? String {
                    user?.username = username
                }
                if let fullName = data["full_name"] as? String {
                    user?.fullName = fullName
                }
                if let profilePicture = data["profile_picture"] as? String {
                    user?.profilePicture = profilePicture
                }
            }
        }
        catch {
            
        }
        
        return user
    }
}
