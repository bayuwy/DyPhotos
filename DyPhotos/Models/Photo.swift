//
//  Photo.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/5/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import CoreData


class Photo: GenericPhoto {

// Insert code here to add functionality to your managed object subclass

    class func photoWithData(_ data: [String: AnyObject], inManagedObjectContext moc: NSManagedObjectContext) -> Photo? {
        return GenericPhoto.photoWithData(data, entity: "Photo", inManagedObjectContext: moc) as? Photo
    }
    
    
    class func photosInManagedObjectContext(_ moc: NSManagedObjectContext) -> [Photo] {
        return GenericPhoto.photosWithEntity("Photo", inManagedObjectContext: moc) as! [Photo]
    }
}
