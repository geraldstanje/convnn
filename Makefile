all: convnn
	
OBJS = CUDA_ConvNN.o CUDA_ConvNN_Layer.o Common.o main.o

CXX = g++ -stdlib=libstdc++
CUDACC = /usr/local/cuda/bin/nvcc

DEBUG = -g

CUDAPATH = /usr/local/cuda
INCLUDES = -I/Developer/NVIDIA/CUDA-6.0/include/
CUDA_LIBS = -L/Developer/NVIDIA/CUDA-6.0/lib/
# make sure that you export: export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-6.0/lib/

CFLAGS = -O3 -c -Wshadow -pedantic -Wall -I$(CUDAPATH)/include
CUDACFLAGS = -O3 -c -arch=compute_30 -code=sm_30 $(DEBUG) 

LDFLAGS = $(DEBUG) -lopencv_core -lopencv_highgui -lopencv_imgproc -lcudart

convnn : $(OBJS)
	$(CXX) -o convnn $(OBJS) $(CUDA_LIBS) $(LDFLAGS)

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