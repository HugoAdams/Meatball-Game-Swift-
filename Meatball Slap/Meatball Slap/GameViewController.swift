//
//  GameViewController.swift
//  Meatball Slap
//
//  Created by Hugo Adams on 21/05/18.
//  Copyright © 2018 Hugo Adams. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController
{

    var backmusic : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView?
        {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene")
            {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
        
        let path = Bundle.main.path(forResource: "Funiculi Funicula.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backmusic = try AVAudioPlayer(contentsOf: url)
            backmusic?.play()
            backmusic?.numberOfLoops = -1
        }
        catch {
            //couldnt play
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .portrait
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
