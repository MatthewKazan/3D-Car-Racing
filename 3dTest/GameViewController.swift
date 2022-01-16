//
//  GameViewController.swift
//  3dTest
//
//  Created by matt kazan on 5/18/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import GameController
import CoreMotion
import GameplayKit
import AVFoundation



class GameViewController: UIViewController {
    
    var sceneView:SCNView!
    var scene:SCNScene!
    var overlayScene:Overlay!
    
    
    var playerNode:SCNNode!
    var trigger:SCNNode!
    var legNodeL:SCNNode!
    var legNodeR:SCNNode!
    var floorNode:SCNNode!
    var road:Road!
    var track = Array<SCNNode>()
    lazy var vehicleNode = SCNNode()
    var jetNode:SCNNode!
    
    let emitter = SKEmitterNode(fileNamed: "particle")
    let colors = [SKColor.white,SKColor.gray,SKColor.green,SKColor.red,SKColor.black]
    
    
    
    lazy var vehicle = SCNPhysicsVehicle()
    var motionManager = CMMotionManager()
    lazy var accelerometer = [UIAccelerationValue(0),UIAccelerationValue(0),UIAccelerationValue(0)]
    lazy var _orientation = CGFloat(0)
    lazy var _vehicleSteering = CGFloat(0) // steering factor
    lazy var _calibrateRoll = Double(0)
    lazy var _calibratePitch = Double(0)
    lazy var _calibrateYaw = Double(0)
    
    
    
    var pOrN = true
    var camControl:SCNNode!
    
    var currentAttitude:CMAttitude!
    
    //var motion = MotionHelper()
    var motionForce = SCNVector3(0,0,0)
    
    var move = false
    var reset = false
    
