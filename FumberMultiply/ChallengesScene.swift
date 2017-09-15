//
//  ChallengesScene.swift
//  fumber
//
//  Created by Srivastava, Richa on 14/07/17.
//  Copyright © 2017 ShivHari Apps. All rights reserved.
//

import UIKit
import SpriteKit

class ChallengesScene: SKScene {
    var challangesTableView = ChallangesTableView()
    private var label : SKLabelNode?
    override func didMove(to view: SKView) {
        
        self.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        background.name = "backgraound"
        background.fillColor = SKColor(hex: 0xB8860B)
        self.addChild(background)
        
        let backShapeNode = SKShapeNode(rect: CGRect(x: 5, y:Int(self.size.height - 50), width: 40, height: 40), cornerRadius: 10)
        backShapeNode.fillColor = SKColor.white
        backShapeNode.name = "BackShape"
        let backNode = SKSpriteNode(imageNamed: "back")
        backNode.position =  CGPoint(x: backShapeNode.frame.midX, y: backShapeNode.frame.midY)
        backNode.name = "Back"
        backShapeNode.addChild(backNode)
        self.addChild(backShapeNode)
        
        // Table setup
        challangesTableView.frame=CGRect(x:20,y:50,width:self.size.width - 40 ,height:self.size.height - 60)
        challangesTableView.backgroundColor = UIColor.clear
        challangesTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.scene?.view?.addSubview(challangesTableView)
        challangesTableView.reloadData()
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            //print(touchPoint)
            let tappedNode = nodes(at: touchPoint)
            //print(tappedNode.count)
            var tappedNodeName = ""
            if tappedNode.count > 0 {
                tappedNodeName = tappedNode[0].name!
            }
            if tappedNodeName == "BackShape" || tappedNodeName == "Back"{
                let v = GameViewController()
                v.showAd(adType: "Back")
                let scene =  GameScene(fileNamed: "GameScene")
                let skView = self.view
                challangesTableView.removeFromSuperview()
                skView?.presentScene(scene)
            }
        }
    }

}
