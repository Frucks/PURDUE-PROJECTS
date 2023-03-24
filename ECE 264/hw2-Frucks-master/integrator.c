#include "hw2.h"
double integrate1(Range rng)
{
        double deltax = (rng.upperlimit - rng.lowerlimit) / rng.intervals;
	double temp = 0;
	double sum = 0;
	double x = 0;
	
	for (int i = 0; i < rng.intervals; i++)
	{

		x = rng.lowerlimit + i * deltax;
		temp = func(x) * deltax;
		sum += temp;
	}
 

	return sum;

}

void integrate2(RangeAnswer * rngans)
{

	rngans -> answer = integrate1(rngans -> rng);
}