    var state2 = SCNScene(named: "art.scnassets/Road2.scn")
    var temp:SCNNode!
    var pieces = Array<SCNNode>()
    var gameState = -1
    var currentAngle: Float = 0.0
    
    
    
    
    
    
    override func viewDidLoad() {
        setup()
        vehicleNode = setupVehicle(scene: scene)
        road = Road(i: 0)
        camControl = scene.rootNode.childNode(withName: "camera",recursively: true)!
        camControl.camera?.zFar = 3000
        //camControl.constraints = [SCNLookAtConstraint(target: vehicleNode)]
        camControl.position = SCNVector3(vehicleNode.position.x, 15, vehicleNode.position.z + 5)
        scene.rootNode.addChildNode(camControl)
        
        let action = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, vehicleNode.position.y, 0), duration: 5))
        vehicleNode.runAction(action)
        print("starting")
        
        self.overlayScene = Overlay(size: self.view.bounds.size)
        sceneView.overlaySKScene = self.overlayScene
        sceneView.overlaySKScene!.isUserInteractionEnabled = true
        scene.physicsWorld.timeStep = 1/180
        
        sceneView.showsStatistics = true
        // 2
        // 3
        sceneView.autoenablesDefaultLighting = true
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentAttitude = motionManager.deviceMotion?.attitude;
        
        _calibrateYaw = currentAttitude.yaw * 180 / .pi;
        _calibratePitch = currentAttitude.pitch * 180 / .pi;
        _calibrateRoll = currentAttitude.roll * 180 / .pi;
        
        
        
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        
        
        
        //addChild(buttonBack)
    }
    func setup(){
        sceneView = self.view as! SCNView
        //sceneView.allowsCameraControl = true
        
        
        sceneView.delegate = self
        scene = SCNScene(named: "art.scnassets/MainScene.scn")
        floorNode = scene.rootNode.childNode(withName: "floor",recursively: true)!
        //floorNode.physicsBody = SCNPhysicsBody.static()
        //scene.rootNode.addChildNode(road.getBox())
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)

        
        sceneView.scene = scene
        
        motionManager.startDeviceMotionUpdates()
        
        
        
        jetNode = scene.rootNode.childNode(withName: "Jet", recursively: true)
        
        //legNodeR.position = SCNVector3(legNodeR.position.x, legNodeR.position.y + 0.375, legNodeR.position.z)
        //     legNodeL.position = SCNVector3(legNodeL.position.x, legNodeL.position.y + 0.375, legNodeL.position.z)
        //   playerNode.position = SCNVector3(playerNode.position.x, playerNode.position.y - 0.1, playerNode.position.z)
        
        
        
        
        
    }
    func walk(node:SCNNode, pOrN: Float) {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.fromValue = NSValue(scnVector4: SCNVector4(x: 1, y: 0, z: 0, w: pOrN * Float(M_PI/3)))
        animation.toValue = NSValue(scnVector4: SCNVector4(x: 1, y: 0, z: 0, w: pOrN * -Float(M_PI/3)))
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        node.addAnimation(animation, forKey: "walk")
    }
    
    func setupVehicle(scene:SCNScene)->SCNNode {
        
        // add chassisNode
        let chassisNode = getNode(nodeName: "rccarBody", fromDaePath: "art.scnassets/rc_car.scn")
        chassisNode.position = SCNVector3Make(40, 10, -50)
        chassisNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
        //chassisNode.scale = SCNVector3(0.75,0.75,0.75)
        
        let body = SCNPhysicsBody.dynamic()
        body.allowsResting = false
        body.mass = 40
        body.restitution = 0.1
        body.friction = 0.5
        body.rollingFriction = 0
        body.centerOfMassOffset = SCNVector3(0,-2,0)
        body.continuousCollisionDetectionThreshold = (CGFloat(0.001))
        //body.damping = 0
        
        //body.charge = -0.1
        chassisNode.physicsBody = body
        
        scene.rootNode.addChildNode(chassisNode)
        
        // add wheels
        let wheelnode0 = chassisNode.childNode(withName: "wheelLocator_FL", recursively: true)
        //wheelnode0?.scale = SCNVector3(0.25,0.25,0.25)
        
        let wheelnode1 = chassisNode.childNode(withName: "wheelLocator_FR", recursively: true)
        //wheelnode1?.scale = SCNVector3(0.25,0.25,0.25)
        
        let wheelnode2 = chassisNode.childNode(withName: "wheelLocator_RL", recursively: true)
        // wheelnode2?.scale = SCNVector3(0.35,0.35,0.35)
        
        let wheelnode3 = chassisNode.childNode(withName: "wheelLocator_RR", recursively: true)
        //wheelnode3?.scale = SCNVector3(0.5,0.5,0.5)
        print("wheels")
        
        let wheel0 = SCNPhysicsVehicleWheel(node: wheelnode0!)
        
        let wheel1 = SCNPhysicsVehicleWheel(node: wheelnode1!)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheelnode2!)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheelnode3!)
        var min = SCNVector3(x: 0, y: 0, z: 0)
        var max = SCNVector3(x: 0, y: 0, z: 0)
        wheelnode0?.__getBoundingBoxMin(&min, max: &max)
        var wheelHalfWidth = Float(0.5 * (max.x - min.x))
        var w0 = wheelnode0?.convertPosition(SCNVector3Zero, to: chassisNode)
        w0 = SCNVector3(simd_float3(w0!) + simd_float3(SCNVector3Make(wheelHalfWidth, 0, 0)))
        wheel0.connectionPosition = w0!
        wheel0.suspensionStiffness = 30
        wheel0.frictionSlip = 5
        wheel0.suspensionRestLength = 0
        
        var w1 = wheelnode1?.convertPosition(SCNVector3Zero, to: chassisNode)
        w1 = SCNVector3(simd_float3(w1!) - simd_float3(SCNVector3Make(wheelHalfWidth, 0, 0)))
        wheel1.connectionPosition = w1!
        wheel1.suspensionStiffness = 30
        wheel1.frictionSlip = 5
        wheel1.suspensionRestLength = 0
        
        
        var w2 = wheelnode2?.convertPosition(SCNVector3Zero, to: chassisNode)
        w2 = SCNVector3(simd_float3(w2!) + simd_float3(SCNVector3Make(wheelHalfWidth, 0, 0)))
        wheel2.connectionPosition = w2!
        wheel2.suspensionStiffness = 30
        wheel2.frictionSlip = 5
        wheel2.suspensionRestLength = 0
        
        
        var w3 = wheelnode3?.convertPosition(SCNVector3Zero, to: chassisNode)
        w3 = SCNVector3(simd_float3(w3!) - simd_float3(SCNVector3Make(wheelHalfWidth, 0, 0)))
        wheel3.connectionPosition = w3!
        wheel3.suspensionStiffness = 30
        wheel3.frictionSlip = 5
        wheel3.suspensionRestLength = 0
        
        // set physics
        vehicle = SCNPhysicsVehicle(chassisBody: chassisNode.physicsBody!,
                                    wheels: [wheel0, wheel1, wheel2, wheel3])
        
        scene.physicsWorld.addBehavior(vehicle)
        
        return chassisNode
        
    }
    func getNode(nodeName:String, fromDaePath:String)->SCNNode {
        
        if let scene = SCNScene(named: fromDaePath){
            if let node = scene.rootNode
                .childNode(withName: nodeName, recursively: true){
                return node
            } else {
                fatalError("unable to get node by name: \(nodeName)")
            }
        } else {
            fatalError("unable to ger scene from path: \(fromDaePath)")
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touch")
        walk(node: legNodeL,pOrN: -1)
        walk(node: legNodeR,pOrN: 1)
        let t = touches.first as? UITouch
        let touchPoint = t!.location(in: self.view)
        
        print("controller touch location: ", t?.location(in: self.view).y)
        
        if(t?.location(in: self.view).y)! < CGFloat(20) {
            reset = true
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        move = false
        //print(move)
        playerNode.removeAllActions()
        legNodeR.removeAllAnimations()
        legNodeL.removeAllAnimations()
        
        
    }
    func camPosition(playerRotation: SCNVector4) {
        let ball = vehicleNode
        let ballPosition = ball.position
        
        let targetPosition = SCNVector3(ballPosition.x, ballPosition.y + 5, ballPosition.z  + 5)
        camControl.position = targetPosition
        
        let camDamping:Float = 0.3
        var cameraPosition = camControl.position
        var timer = Timer()
        
        let xVal = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yVal = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zVal = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        //let roll = (180/M_PI)*self.motionManager.attitude.roll
        
        let lookAtConstraint = SCNLookAtConstraint(target: vehicleNode)
        
        let distanceConstraint = SCNDistanceConstraint(target: vehicleNode)
        let distanceConstraint2 = SCNDistanceConstraint(target: floorNode)
        
        distanceConstraint.minimumDistance = 20 // set to whatever minimum distance between the camera and aircraft you'd like
        distanceConstraint.maximumDistance = 20
        
        camControl.constraints = [lookAtConstraint]//, distanceConstraint]//, distanceConstraint2]
        //camControl.constraints! += [distanceConstraint2]//, distanceConstraint2]
        camControl.eulerAngles.y = .pi//abs(camControl.rotation.y)/2
        //print(camControl.rotation.y)
        camControl.position = targetPosition
        
        
        //camControl.rotate(by: SCNVector4(playerRotation.x, playerRotation.y, playerRotation.z, playerRotation.w), aroundTarget: ballPosition)
        
    }
    
    func multiply(lhs: SCNVector3, rhs: Double) -> SCNVector3 {
        return SCNVector3(lhs.x * .init(rhs), lhs.y * .init(rhs), lhs.z * .init(rhs))
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    func startGyros() {
        
    }
    func getZForward(node: SCNNode) -> SCNVector3 {
        return SCNVector3(node.worldTransform.m31, node.worldTransform.m32, node.worldTransform.m33)
    }
    func stateSwitcher(state: Int){
        //print("switcher", state)
        if state == 0 {
            if let tempRoad = road {
                if let track = tempRoad.getTrack() {
                    for n in road.getTrack()! {
                        n.removeFromParentNode()
                    }
                }
            }
            self.floorNode.enumerateChildNodes { (existingNode, _) in
                existingNode.removeFromParentNode()
            }
            road = nil
            
            move = false
            pieces.removeAll()
            if gameState != 0 {
                print("switcher", state)
                camControl.removeFromParentNode()
                scene.rootNode.addChildNode(camControl)
                vehicleNode.position = SCNVector3Make(0, 10, -50)
                vehicleNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
                
                let action = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, vehicleNode.position.y, 0), duration: 5))
                vehicleNode.runAction(action)
                print("starting from switcher")
                vehicleNode.position = SCNVector3Make(0, 10, -50)
                vehicleNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
                
                
                
            }
            camControl.position = SCNVector3(vehicleNode.position.x, 20, vehicleNode.position.z + 15)
            camControl.eulerAngles.y = 0
            //overlayScene.changeState(to: 0)
            vehicle.chassisBody.clearAllForces()
            //camPosition(playerRotation: vehicleNode.rotation)
            gameState = 0
            
            vehicle.applyEngineForce(0, forWheelAt: 0)
            vehicle.applyEngineForce(0, forWheelAt: 1)
            vehicle.applyEngineForce(0, forWheelAt: 2)
            vehicle.applyEngineForce(0, forWheelAt: 3)
            
        }
        else if state == 1 && gameState != 1{
            //print("1")
            //overlayScene.change()
            overlayScene.stopCon()
            road = Road(i:1)
            
            if gameState != 1 {
                print("switcher", state)
                vehicleNode.position = SCNVector3Make(0, 10, -50)
                vehicleNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
                camControl.removeFromParentNode()
                vehicleNode.addChildNode(camControl)
                for n in road.getTrack()! {
                    scene.rootNode.addChildNode(n)
                    floorNode.addChildNode(n)
                    n.opacity = 100
                    
                    
                }
            }
            camControl.position = SCNVector3Make(0, 10, -20)
            camControl.eulerAngles.y = .pi
            camControl.eulerAngles.z = 0
            gameState = 1
            overlayScene.changeState(to: 1)
            vehicleNode.removeAllActions()
            print("stoping")
            
            //camPosition(playerRotation: vehicleNode.rotation)
            
        }
        
        else if state == 2 && gameState != 2 {
            print("2")
            //overlayScene.change()
            overlayScene.stopCon()
            road = Road(i:2)
            
            if gameState != 2 {
                vehicleNode.position = SCNVector3Make(0, 10, -50)
                vehicleNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
                camControl.removeFromParentNode()
                vehicleNode.addChildNode(camControl)
                for n in road.getTrack()! {
                    scene.rootNode.addChildNode(n)
                    floorNode.addChildNode(n)
                    n.opacity = 100
                    
                    
                }
            }
            camControl.position = SCNVector3Make(0, 10, -20)
            camControl.eulerAngles.y = .pi
            camControl.eulerAngles.z = 0
            gameState = 2
            overlayScene.changeState(to: 2)
            vehicleNode.removeAllActions()
            print("stoping")
            
            
        }
        
        else if state == 3 && gameState != 3 {
            print("2")
            //overlayScene.change()
            overlayScene.stopCon()
            road = Road(i:3)
            
            if gameState != 3 {
                vehicleNode.position = SCNVector3Make(0, 10, -50)
                vehicleNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
                camControl.removeFromParentNode()
                vehicleNode.addChildNode(camControl)
                for n in road.getTrack()! {
                    scene.rootNode.addChildNode(n)
                    floorNode.addChildNode(n)
                    n.opacity = 100
                    
                    
                }
            }
            camControl.position = SCNVector3Make(0, 10, -20)
            camControl.eulerAngles.y = .pi
            camControl.eulerAngles.z = 0
            gameState = 3
            overlayScene.changeState(to: 3)
            vehicleNode.removeAllActions()
            print("stoping")
            
            
        }
        
        
    }
    
}

extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        stateSwitcher(state: overlayScene.check())
        //print(vehicleNode.physicsBody?.velocity)
        //if SCNVector3EqualToVector3(vehicleNode.physicsBody!.velocity, vehicleNode.presentation.eulerAngles) {
        //print(SCNVector3EqualToVector3(vehicleNode.physicsBody!.velocity, getZForward(node: vehicleNode.presentation)))
        
        //}
        if gameState == 0 {
            
        }
        else {
            if vehicleNode.presentation.position.y < -800 && gameState != 0{
                overlayScene.game0()
                overlayScene.changeState(to: 0)
                print("too low")
                
                
            }
            if gameState == 1 {
                vehicleNode.removeAllActions()
                
                if road.finished(point: vehicleNode.presentation.position) {
                    overlayScene.startCon()
                    
                    
                    
                    //print("finished")
                }
                
            }
            else if gameState == 2 {
                vehicleNode.removeAllActions()
                
                if road.finished(point: vehicleNode.presentation.position) {
                    overlayScene.startCon()
                    
                    
                    
                    //print("finished")
                }
                
            }
            if overlayScene.r() {
                overlayScene.game0()
                overlayScene.changeState(to: 0)
                print("reset")
                road = nil
            }
            
            
            
            
            
            if overlayScene.jetOn() && gameState != 0{
                jetNode.opacity = 100
                
                let pos = getZForward(node: vehicleNode.presentation)
                let p = vehicleNode.presentation.position
                //vehicle.chassisBody.applyForce(multiply(lhs: pos, rhs: 3), asImpulse: true)
                let targetPosition = SCNVector3(p.x, p.y, p.z)
                vehicleNode.addChildNode(jetNode)
                jetNode.eulerAngles = SCNVector3( -Float.pi/2 ,0,0)
                jetNode.position = SCNVector3(0 ,1,-4.5)
                let jetSpeed = (100 - vehicle.speedInKilometersPerHour)/7 + 15
                //print(jetSpeed)
                if vehicle.speedInKilometersPerHour < 200 && (gameState == 1 || gameState == 2){
                    vehicle.chassisBody.applyForce(multiply(lhs: pos, rhs: Double(jetSpeed)), asImpulse: true)
                    
                }
                
                //jetNode.position = targetPosition
                // jetNode.eulerAngles = SCNVector3(Float(vehicleNode.presentation.eulerAngles.x - .pi/2), Float(Float(vehicleNode.presentation.eulerAngles.y)) ,Float(vehicleNode.presentation.eulerAngles.z))
                //jetNode.simdPosition = vehicleNode.presentation.simdWorldFront
                print("jetting")
            }
            else {
                jetNode.opacity = 0
            }
            
            if overlayScene.braking() {
                //vehicle.applyBrakingForce(3, forWheelAt: 0)
                //vehicle.applyBrakingForce(3, forWheelAt: 1)
                vehicle.applyBrakingForce(2, forWheelAt: 0)
                vehicle.applyBrakingForce(2, forWheelAt: 1)
                vehicle.applyBrakingForce(2, forWheelAt: 2)
                vehicle.applyBrakingForce(2, forWheelAt: 3)
                //vehicle.chassisBody.clearAllForces()
                print("braking")
                
                
            }
            if overlayScene.direction() && overlayScene.moving() && vehicle.speedInKilometersPerHour < 100 && gameState != 0{
                pOrN = true
                move = true
                
                vehicle.applyBrakingForce(0, forWheelAt: 0)
                vehicle.applyBrakingForce(0, forWheelAt: 1)
                vehicle.applyBrakingForce(0, forWheelAt: 2)
                vehicle.applyBrakingForce(0, forWheelAt: 3)
                
                vehicle.applyEngineForce(CGFloat(175), forWheelAt : 0)
                vehicle.applyEngineForce(CGFloat(175), forWheelAt : 1)
                vehicle.applyEngineForce(CGFloat(175), forWheelAt : 2)
                vehicle.applyEngineForce(CGFloat(175), forWheelAt : 3)
                //print("forward")
                
            }
            
            else if !overlayScene.direction() && overlayScene.moving() && gameState != 0{
                pOrN = false
                move = true
                
                vehicle.applyBrakingForce(0, forWheelAt: 0)
                vehicle.applyBrakingForce(0, forWheelAt: 1)
                vehicle.applyBrakingForce(0, forWheelAt: 2)
                vehicle.applyBrakingForce(0, forWheelAt: 3)
                vehicle.applyEngineForce(CGFloat(-100), forWheelAt : 0)
                vehicle.applyEngineForce(CGFloat(-100), forWheelAt : 1)
                vehicle.applyEngineForce(-100, forWheelAt: 2)
                vehicle.applyEngineForce(-100, forWheelAt: 3)
                print("backward")
                
            }
            else {
                vehicle.applyEngineForce(0, forWheelAt: 0)
                vehicle.applyEngineForce(0, forWheelAt: 1)
                vehicle.applyEngineForce(0, forWheelAt: 2)
                vehicle.applyEngineForce(0, forWheelAt: 3)
                
            }
            
            currentAttitude = motionManager.deviceMotion?.attitude;
            
            if (currentAttitude == nil)
            {
                NSLog("Could not get device orientation.");
                return;
            }
            else {
                let PI = 3.14159265;
                let yaw = currentAttitude.yaw * 180/PI - Double(_calibrateYaw);
                //            print(yaw)
                let pitch = currentAttitude.pitch * 180/PI - Double(_calibratePitch);
                //            print(pitch)
                let roll = currentAttitude.roll * 180/PI - Double(_calibrateRoll);
                //print(roll)
                //print("calibrate: ", _calibrateRoll)
                
                
                self._vehicleSteering = -CGFloat(round(pitch * 10)/1000)
                vehicle.chassisBody.applyTorque(SCNVector4(-Float(round(roll * 10)/10),
                                                           Float(round(yaw * 10)/10),
                                                           -Float(round(pitch * 10)/10), 1), asImpulse: false)
                print(SCNVector4(-Float(round(roll * 10)/10),
                                 Float(round(yaw * 10)/10),
                                 -Float(round(pitch * 10)/10), 1))
                //vehicle.chassisBody.applyTorque()
                //vehicleNode.rotation.z = -Float(round(roll * 10)/1000)
                
            }
            
            //            print(self._vehicleSteering)
            switch UIDevice.current.orientation {
                
                case .landscapeLeft:
                    vehicle.setSteeringAngle(_vehicleSteering, forWheelAt: 0)
                    vehicle.setSteeringAngle(_vehicleSteering, forWheelAt: 1)
                case .landscapeRight:
                    vehicle.setSteeringAngle(-_vehicleSteering, forWheelAt: 0)
                    vehicle.setSteeringAngle(-_vehicleSteering, forWheelAt: 1)
                default:
                    vehicle.setSteeringAngle(_vehicleSteering, forWheelAt: 0)
                    vehicle.setSteeringAngle(_vehicleSteering, forWheelAt: 1)
                    
            }
            // Use the gyroscope data in your app.
            
            //print("speed: ", vehicle.speedInKilometersPerHour)
            
        }
        
    }
    
    
    
    
    
    
}
