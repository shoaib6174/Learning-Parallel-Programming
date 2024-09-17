#include<iostream>
#include "my_utils.h"
#include<cmath>

__global__
void matrix_vec_mult_kernel(float* A_d, float* B_d, float* C_d, int vec_len)
{
    row = blockIdx.x * blockDim.x + threadIdx.x;

    float temp_sum = 0;
    if(row < vec_len)
    {
        for(int col = 0; col < vec_len; col++ )
        {
            temp_sum += B_d[row*vec_len+col] * C_d[col];
        }
        A_d[row] = temp_sum;
    }
}

int main()
{
    int vec_len = 10;
   
    float* C = get_vector(vec_len);
    float** B = get_matrix(vec_len, vec_len);

    float* B_linear = convert_2D_to_1D(B, vec_len, vec_len);

    float *B_d, *C_d, *A_d, *A;
    auto B_size = vec_len * vec_len * sizeof(float);
    auto C_size = vec_len * sizeof(float);
    auto A_size = vec_len * sizeof(float);

    cudaMalloc(B_d, B_size);
    cudaMalloc(C_d, C_size);

    cudaMemcpy(B_d, B,B_size , cudaMemcpyHostToDevice);
    cudaMemcpy(C_d, C, C_size, cudaMemcpyHostToDevice);
    delete[] B;
    delete C;

    dim3 DimGrid(std::ceil(vec_len/2),1,1);
    dim3 DimThread(2,1,1);

    matrix_vec_mult_kernel<<<DimGrid, DimThread>>(A_d, B_d, C_d, vec_len);

    cudaMemcpy(A, A_d, A_size, cudaMemcpyDeviceToHost);

    cudaFree(B_d);
    cudaFree(C_d);
    cudaFree(A_d);


    return 0;
}