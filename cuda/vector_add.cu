#include <iostream>
#include <cstdlib>
#include <random>

void print_vector(int* vec, int size)
{
	for(int i = 0; i < size-1; i++)
	{
		std::cout << vec[i] << " , ";	
	}
	std::cout << vec[size] << "\n";
}

__global__ void add_vectors_kernel(int* A, int* B, int* C, int n)
{

	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if(i < n)
	{
		C[i] = A[i] + B[i];	
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

int main(int argc, char* argv[])
{	
	int n  =atoi(argv[1]);
	int size = n * sizeof(int);
	int* A = get_vector(n);
	int* B = get_vector(n);
	int* C = new int[n];

	print_vector(A, n);
	print_vector(B, n);
	
	int *A_d,*B_d, *C_d;

	cudaMemcpy(A_d, A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(B_d, B, size, cudaMemcpyHostToDevice);

	cudaMalloc((void **) &A_d, size);
	cudaMalloc((void **) &B_d, size);
	
	int num_of_threads = 256;
	dim3 DimGrid(std::ceil(n / num_of_threads), 1, 1);
	dim3 DimThread(num_of_thread, 1, 1);
	
	add_vectors_kernel<<DimGrid, DimThread>>(A_d, B_d, C_d, n);
	
	cudaMemcpy(C, C_d, size, cudaMemcpyDeviceToHost);
	cudaFree(A_d);
	cudaFree(B_d);
	cudaFree(C_d);
	return 0;
	
}
