//
//  GameScene.swift
//  TVTetris
//
//  Created by Joseph Buchoff on 8/31/20.
//  Copyright © 2020 Joe's Studio. All rights reserved.
//

import SpriteKit
import GameplayKit

enum TileType
{
    case s_tile
    case backwards_s_tile
    case l_tile
    case backwards_l_tile
    case square_tile
    case long_tile
    case t_tile
    case background
}

// Class to do all the game logic and hold all the game data.
class TetrisGame
{
    private var alreadyInstantiated = false
    private var gameGrid: [[TileType]]? = nil
    private var pieces: [TetrisPiece] = []
    
    // Holds actively falling piece if there is one. Nil if not.
    private var activePiece: TetrisPiece? = nil
    
    init()
    {
        if alreadyInstantiated
        {
            fatalError("TetrisGame has already been instantiated. Only one instance per program.")
        }
        
        alreadyInstantiated = true
        resetGameGrid()
    }
    
    func resetGameGrid()
    {
        var resetRow: [TileType]
        for _ in 1...10
        {
            resetRow.append(.background)
        }
        for _ in 1...18
        {
            gameGrid!.append(resetRow)
        }
    }
    
    func getGameGrid() -> [[TileType]]
    {
        
    }
    
    // Moves currently active piece down 1.
    func movePieceDown()
    {
        
    }
    
    // Function to check if a piece has landed or is still falling.
    func checkIfLanded() -> Bool
    {
        
    }
    
    // Function to check if a row is completed.
    func checkForCompletedRow(_ row: Int)
    {
        
    }
    
    // Function to delete a row if completed, and move everything above it down.
    func deleteRow(_ row: Int)
    {
        for piece in pieces
        {
            piece.deleteRow(row)
        }
    }
    
    // Moves everything above a certain row down. Done as part of deleting a completed row.
    func moveChunkDown(aboveRow: Int)
    {
        
    }
}

class TetrisPiece
{
    private var squares: [Square]
    
    init (squares: [Square])
    {
        self.squares = squares
    }
    
    func getSquares() -> [Square]
    {
        return squares
    }
    
    // Moves all the squares in this piece down one, if possible.
    func moveDown()
    {
        for square in squares
        {
            // TODO check for collisions with previously dropped tiles
            square.moveDown()
        }
    }
    
    func deleteRow(_ row: Int)
    {
        var indecesToDelete: [Int]
        
        for i in 0..<squares.count
        {
            // Note the squares to be deleted
            if squares[i].containsRow(row)
            {
                indecesToDelete.append(i)
            }
            
            // Move all squares above the deleted row down one.
            if squares[i].getRow() > row
            {
                squares[i].moveDown()
            }
        }
        
        // Delete them from the pieces.
        if indecesToDelete.count > 0
        {
            for i in indecesToDelete.count-1...0
            {
                squares.remove(at: indecesToDelete[i])
            }
        }
    }
}

class Square
{
    private var row: Int
    private var column: Int
    private var type: SKTileGroup
    
    init (row: Int, column: Int, type: SKTileGroup)
    {
        self.row = row
        self.column = column
        self.type = type
    }
    
    func getRow() -> Int
    {
        return row
    }
    
    func getColumn() -> Int
    {
        return column
    }
    
    func getType() -> SKTileGroup
    {
        return type
    }
    
    // If this square is in that row, return true. Otherwise return false.
    func containsRow(_ row:Int) -> Bool
    {
        if self.row == row
        {
            return true
        }
        
        return false
    }
    
    // Moves the square down one row if possible.
    func moveDown()
    {
        if row == 0
        {
            return
        }
        
        row -= 1
    }
}

// Class to handle the SKView and visual stuff.
class GameScene: SKScene {

    private var grid: SKTileMapNode? = nil
    private var tileGrid: [[SKTileGroup]] = [[]]
    private var tileGroups: [String : SKTileGroup] = [:]
    private var bgRow: [SKTileGroup] = []
    private var game: TetrisGame? = nil
    
