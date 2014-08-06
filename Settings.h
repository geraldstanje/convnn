#ifndef __SETTINGS_H__
#define __SETTINGS_H__

// Used by CUDA code
// Change to double when using the gradient checker
typedef float REAL;

// Dataset
const char* const TRAINING_FILE[] = {
    "/home/nghia/Downloads/cifar-10-batches-bin/data_batch_1.bin",
    "/home/nghia/Downloads/cifar-10-batches-bin/data_batch_2.bin",
    "/home/nghia/Downloads/cifar-10-batches-bin/data_batch_3.bin",
    "/home/nghia/Downloads/cifar-10-batches-bin/data_batch_4.bin",
    "END"
};

const char VALIDATION_FILE[] = "/home/nghia/Downloads/cifar-10-batches-bin/data_batch_5.bin";
const char TEST_FILE[] = "/home/nghia/Downloads/cifar-10-batches-bin/test_batch.bin";

const int IMAGE_SIZE = 32;
const int CATEGORIES = 10;

#endif // __SETTINGS_H__
