all: convnn
	
OBJS = CUDA_ConvNN.o CUDA_ConvNN_Layer.o main.o

CXX = g++ -g -std=c++11 
#CXX=/usr/local/bin/g++-4.8 -std=c++11
CUDACC = /usr/local/cuda/bin/nvcc

DEBUG = -g
CUDACFLAGS = -O3 -c -arch=compute_30 -code=sm_30 $(DEBUG)
LDFLAGS = $(DEBUG) -lcudart -lopencv_core -lopencv_highgui -lopencv_imgproc

CUDAPATH=/usr/local/cuda
CFLAGS=-I$(CUDAPATH)/include
INCLUDES = -I/Developer/NVIDIA/CUDA-6.0/include/
CUDA_LIBS = -L/Developer/NVIDIA/CUDA-6.0/lib/

convnn : $(OBJS)
	$(CXX) $(LDFLAGS) $(OBJS) -o CXX $(CUDA_LIBS)

main.o : Common.cpp main.cpp
	$(CXX) $(CFLAGS) Common.cpp main.cpp

CUDA_ConvNN.o : CUDA_ConvNN.cu
	$(CUDACC) $(CUDACFLAGS) CUDA_ConvNN.cu $(INCLUDES)
	    
CUDA_ConvNN_Layer.o : CUDA_ConvNN_Layer.cu
	$(CUDACC) $(CUDACFLAGS) CUDA_ConvNN_Layer.cu $(INCLUDES)

clean:
	rm -f *.o convnn