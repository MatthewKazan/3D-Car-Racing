//
//  Overlay.swift
//  3dTest
//
//  Created by matt kazan on 5/21/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import AVFoundation

class Overlay: SKScene {
    
    var player: AVAudioPlayer?

    var buttonBack:SKSpriteNode!
    var buttonBackR:SKSpriteNode!
    var buttonBackJ:SKSpriteNode!
    var buttonBackB:SKSpriteNode!
    var buttonBackRe:SKSpriteNode!
    var bbb:SKSpriteNode!

    var overlayScene = SKScene()
    
    var fOrB = true
    var move = false
    var jet = false
    var brake = true
    var gameState = 0
    
    var drive:SKLabelNode!
    var reverse:SKLabelNode!
    
    var j:SKLabelNode!
    var br:SKLabelNode!
    
    var reset:SKLabelNode!
    
    var resetB = false

    
    let emitter = SKEmitterNode(fileNamed: "particle")
    let emitter2 = SKEmitterNode(fileNamed: "particle")

     let colors = [SKColor.red,SKColor.blue,SKColor.green,SKColor.red,SKColor.black]
    var s:CGSize!
    
    override init(size: CGSize) {
        super.init(size: size)
        s = size
        self.backgroundColor = UIColor.red
        let xCenter = size.width/2
        let yCenter = size.height/2
        overlayScene.scaleMode = .aspectFill
        MusicHelper.sharedHelper.clang()

        self.bbb = SKSpriteNode(color: UIColor.clear, size: size)
        self.bbb.zPosition = 1
        self.bbb.position = CGPoint(x: xCenter, y: yCenter)

        self.buttonBackR = SKSpriteNode(color: UIColor.red, size: CGSize(width: 200, height: 65))
        self.buttonBackR.position = CGPoint(x: xCenter, y: yCenter + 300)
        self.buttonBackR.zPosition = 2
        
        self.buttonBackRe = SKSpriteNode(color: UIColor.red, size: CGSize(width: 200, height: 65))
        self.buttonBackRe.position = CGPoint(x: xCenter + 300, y: yCenter + 300)
        self.buttonBackRe.zPosition = 2


        self.buttonBack = SKSpriteNode(color: UIColor.green, size: CGSize(width: 200, height: 65))
        self.buttonBack.position = CGPoint(x: xCenter, y: yCenter + 100)
        self.buttonBack.zPosition = 2

        self.buttonBackJ = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 200, height: 65))
        self.buttonBackJ.position = CGPoint(x: xCenter, y: yCenter - 100)
        self.buttonBackJ.zPosition = 2

        self.buttonBackB = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 200, height: 65))
        self.buttonBackB.position = CGPoint(x: xCenter, y: yCenter - 300)
        self.buttonBackB.zPosition = 2



        
        self.drive = SKLabelNode(text: "Track: 2")
        self.drive.fontName = "DINAlternate-Bold"
        self.drive.fontColor = UIColor.black
        self.drive.fontSize = 50
        self.drive.position = CGPoint(x: xCenter, y: yCenter + 80)
        self.drive.zPosition = 3

        self.reverse = SKLabelNode(text: "Track: 1")
        self.reverse.fontName = "DINAlternate-Bold"
        self.reverse.fontColor = UIColor.black
        self.reverse.fontSize = 50
        self.reverse.position = CGPoint(x: xCenter, y: yCenter + 280)
        self.reverse.zPosition = 3
        
        self.j = SKLabelNode(text: "Track: 3")
        self.j.fontName = "DINAlternate-Bold"
        self.j.fontColor = UIColor.black
        self.j.fontSize = 50
        self.j.position = CGPoint(x: xCenter, y: yCenter - 120)
        self.j.zPosition = 3
        
        self.br = SKLabelNode(text: "Track: 4")
        self.br.fontName = "DINAlternate-Bold"
        self.br.fontColor = UIColor.black
        self.br.fontSize = 50
        self.br.position = CGPoint(x: xCenter, y: yCenter - 320)
        self.br.zPosition = 3
        
        self.reset = SKLabelNode(text: "Reset")
        self.reset.fontName = "DINAlternate-Bold"
        self.reset.fontColor = UIColor.black
        self.reset.fontSize = 50
        self.reset.position = CGPoint(x: xCenter + 300, y: yCenter + 280)
        self.reset.zPosition = 3
        
        self.addChild(self.buttonBack)
        self.addChild(self.buttonBackR)
        self.addChild(self.buttonBackJ)
        self.addChild(self.buttonBackB)
        self.addChild(self.drive)
        self.addChild(self.reverse)
        self.addChild(self.j)
        self.addChild(self.br)
        self.addChild(self.reset)
        self.addChild(self.buttonBackRe)
        self.addChild(bbb)
        
        self.view?.isMultipleTouchEnabled = true
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func didMove(to view: SKView) {

    }
    func startCon() {
        

        emitter?.removeFromParent()
        emitter2?.removeFromParent()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        emitter2!.position = CGPoint(x: s.width/4, y:s.height)
        emitter!.position = CGPoint(x: s.width/4 * 3, y:s.height)

        emitter!.particleColorSequence = nil
        emitter!.particleColorBlendFactor = 1.0
        
        emitter2!.particleColorSequence = nil
        emitter2!.particleColorBlendFactor = 1.0

        self.addChild(emitter!)
        self.addChild(emitter2!)


        let action = SKAction.run({
            [unowned self] in
            let random = Int(arc4random_uniform(UInt32(self.colors.count)))

            self.emitter!.particleColor = self.colors[random];
            self.emitter2!.particleColor = self.colors[random];

            print(random)
        })

        let wait = SKAction.wait(forDuration: 0.1)

        self.run(SKAction.repeatForever( SKAction.sequence([action,wait])))
        
    }
    func stopCon() {
        print("stop con")
        emitter?.removeAllActions()
        emitter!.position = CGPoint(x: 200, y: -s.height)
        
        emitter2?.removeAllActions()
        emitter2!.position = CGPoint(x: 200, y: -s.height)


        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("overlay touch")
       // let touch = touches.first as? UITouch
       
        for touch in touches {
            
            let location = touch.location(in: self)
            if gameState == 0 {
                if self.buttonBackR.contains(location) {
                    change()
                    gameState = 1
                    print("gamestate: " + String(gameState))


                }
                else if self.buttonBack.contains(location) {
                    change()
                    gameState = 1
                    print("gamestate: " + String(gameState))
                }
                else if self.buttonBackJ.contains(location) {
                    change()
                    gameState = 1
                    print("gamestate: " + String(gameState))
                }
                else if self.buttonBackB.contains(location) {
                    change()
                    gameState = 1
                    print("gamestate: " + String(gameState))
                }
            }
            else {
                if self.buttonBackRe.contains(location) {
                    fOrB = false
                     move = false
                    brake = false
                    resetB = true
                }
                if self.buttonBack.contains(location) {
                    fOrB = true
                    move = true
                    brake = false
                    MusicHelper.sharedHelper.clang()

                    print("text")

                }
                
                if self.buttonBackR.contains(location) {
                    fOrB = false
                     move = true
                    brake = false
                }
                if self.buttonBackJ.contains(location) {
                    jet = true
                    brake = false

                }
                if self.buttonBackB.contains(location) {
                    brake = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       print(touches)
        resetB = false
        for touch in touches {
            let location = touch.location(in: self)

            if self.buttonBack.contains(location) {
                move = false
                MusicHelper.sharedHelper.stop()

            }
            
            if self.buttonBackR.contains(location) {
                move = false

            }
            if self.buttonBackJ.contains(location) {
                jet = false


            }
            if self.buttonBackB.contains(location) {
                brake = false
            }
        }
        
    }
    func change() {

        self.backgroundColor = UIColor.red
        let xCenter = size.width/2
        let yCenter = size.height/2
        overlayScene.scaleMode = .aspectFill
        
        self.bbb.color = UIColor.clear
        
        self.buttonBackR.position = CGPoint(x: xCenter + 470, y: yCenter - 200)
        self.buttonBackR.size = CGSize(width: 85, height: 85)

        self.buttonBack.position = CGPoint(x: xCenter + 470, y: yCenter - 100)
        self.buttonBack.size = CGSize(width: 85, height: 85)
        
        self.buttonBackJ.position = CGPoint(x: xCenter - 470, y: yCenter - 100)
        self.buttonBackJ.size = CGSize(width: 85, height: 85)
        
        self.buttonBackB.position = CGPoint(x: xCenter - 470, y: yCenter - 200)
        self.buttonBackB.size = CGSize(width: 85, height: 85)



        self.drive.text = "D"
        self.drive.fontName = "DINAlternate-Bold"
        self.drive.fontColor = UIColor.black
        self.drive.fontSize = 50
        self.drive.position = CGPoint(x: xCenter + 470, y: yCenter - 120)
        self.drive.zPosition = 3

        self.reverse.text = "R"
        self.reverse.fontName = "DINAlternate-Bold"
        self.reverse.fontColor = UIColor.black
        self.reverse.fontSize = 50
        self.reverse.position = CGPoint(x: xCenter + 470, y: yCenter - 220)
        self.reverse.zPosition = 3
        
        self.j.text = "Jet"
        self.j.fontName = "DINAlternate-Bold"
        self.j.fontColor = UIColor.black
        self.j.fontSize = 50
        self.j.position = CGPoint(x: xCenter - 470, y: yCenter - 120)
        self.j.zPosition = 3
        
        self.br.text = "B"
        self.br.fontName = "DINAlternate-Bold"
        self.br.fontColor = UIColor.black
        self.br.fontSize = 50
        self.br.position = CGPoint(x: xCenter - 470, y: yCenter - 220)
        self.br.zPosition = 3
        bbb.removeFromParent()
        print("change ended")

        
    }
    func game0() {
        let xCenter = size.width/2
        let yCenter = size.height/2
        
        MusicHelper.sharedHelper.stop()
        gameState = 0
        
        self.bbb = SKSpriteNode(color: UIColor.clear, size: size)
        self.bbb.zPosition = 1
        self.bbb.position = CGPoint(x: xCenter, y: yCenter)
        self.addChild(bbb)
           
        self.buttonBackR.size = CGSize(width: 200, height: 65)
        self.buttonBackR.position = CGPoint(x: xCenter, y: yCenter + 300)
        self.buttonBackR.zPosition = 2

        self.buttonBack.size = CGSize(width: 200, height: 65)
        self.buttonBack.position = CGPoint(x: xCenter, y: yCenter + 100)
        self.buttonBack.zPosition = 2

        self.buttonBackJ.size = CGSize(width: 200, height: 65)
        self.buttonBackJ.position = CGPoint(x: xCenter, y: yCenter - 100)
        self.buttonBackJ.zPosition = 2

        self.buttonBackB.size = CGSize(width: 200, height: 65)
        self.buttonBackB.position = CGPoint(x: xCenter, y: yCenter - 300)
        self.buttonBackB.zPosition = 2



           
        self.drive.text = "Track: 2"
        self.drive.fontName = "DINAlternate-Bold"
        self.drive.fontColor = UIColor.black
        self.drive.fontSize = 50
        self.drive.position = CGPoint(x: xCenter, y: yCenter + 80)
        self.drive.zPosition = 3
        
        self.reverse.text = "Track: 1"
        self.reverse.fontName = "DINAlternate-Bold"
        self.reverse.fontColor = UIColor.black
        self.reverse.fontSize = 50
        self.reverse.position = CGPoint(x: xCenter, y: yCenter + 280)
        self.reverse.zPosition = 3
    
        self.j.text = "Track: 3"
        self.j.fontName = "DINAlternate-Bold"
        self.j.fontColor = UIColor.black
        self.j.fontSize = 50
        self.j.position = CGPoint(x: xCenter, y: yCenter - 120)
        self.j.zPosition = 3
        
        self.br.text = "Track: 4"
        self.br.fontName = "DINAlternate-Bold"
        self.br.fontColor = UIColor.black
        self.br.fontSize = 50
        self.br.position = CGPoint(x: xCenter, y: yCenter - 320)
        self.br.zPosition = 3
    }
    func direction() -> Bool {
        return fOrB
    }
    func moving() -> Bool {
        return move
    }
    func jetOn() -> Bool {
        return jet
        
    }
    func braking() -> Bool{
        return brake
    }
    func check() -> Int{
        print("gamestate: " + String(gameState))

        return gameState
    }
    func changeState(to: Int) {
        gameState = to
        print("changed to: " + String(gameState))

    }
    func r() -> Bool {
        return resetB
    }
}
