//
//  GameScene.swift
//  TVTetris
//
//  Created by Joseph Buchoff on 8/31/20.
//  Copyright © 2020 Joe's Studio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var gameGrid: [SKTileMapNode] = []
    
    override func didMove(to view: SKView)
    {
        gameGrid.append(self.childNode(withName: "GameGrid") as! SKTileMapNode)
    }
    
    
    func touchDown(atPoint pos : CGPoint)
    {

    }
    
    func touchMoved(toPoint pos : CGPoint)
    {

    }
    
    func touchUp(atPoint pos : CGPoint)
    {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {

    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
    }
}
