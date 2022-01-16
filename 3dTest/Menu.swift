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
import SceneKit

class Menu: SKScene {
    
    var buttonBack:SKSpriteNode!
    var buttonBackR:SKSpriteNode!
    var buttonBackJ:SKSpriteNode!
    var buttonBackB:SKSpriteNode!

    var menuScene = SCNScene()
    
    
    var gameState = 0
    var scnScene:SCNScene!
    
    var drive:SKLabelNode!
    var reverse:SKLabelNode!
    
    var j:SKLabelNode!
    var br:SKLabelNode!
    
    init(size: CGSize, view: SCNView) {
        super.init(size: size)
        print("menu")

        self.backgroundColor = UIColor.red
        let xCenter = size.width/2
        let yCenter = size.height/2
        //menuScene.scaleMode = .aspectFill
        

        
        self.buttonBackR = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 100))
        self.buttonBackR.position = CGPoint(x: xCenter, y: yCenter)

        self.buttonBack = SKSpriteNode(color: UIColor.green, size: CGSize(width: 65, height: 65))
        self.buttonBack.position = CGPoint(x: xCenter + 470, y: yCenter - 100)
        
        self.buttonBackJ = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 65, height: 65))
        self.buttonBackJ.position = CGPoint(x: xCenter - 470, y: yCenter - 100)
        
        self.buttonBackB = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 65, height: 65))
        self.buttonBackB.position = CGPoint(x: xCenter - 470, y: yCenter - 200)


        
        self.drive = SKLabelNode(text: "D")
        self.drive.fontName = "DINAlternate-Bold"
        self.drive.fontColor = UIColor.black
        self.drive.fontSize = 50
        self.drive.position = CGPoint(x: xCenter + 470, y: yCenter - 120)
        self.drive.zPosition = 3

        self.reverse = SKLabelNode(text: "Track: 1")
        self.reverse.fontName = "DINAlternate-Bold"
        self.reverse.fontColor = UIColor.black
        self.reverse.fontSize = 50
        self.reverse.position = CGPoint(x: xCenter, y: yCenter)
        self.reverse.zPosition = 3
        
        self.j = SKLabelNode(text: "Jet")
        self.j.fontName = "DINAlternate-Bold"
        self.j.fontColor = UIColor.black
        self.j.fontSize = 50
        self.j.position = CGPoint(x: xCenter - 470, y: yCenter - 120)
        self.j.zPosition = 3
        
        self.br = SKLabelNode(text: "B")
        self.br.fontName = "DINAlternate-Bold"
        self.br.fontColor = UIColor.black
        self.br.fontSize = 50
        self.br.position = CGPoint(x: xCenter - 470, y: yCenter - 220)
        self.br.zPosition = 3
        
        self.addChild(self.buttonBack)
        self.addChild(self.buttonBackR)
        self.addChild(self.buttonBackJ)
        self.addChild(self.buttonBackB)
        self.addChild(self.drive)
        self.addChild(self.reverse)
        self.addChild(self.j)
        self.addChild(self.br)
       // scnScene.overlaySKScene = menuScene
        
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
        let touch = touches.first as? UITouch
        let location = touch?.location(in: self)
        if self.buttonBack.contains(location!) {
          
            print("text")

        }
        else if self.buttonBackR.contains(location!) {
          gameState = 1
            print("execute")
        }
        else if self.buttonBackJ.contains(location!) {
            gameState = 1
        }
        else if self.buttonBackB.contains(location!) {
            gameState = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
    }
    
    func check() -> Int{
        return gameState
    }
    func getScene() -> SCNScene {
        return scnScene
    }
}
