// Simple CUDA example by Ingemar Ragnemalm 2009. Simplest possible?
// Assigns every element in an array with its index.

// nvcc simple.cu -L /usr/local/cuda/lib -lcudart -o simple

#include <stdio.h>

#include <math.h>

#include <chrono>

using namespace std::chrono;

auto start = high_resolution_clock::now();

const int N = 16; 
const int blocksize = 16; 

__global__ 
void add_matrix(float *a, float *b, float *c) 
{
	//calculation of block index
	int index = blockIdx.x * blockDim.x + threadIdx.x;

	c[index] = a[index] + b[index];
}

int main()
{
	float *a = new float[N*N];	
	float *b = new float[N*N];	
	float *c = new float[N*N];	

	float *ca, *cb, *cc;
	const int size = N*N*sizeof(float);
	
	for (int i = 0; i < N; i++)
		for (int j = 0; j < N; j++)
		{
			a[i+j*N] = 10 + i;
			b[i+j*N] = float(j) / N;
		}

	//GPU variables
	cudaMalloc( (void**)&ca, size );
	cudaMalloc( (void**)&cb, size );
	cudaMalloc( (void**)&cc, size );

	//Block size
	dim3 dimBlock( blocksize, 1);
	dim3 dimGrid( 1, 1 );
	
	
	//Copy of CPU variables to GPU variables 
	cudaMemcpy( ca, a, size, cudaMemcpyHostToDevice ); 
	cudaMemcpy( cb, b, size, cudaMemcpyHostToDevice ); 

	//
	add_matrix<<<dimGrid, dimBlock>>>(ca,cb,cc);
	//

	cudaDeviceSynchronize();
	
	//Copy of results from GPU variables to CPU variables
	cudaMemcpy( c, cc, size, cudaMemcpyDeviceToHost ); 

	//printing result
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			printf("%f",c[i+j*N]);
			printf("\n");
		}
	}
	printf("\n");

	//Free GPU memory
	cudaFree( ca );
	cudaFree( cb );
	cudaFree( cc );

	printf("\n");
	delete[] c;
	printf("done\n");
	return EXIT_SUCCESS;
}
