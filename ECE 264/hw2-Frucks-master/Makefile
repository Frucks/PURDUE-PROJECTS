CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
OBJS =  hw2.o integrator.c
FUNCS = func1.o func2.o func3.o func4.o func5.o

# This Makefile can be shortened by using loop. 
# It shows all steps to explain what it does

all: hw2a hw2b

#Build hw2 using integrate1, and all five functions
#Creates 5 different executables, because of the dependences
hw2a: hw2-func1-1 hw2-func2-1 hw2-func3-1 hw2-func4-1 hw2-func5-1
	

#Build hw2 using integrate2, and all five functions
#Creates 5 different executables, because of the dependences
hw2b: hw2-func1-2 hw2-func2-2 hw2-func3-2 hw2-func4-2 hw2-func5-2
	

#build each of the executables for integrate1
hw2-func1-1: hw2a.o integrator.o func1.o
	$(GCC) hw2a.o integrator.o func1.o -o hw2-func1-1

hw2-func2-1: hw2a.o integrator.o func2.o
	$(GCC) hw2a.o integrator.o func2.o -o hw2-func2-1	

hw2-func3-1: hw2a.o integrator.o func3.o
	$(GCC) hw2a.o integrator.o func3.o -o hw2-func3-1

hw2-func4-1: hw2a.o integrator.o func4.o
	$(GCC) hw2a.o integrator.o func4.o -o hw2-func4-1 -lm

hw2-func5-1: hw2a.o integrator.o func5.o
	$(GCC) hw2a.o integrator.o func5.o -o hw2-func5-1 -lm

#build each of the executables for integrate2
hw2-func1-2: hw2b.o integrator.o func1.o
	$(GCC) hw2b.o integrator.o func1.o -o hw2-func1-2

hw2-func2-2: hw2b.o integrator.o func2.o
	$(GCC) hw2b.o integrator.o func2.o -o hw2-func2-2	

hw2-func3-2: hw2b.o integrator.o func3.o
	$(GCC) hw2b.o integrator.o func3.o -o hw2-func3-2

hw2-func4-2: hw2b.o integrator.o func4.o
	$(GCC) hw2b.o integrator.o func4.o -o hw2-func4-2 -lm

hw2-func5-2: hw2b.o integrator.o func5.o
	$(GCC) hw2b.o integrator.o func5.o -o hw2-func5-2 -lm

#build hw2 with integrate1
hw2a.o: hw2.c hw2.h
	$(GCC) -c -DINTEGRATE_1 hw2.c -o hw2a.o

#build hw2 with integrate2
hw2b.o: hw2.c hw2.h
	$(GCC) -c -DINTEGRATE_1 -DINTEGRATE_2 hw2.c -o hw2b.o

#compile integrator
integrator.o: integrator.c hw2.h
	$(GCC) -c integrator.c

#compile func1
func1.o: func1.c
	$(GCC) -c func1.c

#compile func2
func2.o: func2.c
	$(GCC) -c func2.c

#compile func3
func3.o: func3.c
	$(GCC) -c func3.c

#compile func4
func4.o: func4.c
	$(GCC) -c func4.c

#compile func5
func5.o: func5.c
	$(GCC) -c func5.c

# test integrate1 using five different functions
# each function is tested using three sets of input data
hw2-test1: hw2a
	mkdir -p outputs
	echo "testing integrate1"
	echo "testing func1"
	./hw2-func1-1 tests/test-func1-1 > outputs/test-func1-1.out 
	./hw2-func1-1 tests/test-func1-2 > outputs/test-func1-2.out
	./hw2-func1-1 tests/test-func1-3 > outputs/test-func1-3.out
	echo "testing func2"
	./hw2-func2-1 tests/test-func2-1 > outputs/test-func2-1.out
	./hw2-func2-1 tests/test-func2-2 > outputs/test-func2-2.out
	./hw2-func2-1 tests/test-func2-3 > outputs/test-func2-3.out
	echo "testing func3"             
	./hw2-func3-1 tests/test-func3-1 > outputs/test-func3-1.out
	./hw2-func3-1 tests/test-func3-2 > outputs/test-func3-2.out
	./hw2-func3-1 tests/test-func3-3 > outputs/test-func3-3.out
	echo "testing func4"             
	./hw2-func4-1 tests/test-func4-1 > outputs/test-func4-1.out
	./hw2-func4-1 tests/test-func4-2 > outputs/test-func4-2.out
	./hw2-func4-1 tests/test-func4-3 > outputs/test-func4-3.out
	echo "testing func5"             
	./hw2-func5-1 tests/test-func5-1 > outputs/test-func5-1.out
	./hw2-func5-1 tests/test-func5-2 > outputs/test-func5-2.out
	./hw2-func5-1 tests/test-func5-3 > outputs/test-func5-3.out

	# test integrate2
