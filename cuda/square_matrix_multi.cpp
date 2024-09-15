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


int**  mat_mult(int** A,int A_row, int A_col, int **B, int B_row, int  B_col)
{
	int ** C = get_matrix(A_row, B_col, 0);
	
	for (int i = 0; i < A_row; i++)
	{
		for (int j = 0; j < B_col; j++)
		{
			int temp_sum = 0;
	
			for (int k=0; k < A_col; k++)
			{
				temp_sum += A[i][k] * B[k][j];
			}
	
			C[i][j] = temp_sum;
		}
	}
	
	return C;

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

int main(int argc, char* argv[])
{	
	std::cout << "argc = " << argc << "\n";	
	int A_row = atoi(argv[1]);
	int A_col = atoi(argv[2]);
	
	
	int B_row = atoi(argv[3]);
	int B_col = atoi(argv[4]);

	int** A = get_matrix(A_row, A_col);
	int** B = get_matrix(B_row, B_col);

	print_matrix(A, A_row, A_col);	
	print_matrix(B, B_row, B_col);
	
	int** C = mat_mult(A, A_row, A_col, B, B_row, B_col);
	print_matrix(C, A_row, B_col);
	return 0;	
}
