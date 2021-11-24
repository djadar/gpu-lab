// Simple CUDA example by Ingemar Ragnemalm 2009. Simplest possible?
// Assigns every element in an array with its index.

// nvcc simple.cu -L /usr/local/cuda/lib -lcudart -o simple

#include <stdio.h>

#include <math.h>

const int N = 16; 
const int blocksize = 16; 

__global__ 
void simple(float *c) 
{
	c[threadIdx.x] = threadIdx.x;
}

int main()
{
	float *c = new float[N];	
	float *cd;
	const int size = N*sizeof(float);
	
	//cd = malloc(size);

	printf("Part 1\n");
	for (int i = 0; i < N; i++){
		c[i] = rand();
		printf("%f ", sqrt(c[i]));
	}
		

	printf("\n");

	printf("Part 2\n");

	cudaMalloc( (void**)&cd, size );
	dim3 dimBlock( blocksize, 1 );
	dim3 dimGrid( 1, 1 );
	simple<<<dimGrid, dimBlock>>>(cd);
	cudaDeviceSynchronize();
	cudaMemcpy( cd, c, size, cudaMemcpyHostToDevice ); 
	for (int i = 0; i < N; i++)
		printf("%f ", sqrt(c[i]));
		
	cudaFree( cd );
	

	printf("\n");
	delete[] c;
	printf("done\n");
	return EXIT_SUCCESS;
}
