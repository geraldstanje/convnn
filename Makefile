# Compile the my CUDA examples

CC=gcc -std=c++11 
#CC=/usr/local/bin/gcc-4.8 -std=c++11
CXX=g++ -std=c++11
#CXX=/usr/local/bin/g++-4.8 -std=c++11
CUDACC=/usr/local/cuda/bin/nvcc
CUDAPATH=/usr/local/cuda

CFLAGS=-ggdb -I$(CUDAPATH)/include
CUDACFLAGS=-m32 -arch=compute_30 -code=sm_30 -c -I$(CUDAPATH)/include

LDFLAGS=-L/usr/local/cuda/lib -lcuda -lcublas -lcudart 
RM=rm -rf

CUDA_SOURCES=CUDA_ConvNN.cu
SOURCES=main.cpp Common.cpp
CUDA_OBJECTS=$(CUDA_SOURCES:.cu=.o)
OBJECTS=$(SOURCES:.cpp=.o)

.SUFFIXES: .cpp .cu .o

all: convnn

convnn: Common.h CUDA_Common.h Settings.h $(OBJECTS) $(CUDA_OBJECTS)
	$(CXX) -lopencv_core -lopencv_highgui -lopencv_imgproc $(LDFLAGS) $(CUDA_OBJECTS) $(OBJECTS) -o convnn

clean:
	$(RM) *.o convnn

.cpp.o:
	$(CXX) $(CFLAGS) $< -c -o $@

#.cu.o:
#	$(CUDACC) --compiler-bindir /usr/local/bin $(CUDACFLAGS) $< -c -o $@
.cu.o:
	$(CUDACC) $(CUDACFLAGS) $< -c -o $@