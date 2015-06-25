//
//  GameScene.swift
//  jogo
//
//  Created by bsi ccet on 20/05/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit

class Perdeu: SKScene, SKPhysicsContactDelegate{
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var spText1 = SKLabelNode(fontNamed: "Copperplate")
        var spText2 = SKLabelNode(fontNamed: "Copperplate")
        var spText3 = SKLabelNode(fontNamed: "Copperplate")
        spText1.fontSize = 35
        spText1.text = "You"
        spText1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200)
        addChild(spText1)
        
        spText2.fontSize = 35
        spText2.text = "Lose!"
        spText2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+160)
        addChild(spText2)
        
        spText3.fontSize = 20
        spText3.text = "Play again?"
        spText3.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+130)
        addChild(spText3)
        
        var button = SKSpriteNode(imageNamed: "start.jpg")
        button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+80)
        button.name = "previousButton"
        button.setScale(0.5)
        self.addChild(button)
        backgroundColor = SKColor.blackColor()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var touch: UITouch = touches.anyObject() as UITouch
        var location = touch.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If previous button is touched, start transition to previous scene
        if (node.name == "previousButton") {
            var gameScene = Fase1_Intro(size: self.size)
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
}