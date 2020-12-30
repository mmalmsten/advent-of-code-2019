import scala.io.Source

object Puzzle5 {

//------------------------------------------------------------------------------
// Import program
//------------------------------------------------------------------------------
    val program = scala.io.Source
        .fromFile("puzzle5.txt")
        .mkString.split(",").map( x => x.toInt )

//------------------------------------------------------------------------------
// Set operand depending on position mode or immediate mode should be used
//------------------------------------------------------------------------------
    def operand( mode:Int, data:Int ) : Int = {
        mode match {
            case 0 => return program(data)
            case 1 => return data
        }
    }

//------------------------------------------------------------------------------
// Run
//------------------------------------------------------------------------------
    def main(args: Array[String]): Unit = {
        var n = 0
        while(program(n) != 99) {
            var optcode = "%05d".format(program(n)).split("").map(x => x.toInt)
            var modes = optcode.dropRight(2)
            var instruction = optcode(4)
            instruction match {
                // Adds together numbers read from two positions and stores the 
                // result in a third position
                case 1 => 
                    program(program(n + 3)) = 
                        operand(modes(2), program(n + 1)) + 
                        operand(modes(1), program(n + 2))
                    n += 4

                // Works exactly like opcode 1, except it multiplies the two 
                // inputs instead of adding them
                case 2 => 
                    program(program(n + 3)) =
                        operand(modes(2), program(n + 1)) * 
                        operand(modes(1), program(n + 2))
                    n += 4

                // Takes a single integer as input and saves it to the position 
                // given by its only parameter
                case 3 => 
                    println("Input the ID of the system to test:")
                    program(program(n + 1)) = scala.io.StdIn.readInt()
                    n += 2

                // Outputs the value of its only parameter
                case 4 => 
                    println(operand(modes(2), program(n + 1)))
                    n += 2

                // If the first parameter is non-zero, it sets the instruction 
                // pointer to the value from the second parameter. Otherwise, it
                // does nothing.
                case 5 =>
                    if(operand(modes(2), program(n + 1)) != 0){
                        n = operand(modes(1), program(n + 2))
                    } else{
                        n += 3
                    }
                
                // If the first parameter is zero, it sets the instruction 
                // pointer to the value from the second parameter. Otherwise, it
                // does nothing.
                case 6 => 
                    if(operand(modes(2), program(n + 1)) == 0){
                        n = operand(modes(1), program(n + 2))
                    } else{
                        n += 3
                    }
                
                // if the first parameter is less than the second parameter, it
                // stores 1 in the position given by the third parameter.
                // Otherwise, it stores 0.
                case 7 => 
                    if(operand(modes(2), program(n + 1)) < 
                        operand(modes(1), program(n + 2))){
                            program(program(n + 3)) = 1
                    } else{
                        program(program(n + 3)) = 0
                    }
                    n += 4

                // if the first parameter is equal to the second parameter, it
                // stores 1 in the position given by the third parameter.
                // Otherwise, it stores 0.
                case 8 => 
                    if(operand(modes(2), program(n + 1)) == 
                        operand(modes(1), program(n + 2))){
                            program(program(n + 3)) = 1
                    } else{
                        program(program(n + 3)) = 0
                    }
                    n += 4

            }
        }
    }
}