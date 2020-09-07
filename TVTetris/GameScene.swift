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
    
    static func random() -> TileType
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
        return TileType.background
    }
    
    func text() -> String
    {
        switch self
        {
        case .s_tile:
            return "S Piece"
        case .backwards_s_tile:
            return "Backwards S Piece"
        case .l_tile:
            return "L Piece"
        case .backwards_l_tile:
            return "Backwards L Piece"
        case .square_tile:
            return "Square Piece"
        case .long_tile:
            return "Long Piece"
        case .t_tile:
            return "T Piece"
        case .background:
            return "Background"
        }
    }
}

// Class to do all the game logic and hold all the game data.
class TetrisGame
{
    private var alreadyInstantiated = false
    private var gameGrid: [[TileType]] = [[]]
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
        resetGameGrid(firstRun: true)
    }
    
    func resetGameGrid(firstRun: Bool)
    {
        var resetRow: [TileType] = []
        for _ in 1...10
        {
            resetRow.append(.background)
        }
        
        gameGrid[0] = resetRow
        for i in 1..<18
        {
            if firstRun
            {
                gameGrid.append(resetRow)
            } else {
                gameGrid[i] = resetRow
            }
        }
    }
    
    func getGameGrid() -> [[TileType]]
    {
        return gameGrid
    }
    
    // Moves currently active piece down 1.
    func movePieceDown(grid: [[TileType]])
    {
        print("Attempting to move active piece down")
        
        if let unwrappedActivePiece = activePiece
        {
            // Erase square from grid so we don't have old ghost squares
            for square in unwrappedActivePiece.getSquares()
            {
                gameGrid[square.getRowIndex()][square.getColumnIndex()] = .background
            }
            
            // Move the piece down
            unwrappedActivePiece.moveDown(grid: grid)
            
            // Add piece back to gameGrid in the new position
            updateGameGrid()
            
            // If the piece is unable to move down further, set it to inactive
            if !unwrappedActivePiece.canMoveDown(grid: grid) { activePiece = nil }
        }
    }
    
    // Function to check if a piece has landed or is still falling.
    func checkIfLanded() -> Bool
    {
        return false
    }
    
    // Function to check if a row is completed.
    func checkForCompletedRow(_ row: Int)
    {
        
    }
    
    // Function to delete a row if completed, and move everything above it down.
    func deleteRow(_ row: Int, grid: [[TileType]])
    {
        for piece in pieces
        {
            piece.deleteRow(row, grid: grid)
        }
    }
    
    // Moves everything above a certain row down. Done as part of deleting a completed row.
    func moveChunkDown(aboveRow: Int)
    {
        
    }
    
    // Adds tile, sets to active
    func spawnPiece()
    {
        let newPiece = TetrisPiece(type: TileType.random())
        activePiece = newPiece
        pieces.append(newPiece)
        updateGameGrid()
    }
    
    // Updates gameGrid to include new piece
    func updateGameGrid()
    {
        if let unwrappedActivePiece = activePiece
        {
            for index in unwrappedActivePiece.getIndeces()
            {
                gameGrid[index[0]][index[1]] = unwrappedActivePiece.getType()
            }
        }
    }
    
    // Gets indeces of activePiece
    func getActivePieceIndeces() -> [[Int]]
    {
        if let activePiece = self.activePiece
        {
            return activePiece.getIndeces()
        }
        
        return [[0,0]]
    }
    
    // Getter for activePiece
    func getActivePiece() -> TetrisPiece?
    {
        return activePiece
    }
}

class TetrisPiece
{
    private var squares: [Square] = []
    private var type: TileType
    private var isActive = true
    
    init (squares: [Square], type: TileType)
    {
        self.squares = squares
        self.type = type
    }
    
    init (type: TileType, startColumn: Int, startRow: Int)
    {
        self.type = type
        
        var moves: [[Int]] = [[]]
        
        // Initializing only for compiler happiness. It doesn't understand it's initialized in switch
        //var tileGroup: SKTileGroup = tileGroups["T Tile"]!
        
        switch (type)
        {
        case TileType.s_tile:
            moves = [[-1, 0], [0, 1], [-1, 0]]
            //tileGroup = tileGroups["S Tile"]!
            
        case TileType.backwards_s_tile:
            moves = [[-1, 0], [0, -1], [-1, 0]]
            //tileGroup = tileGroups["Backward S Tile"]!
            
        case TileType.l_tile:
            moves = [[-1, 0], [-1, 0], [0, 1]]
            //tileGroup = tileGroups["L Tile"]!
            
        case TileType.backwards_l_tile:
            moves = [[-1, 0], [-1, 0], [0, -1]]
            //tileGroup = tileGroups["Backward L Tile"]!
            
        case TileType.square_tile:
            moves = [[0, 1], [-1, 0], [0, -1]]
            //tileGroup = tileGroups["Square Tile"]!
            
        case TileType.long_tile:
            moves = [[-1, 0], [-1, 0], [-1, 0]]
            //tileGroup = tileGroups["Long Tile"]!
            
        case TileType.t_tile:
            moves = [[-1, 0], [0, 1], [-1, -1]]
            //tileGroup = tileGroups["T Tile"]!
        default:
            // It'll never get here but the compiler must be happy
            break
        }
        
        var column = startColumn - 1
        var row = startRow - 1
        
        var indeces = [[row, column]]
        
        for move in moves
        {
            column += move[1]
            row += move[0]
            indeces.append([row, column])
        }
        
        for index in indeces
        {
            squares.append(Square(rowIndex: index[0], columnIndex: index[1], type: type))
        }
    }
    
