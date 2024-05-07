//
//  StringExtension.swift
//  GoGuards
//
//  Created by Abhishek Agarwal on 26/08/21.
//  Copyright © 2021 Deepak. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    var integerValue: Int {
        return NSString(string: self).integerValue
    }
    var int16: Int16 {
        return Int16(NSString(string: self).integerValue)
    }
    var int64: Int64 {
        return Int64(NSString(string: self).integerValue)
    }
    var doubleValue: Double {
        return NSString(string: self).doubleValue
    }
    func trim() -> String{
        return self.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)
    }
    
    func nameAbbreviated() -> String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(
            from: self
        ) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return self
    }
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
}

extension String {
    func attributedString()->NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
    }
    
    func containsEmoji() -> Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
}

// MARK: - date from string
extension String {
    
    func dateFromString(format1: String? = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", to format2: String? = "dd/MM/yyyy") -> Date? {
     //   let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format1
        dateFormatter.locale = Locale.init(identifier: "en_GB")

        let dateObj = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format2
        return dateObj
        //print("Dateobj: \(dateFormatter.string(from: dateObj!))")
    }
    
    func formatedDate(formatter:String = "MM-dd-yyyy") -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       // dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = formatter
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Dictionary {
    
    func validatedValue(_ key: Key, expected: AnyObject) -> AnyObject {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                return "\(object)" as AnyObject
            }
                
                // checking if object is of desired class
            else if ((object as AnyObject).isKind(of: expected.classForCoder) == false) {
                //Debug.log("case // checking if object is of desired class....not")
                
                return expected
            }
                
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    return "" as AnyObject
                }
                return "\(object)".trim() as AnyObject
                
            } else if object is Int {
                if ((object as! Int).description == "null" || (object as! Int).description == "<null>" || (object as! Int).description == "(null)") {
                    return 0 as AnyObject
                }
            } else if object is Float {
                if ((object as! Float).description == "null" || (object as! Float).description == "<null>" || (object as! Float).description == "(null)") {
                    return 0 as AnyObject
                }
            } else if object is Dictionary {
                if ((object as! Dictionary).description == "null" || (object as! Dictionary).description == "<null>" || (object as! Dictionary).description == "(null)") {
                    return [:] as AnyObject
                }
            } else if object is Array<Any> {
                if ((object as! Array<Any>).description == "null" || (object as! Array<Any>).description == "<null>" || (object as! Array<Any>).description == "(null)") {
                    return [] as AnyObject
                }
            } else if object is NSNumber {
                if ((object as! NSNumber).description == "null" || (object as! NSNumber).description == "<null>" || (object as! NSNumber).description == "(null)") {
                    return 0 as AnyObject
                }
            }
            else if object is Bool {
                if ((object as! Bool).description == "null" || (object as! Bool).description == "<null>" || (object as! Bool).description == "(null)") {
                    return 0 as AnyObject
                }
            }
            
            return object as AnyObject
        } else {
            
            if expected is String {
                return "" as AnyObject
            } else if expected is Int || expected is Float {
                return 0 as AnyObject
            } else if expected is Dictionary {
                return [:] as AnyObject
            } else if expected is Array<Any> {
                return [] as AnyObject
            }
            
            return expected
        }
    }
    
    func validatedStringValue(_ key: Key, expected: String = "") -> String {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber  {
                return "\(object)".trim()
            }else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    return ""
                }
            }else if object is NSNull{
                return expected
            }
            
            return "\(object)".trim()
        }
        return expected
    }
    func validatedDoubleValue(_ key: Key, expected: Double? = 0) -> Double {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            if object is NSNumber {
                return "\(object)".doubleValue
            }else if object is String {
                return "\(object)".doubleValue
            }
        }
        return expected!
    }
    
    
    func validatedInt16Value(_ key: Key, expected: Int16? = 0) -> Int16 {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            
            if object is NSNumber {
                return Int16(NSString(string: "\(object)").integerValue)
            }else if object is String {
                return Int16(NSString(string: "\(object)").integerValue)
            }
        }
        return expected!
    }
    
    func validatedInt32Value(_ key: Key, expected: Int32? = 0) -> Int32 {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            
            if object is NSNumber {
                return Int32(NSString(string: "\(object)").integerValue)
            }else if object is String {
                return Int32(NSString(string: "\(object)").integerValue)
            }
        }
        return expected!
    }
    
    func validatedInt64Value(_ key: Key, expected: Int64? = 0) -> Int64 {
        
        // checking if in case object is nil
        
        if let object = self[key] {
            if object is NSNumber {
                return Int64(NSString(string: "\(object)").integerValue)
            }else if object is String {
                return Int64(NSString(string: "\(object)").integerValue)
            }
        }
        return expected!
    }
    
    func validatedBoolValue(_ key: Key, expected: Bool? = false) -> Bool {
        
        if let object = self[key] {
            if object is NSNumber {
                return NSString(string: "\(object)").boolValue
            }else if object is String {
                return NSString(string: "\(object)").boolValue
            }else if object is Bool {
                return object as! Bool
            }
        }
        return expected!
    }
}
