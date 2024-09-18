#include <cstdlib>
#include <iostream>
#include "my_utils.h"
#include <cmath>

#define thread_size 2;

// Error checking macro
#define CUDA_CHECK_ERROR(call)                                               \
do {                                                                         \
    cudaError_t err = call;                                                  \
    if (err != cudaSuccess) {                                                \
        std::cerr << "CUDA error in file '" << __FILE__ << "' at line "      \
                  << __LINE__ << ": " << cudaGetErrorString(err) << std::endl;\
        exit(EXIT_FAILURE);                                                  \
    }                                                                        \
} while(0)

__global__
void conv2d_kernel(float* I, float* F, float* R, int r, int row, int col)
{   
    int f_size = 2*r+1;
    
    outRow = blockIdx.x * blockDim.x + threadIdx.x;
    outCol = blockIdx.y * blockDim.y + threadIdx.y;

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
    
    R[outRow*row+outCol] = temp_sum;

}

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
    float* filter = get_matrix_1d(2* r + 1, 2* r + 1 , 1.0 / pow(2* r + 1, 2) );

    float* matrix = get_matrix_1d(row,col, (float) v);

    print_array_as_matrix(matrix, row, col);
    print_array_as_matrix(filter, 2* r + 1, 2* r + 1);
    float* output = new float[row*col]; 
    conv2d(matrix, filter, output, r, row, col);
    print_array_as_matrix(output, row, col);

    // cuda
    int input_size = row * col * sizeof(float);
    int filter_size = pow(2* r + 1, 2) * sizeof(float);

    float *I_d, *F_d, *R_d, *R;

    CUDA_CHECK_ERROR( cudaMalloc(I_d, input_size));
    CUDA_CHECK_ERROR( cudaMalloc(R_d, input_size));
    CUDA_CHECK_ERROR( cudaMalloc(F_d, filter_size));


    CUDA_CHECK_ERROR( cudaMemcpy(I_d, matrix, input_size, cudaMemcpyHostToDevice) );
    CUDA_CHECK_ERROR( cudaMemcpy(F_d, filter, input_size, cudaMemcpyHostToDevice) );

    dim3 DimGrid( std::ceil((float) row / thread_size ) , std::ceil((float) col / thread_size), 1 );
    dim3 DimThread(thread_size, thread_size, 1); 

    convKernel <<<DimGrid, DimThread>>>(I_d, F_d, R_d, r, row, col);
  
    CUDA_CHECK_ERROR(cudaGetLastError());
	CUDA_CHECK_ERROR(cudaDeviceSynchronize());

    CUDA_CHECK_ERROR( cudaMemcpy(R, R_d, input_size, cudaMemcpyDeviceToHost) );
    print_array_as_matrix(R, row, col);

    return 0;
}