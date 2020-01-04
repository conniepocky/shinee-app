//
//  SecondScene.swift
//  SHINee
//
//  Created by Connie Waffles on 09/06/2019.
//  Copyright © 2019 Connie Waffles. All rights reserved.


import SpriteKit
import GameplayKit
import CoreMotion

class Ball: SKSpriteNode { }

class SecondScene: SKScene {
    
    func restart(){
        print("ran restart function")
        let myScene = GameScene(fileNamed: "GameScene")
        self.scene?.view?.presentScene(myScene!)
    }

    var balls = ["key-1", "minho-1", "taemin-1", "onew-1", "jonghyun"]
    var motionManager: CMMotionManager?
    
    let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    var matchedBalls = Set<Ball>()
    
    var backgrounds = ["taemin", "minho", "key", "jjonggg", "onew"]
    
    // power ups
    
    var extraPoints = 0
    
    // timer
    
    let levelTimerLabel = SKLabelNode(fontNamed: "Chalkduster")
    var levelTimerValue: Int  = 500

    var levelTimer = Timer()

    func startLevelTimer() {

        levelTimerLabel.fontColor = SKColor.black
        levelTimerLabel.fontSize = 40
        levelTimerLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 350)
        addChild(levelTimerLabel)

        levelTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("levelCountdown")), userInfo: nil, repeats: true)

        levelTimerLabel.text = String(levelTimerValue)

    }
    
    var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedScore = formatter.string(from: score as NSNumber) ?? "0"
            scoreLabel.text = "SCORE: \(formattedScore)"
        }
    }
    
    func levelCountdown(){

        levelTimerValue -= 1

    }
    
    func playSound(sound : String) {
        
        var sound = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
        
        run(sound)
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: backgrounds.randomElement()!)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.zPosition = -1
        addChild(background)
        
        let back = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        back.fontSize = 25
        back.position = CGPoint(x: 20, y: 350)
        back.text = "BACK"
        back.zPosition = 100
        back.horizontalAlignmentMode = .left
        back.name = "back"
        addChild(back)
        
        scoreLabel.fontSize = 72
        scoreLabel.position = CGPoint(x: 20, y: 20)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.zPosition = 100
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        addChild(levelTimerLabel)
        
        let ball = SKSpriteNode(imageNamed: "ballBlue")
        let ballRadius = ball.frame.width / 2.0
        
        for i in stride(from: ballRadius, to: view.bounds.width - ballRadius, by: ball.frame.width) {
            for j in stride(from: 100, to: view.bounds.height - ballRadius, by: ball.frame.height) {
                let ballType = balls.randomElement()!
                let ball = Ball(imageNamed: ballType)
                ball.position = CGPoint(x: i, y: j)
                ball.name = ballType
                
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
                ball.physicsBody?.allowsRotation = false
                ball.physicsBody?.restitution = 0
                ball.physicsBody?.friction = 0
                
                addChild(ball)
            }
        }
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)))
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
    }
    
    func getMatches(from startBall: Ball) {
        let matchWidth = startBall.frame.width * startBall.frame.width * 1.1
        
        for node in children {
            guard let ball = node as? Ball else { continue }
            guard ball.name == startBall.name else { continue }
            
            let dist = distance(from: startBall, to: ball)
            
            guard dist < matchWidth else { continue }
            
            if !matchedBalls.contains(ball) {
                matchedBalls.insert(ball)
                getMatches(from: ball)
            }
        }
    }
    
    
    func distance(from: Ball, to: Ball) -> CGFloat {
        return (from.position.x - to.position.x) * (from.position.x - to.position.x) + (from.position.y - to.position.y) * (from.position.y - to.position.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
            
            for node in nodesarray {
                if node.name == "back" {
        
                    restart()
                    
                } else if node.name == "jonghyun" || node.name == "key-1" || node.name == "onew-1" || node.name == "minho-1" || node.name == "taemin-1" {
                    
                    guard let position = touches.first?.location(in: self) else { return }
                    guard let tappedBall = nodes(at: position).first(where: { $0 is Ball }) as? Ball else { return }
                    
                    matchedBalls.removeAll(keepingCapacity: true)
                    
                    getMatches(from: tappedBall)
                    
                    if matchedBalls.count >= 2 {
                        score += matchedBalls.count
                        
                        if tappedBall.name == "jonghyun" {
                            score += extraPoints
                        }
                        
                        for ball in matchedBalls {
                            if let particles = SKEmitterNode(fileNamed: "Explosion") {
                                particles.position = ball.position
                                addChild(particles)
                                
                                let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
                                particles.run(removeAfterDead)
                            }
                            
                            ball.removeFromParent()
                        }
                    }
                    
                    if matchedBalls.count >= 10 && extraPoints == 0{
                        extraPoints = 3
                        
                        let powerup = SKSpriteNode(imageNamed: "shinee power up")
                        powerup.size = CGSize(width: 900, height: 400)
                        powerup.position = CGPoint(x: frame.midX, y: frame.midY)
                        powerup.zPosition = 100
                        powerup.xScale = 0.001
                        powerup.yScale = 0.001
                        addChild(powerup)
                        
                        let appear = SKAction.group([SKAction.scale(to: 1, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])
                        let disappear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
                        let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 3), disappear, SKAction.removeFromParent()])
                        
                        powerup.run(sequence)
                    }
                    
                    if score >= 150 {
                        let win = SKSpriteNode(imageNamed: "shinee yay")
                        win.position = CGPoint(x: frame.midX, y: frame.midY)
                        win.zPosition = 100
                        win.xScale = 0.001
                        win.yScale = 0.001
                        addChild(win)
                        
                        let appear = SKAction.group([SKAction.scale(to: 1, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])
                        let disappear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
                        let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 0.25), disappear, SKAction.removeFromParent()])
                        
                        win.run(sequence)
                        
                        sleep(3)
                        
                        restart()
                    }
                    
                    if matchedBalls.count >= 15 {
                        
                        if tappedBall.name == "key-1" {
                            playSound(sound: "key.wav")
                        } else if tappedBall.name == "jonghyun" {
                            playSound(sound: "dino.wav")
                        } else if tappedBall.name == "minho-1" {
                            playSound(sound: "ming.wav")
                        } else if tappedBall.name == "onew-1" {
                            playSound(sound: "onew.wav")
                        } else if tappedBall.name == "taemin-1" {
                            playSound(sound: "taem.wav")
                        }
                        
                        let wow = SKSpriteNode(imageNamed: "wow")
                        wow.position = CGPoint(x: frame.midX, y: frame.midY)
                        wow.zPosition = 100
                        wow.xScale = 0.001
                        wow.yScale = 0.001
                        addChild(wow)
                        
                        let appear = SKAction.group([SKAction.scale(to: 1, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])
                        let disappear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
                        let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 0.25), disappear, SKAction.removeFromParent()])
                        
                        wow.run(sequence)
                    }
                }
            }
        }
    }
    
}
