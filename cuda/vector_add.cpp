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

void add_vectors(int* A, int* B,int* C, int size)
{

	for (int i = 0; i < size; i++)
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
	int size =atoi(argv[1]);
	int* A = get_vector(size);
	int* B = get_vector(size);
	int* C = new int[size];

	print_vector(A, size);
	print_vector(B, size);
	
	print_vector(C, size);
	add_vectors(A, B, C, size);
	print_vector(C, size);

	
	return 0;
	
}
