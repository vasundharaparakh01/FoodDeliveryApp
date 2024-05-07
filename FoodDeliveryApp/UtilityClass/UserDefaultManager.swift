
//
//  UserDefaultManager.swift
//  WeSolve
//
//  Created by Abhishek Agarwal on 12/05/19.
//  Copyright © 2019 Abhishek Agarwal. All rights reserved.
//

import UIKit
import Security

public class Keychain1 {
    public class func set(key: String, value: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return set(key: key, value: data)
        }
        
        return false
    }
    
    public class func set(key: String, value: Data) -> Bool {
        let query = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecValueData   : value
        ] as CFDictionary
        
        SecItemDelete(query)
        
        return SecItemAdd(query, nil) == noErr
    }
    
    public class func get(key: String) -> String? {
        if let data = getData(key: key) {
            return String(data: data as Data, encoding: String.Encoding.utf8)
        }
        
        return nil
    }
    
    public class func getData(key: String) -> Data? {
        let query = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData  : kCFBooleanTrue as Any,
            kSecMatchLimit  : kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == noErr && dataTypeRef != nil {
            return dataTypeRef as? Data
        }
        
        return nil
    }
    
    public class func delete(key: String) -> Bool {
        let query = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : key
        ] as CFDictionary
        
        return SecItemDelete(query) == noErr
    }
    
    public class func clear() -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        return SecItemDelete(query) == noErr
    }
}

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

class UserDefaultManager: NSObject {
    
    static let sharedInstance = UserDefaultManager()
    
    var userData:[String:Any] {
        get {
            if NSUSERDEFAULT.value(forKey: Constants.ServerKey.userInfo) != nil {
                do {
                    let decoded = NSUSERDEFAULT.object(forKey: Constants.ServerKey.userInfo) as? Data
                    let decodedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded!) as? [String:Any]
                    return decodedData ?? [:]
                } catch (let error) {
                    print(error)
                }
            }
            return [:]
        }
        set {
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                NSUSERDEFAULT.setValue(encodedData, forKey: Constants.ServerKey.userInfo)
                NSUSERDEFAULT.synchronize()
            } catch (let error) {
                print(error)
            }
        }
    }
    
    var userID:String {
        get {
            if NSUSERDEFAULT.value(forKey: Constants.UserDefaultsKey.deviceID) != nil {
                let getDeviceID = NSUSERDEFAULT.object(forKey: Constants.UserDefaultsKey.deviceID) as? String
                return getDeviceID ?? ""
            }
            return ""
        }
        set {
            NSUSERDEFAULT.setValue(newValue, forKey: Constants.UserDefaultsKey.deviceID)
            NSUSERDEFAULT.synchronize()
        }
    }
    
    var deviceID:String {
        get {
            if NSUSERDEFAULT.value(forKey: Constants.UserDefaultsKey.deviceID) != nil {
                let getDeviceID = NSUSERDEFAULT.object(forKey: Constants.UserDefaultsKey.deviceID) as? String
                return getDeviceID ?? ""
            }
            return ""
        }
        set {
            NSUSERDEFAULT.setValue(newValue, forKey: Constants.UserDefaultsKey.deviceID)
            NSUSERDEFAULT.synchronize()
        }
    }
    
    var deviceToken: String {
        get {
            if NSUSERDEFAULT.value(forKey: Constants.UserDefaultsKey.deviceToken) != nil {
                let getDeviceToken = NSUSERDEFAULT.object(forKey: Constants.UserDefaultsKey.deviceToken) as? String
                return getDeviceToken ?? ""
            }
            return ""
        }
        set {
            NSUSERDEFAULT.setValue(newValue, forKey: Constants.UserDefaultsKey.deviceToken)
            NSUSERDEFAULT.synchronize()
        }
    }
    
    func clearCache() {
      //  NSUSERDEFAULT.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        NSUSERDEFAULT.removeObject(forKey: Constants.ServerKey.userInfo)
        NSUSERDEFAULT.synchronize()
    }
}
