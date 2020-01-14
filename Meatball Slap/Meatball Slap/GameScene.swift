//
//  GameScene.swift
//  Meatball Slap
//
//  Created by Hugo Adams on 21/05/18.
//  Copyright © 2018 Hugo Adams. All rights reserved.
//

import CoreMotion
import SpriteKit
import GameplayKit
import AVFoundation

enum CategBitMask
{
    static let meatBit : UInt32 = 0b0001
    static let saltBit : UInt32 = 0b0010
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    private var spinnyNode : SKShapeNode?
    
    private var camNode : SKCameraNode?
    var panGesture = UIPanGestureRecognizer()
    var meatlist : [CMeatball] = []
    var motionManager : CMMotionManager?
    var table : CTable?
    var Dead : Bool = false
    var timer : CTimer?
    var labelTime : SKLabelNode?
    
    var BestTime_Min : Int = 99
    var BestTime_Sec : Int = 99
    var BestTime_mSec: Int = 99
    let defaults = UserDefaults.standard
    
    var menuNode : SKSpriteNode?
    var menuActive : Bool = false
    var menuButtonCont : SKSpriteNode?
    var menuButtonRetry : SKSpriteNode?
    var menuButtonMenu : SKSpriteNode?
    
    var saltSound : AVAudioPlayer?
    var saltPath : String?
    var successSound : AVAudioPlayer?
    var successPath : String?
    
