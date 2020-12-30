import scala.io.Source

object Puzzle5 {

    val program = scala.io.Source
        .fromFile("puzzle5.txt")
        .mkString.split(",").map( x => x.toInt )

    def operand( mode:Int, data:Int ) : Int = {
        mode match {
            case 0 => return program(data)
            case 1 => return data
        }
    }

    def main(args: Array[String]): Unit = {
        var n = 0
        while(program(n) != 99) {
            var optcode = "%05d".format(program(n)).split("").map( x => x.toInt )
            var modes = optcode.dropRight(2)
            var instruction = optcode(4)
            
            instruction match {
                case 1 => 
                    program(program(n + 3)) = 
                        operand(modes(2), program(n + 1)) + 
                        operand(modes(1), program(n + 2))
                    n += 4

                case 2 => 
                    program(program(n + 3)) =
                        operand(modes(2), program(n + 1)) * 
                        operand(modes(1), program(n + 2))
                    n += 4

                case 3 => 
                    program(program(n + 1)) = 1 //scala.io.StdIn.readInt()
                    n += 2

                case 4 => 
                    println(operand(modes(2), program(n + 1)))
                    n += 2
            }
        }
    }
}