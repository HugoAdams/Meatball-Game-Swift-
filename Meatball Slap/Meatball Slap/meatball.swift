//
//  meatball.swift
//  Meatball Slap
//
//  Created by Hugo Adams on 21/05/18.
//  Copyright © 2018 Hugo Adams. All rights reserved.
//

import SpriteKit
import GameplayKit


class CMeatball
{
    private let meatball : SKSpriteNode?
    //private let meatghost : SKSpriteNode?
    //private let meatspice : SKSpriteNode?
    //private let meatdark : SKSpriteNode?
    private var dead : Bool = false
    private var stopped : Bool = false
    
    init(scen: SKScene)
    {
        meatball = SKSpriteNode(imageNamed: "Meatball")
        meatball?.size.width /= 2
        meatball?.size.height /= 2

        meatball?.position = CGPoint(x: 0, y: 0)
       // meatball?.physicsBody = SKPhysicsBody(texture: (meatball?.texture)!, size: (meatball?.size)!)
        meatball?.physicsBody = SKPhysicsBody(circleOfRadius: (meatball!.size.height/2))
        meatball?.physicsBody?.allowsRotation = true
        meatball?.physicsBody?.linearDamping = 0.5
        meatball?.physicsBody?.mass = 1
        meatball?.name = "meat"

        
        //meatball?.physicsBody?.categoryBitMask = CategBitMask.meatBit
        meatball?.physicsBody?.contactTestBitMask = CategBitMask.saltBit
        
        scen.addChild(meatball!)
        
        /*meatghost = scen.childNode(withName: "//meatball ghost") as? SKSpriteNode
        meatspice = scen.childNode(withName: "//meatball spicy") as? SKSpriteNode
        meatdark = scen.childNode(withName: "//meatball dark") as? SKSpriteNode*/
    }
    
    func SetPosition(x: CGFloat, y: CGFloat)
    {
        meatball?.position = CGPoint(x: x, y: y)
    }
    
    func GetPosition() -> CGPoint
    {
        return meatball!.position
    }
    
    func Stop()
    {
        stopped = true
        meatball?.physicsBody?.affectedByGravity = false
        meatball?.physicsBody?.velocity = CGVector.zero
    }
    
    func Fall()
    {
        dead = true
        meatball?.physicsBody?.affectedByGravity = false
        meatball?.zPosition = -20
        meatball?.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: 0.6)))
        meatball?.run(SKAction.scale(by: 0.01, duration: 1.0))
    }
    func Update()
    {
        if stopped == false && meatball?.physicsBody?.velocity != CGVector.zero
        {
            meatball?.zRotation = CGFloat(Double.pi/2) + atan2((meatball?.physicsBody?.velocity.dy)!, (meatball?.physicsBody?.velocity.dx)!)
        }
    }
    
    func Kill()
    {
        meatball?.removeAllActions()
        meatball?.removeFromParent()
    }
    
    func SaltBounce(saltPos: CGPoint)
    {
        if(dead == true)
        {
            return
        }
        let dx = (meatball?.position.x)! - saltPos.x
        let dy = (meatball?.position.y)! - saltPos.y
        var vec :float2 = /*normalize(*/float2(Float(dx),Float(dy))//)
        vec *= 6
        meatball?.physicsBody?.applyImpulse(CGVector(dx: CGFloat(vec.x), dy: CGFloat(vec.y)))
    }
    
}
