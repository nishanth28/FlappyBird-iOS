//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nishanth P on 1/17/17.
//  Copyright © 2017 Nishapp. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    let birdMask: UInt32 = 0x1 << 0
    let enemyMask: UInt32 = 0x1 << 1
    let openingMask: UInt32 = 0x1 << 2
    
    enum trackZpositions: CGFloat{
        case background = 0
        case floor = 1
        case pipes = 2
        case bird = 3
        case labelNodes = 4
    }
    
    var movingGameObjects = SKNode()
    var background = SKSpriteNode()
    var bird = SKSpriteNode()
    var pipeSpeed: TimeInterval = 7
    var pipesSpawned: Int = 0
    var gameOver:Bool = true
    var score : Int = 0
    var scoreLabelNode = SKLabelNode()
    var flappyBirdLabelNode = SKLabelNode()
    var tapStatusNode = SKLabelNode()
    var lastUpdateTime: TimeInterval = 0
    
    
    override func didMove(to view: SKView) {
        print("Game scene active")
        self.physicsWorld.gravity = CGVector(dx:0,dy:-14)
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingGameObjects)
        createBackground()
        birdToScene()
        FloorToScene()
        ceilToScene()
        labelsToScene()
    }
    
    func createBackground(){
        let bgTexture = SKTexture(imageNamed:"FlappyBG")
        let movebg = SKAction.moveBy(x:-bgTexture.size().width, y:0,duration:12)
        let replaceBg = SKAction.moveBy(x:bgTexture.size().width, y:0, duration:0)
        let backgroundSeq = SKAction.sequence([movebg,replaceBg])
        
        let continousBG = SKAction.repeatForever(backgroundSeq)
        for i in 0...1{
            background = SKSpriteNode(texture:bgTexture)
            background.position = CGPoint(x:CGFloat(i)*bgTexture.size().width , y:self.frame.midY)
            background.size.height = self.frame.height
            
            background.zPosition = trackZpositions.background.rawValue
            background.run(continousBG)
            
            movingGameObjects.addChild(background)
            
        }
        
        
    }
    
    func birdToScene(){
        
        let birdTexture =  SKTexture(imageNamed:"bird1")
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x:0,y:0)
        bird.zPosition = trackZpositions.bird.rawValue
     bird.run(SKAction.init(named:"birdFly")!,withKey:"Fly")
        bird.physicsBody = SKPhysicsBody(circleOfRadius:bird.size.height/2)
        bird.physicsBody?.categoryBitMask = birdMask
        bird.physicsBody?.contactTestBitMask = openingMask | enemyMask
        bird.physicsBody?.collisionBitMask = enemyMask
        
        
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.isDynamic = false
        
        addChild(bird)
        
    }
    
    func FloorToScene(){
        
        let floor = SKNode()
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.frame.width,height:1))
        floor.physicsBody?.isDynamic = false
        floor.position = CGPoint(x:0,y:-self.frame.height/2)
        floor.zPosition = trackZpositions.floor.rawValue
        floor.physicsBody?.categoryBitMask = enemyMask
        floor.physicsBody?.contactTestBitMask = birdMask
        floor.physicsBody?.collisionBitMask = birdMask
        
        addChild(floor)
        
    }
    
    func ceilToScene(){
        
        let ceil = SKNode()
        
        ceil.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.frame.width,height:1))
        ceil.physicsBody?.isDynamic = false
        ceil.position = CGPoint(x:0,y: self.frame.height/2)
        ceil.zPosition = trackZpositions.floor.rawValue
        ceil.physicsBody?.categoryBitMask = enemyMask
        ceil.physicsBody?.contactTestBitMask = birdMask
        ceil.physicsBody?.collisionBitMask = birdMask
        
        addChild(ceil)
        
    }
    
    func labelsToScene(){
        
        flappyBirdLabelNode = SKLabelNode(fontNamed:"Noteworthy-light")
        flappyBirdLabelNode.fontSize = 100
        flappyBirdLabelNode.text = "Flappy Bird"
        flappyBirdLabelNode.position = CGPoint(x:0,y:bird.position.y+100)
        flappyBirdLabelNode.zPosition = trackZpositions.labelNodes.rawValue
        addChild(flappyBirdLabelNode)
        
        tapStatusNode = SKLabelNode(fontNamed: "HoeflerText-Italic")
        tapStatusNode.fontSize = 40
        tapStatusNode.text = "Tap to let the bird fly"
        tapStatusNode.position = CGPoint(x:0,y:bird.position.y-100)
        addChild(tapStatusNode)
        
        tapStatusNode.run(SKAction.init(named:"Pulse")!)
        
        
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        playGame()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let rotateDown = SKAction.rotate(toAngle:-0.1,duration:0)
        bird.run(rotateDown)
    }
    
    func playGame(){
        
        bird.physicsBody?.velocity = CGVector(dx:0,dy:0)
        bird.physicsBody?.applyImpulse(CGVector(dx:0,dy:60))
        let rotateUp = SKAction.rotate(toAngle:0.2,duration:0)
        bird.run(rotateUp)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    
    
}
