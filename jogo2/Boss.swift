//
//  GameScene.swift
//  jogo
//
//  Created by bsi ccet on 20/05/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit

class Boss: SKScene, SKPhysicsContactDelegate{
    var nave = SKSpriteNode(imageNamed: "Spaceship")
    var boss = SKSpriteNode(imageNamed: "boss_1")
    var tiro = SKShapeNode()
    var baseOrigin = CGPoint(x:0, y:0)
    var score: Int = 0
    var shipHealth: Float = 100.0
    var bossHealth: Float = 100.0
    var healthLabel = SKLabelNode(fontNamed: "Courier")
    var bossHealthLabel = SKLabelNode(fontNamed: "Courier")
    var scoreLabel = SKLabelNode(fontNamed: "Courier")
    
    func killNave(nave: SKNode){
        self.nave.color = UIColor.redColor()
        var acaoBlink = SKAction.sequence([SKAction(self.nave.colorBlendFactor = 0.5), SKAction.waitForDuration(3.0/60.0),SKAction.runBlock {
            self.nave.colorBlendFactor = 0
            }])
        self.runAction(acaoBlink)
    }
    
    func killBoss() {
        self.boss.color = UIColor.redColor()
        var acaoBlink = SKAction.sequence([SKAction(self.boss.colorBlendFactor = 0.8), SKAction.waitForDuration(3.0/60.0),SKAction.runBlock {
            self.boss.colorBlendFactor = 0
            }])
        self.runAction(acaoBlink)
    }
    
