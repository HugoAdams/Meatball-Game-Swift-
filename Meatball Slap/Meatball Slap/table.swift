//
//  table.swift
//  Meatball Slap
//
//  Created by Hugo Adams on 28/05/18.
//  Copyright © 2018 Hugo Adams. All rights reserved.
//

import SpriteKit
import GameplayKit

class CTable
{
    var tcNode : SKSpriteNode?
    var bowlNode : SKSpriteNode?
    var bigNode : SKNode?
    var tclist : [SKSpriteNode] = []
    var gameWon : Bool = false
    var particle : SKEmitterNode?
    
    private let level0 = [[1,1,1],
                          [0,0,1],
                          [1,1,1],
                          [1,0,0],
                          [1,1,2]]
    
    private let level1 = [[1,0,1,1,1],
                          [1,0,2,0,1],
                          [1,1,0,1,1],
                          [0,1,3,1,0],
                          [0,1,0,1,0]]
    
    private let level2 = [[1,1,1,0,0],
                          [0,0,1,0,0],
                          [1,1,29,1,1],
                          [1,0,0,0,1],
                          [1,0,0,0,1],
                          [1,0,5,0,1],
                          [39,1,29,1,39],
                          [0,0,1,0,0],
                          [0,0,2,0,0]]
    
    private let level3 = [[1, 0, 0, 0, 0],
                          [1, 0, 0, 0, 0],
                          [1, 1, 1, 1,29],
                          [1, 0, 0, 0,39],
                          [11,0, 0, 0,29],
                          [1, 0, 0, 0,39],
                          [1, 1, 2, 1,29]]
    
    private let level4 = [[1, 0, 0, 1, 1, 1, 1, 0],
                          [1, 0, 0,39, 0, 0, 1, 0],
                          [1, 0, 0,29,39, 0, 1, 3],
                          [1, 0, 0, 0,29,39, 0, 0],
                          [1, 1, 0, 0, 0, 1, 0, 0],
                          [0, 6, 0, 0, 0, 1, 0, 2],
                          [0, 0, 0, 1, 1,25, 0, 0]]
    
