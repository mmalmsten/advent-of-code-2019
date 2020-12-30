import math

deck = range(0, 10007)

def deal_into_new_stack():
	deck.reverse()
	return deck

def cut(n):
	return deck[n:] + deck[:n]

def deal_with_increment(n):
	table = [0] * len(deck)
	for i in range(len(deck)):
		table[(i * n) % len(deck)] = deck[i]
	return table

complete_shuffle_process = open("/Users/madde/Sites/advent-of-code-2019/input/puzzle22.txt", "r").read().split('\n')

for technique in complete_shuffle_process:
	if(technique[0:19] == "deal with increment"):
		deck = deal_with_increment(int(technique[20:]))
	elif(technique == "deal into new stack"):
		deck = deal_into_new_stack()
	elif(technique[0:3] == "cut"):
		deck = cut(int(technique[4:]))

print deck.index(2019)