    override func didMove(to view: SKView)
    {
        camNode = self.childNode(withName: "//camcam") as? SKCameraNode
        self.camera = camNode
        let vw = view
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        vw.addGestureRecognizer(panGesture)
        
        for i in 0..<1
        {
            meatlist.append(CMeatball.init(scen: self))
            meatlist[i].SetPosition(x: CGFloat(i * 60), y: 0)
        }
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
        table = CTable(scen: self, level: SLevel)
        
        physicsWorld.contactDelegate = self
        
        timer = CTimer(scen: self)
        labelTime = self.childNode(withName: "//timer") as? SKLabelNode
        labelTime?.text = timer?.GetTime()
    
        if((defaults.string(forKey: "Level" + "\(SLevel)")) != nil)
        {
            let str :String = defaults.string(forKey: "Level" + "\(SLevel)")!
            BestTime_Min = timer!.TimeToMin(str: str)
            BestTime_Sec = timer!.TimeToSec(str: str)
            BestTime_mSec = timer!.TimeToMSec(str: str)
        }
        
        menuNode = self.childNode(withName: "//menuback") as? SKSpriteNode
        menuButtonCont = self.childNode(withName: "//buttonContinue") as? SKSpriteNode
        menuButtonRetry = self.childNode(withName: "//buttonRetry") as? SKSpriteNode
        menuButtonMenu = self.childNode(withName: "//buttonMenu") as? SKSpriteNode
        menuButtonCont?.color = UIColor.clear
        menuButtonRetry?.color = UIColor.clear
        menuButtonMenu?.color = UIColor.clear
        
        saltPath = Bundle.main.path(forResource: "bump sfx.mp3", ofType: nil)!
        successPath = Bundle.main.path(forResource: "alright sfx.wav", ofType: nil)!
        
    }
    
    
    func touchDown(atPoint pos : CGPoint)
    {
        if menuActive == true
        {
            let Pos = CGAdd(a: pos, b: CGPoint(x: 0, y: 540))//strange offset cos camera is 2x
            if NodeCollision(node: menuButtonCont!, pos: Pos)
            {
                menuButtonCont?.color = UIColor(red: 1, green: 223/255, blue: 191/255, alpha: 1)
            }
            else if NodeCollision(node: menuButtonRetry!, pos: Pos)
            {
                menuButtonRetry?.color = UIColor(red: 1, green: 223/255, blue: 191/255, alpha: 1)
            }
            else if NodeCollision(node: menuButtonMenu!, pos: Pos)
            {
                menuButtonMenu?.color = UIColor(red: 1, green: 223/255, blue: 191/255, alpha: 1)
            }
        }
    }
    func touchMoved(toPoint pos : CGPoint){}
    func touchUp(atPoint pos : CGPoint)
    {
        if menuActive == true
        {
            let Pos = CGAdd(a: pos, b: CGPoint(x: 0, y: 540))//strange offset cos camera is 2x
            if NodeCollision(node: menuButtonCont!, pos: Pos)
            {
                ChangeScene(level: 1)
            }
            else if NodeCollision(node: menuButtonRetry!, pos: Pos)
            {
                ChangeScene(level: 0)
            }
            else if NodeCollision(node: menuButtonMenu!, pos: Pos)
            {
                ChangeScene(level: -1)
            }
            menuButtonCont!.color = UIColor(red: 1, green: 239/255, blue: 196/255, alpha: 1)
            menuButtonRetry!.color = UIColor(red: 1, green: 239/255, blue: 196/255, alpha: 1)
            menuButtonMenu!.color = UIColor(red: 1, green: 239/255, blue: 196/255, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        labelTime?.text = timer?.GetTime()
        if (Dead)
        {
            return
        }
        if let accelData = motionManager?.accelerometerData
        {
            physicsWorld.gravity = CGVector(dx: accelData.acceleration.x * 25, dy: accelData.acceleration.y * 25)
            
            if (physicsWorld.gravity.dx < 1 && physicsWorld.gravity.dx > -1)
            {
                physicsWorld.gravity.dx = 0
            }
            if (physicsWorld.gravity.dy < 1 && physicsWorld.gravity.dy > -1)
            {
                physicsWorld.gravity.dy = 0
            }
            
        }
        
        if table != nil
        {
            if(table!.Update(meat: meatlist[0].GetPosition()) == true)
            {
                //meatball stop
                if(table?.IsGameWon() == true)
                {
                    meatlist[0].Stop()
                    timer?.Stop()
                    if menuActive == false
                    {
                        ActivateMenu()
                        PlaySuccessSound()
                    }
                    if UpdateScore() == true
                    {
                        NewBestTime()
                    }
                }
                else
                {
                    meatlist[0].Fall()
                    Dead = true
                    self.run(SKAction.wait(forDuration: 1.5))
                    {
                        let temp = self.meatlist.removeFirst()
                        temp.Kill()
                        self.meatlist.append(CMeatball(scen: self))
                        self.Dead = false
                    }
                }
            }
            else
            {
                camNode?.position = meatlist[0].GetPosition()
            }
            meatlist[0].Update()
        }
    }
    
    @objc func pan(sender: UIPanGestureRecognizer)
    {
        let translate = sender.translation(in: self.view)
        let newPos = CGPoint(x:(camNode?.position.x)! - translate.x, y: (camNode?.position.y)! + translate.y)
        
        camNode?.position = newPos
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.node?.name == "salt")
        {
            if(contact.bodyB.node?.name == "meat")
            {
                meatlist[0].SaltBounce(saltPos: contact.bodyA.node!.position)
                PlayBumpSound()
                contact.bodyA.node?.run(SKAction.sequence([SKAction.scale(by: 1.5, duration: 0.2),SKAction.scale(to: 2, duration: 0.3)]))
            }
        }
        
        if(contact.bodyA.node?.name == "meat")
        {
            if(contact.bodyB.node?.name == "salt")
            {
                meatlist[0].SaltBounce(saltPos: contact.bodyB.node!.position)
               PlayBumpSound()
                contact.bodyB.node?.run(SKAction.sequence([SKAction.scale(by: 1.5, duration: 0.2),SKAction.scale(to: 2, duration: 0.3)]))
            }
        }
    }
    
    func UpdateScore()-> Bool
    {
        var highscore : Bool = false
        if timer!.minutes! == BestTime_Min
        {
            if timer!.seconds! < BestTime_Sec
            {
                BestTime_Min = timer!.minutes!
                BestTime_Sec = timer!.seconds!
                BestTime_mSec = timer!.milliseconds!
                highscore = true
            }
            else if timer!.seconds! == BestTime_Sec
            {
                if timer!.milliseconds! < BestTime_mSec
                {
                    BestTime_Min = timer!.minutes!
                    BestTime_Sec = timer!.seconds!
                    BestTime_mSec = timer!.milliseconds!
                    highscore = true
                }
            }
        }
        else if timer!.minutes! < BestTime_Min
        {
            BestTime_Min = timer!.minutes!
            BestTime_Sec = timer!.seconds!
            BestTime_mSec = timer!.milliseconds!
            highscore = true
        }
        return highscore
    }
    
    func NewBestTime()
    {
        let backNode = self.childNode(withName: "//timerback") as! SKSpriteNode
        backNode.scale(to: CGSize(width: backNode.size.width, height: 363))
        let a = SKAction.customAction(withDuration: 0.12)
        {Node, elapsedTime in
            let skl = Node as! SKLabelNode
            skl.fontColor = UIColor.white
        }
        let b = SKAction.customAction(withDuration: 0.25)
        {Node, elapsedTime in
            let skl = Node as! SKLabelNode
            skl.fontColor = UIColor(red: 235/256, green: 38/256, blue: 0, alpha: 1)
        }
        let nde = self.childNode(withName: "//timertext") as! SKLabelNode
        nde.text = "BestTime"
        nde.run(SKAction.repeatForever(SKAction.sequence([a,b])))
        
        ///update default vars
        defaults.set(timer?.GetTime(), forKey: "Level" + "\(SLevel)")
    }
    
    func ActivateMenu()
    {
        //menuNode?.position = CGAdd(a: CGPoint(x: 0, y: -750), b: camNode!.position)
        menuNode?.run(SKAction.move(to: CGPoint(x:0, y:-208), duration: 1.0))
        {
            self.menuButtonCont!.color = UIColor(red: 1, green: 239/255, blue: 196/255, alpha: 1)
            self.menuButtonRetry!.color = UIColor(red: 1, green: 239/255, blue: 196/255, alpha: 1)
            self.menuButtonMenu!.color = UIColor(red: 1, green: 239/255, blue: 196/255, alpha: 1)
        }
        menuActive = true
    }
    
    func ChangeScene(level: Int)
    {
        var newscene : SKScene?
        if level == -1
        {
            newscene = SKScene(fileNamed: "MenuScene")
        }
        else
        {//1 or 0
            if SLevel != 6//CHANGE WITH MORE LEVELS ADDED
            {
                SLevel += level
            }
            newscene = SKScene(fileNamed: "GameScene")
        }
        
        let transit = SKTransition.fade(withDuration: 1.0)
        transit.pausesOutgoingScene = true
        newscene?.scaleMode = .aspectFill
        self.view?.presentScene(newscene!, transition: transit)
        
    }
    
    func PlayBumpSound()
    {
        let url = URL(fileURLWithPath: saltPath!)
        
        do {
            saltSound = try AVAudioPlayer(contentsOf: url)
            saltSound?.play()
            saltSound?.numberOfLoops = 0
        }
        catch {
            //couldnt play
        }
    }
    
    func PlaySuccessSound()
    {
        let url = URL(fileURLWithPath: successPath!)
        
        do {
            successSound = try AVAudioPlayer(contentsOf: url)
            successSound?.play()
            successSound?.numberOfLoops = 0
        }
        catch {
            //couldnt play
        }
    }
}
