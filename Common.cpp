#include "Common.h"
#include <cassert>
#include <fstream>
#include <iostream>

using namespace std;

/*
void LoadData(const char *filename, arma::cube &R, arma::cube &G, arma::cube &B, arma::mat &labels)
{
    char label;
    vector <unsigned char> buffer(IMAGE_SIZE*IMAGE_SIZE*3); // temp buffer for RGB patch

    // Load the data as column vectors
    ifstream input(filename);

    if(!input) {
        cerr << "Error opening dataset: " << filename << endl;
        exit(1);
    }

    // Get length
    int count = 0;
    while(input.read((char*)&label, sizeof(label))) {
        input.read((char*)&buffer[0], buffer.size());
        count++;
    }

    input.clear();
    input.seekg(0, std::ios_base::beg);

    R = arma::cube(IMAGE_SIZE, IMAGE_SIZE, count);
    G = arma::cube(IMAGE_SIZE, IMAGE_SIZE, count);
    B = arma::cube(IMAGE_SIZE, IMAGE_SIZE, count);

    labels = arma::zeros<arma::mat>(CATEGORIES, count);

    count = 0;
    while(input.read((char*)&label, sizeof(label))) {
        input.read((char*)&buffer[0], buffer.size());

        assert(label < CATEGORIES);

        for(int y=0; y < IMAGE_SIZE; y++) {
            for(int x=0; x < IMAGE_SIZE; x++) {
                R(y,x,count) = buffer[y*IMAGE_SIZE+x];
                G(y,x,count) = buffer[IMAGE_SIZE*IMAGE_SIZE + y*IMAGE_SIZE+x];
                B(y,x,count) = buffer[IMAGE_SIZE*IMAGE_SIZE*2 + y*IMAGE_SIZE+x];
            }
        }

        R.slice(count) /= 255;
        G.slice(count) /= 255;
        B.slice(count) /= 255;

        labels((int)label, count) = 1.0;

        count++;
    }

    assert(count);
    assert(labels.max() > 0);
}
*/
void LoadData(const char *filename, Dataset &data)
{
    char label;
    vector <unsigned char> buffer(IMAGE_SIZE*IMAGE_SIZE*3); // temp buffer for RGB patch

    // Load the data as column vectors
    ifstream input(filename);

    if(!input) {
        cerr << "Error opening dataset: " << filename << endl;
        exit(1);
    }

    // Get length
    int count = 0;
    while(input.read((char*)&label, sizeof(label))) {
        input.read((char*)&buffer[0], buffer.size());
        count++;
    }

    input.clear();
    input.seekg(0, std::ios_base::beg);

    data.image_width = IMAGE_SIZE;
    data.images.resize(count);

    for(int i=0; i < count; i++) {
        data.images[i].R.resize(IMAGE_SIZE*IMAGE_SIZE);
        data.images[i].G.resize(IMAGE_SIZE*IMAGE_SIZE);
        data.images[i].B.resize(IMAGE_SIZE*IMAGE_SIZE);
        data.images[i].labels.resize(CATEGORIES, 0);
    }

    count = 0;
    while(input.read((char*)&label, sizeof(label))) {
        input.read((char*)&buffer[0], buffer.size());

        assert(label < CATEGORIES);

        int k=0;
        for(int y=0; y < IMAGE_SIZE; y++) {
            for(int x=0; x < IMAGE_SIZE; x++) {
                data.images[count].R[k] = buffer[k] / 255.0;
                data.images[count].G[k] = buffer[IMAGE_SIZE*IMAGE_SIZE + k] / 255.0;
                data.images[count].B[k] = buffer[IMAGE_SIZE*IMAGE_SIZE*2 + k] / 255.0;

                k++;
            }
        }

        data.images[count].labels[label] = 1;

        count++;
    }
}

void CalcMean(Dataset &data, std::vector <REAL> &mean_R, std::vector <REAL> &mean_G, std::vector <REAL> &mean_B)
{
    int image_size = data.image_width;

    mean_R.resize(image_size*image_size);
    mean_G.resize(image_size*image_size);
    mean_B.resize(image_size*image_size);

    for(size_t i=0; i < data.images.size(); i++) {
        for(int j=0; j < image_size*image_size; j++) {
            mean_R[j] += data.images[i].R[j];
            mean_G[j] += data.images[i].G[j];
            mean_B[j] += data.images[i].B[j];
        }
    }

    for(int j=0; j < image_size*image_size; j++) {
        mean_R[j] /= data.images.size();
        mean_G[j] /= data.images.size();
        mean_B[j] /= data.images.size();
    }
}

void CentreData(Dataset &data, std::vector <REAL> &mean_R, std::vector <REAL> &mean_G, std::vector <REAL> &mean_B)
{
    for(size_t i=0; i < data.images.size(); i++) {
        for(size_t j=0; j < mean_R.size(); j++) {
            data.images[i].R[j] -= mean_R[j];
            data.images[i].G[j] -= mean_G[j];
            data.images[i].B[j] -= mean_B[j];
        }
    }
}
