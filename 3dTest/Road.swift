//
//  File.swift
//  3dTest
//
//  Created by matt kazan on 5/20/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import Foundation
import SceneKit
class Road: NSObject {
    var track = Array<SCNNode>()
    var pos = SCNVector3(15,0,-50)
    var count = 0
    var boxGeometry = SCNBox(width: 50, height: 2, length: 20, chamferRadius: 20.0)
    let boxGeometry2 = SCNBox(width: 100.0, height: 2, length: 20, chamferRadius: 20.0)
    var torus = SCNTorus(ringRadius: 100, pipeRadius: 20)
    var boxNode:SCNNode!
    init(i:Int){
        print("road")
        boxGeometry.firstMaterial?.diffuse.contents = "concrete.png"

        //boxGeometry2.firstMaterial?.diffuse.contents = UIImage(contentsOfFile: "ballDiffuse.jpg")
        pos.y = 0
        for x in -30...30 {

            boxNode = SCNNode(geometry: boxGeometry)
            
           
            let body = SCNPhysicsBody.static()
            body.friction = 0.1

            body.continuousCollisionDetectionThreshold = (CGFloat(0.001))

            boxNode.position = pos
            if x != 0
            {
                pos.z += 7 * Float(x)/abs(Float(x))
            }
            
            pos.x += 7
            boxNode.physicsBody = body
            boxNode.name = String(x)
           
            track.append(boxNode)
        }
        pos.y = 0
        for x in -30...30 {
            let boxNode = SCNNode(geometry: boxGeometry)
            let body = SCNPhysicsBody.static()
            body.continuousCollisionDetectionThreshold = (CGFloat(0.001))
            body.friction = 0.1

            boxNode.position = pos
            if x != 0
            {
                pos.z += 12
                pos.y += 7 * Float(-x)/abs(Float(x))
                boxNode.eulerAngles.x += .pi/6 * Float(x)/abs(Float(x))

            }
            else {
                pos.y -= 10
                pos.z += 20
                boxNode.eulerAngles.x += .pi/6 * Float(x)/abs(Float(x))

            }
            boxNode.physicsBody = body
            boxNode.name = String(x)
            track.append(boxNode)
        }
        
        pos.y = 0
        pos.z -= 17

        for x in -20...20 {
            let boxNode = SCNNode(geometry: boxGeometry)
            let body = SCNPhysicsBody.static()
            body.continuousCollisionDetectionThreshold = (CGFloat(0.001))
            body.friction = 0.1


            boxNode.position = pos
            if x != 0
            {
                pos.z += 7 * Float(-x)/abs(Float(x))

            }
            pos.x -= 7
            boxNode.physicsBody = body
            boxNode.name = String(x)
            track.append(boxNode)
        }
        pos.x -= 40
        let zCenter = pos.z
        let yCenter = Float(50)
        for x in stride(from: -1.6, to: 4.5, by: 0.1){
            let boxNode = SCNNode(geometry: boxGeometry)
            let boxNode2 = SCNNode(geometry: boxGeometry)
            let body = SCNPhysicsBody.static()
            body.continuousCollisionDetectionThreshold = (CGFloat(0.001))

            body.friction = 0.1
            //body.mass = 10000000
            let body2 = SCNPhysicsBody.static()
           // body2.mass = 10000000

            //pos.z += -abs(Float(x))
            //pos.y = (-sqrt(Float(10000) - Float(x * x)) + 20) * 10
            let y = (sqrt(10000 - Float(x*x)))
            pos.z = zCenter + cos(Float(x)) * 50
            pos.y = yCenter + sin(Float(x)) * 50
            pos.x = Float(x)*50 - 40//tan(boxNode.eulerAngles.y)

            //print(String(pos.z) + ", " + String(pos.y))
            //pos.z += abs(Float(x))
            boxNode.position = pos
            boxNode.physicsBody = body
            /*pos.z = zCenter + cos(Float(x))*100
            pos.y = yCenter + sin(Float(x))*100
            pos.x = Float(x)
            pos.z = zCenter + Float(x)
            pos.y = yCenter - y
            pos.x = boxNode.eulerAngles.x
            boxNode2.position = pos*/
            boxNode2.physicsBody = body2
            boxNode.eulerAngles.x = atan(-sin(Float(x))/cos(Float(x))) + .pi/2
            //boxNode.eulerAngles.x = atan(1/(-Float(x)/(sqrt(2500-(Float(x*x)))))) + .pi/2
           // boxNode2.eulerAngles.x = atan(1/(Float(x)/(sqrt(10000-(Float(x*x)))))) + .pi/2

            boxNode.name = String(x)
            track.append(boxNode)
            //track.append(boxNode2)
        }
        pos.x -= 300
        pos.y = 0
        for x in 0...10 {
            let boxNode = SCNNode(geometry: boxGeometry)
            let body = SCNPhysicsBody.static()
            body.continuousCollisionDetectionThreshold = (CGFloat(0.001))
            body.friction = 0.1


            boxNode.position = pos
          
            pos.z -= 7
            boxNode.physicsBody = body
            boxNode.name = String(x)
            track.append(boxNode)
        }
        for z in stride(from: 0, to: 1, by: 0.05) {
            let boxNode = SCNNode(geometry: boxGeometry)
            let body = SCNPhysicsBody.static()
            body.continuousCollisionDetectionThreshold = (CGFloat(0.001))
            body.friction = 0.1
            
            boxNode.position = pos
           
            pos.z -= Float(z) * 24
            pos.y += Float(z) * Float(z) * 24
            boxNode.eulerAngles.x = atan(  Float(z))  //+ .pi/2

           
            boxNode.physicsBody = body
            boxNode.name = String(z)
            track.append(boxNode)
        }
        pos.y = 10
        pos.z -= 100
        let boxNode = SCNNode(geometry: torus)
        //let body = SCNPhysicsBody.static()
        //body.continuousCollisionDetectionThreshold = (CGFloat(0.00001))
        
        boxNode.position = pos
        //boxNode.physicsBody = body
        
        track.append(boxNode)
        /*for x in 0...30 {
            let boxNode = SCNNode(geometry: boxGeometry)
            let body = SCNPhysicsBody.static()
            body.continuousCollisionDetectionThreshold = (CGFloat(0.00001))
            body.friction = 0.1


            boxNode.position = pos
          
            pos.z -= 20
            boxNode.physicsBody = body
            boxNode.name = String(x)
            track.append(boxNode)
        }*/
        
       
    }
    func getTrack() -> Array<SCNNode>{
        return track
    }
    func getNode(i:Int) -> SCNNode{
        return track[i]
    }
    func getBox() -> SCNNode {
        return track[0]
    }
    func finished(point: SCNVector3) -> Bool{
        print(point)
        if point.x < track[track.count-1].position.x + 100 && point.x > track[track.count-1].position.x - 100 && point.z > track[track.count-1].position.z - 100 && point.z < track[track.count-1].position.z + 100 && point.y <= 5{
            print("true")
            
            return true
        }
        return false
    }
    
}


