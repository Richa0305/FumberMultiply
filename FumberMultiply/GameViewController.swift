//
//  GameViewController.swift
//  FumberPlus
//
//  Created by Srivastava, Richa on 19/07/17.
//  Copyright © 2017 ShivHari Apps. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

var chartBoostAdType = ""
var tappedNodeNameForPlayAgain = ""
class GameViewController: UIViewController ,GADBannerViewDelegate,GADInterstitialDelegate,ChartboostDelegate {
    
    var bannerView : GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
           
            let scene =  GameScene(fileNamed: "GameScene")
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        Chartboost.setDelegate(self)
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame  = CGRect(x: 0, y: view.bounds.height - bannerView.frame.height, width: bannerView.frame.size.width, height: bannerView.frame.size.height)
        bannerView.delegate = self
        bannerView.rootViewController = self
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = "ca-app-pub-1382562788361552/3685795856"
        bannerView.load(request)
        self.view?.addSubview(bannerView)

        
    }
    func showAd(adType:String) {
        chartBoostAdType = adType
        
        if Chartboost.hasInterstitial(CBLocationMainMenu) {
            print("Has interstitial")
            Chartboost.showInterstitial(CBLocationMainMenu)
        } else {
            Chartboost.cacheInterstitial(CBLocationMainMenu)
            print("Ad wasn't ready")
        }
    }
    
    func showAdForPlayAgain(adType:String,tappedNodeName:String) {
        chartBoostAdType = adType
        tappedNodeNameForPlayAgain = tappedNodeName
        if Chartboost.hasInterstitial(CBLocationMainMenu) {
            print("Has interstitial")
            Chartboost.showInterstitial(CBLocationMainMenu)
        } else {
            Chartboost.cacheInterstitial(CBLocationMainMenu)
            print("Ad wasn't ready")
            let startGame:[String: Bool] = ["StartGame": true]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showChartBoostAd"), object: nil, userInfo: startGame)
        }
    }
    
    
    func didCloseInterstitial(_ location: String!) {
        print("chartboost closed \(chartBoostAdType) \(chartBoostAdType == "AddMoney")")
        if chartBoostAdType == "AddMoney" {
            let highScore = UserDefaults.standard.integer(forKey: "HighScore")
            score = highScore + 1
            UserDefaults.standard.set(score, forKey: "HighScore")
            PlaySound.playSound(fileName: "success", extn: "wav")
        }else if chartBoostAdType == "Play"{
            let startGame:[String: Bool] = ["StartGame": true]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showChartBoostAd"), object: nil, userInfo: startGame)
        }
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
