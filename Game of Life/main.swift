//
//  main.swift
//  Game of Life
//
//  Created by Eric Middelhove on 11.05.21.
//


/**
 
    I almost finishef excercise 4, the last thing I wanted to implement was the scrolling of the Array but there was no time for that :) My first plan was to just adjust the size of the array but that is not possible because i can not change the original input array size during the evolution process since all functions use parameters of the original input array and not the public var itself. The next plan was to recalculate the indices but I had no time anymore. :)
 
 */


import Foundation

let xLength = 30
let yLength = 30
let amountOfEvolutions = 10

var inputArray: [[Int]] = Array(repeating: Array(repeating: 0, count: xLength), count: yLength)



/**
 Printing the array to the console
 - Parameters:
    - arr: The array that should be printed
    - beautiful: f beautiful it prints * instead of 1 and " " instead of 0 - Do not use beautiful when printing a heatmap
 */
func printArray(arr : [[Int]], beautiful: Bool){
    
    var out = ""
    for i in 0 ... yLength-1 {
        for j in 0 ... xLength-1 {
            if beautiful {
                out += arr[i][j] == 1 ? "*" : " "
            }else{
                out += String(arr[i][j])
            }
        }
        out += "\n"
    }
    
    print(out)
}

/**
 converts the inputArray to a heatmap and saves the values inside the heatmap array
   
    - Parameters:
        - arr: The Array to be printed
        - wrap: If true the array wraps around
 */
func convertToHeatmap(arr: [[Int]], wrap: Bool) -> [[Int]]{
    var heatmap = Array(repeating: Array(repeating: 0, count: xLength), count: yLength)
    
    for i in 0 ... yLength - 1 {
        for j in 0 ... xLength - 1 {
            heatmap[i][j] = amountOfNeighbours(arr: arr, x: j, y: i, wrap: wrap)
        }
    }
    return heatmap
}


/**
 Calculates the next iteration of the GameOfLife
 - Parameters:
    - wrap: If true the array wraps around
    - arr: The array used as an input for the evolutions
    - amountOfEvolutions: The amount of evolutions that should be done
    - beautiful: Prints array beautified
 */
func evolution(arr: [[Int]], amountOfEvolutions: Int, wrap: Bool, beautiful: Bool) -> [[Int]]{
    
    var newArray = arr
    print(amountOfEvolutions)
    var prevArrays = [newArray]
    
    for _ in 0 ... amountOfEvolutions - 1 {
        print("\u{001B}[2J")
        printArray(arr: newArray, beautiful: beautiful)
        sleep(1)
        
        for i in 0 ... yLength - 1 {
            for j in 0 ... xLength - 1 {
                let amount = amountOfNeighbours(arr: newArray,x: j, y: i, wrap: wrap)
                
                if amount == 3 {
                    newArray[i][j] = 1
                }
                
                if !(amount == 3 || amount == 2){
                    newArray[i][j] = 0
                }
            }
        }
        
        if prevArrays.contains(newArray){
            print("stop")
           
            return newArray
        }
        prevArrays += [newArray]
    }
    print("evolution finished")
    print("Amount of cycles: " + String(prevArrays.count - 1))
    return newArray
}

/**
 Counts the amout of neighbours around a cell
    * Does not count itself as a neighbour
    * Does not run into an exception when the end of the array is reached
 - Parameters:
    - wrap: If true the array wraps around
 */
func amountOfNeighbours(arr:[[Int]], x: Int, y: Int, wrap: Bool) -> Int{
    
    var neighbours = 0
    var startCoordinates = (x: x - 1, y: y - 1)
    var endCoordinates = (x: x + 1, y: y + 1)
    
    startCoordinates = checkCoordinateValidity(c: startCoordinates, wrap: wrap)
    endCoordinates = checkCoordinateValidity(c: endCoordinates, wrap: wrap)

    let yRange = startCoordinates.y < endCoordinates.y ? startCoordinates.y ... endCoordinates.y : endCoordinates.y ... startCoordinates.y
    let xRange = startCoordinates.x < endCoordinates.x ? startCoordinates.x ... endCoordinates.x : endCoordinates.x ... startCoordinates.x
    
    for i in yRange {
        for j in xRange{
            
            // has the cell a neighbout && is the cell not me
            if (arr[i][j] == 1 && !(i == y && j == x)) {
                neighbours += 1
            }
            
        }
    }
    
    return neighbours
}

/**
    checks if a coordinate is inside of the array boundaries
        * If not it returns the last coordinate inside of the array
        * If wrap is true the board array wraps around
    - Parameters:
        - c: the coordinates that should be checked, formatted as a tupel
        - wrap: If true the array wraps around
 */
func checkCoordinateValidity (c: (x: Int, y: Int), wrap: Bool) -> (x: Int, y: Int){
    var coord = c
    if coord.x < 0 {
        coord.x = 0
    }
    if coord.y < 0 {
        coord.y = 0
    }
    if coord.x > xLength - 1 {
        if wrap {
            coord.x = coord.x % xLength
        }else{
            coord.x = xLength - 1
        }
    }
    if coord.y > yLength - 1{
        if wrap {
            coord.y = coord.y % yLength
        }else{
            coord.y = yLength - 1
        }
    }
    
    return coord
}



//Main function calls

//Setting the inputs

inputArray[0][1] = 1
inputArray[1][2] = 1
inputArray[2][0] = 1
inputArray[2][1] = 1
inputArray[2][2] = 1
inputArray[2][3] = 1
inputArray[3][3] = 1

//Evolution
inputArray = evolution(arr: inputArray, amountOfEvolutions: amountOfEvolutions, wrap: true, beautiful: true)

print("final evolution state: ")
printArray(arr: inputArray, beautiful: true)
//printing heatmap

printArray(arr: convertToHeatmap(arr: inputArray, wrap: false), beautiful: false)
