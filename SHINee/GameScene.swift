//
//  GameScene.swift
//  SHINee
//
//  Created by Connie Waffles on 16/05/2019.
//  Copyright © 2019 Connie Waffles. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
     
        let button = SKSpriteNode(imageNamed: "play.png")
        button.position = CGPoint(x: self.frame.size.width/2, y: 760)
        button.size = CGSize(width: 500, height: 150)
        button.name = "playButton"
        
        let helpButton = SKSpriteNode(imageNamed: "help.png")
        helpButton.position = CGPoint(x: self.frame.size.width/2, y: 600)
        helpButton.size = CGSize(width: 500, height: 150)
        helpButton.name = "helpButton"
        
        self.addChild(helpButton)
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
            
            for node in nodesarray {
                if node.name == "playButton" {
                    let myScene = SecondScene(fileNamed: "SecondScene")
                    self.scene?.view?.presentScene(myScene!)
                }
            }
            
            for node in nodesarray {
                if node.name == "helpButton" {
                    let myScene = HowToPlay(fileNamed: "HowToPlay")
                    self.scene?.view?.presentScene(myScene!)
                }
            }
        }
    }
    
}
