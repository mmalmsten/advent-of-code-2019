import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.ArrayList;

class Puzzle12 { 

	private static class Moon {
		private ArrayList<Integer> pos;
		private ArrayList<Integer> vel;

		private Moon(String[] posString) {
			vel = new ArrayList<Integer>();
			pos = new ArrayList<Integer>();
			vel.add(0);
			vel.add(0);
			vel.add(0);
			pos.add(Integer.parseInt(posString[0]));
			pos.add(Integer.parseInt(posString[1]));
			pos.add(Integer.parseInt(posString[2]));
		}

		private void update(ArrayList<Moon> moons) {
			for (Moon moon : moons) {
				if (moon != this) {
					for (int c = 0; c < 3; c++){
						if (pos.get(c) < moon.pos.get(c)) {
							vel.set(c, vel.get(c) + 1);
						}
						else if (pos.get(c) > moon.pos.get(c)) {
							vel.set(c, vel.get(c) - 1);
						}
					}
				}
			}
		}

		private void updatePosition() {
			pos.set(0, pos.get(0) + vel.get(0));
			pos.set(1, pos.get(1) + vel.get(1));
			pos.set(2, pos.get(2) + vel.get(2));
		}

		private int energy() {
			int sumPos = Math.abs(pos.get(0)) + 
				Math.abs(pos.get(1)) + 
				Math.abs(pos.get(2));
			int sumVel = Math.abs(vel.get(0)) + 
				Math.abs(vel.get(1)) + 
				Math.abs(vel.get(2));
			return sumPos * sumVel;
		}

	}

	private static ArrayList<Moon> moons;

	private static void update() {
		ArrayList<Moon> newMoons = new ArrayList<Moon>();
		newMoons.addAll(moons);
		for (Moon moon : moons) {
			moon.update(moons);
		}
		for(int m = 0; m < moons.size(); m++)
			moons.get(m).updatePosition();
		moons = new ArrayList<Moon>();
		moons.addAll(newMoons);
	}

	private static void importMoons() {
		moons = new ArrayList<Moon>();
		try {
			File myObj = new File("/Users/madde/Sites/advent-of-code-2019/input/puzzle12.txt");
			Scanner myReader = new Scanner(myObj);
			Pattern p = Pattern.compile("([^0-9\\-,])");
			while (myReader.hasNextLine()) {
				String data = myReader.nextLine();
				Matcher m = p.matcher(data); 
				String[] data1 = m.replaceAll("").split(",",-1);
				moons.add(new Moon(data1));
			}
			myReader.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	public static void main(String args[]) {
		importMoons();
		for (int i = 0; i < 1000; i++)
			update();
		double result = 0;
		for(int i = 0; i < moons.size(); i++)
			result += moons.get(i).energy();
		System.out.println(result);
	} 
}