    private let level5 = [[ 1, 1, 1, 1, 0, 0,13, 1,25, 0],
                          [ 1, 0, 0, 1, 0, 0, 1, 0, 0, 2],
                          [39, 0, 0, 0, 0, 0, 1, 0, 0, 1],
                          [29, 1, 0,11, 1, 1,11, 1, 0, 1],
                          [ 0, 3, 0, 1, 0, 0, 1, 0, 0, 3],
                          [ 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
                          [ 1, 0, 1,13, 1, 0,11, 1, 0, 0],
                          [ 1, 0, 0, 1, 0, 0, 1, 0, 0, 1],
                          [39, 0, 0, 1, 0, 0,11, 0, 0, 1],
                          [29,39, 1, 1, 0, 0,29,39,29,39]]
    
    private let level6 = [[ 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1],
                          [ 1, 0, 0, 0, 4, 0, 6, 0, 0, 0, 1],
                          [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
                          [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                          [29, 5,29, 0,39, 5,39, 0,29, 5,29],
                          [39, 0, 0, 0, 4, 0, 6, 0, 0, 0,39],
                          [29, 3,29, 0,39, 3,39, 0,29, 3,29],
                          [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                          [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
                          [13, 0, 0, 0, 4, 0, 6, 0, 0, 0,11],
                          [ 1, 0, 1, 0, 1, 0, 1, 0, 0, 2, 1]]
    
    init(scen: SKScene, level: Int)
    {
        bigNode?.position = CGPoint(x: 0, y: 0)
        tcNode = SKSpriteNode(imageNamed: "tablecloth")
        tcNode?.position = CGPoint(x: 0, y: 0)
        tcNode?.zPosition = -10
        tcNode?.xScale = 2
        tcNode?.yScale = 2
        
        let shadNode = SKSpriteNode(imageNamed: "tableshadow")
        shadNode.anchorPoint.x = 0.584
        shadNode.anchorPoint.y = 0.584
        shadNode.zPosition = -11
        tcNode?.addChild(shadNode)
        //tcNode?.anchorPoint = CGPoint(x: 0, y: 0)
        
        bowlNode = SKSpriteNode(imageNamed: "bowl")
        bowlNode?.zPosition = -5
        
        particle = SKEmitterNode(fileNamed: "MyParticle.sks")
        particle?.particleBirthRate = 0
        
        let levellist = [level0, level1, level2, level3, level4, level5, level6]
        var lev : [[Int]] = levellist[level]
        
        for y in 0..<lev.count
        {
            for x in 0..<lev[0].count
            {
                if (lev[y][x] == 0)
                {
                    continue
                }
                
                let temp = tcNode?.copy() as! SKSpriteNode
                temp.position.x = CGFloat(tcNode!.size.width) * CGFloat(x)
                temp.position.y = CGFloat(tcNode!.size.width) * CGFloat(-y)
                
                if(lev[y][x] == 2)
                {//place bowl
                    bowlNode?.position = temp.position
                    particle?.position = temp.position
                    scen.addChild(bowlNode!)
                    scen.addChild(particle!)
                }
                else if (lev[y][x] == 3 || lev[y][x] == 5)
                {
                    let p = CGPoint(x: temp.position.x, y: temp.position.y + CGFloat(lev[y][x] - 4) * tcNode!.size.height * 2)
                    temp.run(SKAction.repeatForever(SKAction.sequence(
                        [SKAction.move(to: p, duration: 3.0),
                         SKAction.wait(forDuration: 0.4),
                         SKAction.move(to: temp.position, duration: 3.0),
                         SKAction.wait(forDuration: 0.4)])))
                }
                else if (lev[y][x] == 4||lev[y][x] == 6)
                {
                    let p = CGPoint(x: temp.position.x + CGFloat(lev[y][x] - 5) * tcNode!.size.width * 2, y: temp.position.y)
                    temp.run(SKAction.repeatForever(SKAction.sequence(
                        [SKAction.move(to: p, duration: 3.0),
                         SKAction.wait(forDuration: 0.4),
                         SKAction.move(to: temp.position, duration: 3.0),
                         SKAction.wait(forDuration: 0.4)])))
                }
                else if (lev[y][x] == 11 || lev[y][x] == 13)
                {
                    scen.addChild(Baguette(p:temp.position, angVel: CGFloat(4 * (lev[y][x] - 12))))
                }
                else if (lev[y][x] > 20 && lev[y][x] < 30)
                {
                    for _i in 1...(lev[y][x] - 20)
                    {
                        if _i % 2 == 0
                        {
                            continue
                        }
                        scen.addChild(Salt(pos: temp.position, pSize: temp.size, form: _i))
                    }
                }
                else if (lev[y][x] > 30 && lev[y][x] < 40)
                {
                    for _i in 1...(lev[y][x] - 30)
                    {
                        if _i % 2 != 0
                        {
                            continue
                        }
                        scen.addChild(Salt(pos: temp.position, pSize: temp.size, form: _i))
                    }
                }
                tclist.append(temp)
            }
        }
        
        for ind in tclist
        {
            scen.addChild(ind)
        }
    }
    
    func Update(meat: CGPoint) -> Bool
    {
        if (distance(float2(Float(meat.x),Float(meat.y)), float2(Float(bowlNode!.position.x), Float(bowlNode!.position.y))) <= 320)
        {
            if(gameWon == false)
            {
                particle?.particleBirthRate = 25
            }
            gameWon = true
            return true
        }
        
        for tc in tclist
        {
            let pos : CGPoint = tc.position
            let w : CGFloat = tc.size.width * 0.5
            let h : CGFloat = tc.size.height * 0.5
            if (meat.x < pos.x + w && meat.x > pos.x - w && meat.y < pos.y + h && meat.y > pos.y - h)
            {//meat is colliding with a table
                return false
            }
        }
        return true
    }
    
    func IsGameWon() -> Bool
    {
        return gameWon
    }
    
    private func Baguette(p:CGPoint, angVel: CGFloat) ->SKSpriteNode
    {
        let b = SKSpriteNode(imageNamed: "baguette")
        b.xScale *= 2
        b.yScale *= 2
        b.zPosition = -6
        b.position = p
        b.physicsBody = SKPhysicsBody(texture: b.texture!, size: b.size)
        b.physicsBody?.affectedByGravity = false
        b.physicsBody?.mass = 1000
        b.name = "bread"
        
        var spin : SKAction?
        if angVel > 0
        {
             spin = SKAction.customAction(withDuration: 0) {
                node, elapsedTime in
                if let node = node as? SKSpriteNode
                {
                    if((node.physicsBody?.angularVelocity)! < angVel)
                    {
                        node.physicsBody?.angularVelocity = angVel
                    }
                }
            }
        }
        else
        {
            spin = SKAction.customAction(withDuration: 0) {
                node, elapsedTime in
                if let node = node as? SKSpriteNode
                {
                    if((node.physicsBody?.angularVelocity)! > angVel)
                    {
                        node.physicsBody?.angularVelocity = angVel
                    }
                }
            }
        }
        b.run(SKAction.repeatForever(SKAction.sequence([SKAction.move(to: p, duration: 0.001),spin!])))
        return b
    }
    
    private func Salt(pos: CGPoint, pSize: CGSize, form: Int) -> SKSpriteNode
    {
        var poz = pos
        
        if (form < 4)
        {
            poz.y -= pSize.height * 0.40
        }
        else if (form > 6)
        {
            poz.y += pSize.height * 0.40
        }
        
        if (form == 1 || form == 4 || form == 7)
        {
            poz.x -= pSize.width * 0.40
        }
        else if (form % 3 == 0 )
        {
            poz.x += pSize.width * 0.40
        }
        
        let s = SKSpriteNode(imageNamed: "saltshaker")
        s.xScale = 2
        s.yScale = 2
        s.zPosition = -6
        s.position = poz
        s.zRotation = CGFloat(arc4random_uniform(360)) * CGFloat(Double.pi/180)
        
        s.physicsBody = SKPhysicsBody(texture: s.texture!, size: s.size)
        s.physicsBody?.contactTestBitMask = CategBitMask.meatBit
        //s.physicsBody?.categoryBitMask = CategBitMask.saltBit
        s.physicsBody?.affectedByGravity = false
        s.physicsBody?.mass = 1000
        s.name = "salt"
        return s
    }
}