    /* Overridden system functions */
    override func didMove(to view: SKView)
    {
        let press: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pressed))
        press.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        view.addGestureRecognizer(press)
        
        print("Got here 1")
        // Set width and height of square tiles to 25. (for 4K screens, this should be 50)
        let size = 25
        
        // Define the background tiles.
        let bgTexture = SKTexture(imageNamed: "Background")
        let bgDefinition = SKTileDefinition(texture: bgTexture, size: CGSize(width: size, height: size)/*bgTexture.size()*/)
        let bgGroup = SKTileGroup(tileDefinition: bgDefinition)
        tileGroups["Background"] = bgGroup
        
        print("Got here 2")
        
        // Define the "S" tiles.
        let sTexture = SKTexture(imageNamed: "Green")
        let sDefinition = SKTileDefinition(texture: sTexture, size: sTexture.size())
        let sGroup = SKTileGroup(tileDefinition: sDefinition)
        tileGroups["S Tile"] = sGroup
        
        // Define the backward "S" tiles.
        let bwsTexture = SKTexture(imageNamed: "Orange")
        let bwsDefinition = SKTileDefinition(texture: bwsTexture, size: bwsTexture.size())
        let bwsGroup = SKTileGroup(tileDefinition: bwsDefinition)
        tileGroups["Backward S Tile"] = bwsGroup
        
        // Define the "L" tiles.
        let lTexture = SKTexture(imageNamed: "Pink")
        let lDefinition = SKTileDefinition(texture: lTexture, size: lTexture.size())
        let lGroup = SKTileGroup(tileDefinition: lDefinition)
        tileGroups["L Tile"] = lGroup
        
        // Define the backward "L" tiles.
        let bwlTexture = SKTexture(imageNamed: "Purple")
        let bwlDefinition = SKTileDefinition(texture: bwlTexture, size: bwlTexture.size())
        let bwlGroup = SKTileGroup(tileDefinition: bwlDefinition)
        tileGroups["Backward L Tile"] = bwlGroup
        
        // Define the square tiles.
        let squareTexture = SKTexture(imageNamed: "Yellow")
        let squareDefinition = SKTileDefinition(texture: squareTexture, size: squareTexture.size())
        let squareGroup = SKTileGroup(tileDefinition: squareDefinition)
        tileGroups["Square Tile"] = squareGroup
        
        // Define the long tiles.
        let longTexture = SKTexture(imageNamed: "Turquoise")
        let longDefinition = SKTileDefinition(texture: longTexture, size: longTexture.size())
        let longGroup = SKTileGroup(tileDefinition: longDefinition)
        tileGroups["Long Tile"] = longGroup
        
        // Define the "T" tiles.
        let tTexture = SKTexture(imageNamed: "Red")
        let tDefinition = SKTileDefinition(texture: tTexture, size: tTexture.size())
        let tGroup = SKTileGroup(tileDefinition: tDefinition)
        tileGroups["T Tile"] = tGroup
        
        let tileSet = SKTileSet(tileGroups: [bgGroup, sGroup, bwsGroup, lGroup, bwlGroup, squareGroup, longGroup, tGroup])
        grid = SKTileMapNode(tileSet: tileSet, columns: 10, rows: 18, tileSize: CGSize(width: size, height: size)/*bgTexture.size()*/)
        
        grid!.position = CGPoint(x: 1000, y: 500)
        grid!.setScale(1)
        addChild(grid!)
        print("Got here 3")
        
        for _ in 1...10
        {
            bgRow.append(bgGroup)
        }
        
        for _ in 1...18
        {
            tileGrid.append(bgRow)
        }
        
        grid!.fill(with: bgGroup)
        print("Should be up and running right now")
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
        //spawnTile(column: 5, type: randomTile()!)
    }
    
    /* Our functions */
    @objc func pressed()
    {
        game.resetTileGrid()
        grid!.fill(with: tileGroups["Background"]!)
        spawnTile(column: 5, type: randomTile()!)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run(moveDown)])))
    }
    
    func randomTile() -> TileType?
    {
        switch Int.random(in: 1...7)
        {
        case 1:
            return TileType.s_tile
        case 2:
            return TileType.backwards_s_tile
        case 3:
            return TileType.l_tile
        case 4:
            return TileType.backwards_l_tile
        case 5:
            return TileType.square_tile
        case 6:
            return TileType.long_tile
        case 7:
            return TileType.t_tile
        default:
            break
        }
        
        // Shouldn't get here but just to make the compiler happy
        return nil
    }
    
    // Function to update the game grid with the new tilemap
    func updateTetrisGrid()
    {
        for row in 1...17
        {
            for column in 1...9
            {
                print("Updating Tetris Grid. Row: \(row). Column: \(column).")
                grid!.setTileGroup(tileGrid[row][column], forColumn: column, row: row)
            }
        }
    }
    
    // Function to spawn a tile centered around its top-right-most square component.
    func spawnTile(column: Int, type: TileType)
    {
        var moves: [[Int]]
        var tileGroup: SKTileGroup
        
        switch (type)
        {
        case TileType.s_tile:
            moves = [[0, 0], [0, -1], [1, 0], [0, -1]]
            tileGroup = tileGroups["S Tile"]!
            
        case TileType.backwards_s_tile:
            moves = [[0, 0], [0, -1], [-1, 0], [0, -1]]
            tileGroup = tileGroups["Backward S Tile"]!
            
        case TileType.l_tile:
            moves = [[0, 0], [0, -1], [0, -1], [1, 0]]
            tileGroup = tileGroups["L Tile"]!
            
        case TileType.backwards_l_tile:
            moves = [[0, 0], [0, -1], [0, -1], [-1, 0]]
            tileGroup = tileGroups["Backward L Tile"]!
            
        case TileType.square_tile:
            moves = [[0, 0], [1, 0], [0, -1], [-1, 0]]
            tileGroup = tileGroups["Square Tile"]!
            
        case TileType.long_tile:
            moves = [[0, 0], [0, -1], [0, -1], [0, -1]]
            tileGroup = tileGroups["Long Tile"]!
            
        case TileType.t_tile:
            moves = [[0, 0], [0, -1], [1, 0], [-1, -1]]
            tileGroup = tileGroups["T Tile"]!
        }
        
        var rowIndex = 17
        var columnIndex = column - 1
        
        for move in moves
        {
            rowIndex += move[1]
            columnIndex += move[0]
            tileGrid[rowIndex][columnIndex] = tileGroup
        }
        
        updateTetrisGrid()
    }
    
    func touchDown(atPoint pos: CGPoint)
    {

    }
    
    func touchMoved(toPoint pos : CGPoint)
    {

    }
    
    func touchUp(atPoint pos : CGPoint)
    {

    }
    
    // Function to move tile down once
    func moveDown()
    {
        for column in 0...9
        {
            if tileGrid[0][column]
        }
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
