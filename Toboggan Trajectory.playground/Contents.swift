
import Foundation

/*
 --- Day 3: Toboggan Trajectory ---

 With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

 Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

 ..##.......
 #...#...#..
 .#....#..#.
 ..#.#...#.#
 .#...##..#.
 ..#.##.....
 .#.#.#....#
 .#........#
 #.##...#...
 #...##....#
 .#..#...#.#
 These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

 ..##.........##.........##.........##.........##.........##.......  --->
 #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
 .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
 ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
 .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
 ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
 .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
 .#........#.#........#.#........#.#........#.#........#.#........#
 #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
 #...##....##...##....##...##....##...##....##...##....##...##....#
 .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
 You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

 The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

 From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

 The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

 ..##.........##.........##.........##.........##.........##.......  --->
 #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
 .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
 ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
 .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
 ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
 .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
 .#........#.#........X.#........#.#........#.#........#.#........#
 #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
 #...##....##...##....##...#X....##...##....##...##....##...##....#
 .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
 In this example, traversing the map using this slope would cause you to encounter 7 trees.

 Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
 
 Answer:
 
 Failed: 229
 
 Success: 145
 */

let file = Bundle.main.url(forResource: "input", withExtension: "txt")
let rawText = try String(contentsOf: file!, encoding: .utf8)
let list = rawText.components(separatedBy: .newlines)

var numberOfOperations = 0

extension String {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    
    mutating func replaceCharacter(at index: Int, with char: Character) {
        var chars = Array(self)
        chars[index] = char
        self = String(chars)
    }
}

struct MapLayer: CustomStringConvertible {
    var openSpace: [Int] = []
    var treeSpace: [Int] = []
    var description: String {
        var output = String(repeating: ".", count: 31)
        for location in treeSpace {
            output.replaceCharacter(at: location, with: "#")
        }
        return output
    }
    
    init(_ input: String) {
        for i in 0..<input.count {
            if input[i] == "." {
                openSpace.append(i)
            } else if input[i] == "#" {
                treeSpace.append(i)
            }
        }
    }
    
    func isTree(_ position: Int) -> Bool {
        let posCheck = Int(position % 31)
        
        return treeSpace.contains(posCheck)
    }
    
    private func trajectory(with location: Int) {
        var output = description
        
        output.replaceCharacter(at: location, with: (output[location] == ".") ? "O" : "X")
        
        print(output)
    }
}

struct TrajectoryCalculator {
    
    typealias Trajectory = (down: Int, right: Int)
    
    var map: [MapLayer] = []
    
    init(_ input: [String]) {
        let list = input.filter { $0 != "" }
        self.map = list.compactMap { MapLayer($0) }
    }
    
    func numberOfTrees(with trajectory: Trajectory) -> Int {
        var numberOfTrees = 0
        var numberOfLoops = 1
        
        for num in stride(from: trajectory.down, to: map.count, by: trajectory.down) {
            numberOfOperations += 1
            
            numberOfTrees += map[num].isTree(trajectory.right * numberOfLoops) ? 1 : 0
            numberOfLoops += 1
        }
        
        return numberOfTrees
    }
    
    func printMap() {
        for layer in map {
            print(layer)
        }
    }
}

let calculator = TrajectoryCalculator(list)
let numOfTrees = calculator.numberOfTrees(with: (1, 3))

print("Trees Encountered: \(numOfTrees)")
print("Number of Operations: \(numberOfOperations)")

numberOfOperations = 0
print("-------------------------------------------")

/*
 --- Part Two ---

 Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

 Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

 Right 1, down 1.
 Right 3, down 1. (This is the slope you already checked.)
 Right 5, down 1.
 Right 7, down 1.
 Right 1, down 2.
 In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

 What do you get if you multiply together the number of trees encountered on each of the listed slopes?
 
 Answer:
 
 3424528800
 
 */

extension Array where Element == Int {
    func product() -> Int {
        var product = self[0]
        
        for i in 1..<self.count {
            product *= self[i]
        }
        
        return product
    }
}

extension TrajectoryCalculator {
    func numberOfTrees(with trajectories: [Trajectory]) -> Int {
        var numberOfTrees: [Int] = []
        
        for trajectory in trajectories {
            numberOfTrees.append(self.numberOfTrees(with: trajectory))
        }
        
        return numberOfTrees.product()
    }
}

var trajectories: [TrajectoryCalculator.Trajectory] = [(1,1),
                                                       (1,3),
                                                       (1, 5),
                                                       (1, 7),
                                                       (2, 1)]
let numberOfTrees = calculator.numberOfTrees(with: trajectories)

print("Product of encountered trees: \(numberOfTrees)")
print("Number of Operations: \(numberOfOperations)")
