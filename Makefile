all: convnn
	
OBJS = CUDA_ConvNN.o CUDA_ConvNN_Layer.o Common.o main.o

CXX = clang++ 
#-libstdc++
#-std=c++11
#-stdlib=libstdc++
#CXX = /usr/local/bin/g++-4.8 #-std=c++11
CUDACC = /usr/local/cuda/bin/nvcc 
#-libstdc++

DEBUG = -g
CUDACFLAGS = -O3 -c -arch=compute_30 -code=sm_30 $(DEBUG)
LDFLAGS = $(DEBUG) -lopencv_core -lopencv_highgui -lopencv_imgproc -lcudart
#-lgomp

CUDAPATH = /usr/local/cuda
CFLAGS = -O3 -c -I$(CUDAPATH)/include 
#-Wshadow -pedantic -Wall 
#-fopenmp
INCLUDES = -I/Developer/NVIDIA/CUDA-6.0/include/
#INCLUDES  += -I/Developer/NVIDIA/CUDA-6.0/samples/common/inc
CUDA_LIBS = -L/Developer/NVIDIA/CUDA-6.0/lib/
#CUDA_LIBS = -L$(CUDAPATH)/lib

convnn : $(OBJS)
	$(CXX) -o convnn $(CUDA_LIBS) $(LDFLAGS) $(OBJS)

Common.o : Common.cpp
	$(CXX) $(CFLAGS) Common.cpp 

main.o : main.cpp
	$(CXX) $(CFLAGS) main.cpp

CUDA_ConvNN.o : CUDA_ConvNN.cu
	$(CUDACC) $(CUDACFLAGS) CUDA_ConvNN.cu $(INCLUDES)
	    
CUDA_ConvNN_Layer.o : CUDA_ConvNN_Layer.cu
	$(CUDACC) $(CUDACFLAGS) CUDA_ConvNN_Layer.cu $(INCLUDES)

clean:
	rm -f *.o convnn