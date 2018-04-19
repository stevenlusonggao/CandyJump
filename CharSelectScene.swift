//
//  CharSelectScene.swift
//  CandyJump
//
//  Created by Marko Mihailovic on 2018-03-28.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class CharSelectScene: SKScene {  //character selection screen
    var backb: SKSpriteNode?
    var adventurer: SKSpriteNode?
    var male: SKSpriteNode?
    var female: SKSpriteNode?
    var soldier: SKSpriteNode?
    var zombie: SKSpriteNode?
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
        
        adventurer = SKSpriteNode(imageNamed: "adventurer")
        adventurer?.position = CGPoint(x:self.frame.midX-80, y:self.frame.midY+170)
        adventurer?.name = "adventurer"
        adventurer?.zPosition = 1.0
        self.addChild(adventurer!)
        
        male = SKSpriteNode(imageNamed: "male")
        male?.position = CGPoint(x:self.frame.midX+80, y:self.frame.midY+170)
        male?.name = "male"
        male?.zPosition = 1.0
        self.addChild(male!)
        
        female = SKSpriteNode(imageNamed: "female")
        female?.position = CGPoint(x:self.frame.midX-80, y:self.frame.midY+20)
        female?.name = "female"
        female?.zPosition = 1.0
        self.addChild(female!)
        
        soldier = SKSpriteNode(imageNamed: "soldier")
        soldier?.position = CGPoint(x:self.frame.midX+80, y:self.frame.midY+20)
        soldier?.name = "soldier"
        soldier?.zPosition = 1.0
        self.addChild(soldier!)
        
        zombie = SKSpriteNode(imageNamed: "zombie")
        zombie?.position = CGPoint(x:self.frame.midX, y:self.frame.midY-130)
        zombie?.name = "zombie"
        zombie?.zPosition = 1.0
        self.addChild(zombie!)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == adventurer!.name {
                UserDefaultManager.manager.setCharacter(newCharacter: Character.Adventurer)
            }
            else if theNode.name == male!.name {
                UserDefaultManager.manager.setCharacter(newCharacter: Character.Male)
            }
            else if theNode.name == female!.name {
                UserDefaultManager.manager.setCharacter(newCharacter: Character.Female)
            }
            else if theNode.name == soldier!.name {
                UserDefaultManager.manager.setCharacter(newCharacter: Character.Soldier)
            }
            else if theNode.name == zombie!.name {
                UserDefaultManager.manager.setCharacter(newCharacter: Character.Zombie)
            }
            run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
            let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.03)
            let MenuScene = Menu(size: self.size)
            self.view?.presentScene(MenuScene, transition: transition)
        }
    }
}
