//
//  MainGameScene.swift
//  fumber
//
//  Created by Srivastava, Richa on 05/07/17.
//  Copyright © 2017 ShivHari Apps. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
var score = 0
var level = 1

class MainGameScene: SKScene,GADBannerViewDelegate {
    let clickSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
    let levelCompleteSound = SKAction.playSoundFileNamed("winning.wav", waitForCompletion: false)
    var validBlocksToSelect = [String]()
    var selectedBlock = Set<String>()
    let successSound = SKAction.playSoundFileNamed("success.wav", waitForCompletion: false)
    var nodeIntSize = 0
    var targetCombinations = [[00,01,02],[01,02,03],[10,11,12],[11,12,13],[20,21,22],[21,22,23],[30,31,32],[31,32,33],[00,10,20],[10,20,30],[01,11,21],[11,21,31],[02,12,22],[12,22,32],[03,13,23],[13,23,33],[00,10,11],[00,01,11],[01,00,10],[01,02,12],[02,01,11],[02,03,13],[03,13,12],[10,11,21],[10,20,21],[11,10,20],[11,12,22],[12,11,21],[12,13,23],[13,12,22],[13,23,22],[20,21,31],[20,30,31],[21,20,30],[21,22,32],[22,21,31],[22,23,33],[23,22,32],[23,33,32],[30,20,21],[30,31,21],[31,30,20],[31,32,22],[32,31,21],[32,33,23],[33,23,22],[33,32,22]]
    
    
    var colorcodes = [0x8B0000,0xFFD700,0x008000]
    //[red,yellow,green]
    
    var gameGridskNode = [SKNode]()
    var gameGridNumbers = [Int]()
    var calculatedTarget = 0
    var lastSelectedNode = ""
    var currentlySelectedBlock = ""
    
    var targetNumber = 0
    var targetLabelNode = SKLabelNode(fontNamed:"Avenir-Black")
    var scoreLabelNode = SKLabelNode(fontNamed:"Avenir-Black")
    var currentLabelNode = SKLabelNode(fontNamed:"Avenir-Black")
    var calculatedTargetNode = SKLabelNode(fontNamed:"Avenir-Black")
    var circle = SKShapeNode()
    
