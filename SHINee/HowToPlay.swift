//
//  HowToPlay.swift
//  SHINee
//
//  Created by Connie Waffles on 17/08/2019.
//  Copyright © 2019 Connie Waffles. All rights reserved.
//

import SpriteKit

class HowToPlay: SKScene {
    
    override func didMove(to view: SKView) {
        
        let titleLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        titleLabel.text = "How to play"
        titleLabel.color = .black
        titleLabel.position.x = 360
        titleLabel.position.y = 280
        
        let tutorialLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        tutorialLabel.text = "Match three of the same face in a row to score 3 points!"
        tutorialLabel.color = .black
        tutorialLabel.position.x = 400
        tutorialLabel.position.y = 250
        
        let firstTutorialLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        firstTutorialLabel.text = "You can tilt the screen to move the faces around aswell!"
        firstTutorialLabel.color = .black
        firstTutorialLabel.position.x = 400
        firstTutorialLabel.position.y = 220
        
        let secondTutorialLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        secondTutorialLabel.text = "To gain powerups match more than 10 faces in a row!"
        secondTutorialLabel.color = .black
        secondTutorialLabel.position.x = 400
        secondTutorialLabel.position.y = 190
        
        let next = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        next.text = "NEXT"
        next.color = .black
        next.position.x = 600
        next.position.y = 50
        next.name = "next"
        
        addChild(titleLabel)
        addChild(tutorialLabel)
        addChild(firstTutorialLabel)
        addChild(secondTutorialLabel)
        addChild(next)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
            
            for node in nodesarray {
                if node.name == "next" {
                    let myScene = HelpScene(fileNamed: "HelpScene")
                    self.scene?.view?.presentScene(myScene!)
                }
            }
        }
        
    }
    
}
