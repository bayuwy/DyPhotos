//
//  NSDateExtension.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation

extension Date {
    
    func timeAgoString(_ date: Date = Date()) -> String {
        
        let calendar = Calendar.current
        var earliest = (self as NSDate).earlierDate(date)
        var latest: Date!
        if earliest == self {
            latest = date
        }
        else {
            latest = self
        }
        
        // if timeAgo < 24h => compare DateTime else compare Date only
        let upToHours: NSCalendar.Unit = [.second, .minute, .hour]
        var difference = (calendar as NSCalendar).components(upToHours, from: earliest, to: latest, options: [])
        
        var dateString = ""
        
        if difference.hour! < 24 {
            if difference.hour! >= 1 {
                dateString = "\(difference.hour!)h"
            }
            else if (difference.minute! >= 1) {
                dateString = "\(difference.minute!)m"
            }
            else {
                dateString = "\(difference.second!)s"
            }
        }
        else {
            let bigUnits: NSCalendar.Unit = [.timeZone, .day, .weekOfYear, .year]
            
            var components = (calendar as NSCalendar).components(bigUnits, from: earliest)
            earliest = calendar.date(from: components)!
            
            components = (calendar as NSCalendar).components(bigUnits, from:latest)
            latest = calendar.date(from: components)!
            
            difference = (calendar as NSCalendar).components(bigUnits, from: earliest, to: latest, options: [])
            
            if difference.year! >= 1 {
                dateString = "\(difference.year!)y"
            }
            else if (difference.weekOfYear! >= 1) {
                dateString = "\(difference.weekOfYear!)w"
            }
            else {
                dateString = "\(difference.day!)d"
            }
        }
        
        return dateString
    }
}
