CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
TESTS = -DTEST_DIVIDE -DTEST_INTERLEAVE -DTEST_SHUFFLE
GCC = gcc $(CFLAGS) $(TESTS)
EXEC = hw7
OBJS =  main.o shuffle.o
VALGRIND = valgrind --tool=memcheck --leak-check=yes --verbose

$(EXEC): $(OBJS) shuffle.h
	$(GCC) $(OBJS) -o $(EXEC) 

test: $(EXEC)
	./$(EXEC) 4 | sort > output4
	diff -w output4 expected/expected4

	./$(EXEC) 8 | sort > output8
	diff -w output8 expected/expected8

	./$(EXEC) 11 | sort > output11
	diff -w output11 expected/expected11

memory: $(EXEC)
	$(VALGRIND) --log-file=log1 ./$(EXEC) output4

%.o : %.c
	$(GCC) -c $< 

clean:
	/bin/rm -f *.o
	/bin/rm -f $(EXEC)
	/bin/rm -f output? log?
