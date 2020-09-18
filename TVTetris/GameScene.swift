//
//  GameScene.swift
//  TVTetris
//
//  Created by Joseph Buchoff on 8/31/20.
//  Copyright © 2020 Joe's Studio. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

// Class to handle the SKView and visual stuff.
class GameScene: SKScene {

    private var grid: SKTileMapNode? = nil
    private var tileGrid: [[SKTileGroup]] = [[]]
    private var tileGroups: [String : SKTileGroup] = [:]
    private var bgRow: [SKTileGroup] = []
    private var game = TetrisGame()
    private var lastUpdate: TimeInterval = 0
    private var dtUpdate: TimeInterval = 0
    
    // Variables to hold screen width and height. Will get programmatically later.
    private var screenWidth = 1920
    private var screenHeight = 1080
    
    // Variable to help dpad stuff
    //private var actionsSincePress = 0
    
    // Variable to help us detect right and left clicks on the remote
    //private var dPadState: DPadState = .select
    
    /* Overridden system functions */
    override func didMove(to view: SKView)
    {
        setUpControllerObservers()
        
        //let press: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pressed))
        //press.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        //view.addGestureRecognizer(press)
        print("Got here 1")
        // Set width and height of square tiles to 40. (for 4K screens, this should be 80)
        let size = 40
        
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
        
        grid!.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
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
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run({self.spawnTile()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()}),
            SKAction.wait(forDuration: 0.3),
            SKAction.run({self.game.movePieceDown()})])))
        print("Should be up and running right now")
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        /* Called before each frame is rendered */
        updateTetrisGrid()
        displayGrid()
        
    }
    
    /* Our functions */
    // Function to handle presses. Will be updated when I add controller functionality
    @objc func pressed()
    {
        print("Pressed center.")
        //self.game.spawnPiece()
        self.game.movePieceLeft()
        self.updateTetrisGrid()
        self.displayGrid()
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

extension GameScene {
    func setUpControllerObservers()
    {
        print("in setUpControllerObservers()")
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectController), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectController), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    // This Function is called when a controller is connected to the Apple TV
    @objc func connectController()
    {
        print("in connectController(). Controller detected")
        //Unpause the Game if it is currently paused
        self.isPaused = false
        
        for controller in GCController.controllers()
        {
            if let extendedGamepad = controller.extendedGamepad
            {
                print("found extendedGamepad.")
                setupControllerControls(extendedGamepad)
            }
        }
        
    }
    
    // This Function is called when a controller is disconnected from the Apple TV
    @objc func disconnectController()
    {
        // Pause the game
        self.isPaused = true
    }
    
    func setupControllerControls(_ extendedGamepad: GCExtendedGamepad)
    {
        let rotateTileHandler: GCControllerButtonValueChangedHandler =
        {[unowned self] _,_,pressed in
            if pressed
            {
                print("Button A Pressed")
            } else {
                print("Button A Released")
            }
            // Rotate the tile
        }
        
        let moveTileHandler: GCControllerDirectionPadValueChangedHandler =
        {[unowned self] _, xValue, yValue in
            print("DPad changed!")
            
            //If it's pointing to the left
            if xValue < -0.5
            {
                print("Left Pressed!")
            } else if xValue > 0.5 {
                print("Right Pressed!")
            } else if xValue == 0 {
                print("DPad Released!")
            }
        }
        
        print("In setupControllerControls()")
        //Function that check the controller when anything is moved or pressed on it
        extendedGamepad.buttonA.pressedChangedHandler = rotateTileHandler
        extendedGamepad.dpad.valueChangedHandler = moveTileHandler
    }
    
/*    func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int)
    {
        print("Input detected.")
        // Left Thumbstick
        if (gamepad.leftThumbstick == element)
        {
            if (gamepad.leftThumbstick.xAxis.value != 0)
            {
            print("Controller: \(index), LeftThumbstickXAxis: \(gamepad.leftThumbstick.xAxis)")
            } else if (gamepad.leftThumbstick.xAxis.value == 0) {
                // Thumbstick is back to center
            }
        }
        
        // Right Thumbstick
        if (gamepad.rightThumbstick == element)
        {
            if (gamepad.rightThumbstick.xAxis.value != 0)
            {
            print("Controller: \(index), rightThumbstickXAxis: \(gamepad.rightThumbstick.xAxis)")
            } else if (gamepad.rightThumbstick.xAxis.value == 0) {
                // Thumbstick is back to center
            }
        }
            
        // D-Pad
        else if (gamepad.dpad == element)
        {
            if (gamepad.dpad.xAxis.value != 0)
            {
                print("Controller: \(index), D-PadXAxis: \(gamepad.dpad.xAxis)")
            } else if (gamepad.dpad.xAxis.value == 0) {
                // D-Pad is back to center
            }
        }
    }*/
      /*
        // B Button
        else if (gamepad.buttonB == element)
        {
            if (gamepad.buttonB.value != 0)
            {
                print("Controller: \(index), B-Button Pressed!")
            }
        }
            
        // Y Button
        else if (gamepad.buttonY == element)
        {
            if (gamepad.buttonY.value != 0)
            {
                print("Controller: \(index), Y-Button Pressed!")
            }
        }
            
        // X Button
        else if (gamepad.buttonX == element)
        {
            if (gamepad.buttonX.value != 0)
            {
                print("Controller: \(index), X-Button Pressed!")
            }
        }
    }*/
}
