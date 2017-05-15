//
//  StringExtension.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var md5: String {
        
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    func boundingRectWithSize(_ size: CGSize, font: UIFont) -> CGRect {
        
        let rect = NSString(string: self).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
        
        return rect
    }
}
