CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = hw8
OBJS =  main.o shuffle.o
VALGRIND = valgrind --tool=memcheck --leak-check=yes --verbose

$(EXEC): $(OBJS) shuffle.h
	$(GCC) $(OBJS) -o $(EXEC) 

test: $(EXEC)
	./$(EXEC) 3 1 | sort > output_3_1
	diff -w output_3_1 expected/expected_3_1

	./$(EXEC) 3 2 | sort > output_3_2
	diff -w output_3_2 expected/expected_3_2

	./$(EXEC) 4 2 | sort > output_4_2
	diff -w output_4_2 expected/expected_4_2

	./$(EXEC) 6 2 | sort > output_6_2
	diff -w output_6_2 expected/expected_6_2


memory: $(EXEC)
	$(VALGRIND) --log-file=log1 ./$(EXEC) output4

%.o : %.c
	$(GCC) -c $< 

clean:
	/bin/rm -f *.o
	/bin/rm -f $(EXEC)
	/bin/rm -f output? log?
