//
//  main.swift
//  Game of Life
//
//  Created by Eric Middelhove on 11.05.21.
//

import Foundation


let xLength = 4
let yLength = 4
let amountOfEvolutions = 1

var inputArray: [[Int]] = Array(repeating: Array(repeating: 0, count: xLength), count: yLength)
var heatmap = inputArray


/**
 Printing the array to the console
    * param: arr -> The array that should be printed
 */
func printArray(arr : [[Int]]){
    
    var out = ""
    for i in 0 ... yLength-1 {
        for j in 0 ... xLength-1 {
            out += String(arr[i][j])
        }
        out += "\n"
    }
    
    print(out)
}

/**
 converts the inputArray to a heatmap and saves the values inside the heatmap array
 */
func convertToHeatmap(arr: [[Int]]){
    
    for i in 0 ... yLength - 1 {
        for j in 0 ... xLength - 1 {
            heatmap[i][j] = amountOfNeighbours(arr: arr, x: j, y: i)
        }
    }
    
}


/**
 Calculates the next iteration of the GameOfLife
 */
func evolution(arr: [[Int]]) -> [[Int]]{
    
    var newArray = arr
    
    for i in 0 ... yLength - 1 {
        for j in 0 ... xLength - 1 {
           
            let amount = amountOfNeighbours(arr: arr,x: j, y: i)
            
            if amount == 3 {
                newArray[i][j] = 1
            }
            
            if !(amount == 3 || amount == 2){
                newArray[i][j] = 0
            }
            
        }
    }
    
    return newArray
}

/**
 Counts the amout of neighbours around a cell
    * Does not count itself as a neighbour
    * Does not run into an exception when the end of the array is reached
 */
func amountOfNeighbours(arr:[[Int]], x: Int, y: Int) -> Int{
    
    var neighbours = 0
    var startCoordinates = (x: x - 1, y: y - 1)
    var endCoordinates = (x: x + 1, y: y + 1)
    
    startCoordinates = checkCoordinateValidity(c: startCoordinates)
    endCoordinates = checkCoordinateValidity(c: endCoordinates)

    for i in startCoordinates.y ... endCoordinates.y {
        for j in startCoordinates.x ... endCoordinates.x {
            
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
 */
func checkCoordinateValidity (c: (x: Int, y: Int)) -> (x: Int, y: Int){
    var coord = c
    if coord.x < 0 {
        coord.x = 0
    }
    if coord.y < 0 {
        coord.y = 0
    }
    if coord.x > xLength - 1 {
        coord.x = xLength - 1
    }
    if coord.y > yLength - 1{
        coord.y = yLength - 1
    }
    
    return coord
}



//Main function calls

//Setting the inputs
inputArray[0][1] = 1
inputArray[1][1] = 1
inputArray[2][1] = 1

//printing the input array
print("input")
printArray(arr: inputArray)

//converting to heatmap
convertToHeatmap(arr: inputArray)

//going to next iteration
for _ in 0 ... amountOfEvolutions - 1 {
    inputArray = evolution(arr: inputArray)
    printArray(arr: inputArray)
}



//printing heatmap
//print("heatmap")
//printArray(arr: heatmap)
