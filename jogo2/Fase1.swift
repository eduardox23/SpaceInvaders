//
//  GameScene.swift
//  jogo
//
//  Created by bsi ccet on 20/05/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit


class Fase1: SKScene, SKPhysicsContactDelegate{
    var linhasInimigos = 6
    var colunasInimigos = 6
    var countInimigos = 6 * 6
    var nave = SKSpriteNode(imageNamed: "Spaceship")
    var tiro = SKShapeNode()
    var baseOrigin = CGPoint(x:0, y:0)
    var score: Int = 0
    var shipHealth: Float = 100.0
    var healthLabel = SKLabelNode(fontNamed: "Courier")
    var scoreLabel = SKLabelNode(fontNamed: "Courier")
    
    func killNave(nave: SKNode){
        self.nave.color = UIColor.redColor()
        var acaoBlink = SKAction.sequence([SKAction(self.nave.colorBlendFactor = 0.5), SKAction.waitForDuration(3.0/60.0),SKAction.runBlock {
            self.nave.colorBlendFactor = 0
            }])
        self.runAction(acaoBlink)
    }
    
    func killEnemy(inimigo: SKNode) {
        countInimigos -= 1
        var explosao = SKSpriteNode(imageNamed: "explodiu")
        self.removeChildrenInArray([inimigo])
        var acaoExplodiu = SKAction.sequence([SKAction.runBlock {
            explosao.position = inimigo.position
            explosao.setScale(0.38)
            self.addChild(explosao)
            }, SKAction.waitForDuration(0.2),SKAction.runBlock {
                self.removeChildrenInArray([explosao])
            }])
        self.runAction(acaoExplodiu)
        if(countInimigos == 0){
            var gameScene = Fase2_Intro(size: self.size)
            var transition = SKTransition.crossFadeWithDuration(0.2)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func removeTiro(tiro: SKNode) {
        self.removeChildrenInArray([tiro])
    }
    
    func criaInimigoDoTipo(tipo:String, posicao:CGPoint) -> SKSpriteNode{
        if(tipo == "A"){
            var texture = SKTexture(imageNamed: "et_3_1")
            var inimigo = SKSpriteNode(texture: texture)
            var acaoTrocaTextura = SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock {
                inimigo.texture = SKTexture(imageNamed: "et_3_2")
                }, SKAction.waitForDuration(0.7), SKAction.runBlock {
                    inimigo.texture = SKTexture(imageNamed: "et_3_1")
                }])
            var acaoTrocaTexturaLoop = SKAction.repeatActionForever(acaoTrocaTextura)
            inimigo.runAction(acaoTrocaTexturaLoop)
            inimigo.position = posicao
            inimigo.setScale(0.33)
            inimigo.color = UIColor.blueColor()
            inimigo.colorBlendFactor = 1
            criaTiroInimigo(inimigo)
            return inimigo
        }else{
            if(tipo == "B"){
                var texture = SKTexture(imageNamed: "et_2_1")
                var inimigo = SKSpriteNode(texture: texture)
                var acaoTrocaTextura = SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock {
                    inimigo.texture = SKTexture(imageNamed: "et_2_2")
                    }, SKAction.waitForDuration(0.7), SKAction.runBlock {
                        inimigo.texture = SKTexture(imageNamed: "et_2_1")
                    }])
                var acaoTrocaTexturaLoop = SKAction.repeatActionForever(acaoTrocaTextura)
                inimigo.runAction(acaoTrocaTexturaLoop)
                inimigo.position = posicao
                inimigo.setScale(0.3)
                inimigo.color = UIColor.redColor()
                inimigo.colorBlendFactor = 1
                criaTiroInimigo(inimigo)
                return inimigo
            }else{
                var texture = SKTexture(imageNamed: "et_1_1")
                var inimigo = SKSpriteNode(texture: texture)
                var acaoTrocaTextura = SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock {
                    inimigo.texture = SKTexture(imageNamed: "et_1_2")
                    }, SKAction.waitForDuration(0.7), SKAction.runBlock {
                        inimigo.texture = SKTexture(imageNamed: "et_1_1")
                    }])
                var acaoTrocaTexturaLoop = SKAction.repeatActionForever(acaoTrocaTextura)
                inimigo.runAction(acaoTrocaTexturaLoop)
                inimigo.position = posicao
                inimigo.setScale(0.3)
                inimigo.color = UIColor.yellowColor()
                inimigo.colorBlendFactor = 1
                criaTiroInimigo(inimigo)
                return inimigo
            }
            
        }
    }
    
    func criaTiroNave(){
        var tiroWidth:CGFloat = 1.0
        var rectFull = CGRectMake(0, 0, 2, 10)
        tiro = SKShapeNode()
        tiro.path = CGPathCreateWithRect(rectFull, nil)
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
        tiro.physicsBody?.dynamic = true
        tiro.physicsBody?.categoryBitMask = PhysicsCategory.TiroNave
        tiro.physicsBody?.contactTestBitMask = PhysicsCategory.Inimigo
        tiro.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func criaTiroInimigo(inimigo: SKSpriteNode){
        var tiroWidth:CGFloat = 1.0
        var rectFull = CGRectMake(0, 0, 2, 10)
        var tiroInimigo = SKShapeNode()
        tiroInimigo.path = CGPathCreateWithRect(rectFull, nil)
        tiroInimigo.fillColor = UIColor.whiteColor()
        tiroInimigo.position = CGPointMake(inimigo.position.x, inimigo.position.y - 10)
        
        var destino = CGPointMake(inimigo.position.x, -self.frame.height/2)
        
        var duracao = NSTimeInterval(2 + 20 * Float(arc4random()) / Float(UINT32_MAX))
        var acaoTiro = SKAction.sequence([SKAction.runBlock {
            if(inimigo.parent != nil){
                tiroInimigo.position = CGPointMake(inimigo.position.x, inimigo.position.y - 10)
            }
            }, SKAction.moveToY(destino.y, duration: 4), SKAction.waitForDuration(duracao)])
        var acaoTiroLoop = SKAction.repeatActionForever(acaoTiro)
        tiroInimigo.runAction(acaoTiroLoop)
        
        var wait = SKAction.sequence([SKAction.waitForDuration(duracao-2), SKAction.runBlock {
            self.addChild(tiroInimigo)
            }])
        inimigo.runAction(wait)
        
        tiroInimigo.physicsBody = SKPhysicsBody(polygonFromPath: tiroInimigo.path)
        tiroInimigo.physicsBody?.dynamic = true
        tiroInimigo.physicsBody?.categoryBitMask = PhysicsCategory.TiroInimigo
        tiroInimigo.physicsBody?.contactTestBitMask = PhysicsCategory.Nave
        tiroInimigo.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var a = contact.bodyA
        var b = contact.bodyB
        if (a.categoryBitMask == PhysicsCategory.Inimigo && b.categoryBitMask == PhysicsCategory.TiroNave) {
            if(a.node != nil && b.node != nil){
                removeTiro(b.node!)
                killEnemy(a.node!)
                adjustScoreBy(100)
                criaTiroNave()
            }
        } else if(b.categoryBitMask == PhysicsCategory.Inimigo && a.categoryBitMask == PhysicsCategory.TiroNave){
            if(b.node != nil && a.node != nil){
                removeTiro(a.node!)
                killEnemy(b.node!)
                adjustScoreBy(100)
                criaTiroNave()
            }
        } else if(a.categoryBitMask == PhysicsCategory.Nave && b.categoryBitMask == PhysicsCategory.TiroInimigo){
            if(b.node != nil && a.node != nil){
                removeTiro(b.node!)
                killNave(a.node!)
                adjustShipHealthBy(-3.534)
            }
        } else if(b.categoryBitMask == PhysicsCategory.Nave && a.categoryBitMask == PhysicsCategory.TiroInimigo){
            if(b.node != nil && a.node != nil){
                removeTiro(a.node!)
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
    
    func setupHud() {
        scoreLabel.fontSize = 15
        scoreLabel.text = String(format: "Score: %04u", 0)
        scoreLabel.position = CGPoint(x:baseOrigin.x-100, y:baseOrigin.y + 350)
        addChild(scoreLabel)
        
        healthLabel.fontSize = 15
        healthLabel.text = String(format: "Health: %.1f%%", self.shipHealth)
        healthLabel.position = CGPoint(x:baseOrigin.x+80, y:baseOrigin.y + 350)
        addChild(healthLabel)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
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
        
        var posicaoInicialInimigo = CGPoint(x:baseOrigin.x-130, y:baseOrigin.y+300)
        var distanciaEntreInimigos:CGFloat = 5.0
        var distanciaEntreInimigosVertial:CGFloat = 35
        
        var tipos = ["A", "B", "C"]
        var contadorTipos = 0;
        var y = posicaoInicialInimigo.y
        var x = posicaoInicialInimigo.x
        var duracaoAcaoMoveHorizontal = 1.0
        
        for(var i2=0; i2<linhasInimigos; i2++){
            
            for(var i=0; i<colunasInimigos; i++){
                x = posicaoInicialInimigo.x + distanciaEntreInimigos
                
                var inimigo = criaInimigoDoTipo(tipos[contadorTipos], posicao: CGPoint(x:x, y:y))
                var acaoMoveDireita = SKAction.moveByX(50, y: 0, duration: duracaoAcaoMoveHorizontal)
                var acaoMoveEsquerda = SKAction.moveByX(-50, y: 0, duration: duracaoAcaoMoveHorizontal)
                var acaoMoveBaixo = SKAction.moveByX(0, y: -5, duration: 0.1)
                
                var acaoSequencia = SKAction.sequence([acaoMoveDireita,acaoMoveBaixo,acaoMoveEsquerda,acaoMoveBaixo])
                var acaoHorizontalLoop = SKAction.repeatActionForever(acaoSequencia)
                
                
                inimigo.physicsBody = SKPhysicsBody(rectangleOfSize: inimigo.size)
                inimigo.physicsBody?.dynamic = true
                inimigo.physicsBody?.categoryBitMask = PhysicsCategory.Inimigo
                inimigo.physicsBody?.contactTestBitMask = PhysicsCategory.Nave
                inimigo.physicsBody?.collisionBitMask = PhysicsCategory.None
                
                
                inimigo.runAction(acaoHorizontalLoop)
                
                
                self.addChild(inimigo)
                
                
                distanciaEntreInimigos = distanciaEntreInimigos + 40
                
            }
            if(contadorTipos < 2){
                contadorTipos += 1
            }
            else{
                contadorTipos = 0
            }
            y  -= distanciaEntreInimigosVertial
            distanciaEntreInimigos = 5.0
            
        }
    
        
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
        
        
        
        
        criaTiroNave()
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