    override func didMove(to view: SKView) {
        
        self.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        background.name = "mainScene"
        background.fillColor = SKColor(hex: 0xB8860B)
        self.addChild(background)
        
        mainGameGrid()
        addCircle()
        score = UserDefaults.standard.integer(forKey: "HighScore")
        var scoreShapeHeight = 0
        if UIDevice.current.model == "iPad" {
            scoreShapeHeight = Int(self.size.height - 195)
            scoreShapeHeight = nodeIntSize*4 + 145 + 42
        }
        else{
            scoreShapeHeight = nodeIntSize*4 + 70 + 42
        }
        let scoreShapeNode = SKShapeNode(rect: CGRect(x: 0, y: scoreShapeHeight, width: (Int(self.size.width/2) + 40), height: 40), cornerRadius: 0)
        scoreShapeNode.fillColor = SKColor(hex: 0x671edd)
        scoreShapeNode.strokeColor = SKColor(hex: 0x671edd)
        scoreShapeNode.name = "Score"
        scoreLabelNode.text = "Score  :  \(score)"
        scoreLabelNode.fontSize = 20
        scoreLabelNode.fontColor = SKColor.white
        scoreLabelNode.name = "ScoreName"
        scoreLabelNode.position =  CGPoint(x: scoreShapeNode.frame.midX, y: scoreShapeNode.frame.midY)
        scoreLabelNode.horizontalAlignmentMode = .center
        scoreLabelNode.verticalAlignmentMode = .center
        scoreShapeNode.addChild(scoreLabelNode)
        self.addChild(scoreShapeNode)
        
        let backShapeNode = SKShapeNode(rect: CGRect(x: 5, y:Int(self.size.height - 50), width: 40, height: 40), cornerRadius: 10)
        backShapeNode.fillColor = SKColor.white
        backShapeNode.name = "BackShape"
        let backNode = SKSpriteNode(imageNamed: "back")
        backNode.position =  CGPoint(x: backShapeNode.frame.midX, y: backShapeNode.frame.midY)
        backNode.name = "Back"
        backShapeNode.addChild(backNode)
        self.addChild(backShapeNode)
        
        let refresShapeNode = SKShapeNode(rect: CGRect(x: Int(self.size.width - 45), y:Int(self.size.height - 45), width: 40, height: 40), cornerRadius: 10)
        refresShapeNode.fillColor = SKColor.white
        refresShapeNode.name = "RefreshShape"
        let refreshNode = SKSpriteNode(imageNamed: "refresh1")
        refreshNode.position =  CGPoint(x: refresShapeNode.frame.midX, y: refresShapeNode.frame.midY)
        refreshNode.name = "Refresh"
        refresShapeNode.addChild(refreshNode)
        self.addChild(refresShapeNode)
        var currentHeight = 0
        if UIDevice.current.model == "iPad" {
            currentHeight = nodeIntSize*4 + 145
            print(Int(self.size.height - 242))
            print(nodeIntSize*4 + 140)
        }
        else{
            currentHeight = nodeIntSize*4 + 70
            print(Int(self.size.height - 242))
            print(nodeIntSize*4 + 70)
        }
        
        let current = SKShapeNode(rect: CGRect(x: Int(self.size.width - ((self.size.width/2) + 50)), y: currentHeight, width: Int(self.size.width/2) + 50, height: 40), cornerRadius: 0)
        current.fillColor = SKColor(hex: 0x127eea)
        current.strokeColor = SKColor(hex: 0x127eea)
        current.name = "Current"
        currentLabelNode.text = "Current  :  \(calculatedTarget)"
        currentLabelNode.fontSize = 20
        currentLabelNode.fontColor = SKColor.white
        currentLabelNode.name = "CurrentName"
        currentLabelNode.position =  CGPoint(x: current.frame.midX, y: current.frame.midY)
        currentLabelNode.horizontalAlignmentMode = .center
        currentLabelNode.verticalAlignmentMode = .center
        
        current.addChild(currentLabelNode)
        self.addChild(current)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showChartBoostAd(_:)), name: NSNotification.Name(rawValue: "showChartBoostAd"), object: nil)
        
    }
    func getTargetNumber() {
        let targetCombCount = targetCombinations.count - 1
        let randomNumberForTarget = arc4random_uniform(UInt32(targetCombCount))
        targetNumber = Int(randomNumberForTarget)
        let targets = targetCombinations[targetNumber]
        print("Targets \(targets)")
        var targetNum = 1
        for val in targets{
            if val <= 9 {
                if let block: SKShapeNode = self.childNode(withName: "0\(val)") as? SKShapeNode{
                    targetNum = targetNum * Int(block.children[0].children[0].name!)!
                    
                }
            }else{
                if let block: SKShapeNode = self.childNode(withName: "\(val)") as? SKShapeNode{
                         targetNum = targetNum * Int(block.children[0].children[0].name!)!
                }
                
            }
        }
        targetNumber = targetNum
        print(gameGridNumbers)
        print(targetNumber)
        if gameGridNumbers.contains(targetNumber) {
            getTargetNumber()
        }else if targetNumber == 0{
            getTargetNumber()
        }
    }
    
    func addCircle(){
        getTargetNumber()
        let highscore = UserDefaults.standard.integer(forKey: "HighScore")
        
        
        circle = SKShapeNode(circleOfRadius: 50)
        circle.position = CGPoint(x: self.frame.midX, y: (self.size.height - 60))
        circle.fillColor = SKColor.clear
        circle.name = "Timer"
        circle.strokeColor = SKColor.white
        circle.lineWidth = 2
        circle.zRotation = CGFloat.pi / 2
        addChild(circle)
        
        print("target Number \(targetNumber)")
        targetLabelNode.text = "\(targetNumber)"
        targetLabelNode.fontSize = 30
        targetLabelNode.zPosition = 2
        targetLabelNode.fontColor = SKColor.white
        targetLabelNode.name = "TargetName"
        targetLabelNode.position =  CGPoint(x: self.frame.midX, y: (self.size.height - 75))
        self.addChild(targetLabelNode)
        
        
        if highscore <= 60 {
            countdown(circle: circle, steps: 20, duration: 20) {
                self.GameOver()
            }
        
        }else{
            countdown(circle: circle, steps: 30, duration: 30) {
                self.GameOver()
            }
        }

    }
    
    func mainGameGrid(){
        gameGridNumbers.removeAll()
        var nodeSize = self.size.width/4 - 4
        nodeSize = nodeSize.rounded()
        nodeIntSize =  Int(nodeSize)
        if UIDevice.current.model == "iPad" {
            nodeIntSize = nodeIntSize - 30
        }
        
        
        for i in 0 ..< 4 {
            for a in 0 ..< 4 {
                let sprites = SKShapeNode(rectOf: CGSize(width: nodeIntSize-2, height: nodeIntSize-2), cornerRadius: 10.0)
                sprites.fillColor = SKColor(hex: 0xF8F8FF)
                sprites.strokeColor = SKColor(hex: 0xF8F8FF)
                sprites.lineWidth = 1
                sprites.name = "\(i)\(a)"
                if UIDevice.current.model == "iPad" {
                    sprites.position = CGPoint(x:((nodeIntSize * a+1) + Int(nodeSize/2) + 60) , y:((nodeIntSize*i+1) + Int(nodeSize/2) + 120))
                    
                }else{
                    sprites.position = CGPoint(x:((nodeIntSize * a+1) + Int(nodeSize/2) + 8) , y:((nodeIntSize*i+1) + Int(nodeSize/2) + 60))
                }
                sprites.addChild(addNewNumberBlock(superNode: sprites))
                gameGridskNode.append(sprites)
                self.addChild(sprites)
            }
        }
    }
    
    func addNewNumberBlock(superNode:SKShapeNode) -> SKShapeNode{
        let radius = (self.nodeIntSize/2) - 5
        let mainNode = SKShapeNode(circleOfRadius: CGFloat(radius))
        
        let highscore = UserDefaults.standard.integer(forKey: "HighScore")
        
        mainNode.fillColor = SKColor(hex: 0xFFD700)
        mainNode.position = CGPoint(x: 0, y: 0)
        mainNode.zPosition = 1
        mainNode.name = "MainNode"
        
        let myLabel = SKLabelNode(fontNamed:"Arial")
        var randomNumberForlabel = arc4random()%4 + 1
        
        if highscore >= 30 && highscore < 60{
            randomNumberForlabel = arc4random()%8 + 1
        }else if  highscore >= 60  && highscore < 100{
            randomNumberForlabel = arc4random()%12 + 1
        }else if  highscore >= 100  && highscore < 150{
            randomNumberForlabel = arc4random()%15 + 1
        }else if  highscore >= 150  && highscore < 300{
            randomNumberForlabel = arc4random()%18 + 1
        }else if  highscore >= 300 && highscore < 500{
            randomNumberForlabel = arc4random()%21 + 1
        }else if  highscore >= 500 && highscore < 700{
            randomNumberForlabel = arc4random()%25 + 1
        }else if  highscore >= 700 && highscore < 1000{
            randomNumberForlabel = arc4random()%30 + 1
        }else if  highscore >= 1000 {
            randomNumberForlabel = arc4random()%30 + 1
        }
        myLabel.text = String(randomNumberForlabel)
        myLabel.fontSize = 40
        myLabel.name = String(randomNumberForlabel)
        myLabel.horizontalAlignmentMode = .center
        myLabel.verticalAlignmentMode = .center
        let blockNumber = Int(myLabel.text!)!
        myLabel.fontName = "Futura-CondensedExtraBold"
        gameGridNumbers.append(blockNumber)
        mainNode.addChild(myLabel)
        return mainNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentlySelectedBlock = ""
        for touch in touches {
            let touchPoint = touch.location(in: self)
            //print(touchPoint)
            let tappedNode = nodes(at: touchPoint)
            //print(tappedNode.count)
            var tappedNodeName = ""
            if tappedNode.count > 0 {
                tappedNodeName = tappedNode[0].name!
            }
            if tappedNodeName == "Refresh" || tappedNodeName == "RefreshShape"  {
                self.run(clickSound)
                for block in selectedBlock{
                    if let block: SKShapeNode = self.childNode(withName: block) as? SKShapeNode {
                        block.strokeColor = SKColor(hex: 0xDEB887)
                        block.lineWidth = 1
                    }
                }
                calculatedTarget = 0
                currentLabelNode.text = "Current  :  \(calculatedTarget)"
                selectedBlock.removeAll()
                validBlocksToSelect.removeAll()
            }else if(tappedNodeName == "BackShape" || tappedNodeName == "Back"){
                self.run(clickSound)
                let v = GameViewController()
                v.showAd(adType: "Back")
                let scene =  GameScene(fileNamed: "GameScene")
                let skView = self.view
                skView?.presentScene(scene)
                
            }else if(tappedNodeName == "Exit" || tappedNodeName == "ExitLevel"){
                self.run(clickSound)
                selectedBlock.removeAll()
                validBlocksToSelect.removeAll()
                calculatedTarget = 0
                let v = GameViewController()
                v.showAd(adType: "Back")
                let scene =  GameScene(fileNamed: "GameScene")
                let skView = self.view
                skView?.presentScene(scene)
                
            }else if(tappedNodeName == "PlayAgain" ||  tappedNodeName == "PlayNextLevel"){
                PlayAgain(tappedNodeName: tappedNodeName,startGame: false)
            }else if tappedNode.count > 0 {
                tappedNodeName = tappedNode[0].name!
                if tappedNode[0].parent?.name == "MainNode" {
                    currentlySelectedBlock = (tappedNode[0].parent?.parent?.name)!
                }else if tappedNode[0].parent?.name == "mainScene"{
                    currentlySelectedBlock = (tappedNode[0].name)!
                }else if tappedNode[0].name == "MainNode"{
                    currentlySelectedBlock = (tappedNode[0].parent?.name)!
                }
            }
            if currentlySelectedBlock.characters.count == 2 {
                if let block: SKShapeNode = self.childNode(withName: currentlySelectedBlock) as? SKShapeNode {
                    
                    if !selectedBlock.contains(block.name!){
                        if validBlocksToSelect.count > 0 {
                            if validBlocksToSelect.contains(String(describing: Int(block.name!)!)) {
                                let blockColor =  (block.childNode(withName: "MainNode") as! SKShapeNode).fillColor
                                let blockNum = ((block.childNode(withName: "MainNode") as! SKShapeNode).children[0] as! SKLabelNode).text ?? ""
                                block.strokeColor = SKColor.brown
                                block.lineWidth = 3
                                let blockIntVal = Int(block.name!)
                                selectedBlock.insert(block.name!)
                                validBlocksToSelect.removeAll()
                                validBlocksToSelect = [String(blockIntVal! + 1), String(blockIntVal! - 1),String(blockIntVal! + 10), String(blockIntVal! - 10)]
                                calculateTarget(blockText: blockNum, blockColor: blockColor)
                            }
                        }else{
                            let blockColor =  (block.childNode(withName: "MainNode") as! SKShapeNode).fillColor
                            let blockNum = ((block.childNode(withName: "MainNode") as! SKShapeNode).children[0] as! SKLabelNode).text ?? ""
                            block.strokeColor = SKColor.brown
                            block.lineWidth = 3
                            selectedBlock.insert(block.name!)
                            let blockIntVal = Int(block.name!)
                            validBlocksToSelect.removeAll()
                            validBlocksToSelect = [String(blockIntVal! + 1), String(blockIntVal! - 1),String(blockIntVal! + 10), String(blockIntVal! - 10)]
                            calculateTarget(blockText: blockNum, blockColor: blockColor)
                            
                        }
                    }else{
                        
                        for block in selectedBlock{
                            if let block: SKShapeNode = self.childNode(withName: block) as? SKShapeNode {
                                block.strokeColor = SKColor(hex: 0xDEB887)
                                block.lineWidth = 1
                            }
                        }
                        calculatedTarget = 0
                        currentLabelNode.text = "Current  :  \(calculatedTarget)"
                        selectedBlock.removeAll()
                        validBlocksToSelect.removeAll()
                    }
                }
            }
            
            
        }
    }
    
    func showChartBoostAd(_ notification: NSNotification) {
        self.PlayAgain(tappedNodeName: tappedNodeNameForPlayAgain, startGame: (notification.userInfo?["StartGame"] as? Bool)!)
        
    }
    func PlayAgain(tappedNodeName:String,startGame:Bool){
        
        if startGame {
            self.run(clickSound)
            selectedBlock.removeAll()
            validBlocksToSelect.removeAll()
            UserDefaults.standard.set(level, forKey: "Level")
            scoreLabelNode.text = "Score : \(score)"
            calculatedTarget = 0
            currentLabelNode.text = "Current  :  \(calculatedTarget)"
            if tappedNodeName == "PlayAgain" {
                if let mask: SKShapeNode = self.childNode(withName: "GameOverMask") as? SKShapeNode {
                    mask.removeFromParent()
                }
                if let gameOverNode: SKShapeNode = self.childNode(withName: "GameOverShape") as? SKShapeNode {
                    gameOverNode.removeFromParent()
                }
            }else if tappedNodeName == "PlayNextLevel" {
                if let mask: SKShapeNode = self.childNode(withName: "LevelCompletedMask") as? SKShapeNode {
                    mask.removeFromParent()
                }
                if let levelcompletedNode: SKShapeNode = self.childNode(withName: "LevelCompletedShapeNode") as? SKShapeNode {
                    levelcompletedNode.removeFromParent()
                }
            }
            circle.removeFromParent()
            targetLabelNode.removeFromParent()
            self.removeChildren(in: gameGridskNode)
            removeAction(forKey: "actionKey")
            mainGameGrid()
            addCircle()
        }else{
            let v = GameViewController()
            v.showAdForPlayAgain(adType: "Play", tappedNodeName: tappedNodeName)
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastSelectedNode = currentlySelectedBlock
        for touch in touches {
            let touchPoint = touch.location(in: self)
            //print(touchPoint)
            let tappedNode = nodes(at: touchPoint)
            //print(tappedNode.count)
            var tappedNodeName = ""
            if tappedNode.count > 0 {
                tappedNodeName = tappedNode[0].name!
                if tappedNode[0].parent?.name == "MainNode" {
                    currentlySelectedBlock = (tappedNode[0].parent?.parent?.name)!
                }else if tappedNode[0].parent?.name == "mainScene"{
                    currentlySelectedBlock = (tappedNode[0].name)!
                }else if tappedNode[0].name == "MainNode"{
                    currentlySelectedBlock = (tappedNode[0].parent?.name)!
                }
            }
            if tappedNodeName == "Refresh" || tappedNodeName == "RefreshShape"  {
                print("Refresh clicked")
            }
        }
        if currentlySelectedBlock != lastSelectedNode {
            if currentlySelectedBlock.characters.count == 2 {
                if let block: SKShapeNode = self.childNode(withName: currentlySelectedBlock) as? SKShapeNode {
                    
                    if !selectedBlock.contains(block.name!){
                        if validBlocksToSelect.count > 0 {
                            if validBlocksToSelect.contains(String(describing: Int(block.name!)!)) {
                                let blockColor =  (block.childNode(withName: "MainNode") as! SKShapeNode).fillColor
                                let blockNum = ((block.childNode(withName: "MainNode") as! SKShapeNode).children[0] as! SKLabelNode).text ?? ""
                                block.strokeColor = SKColor.brown
                                block.lineWidth = 3
                                let blockIntVal = Int(block.name!)
                                selectedBlock.insert(block.name!)
                                validBlocksToSelect.removeAll()
                                validBlocksToSelect = [String(blockIntVal! + 1), String(blockIntVal! - 1),String(blockIntVal! + 10), String(blockIntVal! - 10)]
                                calculateTarget(blockText: blockNum, blockColor: blockColor)
                            }
                        }else{
                            let blockColor =  (block.childNode(withName: "MainNode") as! SKShapeNode).fillColor
                            let blockNum = ((block.childNode(withName: "MainNode") as! SKShapeNode).children[0] as! SKLabelNode).text ?? ""
                            block.strokeColor = SKColor.brown
                            block.lineWidth = 3
                            selectedBlock.insert(block.name!)
                            let blockIntVal = Int(block.name!)
                            validBlocksToSelect.removeAll()
                            validBlocksToSelect = [String(blockIntVal! + 1), String(blockIntVal! - 1),String(blockIntVal! + 10), String(blockIntVal! - 10)]
                            calculateTarget(blockText: blockNum, blockColor: blockColor)
                            
                        }
                    }else{
                        
                        for block in selectedBlock{
                            if let block: SKShapeNode = self.childNode(withName: block) as? SKShapeNode {
                                block.strokeColor = SKColor(hex: 0xDEB887)
                                block.lineWidth = 1
                            }
                        }
                        calculatedTarget = 0
                        currentLabelNode.text = "Current  :  \(calculatedTarget)"
                        selectedBlock.removeAll()
                        validBlocksToSelect.removeAll()
                    }
                }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if calculatedTarget == targetNumber {
            self.run(successSound)
            score = score + 1
            scoreLabelNode.text = "Score : \(score)"
            
            var highScore = UserDefaults.standard.integer(forKey: "HighScore")
            
            if score > highScore{
                UserDefaults.standard.set(score, forKey: "HighScore")
            }
            highScore = UserDefaults.standard.integer(forKey: "HighScore")
            
            var level = UserDefaults.standard.integer(forKey: "Level")
            
            //  for selectedblock in selectedBlock {
            //                if let block: SKShapeNode = self.childNode(withName: selectedblock) as? SKShapeNode {
            //
            //                    block.strokeColor = SKColor(hex: 0xDEB887)
            //                    block.lineWidth = 1
            //                }
            //            }
            currentLabelNode.text = "Current  :  \(calculatedTarget) ✔️"
            self.removeAction(forKey: "actionKey")
            selectedBlock.removeAll()
            self.circle.removeFromParent()
            self.validBlocksToSelect.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                if highScore == 30 {
                    self.levelCompleted()
                    level = 2
                }else if highScore == 60 {
                    self.levelCompleted()
                    level = 3
                }else if highScore == 100 {
                    self.levelCompleted()
                    level = 4
                }else if highScore == 150 {
                    self.levelCompleted()
                    level = 5
                }else if highScore == 300 {
                    self.levelCompleted()
                    level = 6
                }else if highScore == 500 {
                    self.levelCompleted()
                    level = 7
                }else if highScore == 700 {
                    self.levelCompleted()
                    level = 8
                }else if highScore == 1000 {
                    self.levelCompleted()
                    level = 9
                }
                else{
                    self.targetLabelNode.removeFromParent()
                    self.removeChildren(in: self.gameGridskNode)
                    self.calculatedTarget = 0
                    self.currentLabelNode.text = "Current  :  \(self.calculatedTarget)"
                    self.mainGameGrid()
                    self.addCircle()
                }
            })
            UserDefaults.standard.set(level, forKey: "Level")
            
        }
    }
    
    func calculateTarget(blockText:String,blockColor:UIColor){
        
        var colorString = ""
        let blockNumber = Int(blockText)
        if blockColor.description == UIColor(hex: colorcodes[0]).description {
            colorString = "RED"
        }else if blockColor.description == UIColor(hex: colorcodes[1]).description {
            colorString = "YELLOW"
        }else if blockColor.description == UIColor(hex: colorcodes[2]).description {
            colorString = "GREEN"
        }
        
        // Green - Plus   Red - Substruct   Yellow - Multiply
        
        if colorString == "RED" {
            calculatedTarget = calculatedTarget - blockNumber!
        }else if colorString == "YELLOW" {
            if calculatedTarget == 0 {
                calculatedTarget = blockNumber!
            }else{
                calculatedTarget = calculatedTarget * blockNumber!
            }
        }else if colorString == "GREEN" {
            calculatedTarget = calculatedTarget + blockNumber!
        }
        print("calculated target \(calculatedTarget)")
        currentLabelNode.text = "Current  :  \(calculatedTarget)"
        
        if calculatedTarget >= 1000000 {
            for block in selectedBlock{
                if let block: SKShapeNode = self.childNode(withName: block) as? SKShapeNode {
                    block.strokeColor = SKColor(hex: 0xDEB887)
                    block.lineWidth = 1
                }
            }
            calculatedTarget = 0
            currentLabelNode.text = "Current  :  \(calculatedTarget)"
            selectedBlock.removeAll()
            validBlocksToSelect.removeAll()
        }
        
    }
    // Creates an animated countdown timer
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, completion:@escaping ()->Void) {
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width/2
        let timeInterval = duration/TimeInterval(steps)
        let incr = 1 / CGFloat(steps)
        var percent = CGFloat(1.0)
        
        let animate = SKAction.run({
            percent -= incr
            circle.path = self.circle(radius: radius, percent: percent)
        })
        let wait = SKAction.wait(forDuration: timeInterval)
        let action = SKAction.sequence([wait, animate])
        
        let completed = SKAction.run{
            circle.path = nil
            completion()
        }
        
        let countDown = SKAction.repeat(action,count:steps-1)
        let sequence = SKAction.sequence([countDown, SKAction.wait(forDuration: timeInterval),completed])
        
        run(sequence, withKey: "actionKey")
    }
    
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
        let start:CGFloat = 0
        let end = CGFloat.pi * 2 * percent
        let center = CGPoint.zero
        let bezierPath = UIBezierPath()
        //bezierPath.move(to:center)
        bezierPath.addArc(withCenter:center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        //bezierPath.addLine(to:center)
        return bezierPath.cgPath
    }
    
    func levelCompleted(){
        self.run(levelCompleteSound)
        
        circle.removeFromParent()
        targetLabelNode.removeFromParent()
        removeAction(forKey: "actionKey")
        
        let maskSceneNode = SKShapeNode(rect: CGRect(x: 0, y:0, width: Int(self.frame.size.width), height: Int(self.frame.size.height)), cornerRadius: 10)
        maskSceneNode.fillColor = SKColor.white
        maskSceneNode.alpha = 0.4
        maskSceneNode.zPosition = 50
        maskSceneNode.name = "LevelCompletedMask"
        self.addChild(maskSceneNode)
        
        let levelCompletedShapeNode = SKShapeNode(rect: CGRect(x: Int(self.frame.midX - (self.frame.size.width/2 - 50)), y: Int(self.frame.midY - 125), width: Int(self.frame.size.width - 100), height: 250), cornerRadius: 10)
        levelCompletedShapeNode.fillColor = SKColor(hex: 0xB8860B)
        levelCompletedShapeNode.zPosition = 100
        levelCompletedShapeNode.name = "LevelCompletedShapeNode"
        
        
        let congratesLabelNode = SKLabelNode(fontNamed:"Futura-CondensedExtraBold")
        congratesLabelNode.text = "You Rock!"
        congratesLabelNode.fontSize = 25
        congratesLabelNode.fontColor = SKColor.white
        congratesLabelNode.name = "congratulation"
        congratesLabelNode.position =  CGPoint(x: levelCompletedShapeNode.frame.midX, y: levelCompletedShapeNode.frame.midY + 70)
        levelCompletedShapeNode.addChild(congratesLabelNode)
        
        
        let levelcompleted = SKLabelNode(fontNamed:"Avenir-Black")
        if level == 8 {
            levelcompleted.text = "All Levels Completed!"
        }else{
            levelcompleted.text = "Level : \((UserDefaults.standard.integer(forKey: "Level"))) Completed!"
        }
        levelcompleted.fontSize = 15
        levelcompleted.fontColor = SKColor.white
        levelcompleted.name = "levelcompleted"
        levelcompleted.position =  CGPoint(x: levelCompletedShapeNode.frame.midX, y: levelCompletedShapeNode.frame.midY + 30)
        levelCompletedShapeNode.addChild(levelcompleted)
        
        let highScore = SKLabelNode(fontNamed:"Avenir-Black")
        highScore.text = "Score : \(score)"
        highScore.fontSize = 15
        highScore.fontColor = SKColor.white
        highScore.name = "level"
        highScore.position =  CGPoint(x: levelCompletedShapeNode.frame.midX, y: levelCompletedShapeNode.frame.midY )
        levelCompletedShapeNode.addChild(highScore)
        if level == 8 {
            let confirm = SKLabelNode(fontNamed:"Avenir-Black")
            confirm.text = "Continue Playing?"
            confirm.fontSize = 15
            confirm.fontColor = SKColor.white
            confirm.name = "playnext"
            confirm.position =  CGPoint(x: levelCompletedShapeNode.frame.midX, y: levelCompletedShapeNode.frame.midY - 45)
            levelCompletedShapeNode.addChild(confirm)
        }else{
            let confirm = SKLabelNode(fontNamed:"Avenir-Black")
            confirm.text = "Play Next Level?"
            confirm.fontSize = 15
            confirm.fontColor = SKColor.white
            confirm.name = "playnext"
            confirm.position =  CGPoint(x: levelCompletedShapeNode.frame.midX, y: levelCompletedShapeNode.frame.midY - 45)
            levelCompletedShapeNode.addChild(confirm)
        }
        let yes = SKSpriteNode(imageNamed: "yes")
        yes.position = CGPoint(x: levelCompletedShapeNode.frame.midX - 30, y: levelCompletedShapeNode.frame.midY - 75)
        yes.zPosition = 0
        yes.name = "PlayNextLevel"
        levelCompletedShapeNode.addChild(yes)
        
        
        let no = SKSpriteNode(imageNamed: "no")
        no.position = CGPoint(x: levelCompletedShapeNode.frame.midX + 30, y: levelCompletedShapeNode.frame.midY - 75)
        no.zPosition = 0
        no.name = "ExitLevel"
        levelCompletedShapeNode.addChild(no)
        
        
        let scaleActionlbl1 = SKAction.scale(to: 1, duration: 1)
        let scaleActionlbl2 = SKAction.scale(to: 1.08, duration: 0.3)
        let scaleActionlbl3 = SKAction.scale(to: 1, duration: 0.3)
        
        self.addChild(levelCompletedShapeNode)
        let move = SKAction.move(to: CGPoint(x: 0, y: self.frame.maxY), duration: 0)
        let moveback = SKAction.move(to: CGPoint(x: 0, y: self.frame.minY), duration: 1)
        let scaleAction1 = SKAction.move(to: CGPoint(x: 0, y:  10), duration: 0.3)
        let scaleAction2 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
        let seq = SKAction.sequence([move,moveback,scaleAction1,scaleAction2])
        levelCompletedShapeNode.run(seq)
        
        let highScoreVal = UserDefaults.standard.integer(forKey: "HighScore")
        let sequence = SKAction.sequence([scaleActionlbl1,scaleActionlbl2,scaleActionlbl3])
        congratesLabelNode.run(sequence)
        
        
    }
    
    func GameOver(){
        
        
        circle.removeFromParent()
        targetLabelNode.removeFromParent()
        removeAction(forKey: "actionKey")
        
        let maskSceneNode = SKShapeNode(rect: CGRect(x: 0, y:0, width: Int(self.frame.size.width), height: Int(self.frame.size.height)), cornerRadius: 10)
        maskSceneNode.fillColor = SKColor.white
        maskSceneNode.alpha = 0.4
        maskSceneNode.zPosition = 50
        maskSceneNode.name = "GameOverMask"
        self.addChild(maskSceneNode)
        
        let gameOverShapeNode = SKShapeNode(rect: CGRect(x: Int(self.frame.midX - (self.frame.size.width/2 - 50)), y: Int(self.frame.midY - 125), width: Int(self.frame.size.width - 100), height: 250), cornerRadius: 10)
        gameOverShapeNode.fillColor = SKColor(hex: 0xB8860B)
        gameOverShapeNode.zPosition = 100
        gameOverShapeNode.name = "GameOverShape"
        
        
        let gameOverLabelNode = SKLabelNode(fontNamed:"Avenir-Black")
        gameOverLabelNode.text = "Game Over"
        gameOverLabelNode.fontSize = 20
        gameOverLabelNode.fontColor = SKColor.white
        gameOverLabelNode.name = "gameover"
        gameOverLabelNode.position =  CGPoint(x: gameOverShapeNode.frame.midX, y: gameOverShapeNode.frame.midY + 80)
        gameOverShapeNode.addChild(gameOverLabelNode)
        
        let currentScore = SKLabelNode(fontNamed:"Avenir-Black")
        currentScore.text = "Score : \(score)"
        currentScore.fontSize = 15
        currentScore.fontColor = SKColor.white
        currentScore.name = "YourScore"
        currentScore.position =  CGPoint(x: gameOverShapeNode.frame.midX, y: gameOverShapeNode.frame.midY + 30)
        gameOverShapeNode.addChild(currentScore)
        
        let highScore = SKLabelNode(fontNamed:"Avenir-Black")
        highScore.text = "Level : \(UserDefaults.standard.integer(forKey: "Level"))"
        highScore.fontSize = 15
        highScore.fontColor = SKColor.white
        highScore.name = "level"
        highScore.position =  CGPoint(x: gameOverShapeNode.frame.midX, y: gameOverShapeNode.frame.midY )
        gameOverShapeNode.addChild(highScore)
        
        let confirm = SKLabelNode(fontNamed:"Avenir-Black")
        confirm.text = "Play Again?"
        confirm.fontSize = 15
        confirm.fontColor = SKColor.white
        confirm.name = "playAgain"
        confirm.position =  CGPoint(x: gameOverShapeNode.frame.midX, y: gameOverShapeNode.frame.midY - 45)
        gameOverShapeNode.addChild(confirm)
        
        let yes = SKSpriteNode(imageNamed: "yes")
        yes.position = CGPoint(x: gameOverShapeNode.frame.midX - 30, y: gameOverShapeNode.frame.midY - 75)
        yes.zPosition = 0
        yes.name = "PlayAgain"
        gameOverShapeNode.addChild(yes)
        
        
        let no = SKSpriteNode(imageNamed: "no")
        no.position = CGPoint(x: gameOverShapeNode.frame.midX + 30, y: gameOverShapeNode.frame.midY - 75)
        no.zPosition = 0
        no.name = "Exit"
        gameOverShapeNode.addChild(no)
        
        
        
        self.addChild(gameOverShapeNode)
        let move = SKAction.move(to: CGPoint(x: 0, y: self.frame.maxY), duration: 0)
        let moveback = SKAction.move(to: CGPoint(x: 0, y: self.frame.minY), duration: 1)
        let scaleActionlbl1 = SKAction.move(to: CGPoint(x: 0, y:  10), duration: 0.3)
        let scaleActionlbl2 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5)
        let sequence = SKAction.sequence([move,moveback,scaleActionlbl1,scaleActionlbl2])
        gameOverShapeNode.run(sequence)
        
    }
    
    
}

extension SKColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    } }


