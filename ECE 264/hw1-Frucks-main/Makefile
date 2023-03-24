CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = eliminate

TESTFALGS = -DTEST_ELIMINATE

all: main.c eliminate.c
	$(GCC) $(TESTFALGS) -o $(EXEC) main.c eliminate.c
	

testall: test1 test2 test3 

test1: all
	./$(EXEC) 6 3 > output1         # run your program with n=6, k=3 and output to file output1
	diff output1 expected/expected1 # display the differences between the two files line-by-line

test2: all
	./$(EXEC) 4 6 > output2
	diff output2 expected/expected2

test3: all
	./$(EXEC) 25 7 > output3
	diff output3 expected/expected3


clean:
	rm -f $(EXEC)
	rm -f *.o
