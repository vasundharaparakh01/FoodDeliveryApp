//
//  ISDCodeModel.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 19/05/22.
//


import Foundation
import SwiftyJSON

class ISDCodeModel:NSObject{
    var countryCode = ""
    var countryName = ""
    var isdCode = ""
    var countryFlag = ""
    
    
    class func isdCodeDataModel(dataArray :JSON) -> ISDCodeModel {
        
            let obj = ISDCodeModel()
            
            obj.countryCode = dataArray["countryCode"].stringValue
            obj.countryName = dataArray["countryName"].stringValue
            obj.isdCode = dataArray["isdCode"].stringValue
            obj.countryFlag = dataArray["countryFlag"].stringValue
        
        return obj
    }
}

class BankDetailModel:NSObject{
    
    var name = ""
    var accountNumber = ""
    var confirmAccountNumber = ""
    var ifsc = ""
}

class PreorderModel:NSObject{
    
    var date = ""
    var tournament = ""
    var zone = ""
    var seatNo = ""
    var time = ""
    var deliveryType = ""
}
