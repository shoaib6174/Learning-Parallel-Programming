#include <iostream>
#include <random>

float*  get_matrix_1d(int row, int col, float v=1.0)
{

	float* matrix = new float[row * col];

	

	for(int i=0; i < row; i++)
	{
		for(int j = 0; j < col; j++)
		{
			matrix[i * col + j]= v; //(float) i * col + j;
		}
	}

	return matrix;
}

int**  get_matrix(int row, int col, int v=1)
{
	std::cout << "creating matrix" << "\n";

	int** matrix = new int*[row];

	for(int i = 0; i < row; i++)
	{
		matrix[i] = new int[col];
	}

	for(int i=0; i < row; i++)
	{
		for(int j = 0; j < col; j++)
		{
			matrix[i][j] = v;
		}
	}

	return matrix;
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

void print_matrix(int** matrix, int row, int col)
{
	std::cout << "Printing Matrix: " << "\n";
	for(int i = 0; i < row; i++)
	{
		for(int j = 0; j < col-1; j++)
		{
			std::cout << matrix[i][j] << " , ";
		}
		std::cout << "\n";
	}
}

void print_array_as_matrix(float *A,int r,int c)
{
	std::cout << "Printing Matrix: \n";
	for(int i =0; i < r*c; i++)
	{

		if (i>0 & (i+1) % c == 0) std::cout << A[i] << "\n";
		else std::cout << A[i] << " , ";
	}
	std::cout << "\n";
}

int* convert_2D_to_1D(int** matrix,int r,int c)
{
	int * linear = new int[r * c];

	for (int i = 0; i < r; i++)
	{
		for (int j = 0; j <c; j++)
		{
			linear[i*c + j] = matrix[i][j];
		}
	}
	return linear;
}

