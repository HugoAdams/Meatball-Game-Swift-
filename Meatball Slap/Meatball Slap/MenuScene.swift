//
//  MenuScene.swift
//  Meatball Slap
//
//  Created by Hugo Adams on 4/06/18.
//  Copyright © 2018 Hugo Adams. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

var SLevel: Int = 0

func CGDistance(a: CGPoint, b: CGPoint) ->Float
{
    var fa : float2 = float2(0,0)
    fa.x = Float(a.x)
    fa.y = Float(a.y)
    
    var fb : float2 = float2(0,0)
    fb.x = Float(b.x)
    fb.y = Float(b.y);
    
    return distance(fa, fb)
}

func CGAdd(a: CGPoint, b: CGPoint) -> CGPoint
{
    var r = CGPoint(x:0, y:0)
    r.x = a.x + b.x
    r.y = a.y + b.y
    return r
}

class MenuScene: SKScene
{
    var menuCam : SKCameraNode?
    var panGesture = UIPanGestureRecognizer()
    var autoMove : Bool = false
    
    var time_labelList : [SKLabelNode] = []
    var level_labelList : [SKSpriteNode] = []
    var buttonCol : UIColor?
    
    let defaults = UserDefaults.standard
    
    
    override func didMove(to view: SKView)
    {
        menuCam = self.childNode(withName: "//MenuCam") as? SKCameraNode
        
        let vw = view
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        vw.addGestureRecognizer(panGesture)
        
        let timeStr : String = "//l_level_time"
        let titleStr : String = "//l_level_title"
        
        for i in 0..<7
        {
            var st = timeStr + "\(i)"
            time_labelList.append(self.childNode(withName: st) as! SKLabelNode)
            st = titleStr + "\(i)"
            level_labelList.append(self.childNode(withName: st) as! SKSpriteNode)
        }
        
        buttonCol = level_labelList[0].color
        
        for indx in 0..<time_labelList.count
        {
            if((defaults.string(forKey: "Level" + "\(indx)")) != nil)
            {
                time_labelList[indx].text = defaults.string(forKey: "Level" + "\(indx)")
            }
        }
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint)
    {
        for index in level_labelList
        {
            if NodeCollision(node: index, pos: pos)
            {
                index.color = UIColor(red: 1, green: 223/255, blue: 191/255, alpha: 1)
            }
        }
    }
    func touchMoved(toPoint pos : CGPoint){}
    
    func touchUp(atPoint pos : CGPoint)
    {
        var count : Int = 0
        for index in level_labelList
        {
            
            if NodeCollision(node: index, pos: pos)
            {
                SLevel = count
                let transit = SKTransition.fade(withDuration: 1.0)
                let newscene = SKScene(fileNamed: "GameScene")
                transit.pausesOutgoingScene = true
                newscene?.scaleMode = .aspectFill
                self.view?.presentScene(newscene!, transition: transit)
                break
            }
            
            index.color = buttonCol!
            count += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?){
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
       
    }
    
    @objc func pan(sender: UIPanGestureRecognizer)
    {
        if autoMove == true
        {
            //return
        }
        let translate = sender.translation(in: self.view)
        touchUp(atPoint: sender.translation(in: self.view))
        let newPos = CGPoint(x:(menuCam?.position.x)! - translate.x, y: (menuCam?.position.y)! + translate.y)
        
        menuCam?.position.y = newPos.y
        if newPos.y > 0
        {
            autoMove = true
            menuCam?.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.2))
            {
                self.autoMove = false
            }
        }
        else if newPos.y < -800
        {
            autoMove = true
            menuCam?.run(SKAction.move(to: CGPoint(x: 0, y: -790), duration: 0.2))
            {
                self.autoMove = false
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}

func NodeCollision(node: SKSpriteNode, pos: CGPoint)->Bool
{//node is anchored at bottom left
    var Node = node as SKNode
    var nodePos : CGPoint? = node.position
    while (Node.parent != nil)
    {
        nodePos = CGAdd(a: nodePos!, b: (Node.parent?.position)!)
        if ((Node.parent as? SKScene) != nil)
        {
            break
        }
        Node = Node.parent!
    }
     //nodePos = CGAdd(a: node.position, b: node.parent!.position)
    
    let rect = node.calculateAccumulatedFrame() // Node should be camera so times by camera scale
    let Width = rect.width * Node.xScale
    let Height = rect.height * Node.yScale
    if //(pos.x > nodePos!.x && pos.x < nodePos!.x + node.size.width &&
        //pos.y > nodePos!.y && pos.y < nodePos!.y + node.size.height)
        (pos.x > nodePos!.x && pos.x < nodePos!.x + (Width) &&
            pos.y > nodePos!.y && pos.y < nodePos!.y + (Height))
    {
        return true
    }
    return false
}

