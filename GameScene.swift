//
//  GameScene.swift
//  CandyJump
//
//  Created by Lu Gao on 2018-03-28.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var backgroundNode: SKNode!
    var foregroundNode: SKNode!
    var scoreLabel: SKLabelNode!
    var breakPoint: CGFloat!
    var score = 0 //score counter
    var maxHeight = 80
    var player: SKSpriteNode!
    var scaleFactor: CGFloat!
    var lastpos: CGPoint! //last position of created background tile
    var platformWidth: CGFloat! //width of platform
    var char = 0 //charecter identifier
    var lastPostition: CGFloat! //last position of the plaform creator pointer
    var lastCreatedplat: CGFloat! //the last position of a created node
    var lastplatname:String = "normal" //name of last created platform
    var breakPlatupper:Int = 20 //upper spawn percentage range used to randomly generate break platforms
    var blank_chance:Double = 1.0 //chance of generating a platform
    var lastDiffchange:Int = 19 //last time the difficulty was raised;
    
    var index:Int = 0 //background tiles file name tracker
    var highpos:CGPoint! //highest point of player
    var lowpos:CGPoint! //lowest point of player
    var spriteIndex:Int = 0//index stored in the userdata for platform and background sprites
    var lastdel:Int = 0; //track the sprite index of last deletion
    var lastdelpos:CGPoint! = CGPoint(x:0.0,y:0.0) //last deleted bg tile position tracker
    let leeway:CGFloat = 96*18 //amount of leeway of remaining background tiles
    var deathline:CGFloat = 0 //the line the game will end if crossed
    
    let mediumBounce = CGFloat(250.0) //height of a medium bounce
    let bigBounce = CGFloat(500.0) //height of a big bounce
    let motionManager = CMMotionManager()
    var xAccel: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        scaleFactor = self.size.width / 414
        backgroundNode = create_background()
        backgroundNode.zPosition = -1
        breakPoint = self.frame.midY + 100
        
        backgroundNode = create_background()  //create background
        addChild(backgroundNode)
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        foregroundNode = SKNode()  //create forground
        addChild(foregroundNode)
        
        let platform = createPlatform(position: CGPoint(x: self.size.width/2, y: 320),type: PlatformType.Normal)  //create starting platform
        foregroundNode.addChild(platform)
        
        platformWidth = platform.size.width //set platform width
        
        let platform2 = createPlatform(position: CGPoint(x: self.size.width/2, y: 450),type: PlatformType.Normal)
        foregroundNode.addChild(platform2)
        lastPostition = 450
        lastCreatedplat = lastPostition
        
        player = createPlayer()  //create player node
        player.zPosition = 2
        foregroundNode.addChild(player)
        
        highpos = player!.position //initilize variables
        lowpos = player!.position
        
        scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreLabel.text = "0"
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerometerData: Optional<CMAccelerometerData>, error: Optional<Error>) in
            let acceleration = accelerometerData?.acceleration
            self.xAccel = (CGFloat((acceleration?.x)!) * 0.75) + (self.xAccel * 0.25)
            })
    }
    
    func create_background() -> SKNode { //create starting background
        let background = SKNode()
        let y = 96.0 * scaleFactor
        for i in 0...19 {
            let part = SKSpriteNode(imageNamed:String(format: "p%02d", i + 1)+".jpeg")
            part.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            part.setScale(scaleFactor)
            part.position = CGPoint(x: 0, y: y * CGFloat(i))
            part.name = "bgTile"
            part.userData = ["index" : spriteIndex]
            spriteIndex = spriteIndex + 1
            background.addChild(part)
            if (i == 19) {
                lastpos = CGPoint(x: self.size.width / 2, y: y * CGFloat(i+1))
            }
        }
        return background
    }
    
    func createPlayer() -> SKSpriteNode { //create a player node
        
        char = UserDefaultManager.manager.getCharacter()
        let playerSprite = SKSpriteNode(imageNamed: "male")
        
        if (char == Character.Male) {
            playerSprite.texture = SKTexture(imageNamed: "male")
        }
        
        else if (char == Character.Female) {
            playerSprite.texture = SKTexture(imageNamed: "female")
        }
        
        else if (char == Character.Soldier) {
            playerSprite.texture = SKTexture(imageNamed: "soldier")
        }
        
        else if (char == Character.Adventurer) {
            playerSprite.texture = SKTexture(imageNamed: "adventurer")
        }
        
        else {
            playerSprite.texture = SKTexture(imageNamed: "zombie")
        }
        
        playerSprite.position = CGPoint(x: self.size.width/2, y: 80)
        playerSprite.size = CGSize(width: 50, height: 80)
        playerSprite.physicsBody = SKPhysicsBody(circleOfRadius: playerSprite.size.width / 2)  //set player physical properties
        playerSprite.physicsBody?.isDynamic = false
        playerSprite.physicsBody?.usesPreciseCollisionDetection = true
        playerSprite.physicsBody?.categoryBitMask = PhysicsCategory.Player
        playerSprite.physicsBody?.collisionBitMask = 0
        playerSprite.physicsBody?.contactTestBitMask = PhysicsCategory.NormalPlatform
        playerSprite.physicsBody?.contactTestBitMask = PhysicsCategory.BouncePlatform
        playerSprite.physicsBody?.contactTestBitMask = PhysicsCategory.BreakPlatform
        return playerSprite
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.physicsBody!.isDynamic {
            return
        }
        player.physicsBody?.isDynamic = true
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 420.0)
        
        if (char == Character.Male) {   //animate player jumping when touching a platform
            player.texture = SKTexture(imageNamed: "male_jump")
        }
            
        else if (char == Character.Female) {
            player.texture = SKTexture(imageNamed: "female_jump")
        }
            
        else if (char == Character.Soldier) {
            player.texture = SKTexture(imageNamed: "soldier_jump")
        }
            
        else if (char == Character.Adventurer) {
            player.texture = SKTexture(imageNamed: "adventurer_jump")
        }
            
        else {
            player.texture = SKTexture(imageNamed: "zombie_jump")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (char == Character.Male) {
            player.texture = SKTexture(imageNamed: "male_jump")
        }
            
        else if (char == Character.Female) {
            player.texture = SKTexture(imageNamed: "female_jump")
        }
            
        else if (char == Character.Soldier) {
            player.texture = SKTexture(imageNamed: "soldier_jump")
        }
            
        else if (char == Character.Adventurer) {
            player.texture = SKTexture(imageNamed: "adventurer_jump")
        }
            
        else {
            player.texture = SKTexture(imageNamed: "zombie_jump")
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.NormalPlatform || contact.bodyB.categoryBitMask == PhysicsCategory.NormalPlatform) {  //player contact with normal platform
            if ((player.physicsBody?.velocity.dy)! < mediumBounce) {
                player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: mediumBounce)
                run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
            }
        }
            
        else if (contact.bodyA.categoryBitMask == PhysicsCategory.BreakPlatform) {  //player contact with breaking platform
            if ((player.physicsBody?.velocity.dy)! < mediumBounce) {
                player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: mediumBounce)
                contact.bodyA.node?.removeFromParent()
                run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
            }
        }
            
        else if(contact.bodyB.categoryBitMask == PhysicsCategory.BreakPlatform) {
            if ((player.physicsBody?.velocity.dy)! < mediumBounce) {
                player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: mediumBounce)
                contact.bodyB.node?.removeFromParent()
                run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
            }
        }
            
        else if (contact.bodyA.categoryBitMask == PhysicsCategory.BouncePlatform) {  //player contact with bounce boost
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: bigBounce)
            contact.bodyA.node?.removeFromParent()
            run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
        }
        
        else if (contact.bodyB.categoryBitMask == PhysicsCategory.BouncePlatform) {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: bigBounce)
            contact.bodyA.node?.removeFromParent()
            run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { //player controls (non gyro)
        if (!UserDefaultManager.manager.getAccel()) {
            for touch: AnyObject in touches {
                let location = touch.location(in: self)
                _ = self.atPoint(location)
                self.touchMoved(toPoint: touch.location(in: self))
                
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if (player.position.x+player.yScale/2 < self.frame.maxX) ||
            (player.position.x > self.frame.minX+player.yScale/2) {
            player.position = CGPoint(x: pos.x, y: player.position.y)
        }
    }
    
    func createPlatform(position: CGPoint, type: Int) -> SKSpriteNode {  //create platforms
        var platformNode: SKSpriteNode
        
        if (type == PlatformType.Normal) {
            platformNode = SKSpriteNode(imageNamed: "plat2")
            platformNode.position = CGPoint(x: position.x * scaleFactor, y: position.y)
            platformNode.size = CGSize(width: 70, height: 20)
            platformNode.name = "Platform"
            platformNode.userData = ["type": "normal"]
            platformNode.physicsBody = SKPhysicsBody(rectangleOf: platformNode.size)
            platformNode.physicsBody?.isDynamic = false
            platformNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            platformNode.physicsBody?.collisionBitMask = 0
            platformNode.physicsBody?.categoryBitMask = PhysicsCategory.NormalPlatform
        }
            
        else if (type == PlatformType.Break) {
            platformNode = SKSpriteNode(imageNamed: "plat3")
            platformNode.position = CGPoint(x: position.x * scaleFactor, y: position.y)
            platformNode.size = CGSize(width: 70, height: 20)
            platformNode.name = "Platform"
            platformNode.userData = ["type": "break"]
            platformNode.physicsBody = SKPhysicsBody(rectangleOf: platformNode.size)
            platformNode.physicsBody?.isDynamic = false
            platformNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            platformNode.physicsBody?.collisionBitMask = 0
            platformNode.physicsBody?.categoryBitMask = PhysicsCategory.BreakPlatform
        }
            
        else {
            platformNode = SKSpriteNode(imageNamed: "cherry")
            platformNode.position = CGPoint(x: position.x * scaleFactor, y: position.y)
            platformNode.size = CGSize(width: 40, height: 40)
            platformNode.name = "Platform"
            platformNode.userData = ["type": "cherry"]
            platformNode.physicsBody = SKPhysicsBody(rectangleOf: platformNode.size)
            platformNode.physicsBody?.isDynamic = false
            platformNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            platformNode.physicsBody?.collisionBitMask = 0
            platformNode.physicsBody?.categoryBitMask = PhysicsCategory.BouncePlatform
        }
        platformNode.zPosition = 1
        return platformNode
    }
    
    override func didSimulatePhysics() {
        if (UserDefaultManager.manager.getAccel()) {
            player.physicsBody?.velocity = CGVector(dx: xAccel * 600.0, dy: player.physicsBody!.velocity.dy)
            if player.position.x < -20.0 {
                player.position = CGPoint(x: self.size.width + 20.0, y: player.position.y)
            } else if (player.position.x > self.size.width + 20.0) {
                player.position = CGPoint(x: -20.0, y: player.position.y)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if ((player.physicsBody?.velocity.dy)! < CGFloat(0)) { //animates player jumping
            if (char == Character.Male) {
                player.texture = SKTexture(imageNamed: "male")
            }
            
            else if (char == Character.Female) {
                player.texture = SKTexture(imageNamed: "female")
            }
            
            else if (char == Character.Soldier) {
                player.texture = SKTexture(imageNamed: "soldier")
            }
            
            else if (char == Character.Adventurer) {
                player.texture = SKTexture(imageNamed: "adventurer")
            }
            
            else {
                player.texture = SKTexture(imageNamed: "zombie")
            }
        }
        
        if (spriteIndex - lastDiffchange >= 7) {  //adjust break platform spawn rate as difficulty rises
            if (blank_chance != 0.01) {
                if (blank_chance == 0.1) {
                    blank_chance = 0.01
                } else {
                    blank_chance = blank_chance - 0.15  //decrease chance of spawning a platform, raises difficulty
                    
                }
            }
            if (breakPlatupper != 80) {
                breakPlatupper = breakPlatupper + 10  //increases change of spawning a breaking platform, raises difficulty
            }
            lastDiffchange = spriteIndex
        }
        
        let bonus = arc4random_uniform(100) + 1 //random number to generate platform types
        var type: Int
        
        if (bonus > 0 && bonus < 11) {
            type = PlatformType.Bounce
        }
            
        else if (bonus >= 11 && bonus < breakPlatupper) {
            type = PlatformType.Break
        }
            
        else {
            type = PlatformType.Normal
        }
        
        if Int(player.position.y) > maxHeight {
            score += Int(player.position.y) - maxHeight
            maxHeight = Int(player.position.y)
            updateScore(score: score)
        }
        
        if player.position.y > 200.0 {
            backgroundNode.position = CGPoint(x: 0.0, y: -((player.position.y - 200.0)/10))
            foregroundNode.position = CGPoint(x: 0.0, y: -(player.position.y - 200.0))
        }
        
        let blank_random = drand48()
        if (player.position.y > lastPostition - 500) {  //randomly creates different types of platforms, but also ensures that there will always be a passable path, regardless of difficulty
            if (blank_random <= blank_chance) {
                let newPlatform = createPlatform(position: CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.frame.maxX) - UInt32(self.frame.minX) + 1) + UInt32(self.frame.minX)), y: lastCreatedplat + 50),type: type)
                newPlatform.zPosition = 1
                foregroundNode.addChild(newPlatform)
                lastPostition = newPlatform.position.y
                lastCreatedplat = newPlatform.position.y
                lastplatname = newPlatform.userData?.object(forKey: "type") as! String
            } else if (lastPostition - lastCreatedplat > 150 && lastplatname == "normal") {
                let newPlatform = createPlatform(position: CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.frame.maxX) - UInt32(self.frame.minX) + 1) + UInt32(self.frame.minX)), y: lastCreatedplat + 150),type: type)
                newPlatform.zPosition = 1
                foregroundNode.addChild(newPlatform)
                lastPostition = newPlatform.position.y
                lastCreatedplat = newPlatform.position.y
                lastplatname = newPlatform.userData?.object(forKey: "type") as! String
            } else if (lastPostition - lastCreatedplat > 350 && lastplatname == "cherry") {
                let newPlatform = createPlatform(position: CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.frame.maxX) - UInt32(self.frame.minX) + 1) + UInt32(self.frame.minX)), y: lastCreatedplat + 350),type: type)
                newPlatform.zPosition = 1
                foregroundNode.addChild(newPlatform)
                lastPostition = newPlatform.position.y
                lastCreatedplat = newPlatform.position.y
                lastplatname = newPlatform.userData?.object(forKey: "type") as! String
            } else if (lastPostition - lastCreatedplat > 90 && lastplatname == "break") {
                let newPlatform = createPlatform(position: CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.frame.maxX) - UInt32(self.frame.minX) + 1) + UInt32(self.frame.minX)), y: lastCreatedplat + 90),type: type)
                newPlatform.zPosition = 1
                foregroundNode.addChild(newPlatform)
                lastPostition = newPlatform.position.y
                lastCreatedplat = newPlatform.position.y
                lastplatname = newPlatform.userData?.object(forKey: "type") as! String
            } else {
                lastPostition = lastPostition + 50
            }
            
        }
        updateBackground()
        updateplatforms()
        if player.position.y <= deathline {  //when a player falls to a certain postion, the game is over
            UserDefaultManager.manager.setLastScore(newLastScore: score)
            
            if (score > UserDefaultManager.manager.getHighScore()) {
                UserDefaultManager.manager.setHighScore(newHighScore: score)
            }
            
            let scene = gameover(size: (view?.bounds.size)!)
            view?.presentScene(scene)
        }
    }
        
    func updateBackground() { //generate new background tiles, while deleting old used background tiles
        if highpos.y < player.position.y {
            highpos.y = player.position.y
        }
        if (highpos.y - lowpos.y >= 200) {
            lowpos.y = highpos.y
            if (index == 19) {
                index = 0
            }
            let part = SKSpriteNode(imageNamed:String(format: "p%02d", index + 1)+".jpeg")
            part.name = "bg\(spriteIndex)"
            part.name = "bgTile"
            part.userData = ["index" : spriteIndex]
            spriteIndex = spriteIndex + 1
            part.setScale(scaleFactor)
            part.position = lastpos
            lastpos.y = lastpos.y + scaleFactor * 96.0
            backgroundNode.addChild(part)
            index = index + 1
            if ( lastdelpos.y*2 < player.position.y - leeway) { //start deleting a background after each background creation after 30 background tiles are made
                backgroundNode.enumerateChildNodes(withName: "bgTile") { node, stop in
                    if (node.userData?.object(forKey: "index") as! Int == self.lastdel) {
                        self.lastdelpos = node.position
                        node.removeFromParent()
                        self.lastdel = self.lastdel + 1
                        stop.pointee = true
                    }
                }
            }
        }
    }

    func updateplatforms() { //delete old used platforms
        foregroundNode.enumerateChildNodes(withName: "Platform") { node, stop in
            if (node.position.y < self.player.position.y - 500) {
                self.deathline = node.position.y - 400
                node.removeFromParent()
            }
        }
    }
    
    func updateScore(score: Int) {  //update the score 
        self.scoreLabel.text = String(score)
    }
}
