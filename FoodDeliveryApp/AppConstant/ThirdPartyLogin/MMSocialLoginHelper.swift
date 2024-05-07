//
//  MMSocialLoginHelper.swift
//  McCoy_Mart
//
//  Created by McCoy Mart on 04/03/21.
//  Copyright © 2021 Lalit Kumar Gupta. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

protocol SocialLoginDelegate {
    
    func googleSignInFinished(with user: SocialUser?, error: Error?)
    func facebookSignInFinished(with user: SocialUser?, error: String?)
    func appleSignInFinished(with user: SocialUser?, error: String?)
}

extension SocialLoginDelegate {
    func googleSignInFinished(with user: SocialUser?, error: Error?) {}
    func facebookSignInFinished(with user: SocialUser?, error: String?) {}
    func appleSignInFinished(with user: SocialUser?, error: String?) {}
}

enum SocialType: String {
    case Google = "google"
    case Facebook = "facebook"
    case Apple = "apple"
}

class MMSocialLoginHelper: NSObject {
    
    static let shared: MMSocialLoginHelper = MMSocialLoginHelper()
    var delegate: SocialLoginDelegate?
    var controller: UIViewController?
}

// Facebook Login
extension MMSocialLoginHelper {
    
    func initialiseFacebookLogin(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    func facebookSignIn(controller: UIViewController) {
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: controller){ (result, error) in
            if (error == nil){
                let fbLoginresult: LoginManagerLoginResult = result!
                if  fbLoginresult.grantedPermissions.count > 0 {
                    if(fbLoginresult.grantedPermissions.contains("email")){
                        self.getFBData { [weak self](result, errorMessage) in
                            if let message = errorMessage {
                                self?.delegate?.facebookSignInFinished(with: nil, error: message)
                                fbLoginManager.logOut()
                            } else if let dict = result {
                                let fName = dict["first_name"] as! String
                                let lName = dict["last_name"] as! String
                                let name = dict["name"] as! String
                                let email = dict["email"] as! String
                                let id = dict["id"] as! String
                                
                                var imageUrl = ""
                                var hasImage = false
                                if let picture = dict["picture"] as? [String: Any], let imageData = picture["data"] as? [String: Any], let imgURL = imageData["url"] as? String {
                                    hasImage = true
                                    imageUrl = imgURL
                                }
                                let user = SocialUser(id: id, name: name, givenName: fName, familyName: lName, email: email, hasImage: hasImage, imageUrl: imageUrl, socialType: .Facebook)
                                
                                self?.delegate?.facebookSignInFinished(with: user, error: nil)
                                fbLoginManager.logOut()
                            } else {
                                self?.delegate?.facebookSignInFinished(with: nil, error: "Something went wrong!")
                                fbLoginManager.logOut()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getFBData(onCompletion: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void) {
        if (AccessToken.current) != nil {
            GraphRequest (graphPath: "me", parameters: ["fields":" id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {(connection, result, error) -> Void in
                if (error == nil){
                    let faceDic = result as! [String: Any]
                    onCompletion(faceDic, nil)
                } else {
                    onCompletion(nil, error?.localizedDescription)
                }
            })
        } else {
            onCompletion(nil, "Facebook token not found.")
        }
    }
}

struct SocialUser {
    
    var socialId: String
    var fullName: String
    var givenName: String
    var familyName: String
    var email: String
    var hasImage: Bool
    var imageUrl: String
    var socialType: SocialType
    
    init(id: String, name: String, givenName: String, familyName: String, email: String, hasImage: Bool, imageUrl: String, socialType: SocialType) {
        self.socialId = id
        self.fullName = name
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
        self.hasImage = hasImage
        self.imageUrl = imageUrl
        self.socialType = socialType
    }
}
