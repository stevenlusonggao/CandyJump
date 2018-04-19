//
//  instructions.swift
//  GUI
//
//  Created by Lu Gao on 2018-03-23.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class instructions: SKScene {  //instruction screen
    var backb:SKSpriteNode?
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
        
        let lable1 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable1.text = "Instructions"
        lable1.fontSize = 20
        lable1.fontColor = .black
        lable1.position = CGPoint(x: out.position.x, y: out.position.y+190)
        lable1.zPosition = 1.0
        self.addChild(lable1)
        
        let lable2 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable2.text = "Moving"
        lable2.fontSize = 16
        lable2.fontColor = .black
        lable2.position = CGPoint(x: out.position.x, y: out.position.y+161)
        lable2.zPosition = 1.0
        self.addChild(lable2)
        
        let lable2_2 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable2_2 .text = "Option 1: Use the accelerometer"
        lable2_2 .fontSize = 14
        lable2_2 .fontColor = .black
        lable2_2 .position = CGPoint(x: out.position.x, y: out.position.y+140)
        lable2_2 .zPosition = 1.0
        self.addChild(lable2_2 )
        
        let lable3 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable3.text = "Option 2: Drag the character from side to side"
        lable3.fontSize = 14
        lable3.fontColor = .black
        lable3.position = CGPoint(x: out.position.x, y: out.position.y+110)
        lable3.zPosition = 1.0
        self.addChild(lable3)
        
        let lable4 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable4.text = "Platforms and Objects"
        lable4.fontSize = 16
        lable4.fontColor = .black
        lable4.position = CGPoint(x: out.position.x, y: out.position.y+60)
        lable4.zPosition = 1.0
        self.addChild(lable4)
        
        let plat1 = SKSpriteNode(imageNamed: "plat2")
        plat1.position = CGPoint(x:out.position.x - 120, y:out.position.y + 20)
        plat1.zPosition = 1.0
        self.addChild(plat1)
        
        let lable5 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable5.text = "Jump on these as much as you want!"
        lable5.fontSize = 14
        lable5.fontColor = .black
        lable5.position = CGPoint(x:out.position.x + 40, y:out.position.y + 20)
        lable5.zPosition = 1.0
        self.addChild(lable5)
        
        let plat2 = SKSpriteNode(imageNamed: "plat3")
        plat2.position = CGPoint(x:out.position.x - 120, y:out.position.y-40)
        plat2.zPosition = 1.0
        self.addChild(plat2)
        
        let lable6 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable6.text = "These will break after you touch them!"
        lable6.fontSize = 14
        lable6.fontColor = .black
        lable6.position = CGPoint(x:out.position.x + 40, y:out.position.y-40)
        lable6.zPosition = 1.0
        self.addChild(lable6)
        
        let plat3 = SKSpriteNode(imageNamed: "cherry")
        plat3.position = CGPoint(x:out.position.x - 120, y:out.position.y-100)
        plat3.zPosition = 1.0
        self.addChild(plat3)
        
        let lable7 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        lable7.text = "Touch these to give you a boost!"
        lable7.fontSize = 14
        lable7.fontColor = .black
        lable7.position = CGPoint(x:out.position.x + 40, y:out.position.y-100)
        lable7.zPosition = 1.0
        self.addChild(lable7)
        
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