    // convenience init for a tile at the startline
    convenience init (type: TileType)
    {
        self.init(type: type, startColumn: 5, startRow: 18)
    }
    
    // Tells caller whether this tile can move down or not, updates isActive accordingly
    func canMoveDown(grid:[[TileType]]) -> Bool
    {
        if (isOnBottom() || isOnTopOfOtherPiece(grid: grid))
        {
            isActive = false
            return false
        }
        
        return true
    }
    
    // Moves all the squares in this piece down one, if possible. Returns whether it's active or not after moving down.
    func moveDown(grid: [[TileType]])
    {
        for square in squares
        {
            square.moveDown(grid: grid)
        }
    }
    
    // Returns true if any squares are on top of another Tetris piece
    func isOnTopOfOtherPiece(grid: [[TileType]]) -> Bool
    {
        for square in squares
        {
            if !square.isOnBottom()
            {
                if !self.containsSquareInSpot(indexToCheck: square.indecesBelow()!)
                {
                    if square.isOnTopOfOtherSquare(grid: grid)
                    {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    // Returns true if any of the squares in this piece are in the bottom row
    func isOnBottom() -> Bool
    {
        for square in squares
        {
            if square.isOnBottom()
            {
                return true
            }
        }
        
        return false
    }
    
    // Deletes any squares in this piece which are in that row
    func deleteRow(_ row: Int, grid: [[TileType]])
    {
        var indecesToDelete: [Int] = []
        
        for i in 0..<squares.count
        {
            // Note the squares to be deleted
            if squares[i].containsRowIndex(row)
            {
                indecesToDelete.append(i)
            }
            
            // Move all squares above the deleted row down one.
            if squares[i].getRowIndex() > row
            {
                squares[i].moveDown(grid: grid)
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
    
    // Returns whether or not this piece has a square in a certain spot on the grid
    func containsSquareInSpot(indexToCheck: [Int]) -> Bool
    {
        print("Checking if there is a square in row: \(indexToCheck[0]), column:\(indexToCheck[1])")
        for square in squares
        {
            if square.isInSpot(spot: indexToCheck)
            {
                return true
            }
        }
        
        return false
    }
    
    // Public getter for squares
    func getSquares() -> [Square]
    {
        return squares
    }
    
    // Generates and returns indeces
    func getIndeces() -> [[Int]]
    {
        //print("Getting Indeces: row: \(squares[0].getRowIndex()), \(squares[0].getColumnIndex())")
        var indeces: [[Int]] = [[squares[0].getRowIndex(), squares[0].getColumnIndex()]]
        for i in 1..<4
        {
            let square = squares[i]
            //print("Getting Indeces: row: \(square.getRowIndex()), \(square.getColumnIndex())")
            indeces.append([square.getRowIndex(), square.getColumnIndex()])
        }
        
        return indeces
    }
    
    func getType() -> TileType
    {
        return type
    }
}

class Square
{
    private var rowIndex: Int
    private var columnIndex: Int
    private var type: TileType
    
    init (rowIndex: Int, columnIndex: Int, type: TileType)
    {
        self.rowIndex = rowIndex
        self.columnIndex = columnIndex
        self.type = type
    }
    
    func getRowIndex() -> Int
    {
        return rowIndex
    }
    
    func getColumnIndex() -> Int
    {
        return columnIndex
    }
    
    func getType() -> TileType
    {
        return type
    }
    
    // If this square is in that row, return true. Otherwise return false.
    func containsRowIndex(_ rowIndex:Int) -> Bool
    {
        if self.rowIndex == rowIndex
        {
            return true
        }
        
        return false
    }
    
    //func canMoveDown(grid: [[TileType]]) -> Bool
    //{
    //    return !(isOnBottom() || isOnTopOfOtherSquare(grid: grid))
    //}
    
    // Says whether the piece is on the bottom row or not.
    func isOnBottom() -> Bool
    {
        return containsRowIndex(0)
    }
    
    // Returns true if this square is on top of another Tetris piece
    func isOnTopOfOtherSquare(grid: [[TileType]]) -> Bool
    {
        print("Checking if this square is on top of another... Row: \(rowIndex+1), Column: \(columnIndex+1)")
        if !isOnBottom()
        {
            print("Not on bottom. Doing checks.")
            let squareBelow = grid[rowIndex-1][columnIndex]
            if squareBelow != TileType.background
            {
                print("Square below is not background. Type: \(squareBelow.text())")
                return true
            }
        }
        return false
    }
    
    // Returns indeces of square below, if not on bottom
    func indecesBelow() -> [Int]?
    {
        if isOnBottom() { return nil }
        return [rowIndex - 1, columnIndex]
    }
    
    // Moves the square down one row if possible, returns whether it's still active or not after moving
    func moveDown(grid: [[TileType]])
    {
        //print("In Square.moveDown() about to actually move down. Row: \(rowIndex).")
        if !isOnBottom() { rowIndex -= 1 }
        //print("In Square.moveDown(). Moved down. Row: \(rowIndex).")
    }
    
    // Returns whether this square is in a specific spot
    func isInSpot(spot: [Int]) -> Bool
    {
        print("Checking if these are the same:\nIndeces 1: \(rowIndex), \(columnIndex)\nIndeces 2: \(spot[0]), \(spot[1])\nResult: \(rowIndex == spot[0] && columnIndex == spot[1])")
        return rowIndex == spot[0] && columnIndex == spot[1]
    }
}

// Class to handle the SKView and visual stuff.
class GameScene: SKScene {

    private var grid: SKTileMapNode? = nil
    private var tileGrid: [[SKTileGroup]] = [[]]
    private var tileGroups: [String : SKTileGroup] = [:]
    private var bgRow: [SKTileGroup] = []
    private var game = TetrisGame()
    
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
        
        tileGrid[0] = bgRow
        for _ in 1..<18
        {
            tileGrid.append(bgRow)
        }
        
        grid!.fill(with: bgGroup)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run({self.game.movePieceDown(grid: self.game.getGameGrid())}), SKAction.wait(forDuration: 0.3)])))
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
        updateTetrisGrid()
        displayGrid()
        //game.movePieceDown()
        
    }
    
    /* Our functions */
    @objc func pressed()
    {
        print("Pressed")
        //game.resetGameGrid(firstRun: false)
        game.spawnPiece()
        updateTetrisGrid()
        displayGrid()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run(moveDown)])))
    }
    
    // Function to updates the grid of TileGroups to reflect the gameGrid
    func updateTetrisGrid()
    {
        let gameGrid = game.getGameGrid()
        for row in 0..<18
        {
            for column in 0..<10
            {
                tileGrid[row][column] = groupFromType(gameGrid[row][column])
            }
        }
    }
    
    // Displays grid
    func displayGrid()
    {
        for rowIndex in 0..<18
        {
            for columnIndex in 0..<10
            {
                //print("Updating Tetris Grid. Row: \(row). Column: \(column).")
                grid!.setTileGroup(tileGrid[rowIndex][columnIndex], forColumn: columnIndex, row: rowIndex)
            }
        }
    }
    
    // Function to spawn a tile centered around its top-right-most square component.
    func spawnTile()
    {
        game.spawnPiece()
        
        let tileGroup: SKTileGroup = groupFromType(game.getActivePiece()!.getType())
        
        for index in game.getActivePieceIndeces()
        {
            tileGrid[index[0]][index[1]] = tileGroup
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
    
    // Function to move tiles down once
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
    
    // Takes TileType and returns associated SKTileGroup
    func groupFromType(_ type: TileType) -> SKTileGroup
    {
        // Initializing only for compiler happiness. It doesn't understand it's initialized in switch
        var tileGroup = tileGroups["Background"]
        
        switch (type)
        {
        case TileType.s_tile:
            tileGroup = tileGroups["S Tile"]!
            
        case TileType.backwards_s_tile:
            tileGroup = tileGroups["Backward S Tile"]!
            
        case TileType.l_tile:
            tileGroup = tileGroups["L Tile"]!
            
        case TileType.backwards_l_tile:
            tileGroup = tileGroups["Backward L Tile"]!
            
        case TileType.square_tile:
            tileGroup = tileGroups["Square Tile"]!
            
        case TileType.long_tile:
            tileGroup = tileGroups["Long Tile"]!
            
        case TileType.t_tile:
            tileGroup = tileGroups["T Tile"]!
        default:
            // It'll never get here but the compiler must be happy
            break
        }
        
        return tileGroup!
    }
}
