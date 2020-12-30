import System.IO  
import Debug.Trace
import Data.Char

run :: [Int] -> [Int] -> [Int] -> Int
run [] basepattern resultlist = do rem (abs (sum resultlist)) 10
run (hi:ti) (hb:tb) resultlist = run ti (tb ++ [hb]) (resultlist ++ [hb * hi])

update_base_pattern :: Int -> [Int]
update_base_pattern n = do
    let [x1,x2,x3,x4] = map (replicate n) [0, 1, 0, -1]
    let (h:t) = x1 ++ x2 ++ x3 ++ x4
    t ++ [h]

phase :: [Int] -> Int -> Int -> [Int] -> [Int]
phase inputdata len n result | len == n = do reverse result
phase inputdata len n result = do 
    let pattern = update_base_pattern n
    let result1 = run inputdata pattern []
    phase inputdata len (n + 1) (result1:result)

phases :: Int -> [Int] -> [Int]
phases 2 result = do result
phases n inputdata = do 
    let result = phase inputdata ((length inputdata) + 1) 1 []
    phases (n + 1) result 

main = do 
    file <- readFile "puzzle16.txt"
    let input = map (read . (:"")) file :: [Int]
    print( phases 0 input )
    return ()