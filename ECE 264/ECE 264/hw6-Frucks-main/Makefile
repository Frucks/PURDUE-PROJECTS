CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
TESTS = -DTEST_SORTED -DTEST_SORTID -DTEST_SORTFIRSTNAME -DTEST_SORTLASTNAME
GCC = gcc $(CFLAGS) $(TESTS)
EXEC = hw6
OBJS =  hw6.o student.o
VALGRIND = valgrind --tool=memcheck --leak-check=yes --verbose

$(EXEC): $(OBJS) student.h
	$(GCC) $(OBJS) -o $(EXEC) 

test: $(EXEC)
	./$(EXEC) inputs/testinput1 id1 first1 last1
	./$(EXEC) inputs/testinput2 id2 first2 last2
	./$(EXEC) inputs/testinput3 id3 first3 last3

memory: $(EXEC)
	$(VALGRIND) --log-file=log1 ./$(EXEC) inputs/testinput1 id1 first1 last1
	$(VALGRIND) --log-file=log2 ./$(EXEC) inputs/testinput2 id2 first2 last2
	$(VALGRIND) --log-file=log3 ./$(EXEC) inputs/testinput3 id3 first3 last3

%.o : %.c
	$(GCC) -c $< 

clean:
	/bin/rm -f *.o
	/bin/rm -f $(EXEC)
	/bin/rm -f id? first? last? log?