# ***
# *** DO NOT modify this file
# ***

CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = hw4
VAL = valgrind --tool=memcheck --log-file=memcheck.txt --leak-check=full --verbose

TESTFALGS = -DTEST_MAIN -DTEST_COUNTINT -DTEST_READINT -DTEST_WRITEINT -DTEST_COMPAREINT

SRCS = main.c hw4.c
OBJS = $(SRCS:%.c=%.o)

all: $(OBJS)
	$(GCC) $(TESTFALGS) $(OBJS) -o $(EXEC)

%.o: %.c
	$(GCC) $(TESTFALGS) $< -c


testmemory: all
	$(VAL) ./$(EXEC) inputs/input3 output3
#testing only input3 and output3


testall: test1 test2 test3 test4

test1: all
	./$(EXEC) inputs/input1 output1
	diff output1 expected/expected1

test2: all
	./$(EXEC) inputs/input2 output2
	diff output2 expected/expected2

test3: all
	./$(EXEC) inputs/input3 output3
	diff output3 expected/expected3

test4: all
	./$(EXEC) inputs/input4 output4
	diff output4 expected/expected4

clean:
	rm -f $(EXEC)
	rm -f *.o
