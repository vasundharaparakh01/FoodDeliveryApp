//
//  SDataHelper.swift
//  FanServe
//
//  Created by McCoy Mart on 27/06/22.
//

import UIKit
import Loaf

class SDataHelper: NSObject {
    
    static let shared = SDataHelper()
    
    func callWebApiToGetTicketToken(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        var params = Dictionary<String, Any>()
        params["username"] = "admin".sha256()
        params["password"] = "nimda".sha256()
        
        ServiceHelper.request(params: params, method: .post, apiName: "getToken") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if responseCode == 200{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(true, responseDic)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetTicketDetail(isFromScan : Bool, ticketnumber: String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        var params = Dictionary<String, Any>()
        if isFromScan{
            params["qrValue"] = ticketnumber
        }else{
            params["ticketNumber"] = ticketnumber
        }
        ServiceHelper.request(params: params, method: .post, apiName: "getTicketDetail") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetMatchList(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "getMatch") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetNewsList(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .get, apiName: "news") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetClubsList(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "club") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetPlayersList(clubId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "players/club/\(clubId)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetPrivacyPolicy(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "policy/privacy-policy") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetTermCondition(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "policy/terms-and-condition") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetRefundPolicy(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "policy/refund-and-shipping-policy") { (response, error, responseCode) in

            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetAboutUs(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "policy/about-us") { (response, error, responseCode) in

            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetContactUs(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "policy/contact-us") { (response, error, responseCode) in

            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetRestaurantList(sorting:String, filter : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        var apiUrl = "restaurant"
        if sorting.count > 0{
            apiUrl = "restaurant?sortBy=\(sorting)"
        }else if filter.count > 0{
            apiUrl = "restaurant?cusine=\(filter)"
        }
        ServiceHelper.request(params: [:], method: .get, apiName: apiUrl) { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetRestaurantMenuList(restoId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        let appUser = SCoreDataHelper.shared.currentUser()
        var apiUrl = ""
        if appUser?.isCurrentlyLogin ?? false{
            apiUrl = "menu/list/\(restoId)?userId=\(appUser?.userId ?? "")"
        }else{
            apiUrl = "menu/list/\(restoId)"
        }
        ServiceHelper.request(params: [:], method: .get, apiName: apiUrl) { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetRestaurantSouvenierList(sorting: String, pageNumber : Int, restoId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        let appUser = SCoreDataHelper.shared.currentUser()
        var apiUrl = ""
        if appUser?.isCurrentlyLogin ?? false{
            apiUrl = "souvenier/list/\(restoId)?userId=\(appUser?.userId ?? "")"
            if sorting.count > 0{
                apiUrl = "souvenier/list/\(restoId)?sortBy=\(sorting)&userId=\(appUser?.userId ?? "")"
            }
        }else{
            apiUrl = "souvenier/list/\(restoId)"
            if sorting.count > 0{
                apiUrl = "souvenier/list/\(restoId)?sortBy=\(sorting)"
            }
        }
        ServiceHelper.request(params: [:], method: .get, apiName: apiUrl) { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetPlayerSouvenierList(sorting: String, pageNumber : Int, restoId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        let appUser = SCoreDataHelper.shared.currentUser()
        var apiUrl = ""
        if appUser?.isCurrentlyLogin ?? false{
            apiUrl = "souvenier/list/player/\(restoId)?userId=\(appUser?.userId ?? "")"
    //        if sorting.count > 0{
    //            apiUrl = "souvenier/list/\(restoId)?sortBy=\(sorting)"
    //        }
        }else{
            apiUrl = "souvenier/list/player/\(restoId)"
    //        if sorting.count > 0{
    //            apiUrl = "souvenier/list/\(restoId)?sortBy=\(sorting)"
    //        }
        }
        
        ServiceHelper.request(params: [:], method: .get, apiName: apiUrl) { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToRegisterNewUser(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.multipartApiCall(params: params, method: .post, apiName: "auth/register") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Bool, status == true{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if responseCode != 200{
                            if let message = responseDic["message"] as? String{
                                MessageView.showMessage(message: message, time: 3.0, verticalAlignment: .bottom)
                            }
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToLoginUser(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "auth/login") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if responseCode != 200{
                            if let message = responseDic["message"] as? String{
                                MessageView.showMessage(message: message, time: 3.0, verticalAlignment: .bottom)
                            }
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToSocialUserRegister(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.multipartApiCall(params: params, method: .post, apiName: "social-auth/register") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let status = responseDic["status"] as? Int16, status == 0 && (responseCode == 400){
                            onCompletionBlock!(true, responseDic)
                        }else{
                            if responseCode != 200{
                                if let message = responseDic["message"] as? String{
                                    MessageView.showMessage(message: message, time: 3.0, verticalAlignment: .bottom)
                                }
                            }
                            onCompletionBlock!(false, nil)
                        }
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToSocialUserLogin(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "social-auth/login") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if responseCode != 200{
                            if let message = responseDic["message"] as? String{
                                MessageView.showMessage(message: message, time: 3.0, verticalAlignment: .bottom)
                            }
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToForgotPassword(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "auth/forgot-password") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if responseCode != 200{
                            if let message = responseDic["message"] as? String{
                                MessageView.showMessage(message: message, time: 3.0, verticalAlignment: .bottom)
                            }
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToChangePassword(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .patch, apiName: "auth/update-password") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToVerifyOTP(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "auth/verify-otp") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToResetPassword(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "auth/reset-password") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToUpdateUserDetail(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.multipartApiCall(params: params, method: .patch, apiName: "auth/update") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToAddToCart(params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "cart") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToUpdateCart(menuId : String, params: Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .patch, apiName: "cart/\(menuId)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToDeleteItemInCart(menuId: String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .delete, apiName: "cart/\(menuId)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGatCartDetail(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "cart") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGatTaxList(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "tax") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetAllCategoryListOfRestaurant(restoId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "category/all/\(restoId)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetAllNotifications(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "notifications") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetWalletDetails(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "wallet") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetLoyaltyDetails(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "auth/loyality-points") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetStripeIntent(amount : Int64, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        var params = Dictionary<String, Any>()
        params["amount"] = amount * 100
        
        ServiceHelper.request(params: params, method: .post, apiName: "stripe") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToPlaceOrder(params : Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "order") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetPassbookList(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "transaction?limit=10&page=1") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetMyOrders(page : Int, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "order?page=\(page)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToCancelMyOrders(params : Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "order/cancel") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToUpdateRestaurantReview(params : Dictionary<String, Any>, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: params, method: .post, apiName: "review/restaurant") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetOrderDetail(orderId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "order/details/\(orderId)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetOrderDetailByCustomId(orderId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "order/details/customId/\(orderId)") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetCancelPolicy(restoId : String, onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "static-page/\(restoId)/cancellation-policy") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToGetCartCount(onCompletionBlock: ((Bool, Dictionary<String, Any>?)->(Void))?){
        
        ServiceHelper.request(params: [:], method: .get, apiName: "cart/count") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        if let dataDic = responseDic["data"] as? Dictionary<String, Any>{
                            let appUser = SCoreDataHelper.shared.currentUser()
                            appUser?.cartCount = dataDic.validatedInt32Value("cartCount")
                            SCoreDataHelper.shared.saveContext()
                        }
                        onCompletionBlock!(true, responseDic)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }

    func callWebApiToGetFaceIdLockStatus(onCompletionBlock: ((_ status: Bool, _ faceIdStatus: Bool?)->(Void))?){
        ServiceHelper.request(params: [:], method: .get, apiName: "auth/face-id-status") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        if let dataDic = responseDic["data"] as? Dictionary<String, Any> {
//                            let appUser = SCoreDataHelper.shared.currentUser()
//                            appUser?.cartCount = dataDic.validatedInt32Value("cartCount")
//                            SCoreDataHelper.shared.saveContext()
                            print(dataDic)
                            print(dataDic)
                            print(dataDic)
                            onCompletionBlock!(true, dataDic["faceIdStatus"] as! Bool)
                            return
                        }
                        onCompletionBlock!(true, false)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
    
    func callWebApiToSetFaceIdLockStatus(_ isOn: Bool,onCompletionBlock: ((_ status: Bool, _ faceIdStatus: Bool?)->(Void))?){
        ServiceHelper.request(params: ["faceIdStatus":isOn], method: .patch, apiName: "auth/update") { (response, error, responseCode) in
            
            if error == nil{
                if let responseDic = response as? Dictionary<String, Any>{
                    if let status = responseDic["status"] as? Int16, status == 1{
                        if let dataDic = responseDic["data"] as? Dictionary<String, Any> {
//                            let appUser = SCoreDataHelper.shared.currentUser()
//                            appUser?.cartCount = dataDic.validatedInt32Value("cartCount")
//                            SCoreDataHelper.shared.saveContext()
                            print(dataDic)
                            print(dataDic)
                            print(dataDic)
                            onCompletionBlock!(true, dataDic["faceIdStatus"] as! Bool)
                            return
                        }
                        onCompletionBlock!(true, false)
                    }else{
                        if let message = responseDic["message"] as? String{
                            MessageView.showMessage(message: message, time: 2.0, verticalAlignment: .bottom)
                        }
                        onCompletionBlock!(false, nil)
                    }
                }
            }else{
                onCompletionBlock!(false, nil)
            }
        }
    }
}
