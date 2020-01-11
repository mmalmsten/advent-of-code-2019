import Swift
import Foundation

var cells: [(Int, Int)] = []

let filename = "puzzle3.txt"
let contents = try! String(contentsOfFile: filename)
let lines = contents.split(separator:"\n")

var x: [String]
var width: Int
var height: Int

for line in lines {
    x = line.components(separatedBy: ["#", " ", "@", ",", ":", "x"])
    width = Int(x[4]) ?? 0
    for w in (width + 1)...(width + (Int(x[7]) ?? 0)) {
        height = Int(x[5]) ?? 0
        for h in (height + 1)...(height + (Int(x[8]) ?? 0)) {
            cells.append((w, h))
        }
    }
}

cells.sort(by: <)

var claims: Int = 0
var n = 0
for cell in cells {
    if n < cells.count - 1 {
        //Ignore if the cell before is the same as the current
        if n < 1 || cell != cells[n-1] {
            //Add to claims if the following cell is the same
            if cell == cells[n+1] {
                claims += 1
            }
        }
    }
    n += 1
}

print(claims)
