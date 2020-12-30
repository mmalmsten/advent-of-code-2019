<?php 

/*
* Import data and find the Manhattan distance from the central port to the 
* closest intersection
*/
$data = file_get_contents(
    "/Users/madde/Sites/advent-of-code-2019/input/puzzle3.txt");
$data = explode("\n", $data);

$wire = multi_sort(array_merge(draw_wire($data[0]), draw_wire($data[1])));
foreach ($wire as $key => $value) {
    if (
        $value["x"] === $wire[$key + 1]["x"] && 
        $value["y"] === $wire[$key + 1]["y"]
    ) {
        $distance[] = $value["steps"] + $wire[$key + 1]["steps"];
    }
}

var_dump(min($distance));
/**
* Draw the wires based on input data
*/
function draw_wire($sequences){
    $directionX = array("L" => -1, "R" => 1, "U" => 0, "D" => 0);
    $directionY = array("L" => 0, "R" => 0, "U" => 1, "D" => -1);
    $sequences = explode(",", $sequences);

    foreach ($sequences as $sequence) {
        $direction = substr($sequence,0,1);
        $steps = intval(substr($sequence,1));
        for ($i = 0; $i < $steps; $i++) { 
            $x += $directionX[$direction];
            $y += $directionY[$direction];
            $wire[] = array("x" => $x, "y" => $y);
        }
    }
    $wire = multi_unique($wire);
    foreach ($wire as $key => $value) {
        $wire[$key]["steps"] = $key + 1;
    }
    return $wire;
}

/**
* Remove duplicates from array of coordinates
*/
function multi_unique($array){
    return array_map("unserialize", 
        array_unique(array_map("serialize", $array)));
}

/**
* Sort array of coordinates
*/
function multi_sort($array){
    $x = array_column($array, 'x'); 
    $y = array_column($array, 'y');
    array_multisort($x, SORT_ASC, $y, SORT_ASC, $array);
    return $array;
}