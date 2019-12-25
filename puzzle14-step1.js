let fs = require("fs")

let fuel = {}
let reactions = {}
let remaining = {}

// -----------------------------------------------------------------------------
// Import and format data
// -----------------------------------------------------------------------------
const import_data = () => {
    let lst = fs
        .readFileSync("/Users/madde/Sites/advent-of-code-2019/input/puzzle14.txt")
        .toString()
        .split("\n")

    lst.forEach(li => {
        li = li.split(" => ")
        li[1] = li[1].split(" ")
        li[0] = li[0].split(", ")

        let ingredients = {}
        li[0].forEach(l => {
            l = l.split(" ")
            ingredients[l[1]] = parseFloat(l[0])
        })

        if(li[1][1] == "FUEL") {
            fuel = ingredients
        } else {
            reactions[li[1][1]] = {
                amount: parseFloat(li[1][0]), 
                ingredients: ingredients
            }
            remaining[li[1][1]] = 0    
        }
    })
}

// -----------------------------------------------------------------------------
// Get ore amount needed for a cetrain amount of chemical
// -----------------------------------------------------------------------------
let get_ore_amount = (chemical, amount) => {
    let need = amount - remaining[chemical]
    if (need <= chemical) {
        remaining[chemical] -= amount
        return 0
    }
    let ns = parseInt(Math.ceil(need / reactions[chemical]["amount"]))
    remaining[chemical] += (ns * reactions[chemical]["amount"]) - amount
    let ore = 0
    for (var i = 0; i < ns; i++) {
        Object.keys(reactions[chemical]["ingredients"]).forEach(ingredient => {
            if(ingredient == "ORE")
                ore += reactions[chemical]["ingredients"][ingredient]
            else
                ore += get_ore_amount(
                    ingredient, reactions[chemical]["ingredients"][ingredient]
                )
        })
    }
    return ore
}

import_data()
let ore = 0
Object.keys(fuel).forEach(chemical => 
    ore += get_ore_amount(chemical, fuel[chemical])
)
console.log(parseInt(ore))