#ifndef MY_UTILS_H
#define MY_UTILS_H

float* get_matrix_1d(int row, int col, float v = 1);
int**  get_matrix(int row, int col, int v=1);

int* get_vector(int size);
void print_matrix(int** matrix, int row, int col);
void print_array_as_matrix(float* A, int r, int c);
int* convert_2D_to_1D(int** matrix, int r, int c);

#endif // MY_UTILS_H