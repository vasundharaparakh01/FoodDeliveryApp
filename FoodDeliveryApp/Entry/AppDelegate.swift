//
//  AppDelegate.swift
//  appName
//
//  Created by Varun Kumar Raghav on 17/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isLogin:Bool = false
    var isSeatConfirm:Bool = false
    var deviceToken = ""
    var HomeTabBarVC = HomeTabViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .default
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //IQKeyboardManager.shared.disabledToolbarClasses = [MMAccountTypeVC.self]
        // IQKeyboardManager.shared.disabledDistanceHandlingClasses = [MMAccountTypeVC.self]
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            // Show the app's signed-out state.
              print("the app's signed-out state")
          } else {
            // Show the app's signed-in state.
              print("the app's signed-in state")
          }
        }
        
        Messaging.messaging().delegate = self
        
        MMSocialLoginHelper.shared.initialiseFacebookLogin(application, didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that w........................ere specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
//            if USERDEFAULT.object(forKey: kAccessToken) == nil {
//                return false
//            }
           // MMDeepLinkHelper.shared.manageDeepLinkingUrl(url: url)
            print("DeepLink Url : \(url)")
        }
        return false
    }


}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        DLog(" >>>>>>>  \(fcmToken ?? "")")
        //CleverTap.sharedInstance()?.setPushTokenAs(fcmToken ?? "")
        self.deviceToken = fcmToken ?? ""
        //  self.registerDeviceToken()
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
//        print(" =====willPresent== \(notification.request.content)")
//        print(" =====willPresent== \(notification.request.content.userInfo as! Dictionary<String, Any>)")
//        if let data = notification.request.content.userInfo as? Dictionary<String, Any> {
//            AlertController.alert(title: data.toJsonString(), message: "", options: ["Ok"], controller: self.window?.rootViewController) { (str) -> (Void) in
//
//            }
//        }
       // CleverTap.sharedInstance()?.handleNotification(withData: notification.request.content.userInfo)
        completionHandler( [.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(" =====didReceive== \(response.notification.request.content)")
        print(" =====didReceive== \(response.notification.request.content.userInfo as! Dictionary<String, Any>)")
        
//        if let data = response.notification.request.content.userInfo as? Dictionary<String, Any> {
//            if let deepLinkUrl = data["wzrk_dl"] as? String, deepLinkUrl.count > 0{
//                if USERDEFAULT.object(forKey: kAccessToken) == nil {
//                    return
//                }
//                self.perform(#selector(manageDeeplinkUrlWithPushNotification), with: deepLinkUrl, afterDelay: 2.0)
//            }else{
//                var notificationDic = Dictionary<String, Any>()
//                if let type = data["type"] as? String{
//                    print("Notification Type : \(type)")
//                    notificationDic["type"] = type
//                    if type == "lead" || type == "reminder"{
//                        if let companyId = data["additional_data"] as? String{
//                            notificationDic["companyId"] = companyId
//                        }
//                    }
//                }
//                if let typeId = data["type_id"] as? String{
//                    print("Notification Type Id : \(typeId)")
//                    notificationDic["typeId"] = typeId
//                }
//                if let name = data["category_name"] as? String{
//                    notificationDic["category_name"] = name
//                }
//                if let name = data["brand_category_id"] as? String{
//                    notificationDic["brand_category_id"] = name
//                }
//                if let name = data["image_url"] as? String{
//                    notificationDic["image"] = name
//                }
//                if let name = data["isChild_category"] as? Int16{
//                    notificationDic["child"] = name
//                }
////                if response.actionIdentifier == "completeReminder"{
////
////                }else if response.actionIdentifier == "remindLater"{
////
////                }else{
//                    self.perform(#selector(manageNotification), with: notificationDic, afterDelay: 2.0)
////                }
//            }
//        }
        DLog(" ++============  \( response.notification.request.content.userInfo)")
    }
    
}

