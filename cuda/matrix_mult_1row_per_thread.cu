#include <iostream>
#include <cstdlib>
#include "my_utils.h"
#include<cmath>

// nvcc matrix_mult_1block_1dthread.cu my_utils.cpp -o matrix_mult_1block_2dthread -x cu


__global__ void  mat_mult_kernel(int* A_d,int A_row, int A_col, int *B_d, int B_row, int  B_col, int* C_d)
{

	int row = blockIdx.x * blockDim.x + threadIdx.x;
	// int col = blockIdx.y * blockDim.y + threadIdx.y;
    for(int col = 0; col < B_col; col++)
    {
        int temp_sum = 0;
        int row_curr = row * A_col;
        for (int k = 0; k < A_col; k++)
        {
            temp_sum += A_d[row_curr + k] * B_d[k * B_row + col];
        }

        C_d[row * B_col + col ] = temp_sum;
    }
	
}



int main()
{
	int A_row = 5;
	int A_col = 4;


	int B_row = 4;
	int B_col = 4;

	int** A = get_matrix(A_row, A_col);
	int** B = get_matrix(B_row, B_col);


	print_matrix(A, A_row, A_col);
	print_matrix(B, B_row, B_col);

	int* A_linear = convert_2D_to_1D(A, A_row, A_col);
	int* B_linear = convert_2D_to_1D(B, B_row, B_col);

	print_array_as_matrix(A_linear, A_row, A_col);
	int* C = new int[A_row * B_col];

	int *A_d, *B_d, *C_d;
	int A_size = A_row * A_col * sizeof(int);
	int B_size = B_row * B_col * sizeof(int);
	int C_size = A_row * B_col * sizeof(int);

	cudaMalloc((void **) &A_d, A_size);
	cudaMalloc((void **) &B_d, B_size);
	cudaMalloc((void **) &C_d, C_size);

	cudaMemcpy(A_d, A_linear, A_size, cudaMemcpyHostToDevice);
	cudaMemcpy(B_d, B_linear, B_size, cudaMemcpyHostToDevice);

	dim3 DimGrid(1,1,1);
	dim3 DimThread(A_row, 1, 1 );

	mat_mult_kernel<<<DimGrid, DimThread>>>(A_d, A_row, A_col, B_d, B_row, B_col, C_d);
	cudaDeviceSynchronize();

	cudaMemcpy(C, C_d,C_size, cudaMemcpyDeviceToHost);

	print_array_as_matrix(C, A_row, B_col);

	cudaFree(A_d);
	cudaFree(B_d);
	cudaFree(C_d);
	free(A);
	free(B);
	free(C);
	return 0;
}
