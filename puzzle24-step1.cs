using System;
using System.IO;
using System.Collections;

namespace Puzzle24
{

    public struct Area 
    {
        public ArrayList cache;
        public Space[] area;
        public bool repeating;

        public Area(bool i)
        {
            cache = new ArrayList();
            area = new Space[25];
            repeating = false;

            string[] f = File.ReadAllText(
                "/Users/madde/Sites/advent-of-code-2019/input/puzzle24.txt"
            ).Split("\n");
            
            int biodiversityRating = 1;
            int index = 0;
            int y = 0;
            foreach (string line in f)
            {
                int x = 0;
                foreach (char val in line.ToCharArray()) 
                {
                    Space space = new Space(
                            index, y, x, val, biodiversityRating
                        ); 
                    area[index] = space;
                    biodiversityRating *= 2;
                    index ++;
                    x ++;
                }
                y ++;
            }
        }

        public void updateCache()
        {
            string c = "";
            foreach (Space space in area)
                c += space.hasBug.ToString();
            repeating = cache.Contains(c);
            cache.Add(c);
        }

        public void plotMinutes()
        {
            while (!repeating) 
            {
                Space[] clonedArea = (Space[]) area.Clone();
                foreach (Space space in area) 
                {
                    int adjacents = space.adjacentsWithBugs(clonedArea);

                    // A bug dies (becoming an empty space) unless there is 
                    // exactly one bug adjacent to it.
                    if(space.hasBug == 1 && adjacents != 1)
                        area[space.id].hasBug = 0;

                    // An empty space becomes infested with a bug if exactly one 
                    // or two bugs are adjacent to it.
                    if(space.hasBug == 0 && adjacents >= 1 && adjacents <= 2)
                        area[space.id].hasBug = 1;
                }
                updateCache();
            }
            
            print();
            
            int biodiversityRating = 0;
            foreach (Space space in area) 
            {
                if(space.hasBug == 1)
                    biodiversityRating += space.biodiversityRating;

            }
            Console.WriteLine(biodiversityRating);
        }

        public void print()
        {
            int[] array = new int[5] {0,1,2,3,4};
            int index = 0;
            foreach (int y in array) 
            {
                string xs = "";
                foreach (int x in array) 
                {
                    if(area[index].hasBug == 1)
                        xs += "#";
                    else
                        xs += ".";
                    index ++;
                }
                Console.WriteLine(xs);
            }
        }
    }

    public struct Space 
    {
        public int id;
        public int y;
        public int x;
        public int hasBug;
        public int biodiversityRating;
        public ArrayList adjacents;

        public Space(int id1, int y1, int x1, char val, int bd)
        {
            id = id1;
            y = y1;
            x = x1;
            biodiversityRating = bd;
            hasBug = val == '#' ? 1 : 0;

            adjacents = new ArrayList();
            if(y > 0)
                adjacents.Add(id - 5);
            if(y < 4)
                adjacents.Add(id + 5);
            if(x > 0)
                adjacents.Add(id - 1);
            if(x < 4)
                adjacents.Add(id + 1);
        }

        public int adjacentsWithBugs(Space[] spaces)
        {
            int adj = 0;
            foreach (int adjacent in adjacents) 
                adj += spaces[adjacent].hasBug;
            return adj;
        }

    }

    class Program
    {
        static void Main(string[] args)
        {
            Area area = new Area(true);
            area.plotMinutes();
        }
    }
}