/* garbgae
for x in 0...5 {
    let boxNode = SCNNode(geometry: boxGeometry)
    let body = SCNPhysicsBody.static()

    boxNode.position = pos
    if x-15 != 0
    {
        pos.z += 30 * Float(x-10)/abs(Float(x-10))
        pos.y += Float(5) * Float(x)// * Float(x)/abs(Float(x))
    }
    else {
        pos.y -= 30
        pos.z += 20
        //boxNode.eulerAngles.x += .pi/6 //* Float(x)/abs(Float(x))

    }
    boxNode.eulerAngles.x += .pi/24 * abs(Float(x))

    boxNode.physicsBody = body
    boxNode.name = String(x)
    track.append(boxNode)
}
for x in 0...10 {
    let boxNode = SCNNode(geometry: boxGeometry)
    let body = SCNPhysicsBody.static()

    boxNode.position = pos
    if x-15 != 0
    {
        pos.z -= 50 * Float(x-15)/abs(Float(x-15))
        pos.y += Float(5) * Float(x)// * Float(x)/abs(Float(x))
    }
    else {
        pos.y -= 30
        pos.z += 20
        //boxNode.eulerAngles.x += .pi/6 //* Float(x)/abs(Float(x))

    }
    boxNode.eulerAngles.x += .pi/24 + .pi/24 * abs(Float(10))// * abs(Float(x+1))

    boxNode.physicsBody = body
    boxNode.name = String(x)
    track.append(boxNode)
*/*/*/




