#include <iostream>
#include <cstdlib>
#include <random>
#include <cuda_runtime.h>
#include <stdio.h>

void print_vector(int* vec, int n)
{
	for(int i = 0; i < n-1; i++)
	{
		std::cout << vec[i] << " , ";	
	}
	std::cout << vec[n-1] << "\n";
}

__global__ void add_vectors_kernel(int* A_d, int* B_d, int* C_d, int n)
{

	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if(i < n)
	{
		C_d[i] = A_d[i] + B_d[i];	
	}
}


int* get_vector(int size)
{
	int* vec = new int[size];
	std::random_device rd;
	std::mt19937 gen(rd());	
	std::uniform_int_distribution<> distr(0, 100);

	for (int i = 0; i < size; i++)
	{
		vec[i] = distr(gen);
	}
	return vec;
}

int main()
{
	int n  = 10;
	int size = n * sizeof(int);
	int* A = get_vector(n);
	int* B = get_vector(n);
	int* C = new int[n];

	print_vector(A, n);
	print_vector(B, n);

	int *A_d,*B_d, *C_d;

	cudaMalloc((void **) &A_d, size);
	cudaMalloc((void **) &B_d, size);
	cudaMalloc((void **) &C_d, size);

	cudaMemcpy(A_d, A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(B_d, B, size, cudaMemcpyHostToDevice);


	int num_of_threads = 256;
	dim3 DimGrid((n+num_of_threads) / num_of_threads, 1, 1);
	dim3 DimThread(num_of_threads, 1, 1);

	add_vectors_kernel<<<DimGrid, DimThread>>>(A_d, B_d, C_d, n);

	cudaDeviceSynchronize();
	cudaMemcpy(C, C_d, size, cudaMemcpyDeviceToHost);

	print_vector(C,n);

	cudaFree(A_d);
	cudaFree(B_d);
	cudaFree(C_d);
	return 0;
}
