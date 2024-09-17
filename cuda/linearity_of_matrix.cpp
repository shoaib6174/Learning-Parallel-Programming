#include <iostream>

int main() {
    int A[5][5]; // A 2D array of integers

    // Fill the array with some values
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            A[i][j] = i * 5 + j; // Example initialization
        }
    }

    // Print the addresses
    std::cout << "Address of A[0][0]: " << &A[0][0] << std::endl;
    std::cout << "Address of A: " << &A << std::endl;

    // Pointer arithmetic
    std::cout << "Address using &A[0][0] + 1: " << (&A[0][0] + 1) << std::endl;
    std::cout << "Address using &A + 1: " << (&A + 1) << std::endl;

    return 0;
}