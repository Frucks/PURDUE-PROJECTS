GCC=gcc
CFLAGS=-std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
EXEC = sort

all: main.c sort.c
	$(GCC) $(CFLAGS) -o $(EXEC) main.c sort.c
	
#add ascending target here
	
test: all
	./$(EXEC) testcases/inp1
	./$(EXEC) testcases/inp2
	./$(EXEC) testcases/inp3	
	
test-ascending: ascending
	./$(EXEC) testcases/inp1
	./$(EXEC) testcases/inp2
	./$(EXEC) testcases/inp3	
	
clean:
	rm -f $(EXEC)
	rm -f *.o
ascending: main.c sort.c
	$(GCC) $(CFLAGS) -o $(EXEC) main.c sort.c -DASCENDING