hw2-test2: hw2b
	mkdir -p outputs
	echo "testing integrate2"
	echo "testing func1"
	./hw2-func1-2 tests/test-func1-1 > outputs/test-func1-1.out 
	./hw2-func1-2 tests/test-func1-2 > outputs/test-func1-2.out
	./hw2-func1-2 tests/test-func1-3 > outputs/test-func1-3.out
	echo "testing func2"             
	./hw2-func2-2 tests/test-func2-1 > outputs/test-func2-1.out
	./hw2-func2-2 tests/test-func2-2 > outputs/test-func2-2.out
	./hw2-func2-2 tests/test-func2-3 > outputs/test-func2-3.out
	echo "testing func3"             
	./hw2-func3-2 tests/test-func3-1 > outputs/test-func3-1.out
	./hw2-func3-2 tests/test-func3-2 > outputs/test-func3-2.out
	./hw2-func3-2 tests/test-func3-3 > outputs/test-func3-3.out
	echo "testing func4"             
	./hw2-func4-2 tests/test-func4-1 > outputs/test-func4-1.out
	./hw2-func4-2 tests/test-func4-2 > outputs/test-func4-2.out
	./hw2-func4-2 tests/test-func4-3 > outputs/test-func4-3.out
	echo "testing func5"             
	./hw2-func5-2 tests/test-func5-1 > outputs/test-func5-1.out
	./hw2-func5-2 tests/test-func5-2 > outputs/test-func5-2.out
	./hw2-func5-2 tests/test-func5-3 > outputs/test-func5-3.out

# generate 15 test cases: 5 functions and 3 test cases per function
testgen: testgen.c integrator.c hw2.h | testdir
	$(GCC) -DINTEGRATE_1 testgen.c integrator.c func1.c -o testgen
	./testgen test-func1-1 1.0 2.0 10000
	./testgen test-func1-2 -1.0 3.0 10000
	./testgen test-func1-3 0.8 2.9 10000
	$(GCC) -DINTEGRATE_1 testgen.c integrator.c func2.c -o testgen
	./testgen test-func2-1 11.0 22.0 5000
	./testgen test-func2-2 -15.0 3.0 10000
	./testgen test-func2-3 -0.7 12.9 10000
	$(GCC) -DINTEGRATE_1 testgen.c integrator.c func3.c -o testgen
	./testgen test-func3-1 1.5 2.6 10000
	./testgen test-func3-2 -1.0 31.0 20000
	./testgen test-func3-3 0.8 2.9 100000
	$(GCC) -DINTEGRATE_1 testgen.c integrator.c func4.c -o testgen -lm
	./testgen test-func4-1 1.0 2.0 10000
	./testgen test-func4-2 -1.0 3.0 10000
	./testgen test-func4-3 0.8 2.9 100000
	$(GCC) -DINTEGRATE_1 testgen.c integrator.c func5.c -o testgen -lm
	./testgen test-func5-1 1.0 2.0 100000
	./testgen test-func5-2 -1.0 3.0 100000
	./testgen test-func5-3 0.8 2.9 100000
	mv test-func* tests/

testdir:
	mkdir -p tests

clean:
	/bin/rm -f input*
	/bin/rm -f *.o
	/bin/rm -f testgen test??
	/bin/rm -f *.gcda *.gcno gmon.out *gcov
	/bin/rm -f hw2-func*
	/bin/rm -rf outputs



