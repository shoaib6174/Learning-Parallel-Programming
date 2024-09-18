#include <cstdlib>
#include <iostream>
#include "my_utils.h"

void conv2d(float* I, float* F, float* R, int r, int row, int col)
{   
    int f_size = 2*r+1;
    for(int outRow = 0; outRow < row; outRow++)
    {
        for(int outCol=0;  outCol < col; outCol++)
        {
            float temp_sum = 0.0;
            for (int fRow = 0 ; fRow < f_size; fRow++)
            {
                for(int fCol = 0 ; fCol < f_size; fCol++)
                {   
                    int inRow = outRow - r + fRow;
                    int inCol = outCol - r + fCol;
                    if(inRow>=0 && inRow < row && inCol >= 0 && inCol < col)
                    {
                        temp_sum += F[fRow * f_size + fCol] * I[inRow * row + inCol]  ;
                    }
                }
            }
            // std::cout << temp_sum << "\n";
            R[outRow*row+outCol] = temp_sum;
        }
    }

}


int main(int argc, char* argv[])
{   
    int row = std::atoi(argv[1]);
    int col = std::atoi(argv[2]);
    float v = std::atof(argv[3]);

    int r = std::atoi(argv[4]);
    float* filter = get_matrix_1d(2* r + 1, 2* r + 1 , 1.0 / (2* r + 1) / (2* r + 1) );

    float* matrix = get_matrix_1d(row,col, (float) v);

    print_array_as_matrix(matrix, row, col);
    print_array_as_matrix(filter, 2* r + 1, 2* r + 1);
	    
    float* output = new float[row*col]; 
    
    conv2d(matrix, filter, output, r, row, col);
    print_array_as_matrix(output, row, col);

    return 0;
}