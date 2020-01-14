//
//  timer.swift
//  Meatball Slap
//
//  Created by Hugo Adams on 4/06/18.
//  Copyright © 2018 Hugo Adams. All rights reserved.
//

import SpriteKit
import GameplayKit

class CTimer
{
    private var clock : SKNode?
    var seconds : Int?
    var minutes : Int?
    var milliseconds : Int?
    
    init(scen : SKScene)
    {
        seconds = 0
        minutes = 0
        milliseconds = 0
        
        let time = SKAction.customAction(withDuration: 0.1){
            node, elapsedTime in
            if elapsedTime < 0.1
            {
                return
            }
            
            self.milliseconds! += 1
            if self.milliseconds == 10
            {
                self.seconds! += 1
                self.milliseconds = 0
                if self.seconds == 60
                {
                    self.minutes! += 1
                    self.seconds = 0
                }
            }
        }
        
        clock = SKNode()
        clock!.run(SKAction.repeatForever(time))
        scen.addChild(clock!)
    }
    
    func GetTime() -> String
    {
        var st : String = ""
        if minutes! < 10
        {
            st = String("0")
        }
        st += String(describing: minutes!) + String(":")
        
        if seconds! < 10
        {
            st += "0"
        }
        st += String(describing: seconds!) + String(":") + String(describing: milliseconds!) + String("0")
        return st
    }
    
    func Stop()
    {
        clock?.removeAllActions()
    }
    
    func TimeToMin(str: String)->Int
    {
        var wrk : String = ""
        for i in str
        {
            if i == ":"
            {
                break
            }
            wrk.append(i)
        }
        return Int(wrk)!
    }
    
    func TimeToSec(str: String)->Int
    {
        var strCount : Int = 0
        var wrk : String = ""
        for i in str
        {
            if i == ":"
            {
                strCount += 1
                if(strCount == 2)
                {
                    break
                }
            }
            else if strCount == 1
            {
                wrk.append(i)
            }
        }
        return Int(wrk)!
    }
    
    func TimeToMSec(str:String)->Int
    {
        var strCount : Int = 0
        var wrk : String = ""
        for i in str
        {
            if i == ":"
            {
                strCount += 1
            }
            else if strCount == 2
            {
                wrk.append(i)
            }
        }
        
        return Int(wrk)!
    }
}