    func removeTiro(tiro: SKNode) {
        self.removeChildrenInArray([tiro])
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var a = contact.bodyA
        var b = contact.bodyB
        if (a.categoryBitMask == PhysicsCategory.Inimigo && b.categoryBitMask == PhysicsCategory.TiroNave) {
            if(a.node != nil && b.node != nil){
                removeTiro(b.node!)
                killBoss()
                adjustScoreBy(100)
                adjustBossHealthBy(-4.53)
                criaTiroNave()
            }
        } else if(b.categoryBitMask == PhysicsCategory.Inimigo && a.categoryBitMask == PhysicsCategory.TiroNave){
            if(b.node != nil && a.node != nil){
                removeTiro(a.node!)
                killBoss()
                adjustScoreBy(100)
                adjustBossHealthBy(-4.53)
                criaTiroNave()
            }
        } else if(a.categoryBitMask == PhysicsCategory.Nave && b.categoryBitMask == PhysicsCategory.TiroInimigo){
            if(b.node != nil && a.node != nil){
                //removeTiro(b.node!)
                killNave(a.node!)
                adjustShipHealthBy(-3.534)
            }
        } else if(b.categoryBitMask == PhysicsCategory.Nave && a.categoryBitMask == PhysicsCategory.TiroInimigo){
            if(b.node != nil && a.node != nil){
                //removeTiro(a.node!)
                killNave(b.node!)
                adjustShipHealthBy(-3.534)
            }
        } else if(a.categoryBitMask == PhysicsCategory.Inimigo && b.categoryBitMask == PhysicsCategory.LimiteY){
            var gameScene = Perdeu(size: self.size)
            var transition = SKTransition.crossFadeWithDuration(0.2)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        } else if(b.categoryBitMask == PhysicsCategory.Inimigo && a.categoryBitMask == PhysicsCategory.LimiteY){
            var gameScene = Perdeu(size: self.size)
            var transition = SKTransition.crossFadeWithDuration(0.2)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func adjustScoreBy(points: Int) {
        self.score += points
        scoreLabel.text = String(format: "Score: %04u", self.score)
    }
    
    func adjustShipHealthBy(healthAdjustment: Float) {
        self.shipHealth = max(self.shipHealth + healthAdjustment, 0)
        healthLabel.text = String(format: "Health: %.1f%%", self.shipHealth)
        if(self.shipHealth == 0){
            var gameScene = Perdeu(size: self.size)
            var transition = SKTransition.crossFadeWithDuration(0.2)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func adjustBossHealthBy(healthAdjustment: Float) {
        self.bossHealth = max(self.bossHealth + healthAdjustment, 0)
        bossHealthLabel.text = String(format: "Enemy Health: %.1f%%", self.bossHealth)
        if(self.bossHealth == 0){
            var gameScene = Ganhou(size: self.size)
            var transition = SKTransition.crossFadeWithDuration(0.2)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func setupHud() {
        scoreLabel.fontSize = 15
        scoreLabel.text = String(format: "Score: %04u", 0)
        scoreLabel.position = CGPoint(x:baseOrigin.x-100, y:baseOrigin.y + 350)
        addChild(scoreLabel)
        
        healthLabel.fontSize = 15
        healthLabel.text = String(format: "Health: %.1f%%", self.shipHealth)
        healthLabel.position = CGPoint(x:baseOrigin.x+80, y:baseOrigin.y + 350)
        addChild(healthLabel)
        
        bossHealthLabel.fontSize = 15
        bossHealthLabel.text = String(format: "Enemy Health: %.1f%%", self.bossHealth)
        bossHealthLabel.position = CGPoint(x:baseOrigin.x+80, y:baseOrigin.y + 330)
        addChild(bossHealthLabel)
    }
    
    func criaTiroNave(){
        var rectFull = CGRectMake(0, 0, 2, 10)
        tiro = SKShapeNode(rect: rectFull)
        //tiro.path = CGPathCreateWithRect(rectFull, nil)
        tiro.fillColor = UIColor.greenColor()
        tiro.strokeColor = UIColor.greenColor()
        tiro.position = CGPointMake(nave.position.x - 1, nave.position.y + 10)
        
        var destino = CGPointMake(nave.position.x, self.size.height)
        var acaoTiro = SKAction.sequence([SKAction.moveToY(destino.y, duration: 1.3), SKAction.waitForDuration(3.0/60.0),SKAction.runBlock {
            self.tiro.position = CGPointMake(self.nave.position.x - 1, self.nave.position.y + 10)
            }])
        var acaoTiroLoop = SKAction.repeatActionForever(acaoTiro)
        
        tiro.runAction(acaoTiroLoop)
        
        self.addChild(tiro)
        
        tiro.physicsBody = SKPhysicsBody(polygonFromPath: tiro.path)
        tiro.physicsBody?.dynamic = false
        tiro.physicsBody?.categoryBitMask = PhysicsCategory.TiroNave
        tiro.physicsBody?.contactTestBitMask = PhysicsCategory.Inimigo
        tiro.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func criaTiroBoss(){
        var duracao = 0.2
        var distancia:CGFloat = 1
        for(var i = 1; i < 20; i++){
            distancia += 1
            var _position = CGPointMake(0,0)
            if(i < 10){
                _position = CGPointMake(boss.position.x-40+(distancia*10), boss.position.y-20-distancia)
            } else{
                _position = CGPointMake(boss.position.x+5+(distancia*10), boss.position.y-20-distancia)
            }
            
            var tiroWidth:CGFloat = 1.0
            var rectFull = CGRectMake(0, 0, 2, 10)
            var tiroBoss = SKShapeNode()
            tiroBoss.path = CGPathCreateWithRect(rectFull, nil)
            tiroBoss.fillColor = UIColor.whiteColor()
            tiroBoss.position = _position
            
            var destino = CGPointMake(boss.position.x, -self.frame.height/2)
            var posicaoInicial = tiroBoss.position
            
            var acaoTiro = SKAction.sequence([SKAction.moveToY(destino.y, duration: 4), SKAction.waitForDuration(duracao)])
            var acaoTiroLoop = SKAction.repeatActionForever(acaoTiro)
            tiroBoss.runAction(acaoTiro)
            
           var teste = SKAction.sequence([SKAction.waitForDuration(duracao), SKAction.runBlock {
                self.addChild(tiroBoss)
            }])
            boss.runAction(teste)
            
            tiroBoss.physicsBody = SKPhysicsBody(polygonFromPath: tiroBoss.path)
            tiroBoss.physicsBody?.dynamic = false
            tiroBoss.physicsBody?.categoryBitMask = PhysicsCategory.TiroInimigo
            tiroBoss.physicsBody?.contactTestBitMask = PhysicsCategory.Nave
            nave.physicsBody?.collisionBitMask = 0
        }
    }
    
    func criaBoss(){
        var posicaoInicialInimigo = CGPoint(x:baseOrigin.x-130, y:baseOrigin.y+250)
        var y = posicaoInicialInimigo.y
        var x = posicaoInicialInimigo.x
        var duracaoAcaoMoveHorizontal = 1.0
        
        var acaoTrocaTextura = SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock {
            self.boss.texture = SKTexture(imageNamed: "boss_2")
            }, SKAction.waitForDuration(0.7), SKAction.runBlock {
                self.boss.texture = SKTexture(imageNamed: "boss_3")
            }, SKAction.waitForDuration(0.7), SKAction.runBlock {
                self.boss.texture = SKTexture(imageNamed: "boss_1")
            }])
        var acaoTrocaTexturaLoop = SKAction.repeatActionForever(acaoTrocaTextura)
        boss.runAction(acaoTrocaTexturaLoop)
        boss.position = CGPoint(x:x, y:y)
        boss.setScale(0.7)
        //boss.color = UIColor.blueColor()
        //boss.colorBlendFactor = 1
        
        var acaoMoveDireita = SKAction.moveByX(50, y: 0, duration: duracaoAcaoMoveHorizontal)
        var acaoMoveEsquerda = SKAction.moveByX(-50, y: 0, duration: duracaoAcaoMoveHorizontal)
        var acaoMoveBaixo = SKAction.moveByX(0, y: -5, duration: 0.1)
        
        var acaoSequencia = SKAction.sequence([acaoMoveDireita,acaoMoveDireita,acaoMoveDireita,acaoMoveDireita,acaoMoveDireita,acaoMoveBaixo,acaoMoveEsquerda,acaoMoveEsquerda,acaoMoveEsquerda,acaoMoveEsquerda,acaoMoveEsquerda,acaoMoveBaixo])
        var acaoHorizontalLoop = SKAction.repeatActionForever(acaoSequencia)
        
        boss.runAction(acaoHorizontalLoop)
        
        self.addChild(boss)
        
        boss.physicsBody = SKPhysicsBody(rectangleOfSize: boss.size)
        boss.physicsBody?.dynamic = true
        boss.physicsBody?.categoryBitMask = PhysicsCategory.Inimigo
        boss.physicsBody?.contactTestBitMask = PhysicsCategory.TiroNave
        boss.physicsBody?.collisionBitMask = 0
        
        var acaoTiroBoss = SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.runBlock { self.criaTiroBoss() }])
        var acaoTiroBossLoop = SKAction.repeatActionForever(acaoTiroBoss)
        boss.runAction(acaoTiroBossLoop)
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        nave = SKSpriteNode(imageNamed: "Spaceship")
        baseOrigin = CGPoint(x:size.width/2, y:size.height/2)
        nave.position = CGPoint(x:baseOrigin.x, y:baseOrigin.y - 200)
        nave.setScale(0.35)
        nave.physicsBody = SKPhysicsBody(rectangleOfSize: nave.size)
        nave.physicsBody?.categoryBitMask = PhysicsCategory.Nave
        nave.physicsBody?.contactTestBitMask = PhysicsCategory.TiroInimigo | PhysicsCategory.Inimigo
        nave.physicsBody?.collisionBitMask = 0
        self.addChild(nave)
        
        criaTiroNave()
        
        criaBoss()
        
        var linhaLimiteY = SKShapeNode(rect: CGRectMake(0, 0, frame.maxX, 1000))
        linhaLimiteY.position = CGPointMake(frame.minX, frame.minY-850)
        linhaLimiteY.fillColor = UIColor.brownColor()
        linhaLimiteY.strokeColor = UIColor.greenColor()
        self.addChild(linhaLimiteY)
        
        linhaLimiteY.physicsBody = SKPhysicsBody(polygonFromPath: linhaLimiteY.path)
        linhaLimiteY.physicsBody?.dynamic = false
        linhaLimiteY.physicsBody?.categoryBitMask = PhysicsCategory.LimiteY
        linhaLimiteY.physicsBody?.contactTestBitMask = PhysicsCategory.Inimigo
        linhaLimiteY.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        
        setupHud()
        
        backgroundColor = SKColor.blackColor()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            var newLocation = touch.locationInNode(self)
            if(newLocation.y < baseOrigin.y && newLocation.x < baseOrigin.x+150 && newLocation.x > baseOrigin.x-120){
                var acaoMove = SKAction.moveTo(newLocation, duration: 0.1)
                nave.runAction(acaoMove)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}