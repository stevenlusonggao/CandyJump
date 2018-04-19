//
//  gameover.swift
//  GUI
//
//  Created by Lu Gao on 2018-03-27.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class gameover: SKScene { //screen when game ends
    var backb:SKSpriteNode?
    var playb:SKSpriteNode?
    var lable: SKLabelNode?
    var highScoreLabel: SKLabelNode?
    var playagain:SKSpriteNode?
    var highscore:SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        let background = SKSpriteNode(imageNamed: "otherbackground")
        background.anchorPoint = CGPoint(x:0, y:0)
        background.position = CGPoint(x: 0, y: 0)
        background.setScale(0.8)
        background.zPosition = -1.0
        self.addChild(background)
        
        let out = SKSpriteNode(imageNamed: "outputarea")
        out.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        out.setScale(0.6)
        self.addChild(out)
        
        highscore = SKSpriteNode(imageNamed: "scoresbutton")
        highscore?.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY-290)
        highscore?.zPosition = 1.0
        highscore?.name = "highscore"
        self.addChild(highscore!)
        
        playagain = SKSpriteNode(imageNamed: "replaybutton")
        playagain?.position = CGPoint(x:self.frame.midX, y:self.frame.midY-290)
        playagain?.zPosition = 1.0
        playagain?.name = "playagain"
        self.addChild(playagain!)
        
        backb = SKSpriteNode(imageNamed: "backb")
        backb?.position = CGPoint(x:self.frame.midX-100, y:self.frame.midY-290)
        backb?.zPosition = 1.0
        backb?.name = "back"
        self.addChild(backb!)
        
        lable = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable?.text = "Your score is: \(UserDefaultManager.manager.getLastScore())"
        lable?.fontColor = .black
        lable?.position = CGPoint(x: out.position.x, y: out.position.y+175)
        lable?.zPosition = 2
        self.addChild(lable!)
        
        if (UserDefaultManager.manager.getLastScore() == UserDefaultManager.manager.getHighScore()) {
            highScoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
            highScoreLabel?.text = "New High Score!"
            highScoreLabel?.fontColor = .black
            highScoreLabel?.position = CGPoint(x: out.position.x, y: out.position.y)
            highScoreLabel?.zPosition = 2
            self.addChild(highScoreLabel!)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == backb!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.03)
                let MenuScene = Menu(size: self.size)
                self.view?.presentScene(MenuScene, transition: transition)
            } else if theNode.name == highscore!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration:0.09)
                let hsScene = highscores(size: self.size)
                self.view?.presentScene(hsScene, transition: transition)
            } else if theNode.name == playagain!.name {
                run(SKAction.playSoundFileNamed("play.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration:0.09)
                let hsScene = GameScene(size: self.size)
                self.view?.presentScene(hsScene, transition: transition)
            }
            
        }
    }
}

