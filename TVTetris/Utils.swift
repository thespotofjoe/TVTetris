//
//  Utils.swift
//  TVTetris
//
//  Created by Joseph Buchoff on 9/8/20.
//  Copyright © 2020 Joe's Studio. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

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
    func movePieceDown()
    {
        //print("Attempting to move active piece down")
        
        if let unwrappedActivePiece = activePiece
        {
            // Check if we can move this piece down or not
            if unwrappedActivePiece.canMoveDown(grid: gameGrid)
            {
                // Erase square from grid so we don't have old ghost squares
                for square in unwrappedActivePiece.getSquares()
                {
                    gameGrid[square.getRowIndex()][square.getColumnIndex()] = .background
                }
                
                // Move the piece down
                unwrappedActivePiece.moveDown(grid: gameGrid)
                
                // Add piece back to gameGrid in the new position
                updateGameGrid()
                
                // If the piece is unable to move down further, set it to inactive
                if !unwrappedActivePiece.canMoveDown(grid: gameGrid) { activePiece = nil }
            }
        }
    }
    
    // Moves currently active piece left 1 if possible.
    func movePieceLeft()
    {
        print("Attempting to move active piece left")
        
        if let unwrappedActivePiece = activePiece
        {
            if unwrappedActivePiece.canMoveLeft(grid: gameGrid)
            {
                // Erase square from grid so we don't have old ghost squares
                for square in unwrappedActivePiece.getSquares()
                {
                    gameGrid[square.getRowIndex()][square.getColumnIndex()] = .background
                }
                
                // Move the piece left
                unwrappedActivePiece.moveLeft(grid: gameGrid)
                
                // Add piece back to gameGrid in the new position
                updateGameGrid()
            }
        }
    }
    
    // Moves currently active piece right 1 if possible.
    func movePieceRight()
    {
        print("Attempting to move active piece right")
        
        if let unwrappedActivePiece = activePiece
        {
            if unwrappedActivePiece.canMoveRight(grid: gameGrid)
            {
                // Erase square from grid so we don't have old ghost squares
                for square in unwrappedActivePiece.getSquares()
                {
                    gameGrid[square.getRowIndex()][square.getColumnIndex()] = .background
                }
                
                // Move the piece down
                unwrappedActivePiece.moveRight(grid: gameGrid)
                
                // Add piece back to gameGrid in the new position
                updateGameGrid()
            }
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
    
    // Gamestep
    func gameStep()
    {
        if let _ = activePiece
        {
            movePieceDown()
        } else {
            spawnPiece()
        }
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
    func canMoveDown(grid: [[TileType]]) -> Bool
    {
        if (isOnBottom() || isOnTopOfOtherPiece(grid: grid))
        {
            isActive = false
            return false
        }
        
        return true
    }
    
    // Tells caller whether htis tile can move left or not
    func canMoveLeft(grid: [[TileType]]) -> Bool
    {
        if piecesToLeft(grid: grid) || isOnLeft() { return false }
        return true
    }
    
    // Tells caller whether htis tile can move right or not
    func canMoveRight(grid: [[TileType]]) -> Bool
    {
        if piecesToRight(grid: grid) || isOnRight() { return false }
        return true
    }
    
    // Moves all the squares in this piece down one, if possible.
    func moveDown(grid: [[TileType]])
    {
        for square in squares
        {
            square.moveDown(grid: grid)
        }
    }
    
    // Moves all the squares in this piece left one, if possible.
    func moveLeft(grid: [[TileType]])
    {
        for square in squares
        {
            square.moveLeft(grid: grid)
        }
    }
    
    // Moves all the squares in this piece left one, if possible.
    func moveRight(grid: [[TileType]])
    {
        for square in squares
        {
            square.moveRight(grid: grid)
        }
    }
    
    // Returns true if any squares are on top of another Tetris piece
    func isOnTopOfOtherPiece(grid: [[TileType]]) -> Bool
    {
        for square in squares
        {
            if !square.isOnBottom()
            {
                // Makes sure we don't count another suqare from this piece as a false positive
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
    
    // Returns true if any squares from other pieces are just to the right of this tile
    func piecesToLeft(grid: [[TileType]]) -> Bool
    {
        for square in squares
        {
            if !square.isOnLeft()
            {
                // Makes sure we don't count another suqare from this piece as a false positive
                if !self.containsSquareInSpot(indexToCheck: square.indecesToLeft()!)
                {
                    if square.hasOtherSquareOnLeft(grid: grid)
                    {
                        //print("There is another piece on the left.")
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    // Returns true if any squares from other pieces are just to the right of this tile
    func piecesToRight(grid: [[TileType]]) -> Bool
    {
        for square in squares
        {
            if !square.isOnRight()
            {
                // Makes sure we don't count another suqare from this piece as a false positive
                if !self.containsSquareInSpot(indexToCheck: square.indecesToRight()!)
                {
                    if square.hasOtherSquareOnRight(grid: grid)
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
    
    // Returns true if any of the squares in this piece are in the leftmost column
    func isOnLeft() -> Bool
    {
        for square in squares
        {
            if square.isOnLeft()
            {
                return true
            }
        }
        
        return false
    }
    
    // Returns true if any of the squares in this piece are in the rightmost column
    func isOnRight() -> Bool
    {
        for square in squares
        {
            if square.isOnRight()
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
        //print("Checking if there is a square in row: \(indexToCheck[0]), column:\(indexToCheck[1])")
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
    func containsRowIndex(_ rowIndex: Int) -> Bool { return self.rowIndex == rowIndex }
    
    // If this square is in that column, return true. Otherwise return false.
    func containsColumnIndex(_ columnIndex: Int) -> Bool { return self.columnIndex == columnIndex }
    
    // Says whether the piece is on the bottom row or not.
    func isOnBottom() -> Bool
    {
        return containsRowIndex(0)
    }
    
    // Says whether the square is touching the left side or not
    func isOnLeft() -> Bool
    {
        return containsColumnIndex(0)
    }
    
    // Says whether the square is touching the right side or not
    func isOnRight() -> Bool
    {
        return containsColumnIndex(9)
    }
    
    // Returns true if this square is on top of another Tetris piece
    func isOnTopOfOtherSquare(grid: [[TileType]]) -> Bool
    {
        if !isOnBottom()
        {
            //print("Not on bottom. Doing checks.")
            let squareBelow = grid[rowIndex-1][columnIndex]
            if squareBelow != TileType.background
            {
                return true
            }
        }
        return false
    }
    
    // Returns true if this square has another piece to the left
    func hasOtherSquareOnLeft(grid: [[TileType]]) -> Bool
    {
        if !isOnLeft()
        {
            let squareToLeft = grid[rowIndex][columnIndex-1]
            if squareToLeft != TileType.background
            {
                return true
            }
        }
        return false
    }
    
    // Returns true if this square has another piece to the right
    func hasOtherSquareOnRight(grid: [[TileType]]) -> Bool
    {
        if !isOnRight()
        {
            let squareToRight = grid[rowIndex][columnIndex+1]
            if squareToRight != TileType.background
            {
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
    
    // Returns indeces of square to the left, if there are any
    func indecesToLeft() -> [Int]? { return isOnLeft() ? nil : [rowIndex, columnIndex - 1] }
    
    // Returns indeces of square to the right, if there are any
    func indecesToRight() -> [Int]? { return isOnRight() ? nil : [rowIndex, columnIndex + 1] }
    
    // Moves the square down one row if possible
    func moveDown(grid: [[TileType]])
    {
        //print("In Square.moveDown() about to actually move down. Row: \(rowIndex).")
        if !isOnBottom() { rowIndex -= 1 }
        //print("In Square.moveDown(). Moved down. Row: \(rowIndex).")
    }
    
    // Moves the square left one column if possible
    func moveLeft(grid: [[TileType]])
    {
        //print("In Square.moveLeft() about to actually move left. Column: \(columnIndex).")
        if !isOnLeft() { columnIndex -= 1 }
        //print("In Square.moveLeft(). Moved left. Column: \(columnIndex).")
    }
    
    // Moves the square right one column if possible
    func moveRight(grid: [[TileType]])
    {
        //print("In Square.moveRight() about to actually move right. Column: \(columnIndex).")
        if !isOnRight() { columnIndex += 1 }
        //print("In Square.moveRight(). Moved right. Column: \(columnIndex).")
    }
    
    // Returns whether this square is in a specific spot
    func isInSpot(spot: [Int]) -> Bool
    {
        //print("Checking if these are the same:\nIndeces 1: \(rowIndex), \(columnIndex)\nIndeces 2: \(spot[0]), \(spot[1])\nResult: \(rowIndex == spot[0] && columnIndex == spot[1])")
        return rowIndex == spot[0] && columnIndex == spot[1]
    }
}
