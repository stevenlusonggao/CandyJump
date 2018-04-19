//
//  highscores.swift
//  GUI
//
//  Created by Lu Gao on 2018-03-23.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class highscores: SKScene {  //highscores scene
    var backb:SKSpriteNode?
    var highScore: SKLabelNode?
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
        
        backb = SKSpriteNode(imageNamed: "backb")
        backb?.position = CGPoint(x:self.frame.midX, y:self.frame.midY-290)
        backb?.name = "back"
        backb?.zPosition = 1.0
        self.addChild(backb!)
        
        highScore = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        highScore?.text = "Highscore is: \(UserDefaultManager.manager.getHighScore())"
        highScore?.fontColor = .black
        highScore?.position = CGPoint(x: out.position.x, y: out.position.y)
        highScore?.zPosition = 2
        self.addChild(highScore!)
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
            }
            
        }
    }
}

