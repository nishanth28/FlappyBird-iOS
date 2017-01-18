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
    
    func pipesToScene(){
        
        pipesSpawned += 2
        if pipesSpawned % 10 == 0{
            pipeSpeed -= 0.1
        }
        
        let gap : CGFloat = bird.size.height * 3.5
        
        let TopPipeTexture = SKTexture(imageNamed:"pipe1")
        let bottomPipeTexture = SKTexture(imageNamed:"pipe2")
        
        let topPipe = SKSpriteNode(texture:TopPipeTexture)
        let bottomPipe = SKSpriteNode(texture:bottomPipeTexture)
        topPipe.anchorPoint = CGPoint(x:0.5,y:0)
        bottomPipe.anchorPoint = CGPoint(x:0.5,y:1)
        
        var randomY : CGFloat = CGFloat(arc4random_uniform(UInt32(self.frame.height/2 * 0.6)))
        let sign = Int(arc4random_uniform(1000))
        
        randomY = sign % 2 == 0 ? randomY : -randomY
        
        topPipe.position = CGPoint(x:self.frame.width+topPipe.size.width,y:randomY)
        
        topPipe.physicsBody = SKPhysicsBody(rectangleOf:topPipe.size,center:CGPoint(x:0,y:topPipe.size.height/2))
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = enemyMask
        topPipe.physicsBody?.collisionBitMask = birdMask
        topPipe.physicsBody?.contactTestBitMask = birdMask
        
        topPipe.zPosition = trackZpositions.pipes.rawValue
        movingGameObjects.addChild(topPipe)
        
        let movePipe = SKAction.moveTo(x: -self.frame.width, duration: pipeSpeed)
        let removePipe = SKAction.removeFromParent()
        topPipe.run(SKAction.sequence([movePipe,removePipe]))
        
        bottomPipe.position = CGPoint(x:self.frame.width+bottomPipe.size.width,y:topPipe.position.y - gap)
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf:bottomPipe.size,center:CGPoint(x:0,y:-bottomPipe.size.height/2))
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.categoryBitMask = enemyMask
        bottomPipe.physicsBody?.collisionBitMask = birdMask
        bottomPipe.physicsBody?.contactTestBitMask = birdMask
        
        bottomPipe.zPosition = trackZpositions.pipes.rawValue
        movingGameObjects.addChild(bottomPipe)
        
        bottomPipe.run(SKAction.sequence([movePipe,removePipe]))
        
        let crossing = SKNode()
        crossing.position = CGPoint(x:topPipe.position.x,y:0)
        crossing.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width:1,height:self.frame.height))
        crossing.physicsBody?.isDynamic = false
        crossing.physicsBody?.categoryBitMask = openingMask
        crossing.physicsBody?.contactTestBitMask = birdMask
        
        movingGameObjects.addChild(crossing)
        
        crossing.run(SKAction.sequence([movePipe,removePipe]))
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver {
        startGame()
        }else{
            playGame()
        }
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
        
        if (self.lastUpdateTime == 0)
        {
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        if dt > 2.5 {
            if !gameOver{
                pipesToScene()
                self.lastUpdateTime = currentTime
            }
        }
    }
    
    func startGame(){
        
        gameOver = false
        flappyBirdLabelNode.removeFromParent()
        tapStatusNode.removeFromParent()
        movingGameObjects.isPaused = false
        bird.physicsBody?.isDynamic = true
        
        scoreLabelNode = SKLabelNode(fontNamed: "Helvetica Neue")
        scoreLabelNode.fontSize = 75
        scoreLabelNode.text = "0"
        scoreLabelNode.position = CGPoint(x:0,y:self.frame.height/2 - scoreLabelNode.frame.height - 15)
        scoreLabelNode.zPosition = trackZpositions.labelNodes.rawValue
        addChild(scoreLabelNode)
        
        playGame()
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == openingMask || contact.bodyB.categoryBitMask == openingMask{
            score += 1
            scoreLabelNode.text = "\(score)"
        } else if contact.bodyA.categoryBitMask == enemyMask || contact.bodyB.categoryBitMask == enemyMask
        {
            self.physicsWorld.contactDelegate = nil
            self.finish()
        }
        
    }
    
    func finish(){
        
        bird.removeAllActions()
        movingGameObjects.isPaused = true
        bird.physicsBody?.isDynamic = false
        
        let firstPause = SKAction.wait(forDuration: 1.0)
        let secondPause = SKAction.wait(forDuration: 3.0)
        
        bird.run(firstPause){
            self.bird.physicsBody?.isDynamic = true
            self.bird.physicsBody?.velocity = CGVector(dx:0,dy:0)
            self.bird.physicsBody?.applyImpulse(CGVector(dx:-5,dy:150))
            self.bird.run(secondPause,completion:{
                
                self.removeAllChildren()
                self.removeAllActions()
                
                let scene = GameScene(fileNamed:"GameScene")
                scene?.scaleMode = .aspectFill
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
                self.view?.presentScene(scene!,transition:transition)
            
        })
        
    }
    }
    
}
