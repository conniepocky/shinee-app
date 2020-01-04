//
//  HelpScene.swift
//  SHINee
//
//  Created by Connie Waffles on 11/07/2019.
//  Copyright © 2019 Connie Waffles. All rights reserved.
//

import SpriteKit

class HelpScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let sample = SKVideoNode(fileNamed: "tutorial.mov")
        sample.position = CGPoint(x: frame.midX,
                                  y: frame.midY)
        
        let helpLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        helpLabel.text = "DEMO VIDEO ^"
        helpLabel.color = .black
        helpLabel.position.x = 150
        helpLabel.position.y = -150
        
        let tapLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        tapLabel.text = "Tap when your ready to play!"
        tapLabel.color = .black
        tapLabel.position.x = 150
        tapLabel.position.y = -175  
        
        addChild(helpLabel)
        addChild(tapLabel)
        addChild(sample)
        sample.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myScene = SecondScene(fileNamed: "SecondScene")
        self.scene?.view?.presentScene(myScene!)
        
    }
}
