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
    
    private var gameGrid: [[SKTileDefinition]] = [[]]
    
    override func didMove(to view: SKView)
    {
        let size = 25
        
        let bgTexture = SKTexture(imageNamed: "Background")
        let bgDefinition = SKTileDefinition(texture: bgTexture, size: CGSize(width: size, height: size)/*bgTexture.size()*/)
        let bgGroup = SKTileGroup(tileDefinition: bgDefinition)
        
        let sTexture = SKTexture(imageNamed: "Green")
        let sDefinition = SKTileDefinition(texture: sTexture, size: sTexture.size())
        let sGroup = SKTileGroup(tileDefinition: sDefinition)
        
        let bwsTexture = SKTexture(imageNamed: "Orange")
        let bwsDefinition = SKTileDefinition(texture: bwsTexture, size: bwsTexture.size())
        let bwsGroup = SKTileGroup(tileDefinition: bwsDefinition)
        
        let lTexture = SKTexture(imageNamed: "Pink")
        let lDefinition = SKTileDefinition(texture: lTexture, size: lTexture.size())
        let lGroup = SKTileGroup(tileDefinition: lDefinition)
        
        let bwlTexture = SKTexture(imageNamed: "Purple")
        let bwlDefinition = SKTileDefinition(texture: bwlTexture, size: bwlTexture.size())
        let bwlGroup = SKTileGroup(tileDefinition: bwlDefinition)
        
        let squareTexture = SKTexture(imageNamed: "Red")
        let squareDefinition = SKTileDefinition(texture: squareTexture, size: squareTexture.size())
        let squareGroup = SKTileGroup(tileDefinition: squareDefinition)
        
        let longTexture = SKTexture(imageNamed: "Turquoise")
        let longDefinition = SKTileDefinition(texture: longTexture, size: longTexture.size())
        let longGroup = SKTileGroup(tileDefinition: longDefinition)
        
        let tTexture = SKTexture(imageNamed: "Yellow")
        let tDefinition = SKTileDefinition(texture: tTexture, size: tTexture.size())
        let tGroup = SKTileGroup(tileDefinition: tDefinition)
        
        let tileSet = SKTileSet(tileGroups: [bgGroup, sGroup, bwsGroup, lGroup, bwlGroup, squareGroup, longGroup, tGroup])
        let gameGridNode = SKTileMapNode(tileSet: tileSet, columns: 10, rows: 18, tileSize: CGSize(width: size, height: size)/*bgTexture.size()*/)
        
        gameGridNode.position = CGPoint(x: 0.5, y: 0.5)
        gameGridNode.setScale(1)
        self.addChild(gameGridNode)
        
        //gameGrid.append(self.childNode(withName: "GameGrid") as! SKTileMapNode)
//        let bgTile = gameGridNode.tileSet.tileGroups.first(
//            where: {$0.name == "Background"})

        for column in 0...10 {
            for row in 0...18 {
                gameGridNode.setTileGroup(bgGroup, forColumn: column, row: row)
            }
        }
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
    
    // Function to move tile down once
    func moveDown()
    {
        
    }
    
    // Function to check for full rows, returns array of full rows
    func whichRowsAreFull() -> [Int]
    {
        var rows: [Int] = []
        
        return rows
    }
    
    // Function to delete a row
    func deleteRow(_ row: Int)
    {
        
    }
}
