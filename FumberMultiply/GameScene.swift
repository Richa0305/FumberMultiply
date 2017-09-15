//
//  GameScene.swift
//  fumber
//
//  Created by Srivastava, Richa on 04/07/17.
//  Copyright © 2017 ShivHari Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let clickSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
    var helpViewHidden = true
    var helpShapeNode = SKShapeNode()
    var maskSceneNode = SKShapeNode()
    var rulesFontSize = 12
    override func didMove(to view: SKView) {
        
        self.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        if UIDevice.current.model == "iPad" {
            rulesFontSize = 14
        }
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        background.name = "backgraound"
        background.fillColor = SKColor(hex: 0xB8860B)
        self.addChild(background)
        
        let gameNameLabel: SKLabelNode = SKLabelNode(text: "fumber")
        gameNameLabel.fontColor = SKColor.white
        gameNameLabel.fontSize = 60
        gameNameLabel.name = "GameName"
        gameNameLabel.position = CGPoint(x: self.frame.midX , y: self.frame.midY + 180)
        gameNameLabel.fontName = "Futura-CondensedExtraBold"
        gameNameLabel.horizontalAlignmentMode = .center
        gameNameLabel.verticalAlignmentMode = .center
        gameNameLabel.physicsBody?.affectedByGravity = true
        self.addChild(gameNameLabel)
        gameNameLabel.setScale(0)
        let scaleActionlbl1 = SKAction.scale(to: 1, duration: 1)
        let scaleActionlbl2 = SKAction.scale(to: 0.9, duration: 0.4)
        let scaleActionlbl3 = SKAction.scale(to: 1, duration: 0.4)
        let sequence = SKAction.sequence([scaleActionlbl1,scaleActionlbl2,scaleActionlbl3])
        gameNameLabel.run(sequence)
        
        let gameRule1: SKLabelNode = SKLabelNode(text: "Multiply")
        gameRule1.fontColor = SKColor.white
        gameRule1.fontSize = 30
        gameRule1.name = "addison"
        gameRule1.position = CGPoint(x: self.frame.midX , y: self.frame.midY + 120)
        gameRule1.fontName = "Futura-CondensedExtraBold"
        gameRule1.horizontalAlignmentMode = .center
        gameRule1.verticalAlignmentMode = .center
        self.addChild(gameRule1)
        
        
        let gameRule4: SKLabelNode = SKLabelNode(text: "Calculate the target number in the circle")
        gameRule4.fontColor = SKColor.white
        gameRule4.fontSize = CGFloat(rulesFontSize)
        gameRule4.name = "rule4"
        gameRule4.position = CGPoint(x: self.frame.midX , y: self.frame.midY + 90)
        gameRule4.fontName = "Avenir-Black"
        gameRule4.horizontalAlignmentMode = .center
        gameRule4.verticalAlignmentMode = .center
        self.addChild(gameRule4)
        
        let gameRule5: SKLabelNode = SKLabelNode(text: "before circle disappears!")
        gameRule5.fontColor = SKColor.white
        gameRule5.fontSize = CGFloat(rulesFontSize)
        gameRule5.name = "rule5"
        gameRule5.position = CGPoint(x: self.frame.midX , y: self.frame.midY + 70)
        gameRule5.fontName = "Avenir-Black"
        gameRule5.horizontalAlignmentMode = .center
        gameRule5.verticalAlignmentMode = .center
        self.addChild(gameRule5)
        
        
        
        let play = SKSpriteNode(imageNamed: "play2")
        play.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        play.zPosition = 2
        play.name = "playGame"
        self.addChild(play)
        let scaleAction1 = SKAction.scale(to: 1.1, duration: 1)
        let scaleAction2 = SKAction.scale(to: 1.0, duration: 1)
        let seq = SKAction.sequence([scaleAction1,scaleAction2])
        play.run(SKAction.repeatForever(seq))
        
        let achimentsShapeNode = SKShapeNode(rect: CGRect(x: Int(self.frame.midX - (play.size.width + 50)), y:Int(self.frame.midY - 25), width: 40, height: 40), cornerRadius: 10)
        achimentsShapeNode.fillColor = SKColor.white
        achimentsShapeNode.name = "AchievementsNodeShape"
        let achievementsNode = SKSpriteNode(imageNamed: "achieve")
        achievementsNode.position =  CGPoint(x: achimentsShapeNode.frame.midX, y: achimentsShapeNode.frame.midY)
        achievementsNode.name = "Achievements"
        achimentsShapeNode.addChild(achievementsNode)
        self.addChild(achimentsShapeNode)
        
        let helpShapeNode = SKShapeNode(rect: CGRect(x:  Int(self.frame.midX + (play.size.width + 10)), y:Int(self.frame.midY - 25), width: 40, height: 40), cornerRadius: 10)
        helpShapeNode.fillColor = SKColor.white
        helpShapeNode.name = "HelpShape"
        let helpNode = SKSpriteNode(imageNamed: "help")
        helpNode.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY)
        helpNode.name = "Help"
        helpShapeNode.addChild(helpNode)
        self.addChild(helpShapeNode)
        
        let moneyShapeNode = SKShapeNode(rect: CGRect(x: self.frame.midX - 20, y: self.frame.midY - 130, width: 40, height: 40), cornerRadius: 10)
        moneyShapeNode.fillColor = SKColor.white
        moneyShapeNode.name = "MoneyShape"
        let moneyNode = SKSpriteNode(imageNamed: "money")
        moneyNode.position =  CGPoint(x: moneyShapeNode.frame.midX, y: moneyShapeNode.frame.midY)
        moneyNode.name = "Money"
        moneyShapeNode.addChild(moneyNode)
        self.addChild(moneyShapeNode)
        
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        
        if highScore < 30 {
            level = 1
        }
        if highScore >= 30 {
            level = 2
        }
        if highScore >= 60 {
            level = 3
        }
        if highScore >= 100 {
            level = 4
        }
        if highScore >= 150 {
            level = 5
        }
        if highScore >= 300 {
            level = 6
        }
        if highScore >= 500 {
            level = 7
        }
        if highScore >= 700 {
            level = 8
        }
        if highScore >= 1000 {
            level = 9
        }
        
        UserDefaults.standard.set(level, forKey: "Level")

        
    }
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
     
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            print(touchPoint)
            let tappedNode = nodes(at: touchPoint)
            print(tappedNode.count)
            var tappedNodeName = ""
            if tappedNode.count > 0 {
                tappedNodeName = tappedNode[0].name!
            }
            if tappedNodeName == "playGame" {
                let scene =  MainGameScene(fileNamed: "MainGameScene")
                let skView = self.view
                skView?.presentScene(scene)
            }else if tappedNodeName == "HelpShape" ||  tappedNodeName == "Help"{
                helpView()
            }else if tappedNodeName == "Mask" {
                helpShapeNode.removeFromParent()
                maskSceneNode.removeFromParent()
            }else if tappedNodeName == "Play" || tappedNodeName == "PlayShape"{
                let scene =  MainGameScene(fileNamed: "MainGameScene")
                let skView = self.view
                skView?.presentScene(scene)
            }else if tappedNodeName == "Achievements" || tappedNodeName == "AchievementsNodeShape"{
                let scene =  ChallengesScene(size:self.size)
                let skView = self.view
                skView?.presentScene(scene)
            }else if tappedNodeName == "MoneyShape" || tappedNodeName == "Money"{
                
                let v = GameViewController()
                v.showAd(adType: "AddMoney")
            }
        }
    }

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func helpView(){
        maskSceneNode = SKShapeNode(rect: CGRect(x: 0, y:0, width: Int(self.frame.size.width), height: Int(self.frame.size.height)), cornerRadius: 10)
        maskSceneNode.fillColor = SKColor.black
        maskSceneNode.alpha = 0.4
        maskSceneNode.zPosition = 50
        maskSceneNode.name = "Mask"
        self.addChild(maskSceneNode)
        
        helpViewHidden = false
        helpShapeNode = SKShapeNode(rect: CGRect(x: Int(self.frame.midX - (self.frame.size.width/2 - 50)), y: Int(self.frame.midY - 150), width: Int(self.frame.size.width - 100), height: 300), cornerRadius: 10)
        helpShapeNode.fillColor = SKColor(hex: 0xB8860B)
        helpShapeNode.zPosition = 100
        helpShapeNode.name = "Rule"
        
        
        let helpLabelNode = SKLabelNode(fontNamed:"Avenir-Black")
        helpLabelNode.text = "Rules of the Game "
        helpLabelNode.fontSize = 20
        helpLabelNode.fontColor = SKColor.white
        helpLabelNode.name = "RuleName"
        helpLabelNode.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY + 100)
        helpShapeNode.addChild(helpLabelNode)
        
        
        let ruleLabelNode1 = SKLabelNode(fontNamed:"Avenir-Black")
        ruleLabelNode1.text = "1. Select blocks in sequence "
        ruleLabelNode1.fontSize = CGFloat(rulesFontSize)
        ruleLabelNode1.fontColor = SKColor.white
        ruleLabelNode1.name = "RuleName"
        ruleLabelNode1.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY + 70)
        helpShapeNode.addChild(ruleLabelNode1)
        
        let ruleLabelNode2 = SKLabelNode(fontNamed:"Avenir-Black")
        ruleLabelNode2.text = "2. Only parallel blocks "
        ruleLabelNode2.fontSize = CGFloat(rulesFontSize)
        ruleLabelNode2.fontColor = SKColor.white
        ruleLabelNode2.name = "RuleName"
        ruleLabelNode2.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY + 50)
        helpShapeNode.addChild(ruleLabelNode2)
        
        let ruleLabelNode3 = SKLabelNode(fontNamed:"Avenir-Black")
        ruleLabelNode3.text = "can be selected"
        ruleLabelNode3.fontSize = CGFloat(rulesFontSize)
        ruleLabelNode3.fontColor = SKColor.white
        ruleLabelNode3.name = "RuleName"
        ruleLabelNode3.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY + 35)
        helpShapeNode.addChild(ruleLabelNode3)
        
        let ruleLabelNode4 = SKLabelNode(fontNamed:"Avenir-Black")
        ruleLabelNode4.text = "3. Same block can not be Revisited"
        ruleLabelNode4.fontSize = CGFloat(rulesFontSize)
        ruleLabelNode4.fontColor = SKColor.white
        ruleLabelNode4.name = "RuleName"
        ruleLabelNode4.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY + 15)
        helpShapeNode.addChild(ruleLabelNode4)
        
        let ruleLabelNode5 = SKLabelNode(fontNamed:"Avenir-Black")
        ruleLabelNode5.text = "4. Calculate the target number in "
        ruleLabelNode5.fontSize = CGFloat(rulesFontSize)
        ruleLabelNode5.fontColor = SKColor.white
        ruleLabelNode5.name = "RuleName"
        ruleLabelNode5.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY - 5)
        helpShapeNode.addChild(ruleLabelNode5)
        
        let ruleLabelNode6 = SKLabelNode(fontNamed:"Avenir-Black")
        ruleLabelNode6.text = "circle before the circle disappear "
        ruleLabelNode6.fontSize = CGFloat(rulesFontSize)
        ruleLabelNode6.fontColor = SKColor.white
        ruleLabelNode6.name = "RuleName"
        ruleLabelNode6.position =  CGPoint(x: helpShapeNode.frame.midX, y: helpShapeNode.frame.midY - 20)
        helpShapeNode.addChild(ruleLabelNode6)

        
        let playShapeNode = SKShapeNode(rect: CGRect(x: helpShapeNode.frame.midX - 50, y: helpShapeNode.frame.midY - 100, width: 100, height: 30), cornerRadius: 10)
        playShapeNode.fillColor = SKColor.white
        playShapeNode.zPosition = 50
        playShapeNode.name = "PlayShape"
        
        let playLabelNode = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        playLabelNode.text = "Play!"
        playLabelNode.fontSize = 20
        playLabelNode.fontColor = SKColor.blue
        playLabelNode.name = "Play"
        playLabelNode.horizontalAlignmentMode = .center
        playLabelNode.verticalAlignmentMode = .center
        playLabelNode.position =  CGPoint(x: playShapeNode.frame.midX, y: playShapeNode.frame.midY)
        playShapeNode.addChild(playLabelNode)
        helpShapeNode.addChild(playShapeNode)
        self.addChild(helpShapeNode)
        
        let move = SKAction.move(to: CGPoint(x: 0, y: self.frame.maxY), duration: 0)
        let moveback = SKAction.move(to: CGPoint(x: 0, y: self.frame.minY), duration: 1)
        let scaleActionlbl1 = SKAction.move(to: CGPoint(x: 0, y:  10), duration: 0.3)
        let scaleActionlbl2 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
        let sequence = SKAction.sequence([move,moveback,scaleActionlbl1,scaleActionlbl2])
        helpShapeNode.run(sequence)
        
        
    }
    
}
