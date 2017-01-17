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
        case ground = 1
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
    var FlappyBirdLabelNode = SKLabelNode()
    var TapStatusNode = SKLabelNode()
    var lastUpdateTime: TimeInterval = 0
    
    
    override func didMove(to view: SKView) {
        print("Game scene active")
        self.physicsWorld.gravity = CGVector(dx:0,dy:-14)
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingGameObjects)
        createBackground()
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
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    
}
