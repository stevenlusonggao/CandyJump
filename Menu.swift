//
//  Menu.swift
//  GUI
//
//  Created by Lu Gao on 2018-03-21.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import UIKit
import GameplayKit

class Menu: SKScene { //main menu screen
    var playb: SKSpriteNode?
    var insb: SKSpriteNode?
    var soundb: SKSpriteNode?
    var accelb: SKSpriteNode?
    var charb: SKSpriteNode?
    var leaderboardsb: SKSpriteNode?
    var mbackground: SKSpriteNode?
    var soundoffb: SKSpriteNode?
    var soundswitch:Bool = true
    var borf:borf = .back
    var timer:Int = 0
    var timetoswitch:Bool = false
    
    
    override init(size: CGSize) {
        super.init(size: size)
        mbackground = SKSpriteNode(imageNamed: "menubackground")
        mbackground!.anchorPoint = CGPoint(x:0, y:0)
        mbackground!.position = CGPoint(x: 0, y: 0)
        mbackground!.zPosition = -1.0
        self.addChild(mbackground!)
        
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x:self.frame.midX+15, y:self.frame.midY+200);
        self.addChild(logo)
        
        playb = SKSpriteNode(imageNamed: "playbutton")
        playb!.position = CGPoint(x:self.frame.midX, y:self.frame.midY+25);
        playb!.name = "PlayButton"
        self.addChild(playb!)
        
        insb = SKSpriteNode(imageNamed: "insbutton")
        insb!.position = CGPoint(x:self.frame.midX-50, y:self.frame.midY-100);
        insb!.name = "instructions"
        self.addChild(insb!)
        
        leaderboardsb = SKSpriteNode(imageNamed: "scoresbutton")
        leaderboardsb!.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-100);
        leaderboardsb!.name = "leaderboards"
        self.addChild(leaderboardsb!)
        
        soundb = SKSpriteNode(imageNamed: "soundb")
        soundb!.position = CGPoint(x:self.frame.midX - 150, y:self.frame.midY-300);
        soundb!.name = "sound"
        self.addChild(soundb!)
        
        if (UserDefaultManager.manager.getAccel()) {
            accelb = SKSpriteNode(imageNamed: "gyro_on")
            accelb!.position = CGPoint(x:self.frame.midX + 150, y:self.frame.midY-300);
            accelb!.name = "accel"
            self.addChild(accelb!)
        }
            
        else {
            accelb = SKSpriteNode(imageNamed: "gyro_off")
            accelb!.position = CGPoint(x:self.frame.midX + 150, y:self.frame.midY-300);
            accelb!.name = "accel"
            self.addChild(accelb!)
        }
        
        let char = UserDefaultManager.manager.getCharacter()
        
        if (char == Character.Male) {
            charb = SKSpriteNode(imageNamed: "male")
        }
            
        else if (char == Character.Female) {
            charb = SKSpriteNode(imageNamed: "female")
        }
            
        else if (char == Character.Soldier) {
            charb = SKSpriteNode(imageNamed: "soldier")
        }
            
        else if (char == Character.Adventurer) {
            charb = SKSpriteNode(imageNamed: "adventurer")
        }
            
        else {
            charb = SKSpriteNode(imageNamed: "zombie")
        }
        
        charb!.position = CGPoint(x:self.frame.midX, y:self.frame.midY-200);
        charb!.name = "char"
        self.addChild(charb!)
        
        if (musicplayer.playing == false) {
            _ = musicplayer.playm()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveb() {
        if (timer > 250) {
            self.timetoswitch = true
            timer = 0
        }
        switch self.borf {
        case .forward:
            if (self.timetoswitch == true) {
                self.borf = .back
                self.timetoswitch = false
            }
            mbackground?.position.x += 1
        case .back:
            if (self.timetoswitch == true) {
                self.borf = .forward
                self.timetoswitch = false
            }
            mbackground?.position.x -= 1
        }
    }
    override func update(_ currentTime: TimeInterval) {
        timer = timer + 1
        moveb()
    }
    
    enum borf {
        case forward
        case back
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == soundb!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                if self.soundswitch == true {
                    let soundpos = (soundb?.position)!
                    soundb?.removeFromParent()
                    soundb = SKSpriteNode(imageNamed: "soundoffb")
                    soundb!.position = soundpos
                    soundb!.name = "soundb"
                    self.addChild(soundb!)
                    _ = musicplayer.stopm()
                    self.soundswitch = false
                } else {
                    let soundpos = (soundb?.position)!
                    soundb?.removeFromParent()
                    soundb = SKSpriteNode(imageNamed: "soundb")
                    soundb!.position = soundpos
                    soundb!.name = "soundb"
                    self.addChild(soundb!)
                    _ = musicplayer.playm()
                    self.soundswitch = true
                }
            } else if theNode.name == accelb!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                if UserDefaultManager.manager.getAccel() == true {
                    let accelpos = (accelb?.position)!
                    accelb?.removeFromParent()
                    accelb = SKSpriteNode(imageNamed: "gyro_off")
                    accelb!.position = accelpos
                    accelb!.name = "accelb"
                    self.addChild(accelb!)
                    UserDefaultManager.manager.setAccelerometer(isSet: false)
                } else {
                    let accelpos = (accelb?.position)!
                    accelb?.removeFromParent()
                    accelb = SKSpriteNode(imageNamed: "gyro_on")
                    accelb!.position = accelpos
                    accelb!.name = "accelb"
                    self.addChild(accelb!)
                    UserDefaultManager.manager.setAccelerometer(isSet: true)
                }
            } else if theNode.name == playb!.name {
                run(SKAction.playSoundFileNamed("play.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration:0.09)
                let pScene = GameScene(size: self.size)
                self.view?.presentScene(pScene, transition: transition)
            } else if theNode.name == insb!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration:0.09)
                let insScene = instructions(size: self.size)
                self.view?.presentScene(insScene, transition: transition)
            } else if theNode.name == leaderboardsb!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration:0.09)
                let hsScene = highscores(size: self.size)
                self.view?.presentScene(hsScene, transition: transition)
            } else if theNode.name == charb!.name {
                run(SKAction.playSoundFileNamed("select.wav", waitForCompletion: false))
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration:0.09)
                let cScene = CharSelectScene(size: self.size)
                self.view?.presentScene(cScene, transition: transition)
            }
        }
    }
}


