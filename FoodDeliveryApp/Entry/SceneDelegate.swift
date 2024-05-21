//
//  SceneDelegate.swift
//  appName
//
//  Created by Varun Kumar Raghav on 17/05/22.
//

import UIKit
import FAPanels
import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    var FAPanelVC: FAPanelController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        SocketHelper.shared.connect()
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
//        let authDict = NSUSERDEFAULTMANAGER.userData[Constants.UserDefaultsKey.tokens] as? [String: Any]
//        if((authDict?.count ?? 0) > 0) {
//            RedirectionHelper.redirectToHome()
//        } else {
//        let initialVC = SplashVideoVC()
//        setUpRootController(controller: initialVC)
//        }
//        let isSplashShown: Bool = UserDefaults.standard.value(forKey: kSplashShown) as? Bool ?? false
//        let isFaceIdUnlockEnable: Bool = UserDefaults.standard.value(forKey: kFaceIDUnlock) as? Bool ?? false
//        if isSplashShown {
//            if isFaceIdUnlockEnable {
//                let initialVC = BiometricViewController()
//                initialVC.onSucess = {
//                    if SCoreDataHelper.shared.currentUser() == nil{
//                        SCoreDataHelper.shared.createAppUser(params: nil)
//                    }
//                    self.setSideMenu()
//                }
//                setUpRootController(controller: initialVC)
//            } else {
//                if SCoreDataHelper.shared.currentUser() == nil{
//                    SCoreDataHelper.shared.createAppUser(params: nil)
//                }
//                self.setSideMenu()
//            }
//        } else {
            let initialVC = SplashVideoVC()
            setUpRootController(controller: initialVC)
//            UserDefaults.standard.setValue(true, forKey: kSplashShown)
//        }
    }
    
    func setUpRootController(controller: UIViewController){
        
        self.navController = UINavigationController(rootViewController: controller)
        self.navController?.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = self.navController
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        self.window!.makeKeyAndVisible()
    }
    
    func setHomeViewAfterLogin() {
        SDataHelper().callWebApiToGetFaceIdLockStatus { status, faceIdStatus in
            UserDefaults.standard.set(faceIdStatus ?? false, forKey: kFaceIDUnlock)
        }
        self.setSideMenu()
    }
    
    func setSideMenu() {
        
        let window = UIWindow(windowScene: WINDOWSCENE!)
        self.window = window
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
       // let contentVC = HomeTabViewController()
        let appUser = SCoreDataHelper.shared.currentUser()
        let menuVC = ((appUser?.isCurrentlyLogin ?? false) ? SideMenuVC() : SideMenuWithOutLoginVC())
        self.navController = UINavigationController(rootViewController: appDelegate!.HomeTabBarVC)
        self.navController?.isNavigationBarHidden = true
        self.FAPanelVC = FAPanelController()
        self.FAPanelVC?.configs.resizeLeftPanel = true
        self.FAPanelVC?.configs.leftPanelWidth = screenWidth - 50
        self.FAPanelVC!.center(self.navController!).left(menuVC)
        self.window?.rootViewController = self.FAPanelVC
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

