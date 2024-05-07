//
//  SplashVideoVC.swift
//  FanServe
//
//  Created by Varun Kumar Raghav on 17/05/22.
//

import UIKit
import AVKit
import AVFoundation

class SplashVideoVC: UIViewController {
    
//    private let floatingAddButton: UIButton = {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
//      //  let button = UIButton()
//        button.layer.masksToBounds = true
//        button.setImage(UIImage(named: "playBtn"), for: .normal)
//        return button
//    }()
    
//    private let floatingTitleLbl: UILabel = {
//        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 85, height: 35))
//        titleLbl.layer.masksToBounds = true
//        titleLbl.text = "FANSERVE"
//        return titleLbl
//    }()
    
    let playerController = AVPlayerViewController()
    var isVideoRunning : Bool = false
    
    //MARK: - lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        floatingAddButton.frame = CGRect(x: ScreenWidth/2-55, y: ScreenHeight/2-55, width: 110, height: 110)
//        floatingAddButton.addTarget(self, action: #selector(PlayBtnAction), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isVideoRunning == false
        {
            playVideo()
        }
    }

    //MARK: - setup Title
    private func setupTitle() {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 187, height: 62.84)
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.font = UIFont(name: "Poppins-Medium", size: 36)

        // Line height: 54 pt

        view.textAlignment = .center
        view.text = "FAN SERVE"

        let parent = self.playerController.view!//self.view!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 187).isActive = true
        view.heightAnchor.constraint(equalToConstant: 62.84).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: ScreenWidth/2 - 93.5).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 114.1).isActive = true
        view.rotateAtPoint()
    }

    
    //MARK: - setup Video Methods

    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "splashVideo", ofType: ".mp4") else {
            debugPrint("Splash video not found!!")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        playerController.showsPlaybackControls = false
        playerController.player = player
        playerController.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerController.player?.currentItem)
        present(playerController, animated: true){
            player.play()
        }
    }
    
    @objc func playerDidFinishPlaying () {
        print("Finished Playing")
        isVideoRunning = true
        let isSplashShown: Bool = UserDefaults.standard.value(forKey: kSplashShown) as? Bool ?? false
        let isFaceIdUnlockEnable: Bool = UserDefaults.standard.value(forKey: kFaceIDUnlock) as? Bool ?? false
        if isSplashShown {
            if isFaceIdUnlockEnable {
                let initialVC = BiometricViewController()
                initialVC.onSucess = {
                    if SCoreDataHelper.shared.currentUser() == nil{
                        SCoreDataHelper.shared.createAppUser(params: nil)
                    }
                    sceneDelegate?.setSideMenu()
                }
                sceneDelegate?.setUpRootController(controller: initialVC)
            } else {
                if SCoreDataHelper.shared.currentUser() == nil{
                    SCoreDataHelper.shared.createAppUser(params: nil)
                }
                sceneDelegate?.setSideMenu()
            }
        } else {
            sceneDelegate?.setUpRootController(controller: OnBoardingVC())
        }
        
    //    self.setupTitle()
        

       // self.playerController.view.addSubview(floatingAddButton)
    }
    
//    @objc func PlayBtnAction () {
//        sceneDelegate?.setUpRootController(controller: OnBoardingVC())
//    }
}
