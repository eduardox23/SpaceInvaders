//
//  GameScene.swift
//  jogo
//
//  Created by bsi ccet on 20/05/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit



class Fase2_Intro: SKScene{
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var spText1 = SKLabelNode(fontNamed: "Copperplate")
        var spText2 = SKLabelNode(fontNamed: "Copperplate")
        spText1.fontSize = 35
        spText1.text = "Level 2"
        spText1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200)
        addChild(spText1)
        
        spText2.fontSize = 35
        spText2.text = "Ready?"
        spText2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+160)
        addChild(spText2)
        
        var acaoChamaFase1 = SKAction.sequence([SKAction.waitForDuration(1),SKAction.runBlock {
            var gameScene = Fase2(size: self.size)
            var transition = SKTransition.crossFadeWithDuration(0.2)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }])
        self.runAction(acaoChamaFase1)
        
        backgroundColor = SKColor.blackColor()
    }

}
