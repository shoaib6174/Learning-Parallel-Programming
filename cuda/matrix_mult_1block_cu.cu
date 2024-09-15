#include <iostream>
#include <cstdlib>

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


__global__ void  mat_mult_kernel(int* A_d,int A_row, int A_col, int *B_d, int B_row, int  B_col, int* C_d)
{
	
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int row = i / B_col;
	int col = i % B_col;
	
	int temp_sum = 0;
	int row_t = row * A_col;

	for (int k = 0; i < A_row; i++)
	{	
		temp_sum += A_d[row_t + k] * B_d[k*B_row + col];	
	}
	
	C_d[row * A_row + col] = temp_sum;
	

}

void print_matrix(int** matrix, int row, int col)
{	
	std::cout << "Printing Matrix: " << "\n";
	for(int i = 0; i < row; i++)
	{
		for(int j = 0; j < col; j++)
		{
			std::cout << matrix[i][j] << " , ";
		}
		std::cout << "\n";
	}
}
void print_array_as_vector(int *A, r, c)
{
	for(int i =0; i < r*c; i++)
	{
		std::cout << A[i] << " , ";
		
		if (i % c == 0)
		{
			std::cout << "\n";
		}
	}
}

int* convert_2D_to_1D(int* matrix_start, r, c)
{
	int * linear = new int[r * c];
	
	for (int i = 0; i < r * c; i++)
	{
		linear[i] = matrix_start[i];
	}
	return linear;
}

int main()
{	
	std::cout << "argc = " << argc << "\n";	
	int A_row = 3;
	int A_col = 3;
	
	
	int B_row = 3;
	int B_col = 5;

	int** A = get_matrix(A_row, A_col);
	int** B = get_matrix(B_row, B_col);


	print_matrix(A, A_row, A_col);	
	print_matrix(B, B_row, B_col);
	
	int* A_linear = convert_2D_to_1D(&A[0][0], A_row, A_col);
	int* B_linear = convert_2D_to_1D(&B[0][0], B_row, B_col);
	
	int* C = new int[A_row * B_col]; 
	
	int *A_d, *B_d, *C_d;
	int A_size = A_row * A_col * sizeof(int);
	int B_size = B_row * B_col * sizeof(int);
	int C_size = A_row * B_col * sizeof(int);
	
	cudaMemcpy(A_d, A_linear, A_size, cudaMemcpyHostToDevice);
	cudaMemcpy(B_d, B_linear, B_size, cudaMemcpyHostToDevice); 
	
	mat_mult_kernel<<<1,A_row*B_col>>>(A_d, A_row, A_col, B_d, B_row, B_col, C_d);
	
	cudaMemcpy(C, C_d,C_size, cudaMemcpyDeviceToHost);
 
	print_matrix(C, A_row, B_col);
	return 0;	
}
