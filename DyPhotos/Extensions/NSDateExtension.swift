//
//  NSDateExtension.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation

extension NSDate {
    
    func timeAgoString(date: NSDate = NSDate()) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        
        var earliest = earlierDate(date)
        var latest = (earliest == self) ? date : self;
        
        // if timeAgo < 24h => compare DateTime else compare Date only
        let upToHours: NSCalendarUnit = [.Second, .Minute, .Hour]
        var difference = calendar.components(upToHours, fromDate: earliest, toDate: latest, options: [])
        
        if difference.hour < 24 {
            if difference.hour >= 1 {
                return "\(difference.hour)h"
            }
            else if (difference.minute >= 1) {
                return "\(difference.minute)m"
            }
            else {
                return "\(difference.second)s"
            }
            
        }
        else {
            let bigUnits: NSCalendarUnit = [.TimeZone, .Day, .WeekOfYear, .Year]
            
            var components = calendar.components(bigUnits, fromDate: earliest)
            earliest = calendar.dateFromComponents(components)!
            
            components = calendar.components(bigUnits, fromDate:latest)
            latest = calendar.dateFromComponents(components)!
            
            difference = calendar.components(bigUnits, fromDate: earliest, toDate: latest, options: [])
            
            if difference.year >= 1 {
                return "\(difference.year)y"
            }
            else if (difference.weekOfYear >= 1) {
                return "\(difference.weekOfYear)w"
            }
            else {
                return "\(difference.day)d"
            }
        }
    }
}