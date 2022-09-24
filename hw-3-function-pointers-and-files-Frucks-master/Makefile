CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror -DTEST_INTEGRATE -DRUN_INTEGRATE
GCC = gcc $(CFLAGS)
LIBS = -lm
EXEC = hw3
FUNCS = func1.o func2.o func3.o func4.o func5.o
DEPS = hw3.h 
OBJ = answer3.o hw3.o $(FUNCS)

%.o: %.c
	$(GCC) -c $<

hw3: $(OBJ)
	mkdir -p outputs
	$(GCC) $(OBJ) -o $(EXEC) $(LIBS)

testall: hw3
	./hw3 testdir/test1 outputs/hw3-test1.out
	./hw3 testdir/test2 outputs/hw3-test2.out
	./hw3 testdir/test3 outputs/hw3-test3.out
	./hw3 testdir/test4 outputs/hw3-test4.out
	./hw3 testdir/test5 outputs/hw3-test5.out
clean:
	/bin/rm -f input*
	/bin/rm -f *.o
	/bin/rm -f testgen 
	/bin/rm -f *.gcda *.gcno gmon.out *gcov
	/bin/rm -f hw3 hw3.prof
	/bin/rm -f -r testdir
