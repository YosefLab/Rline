#include <vector>
#include <string>

#ifndef RECONSTRUCT_H
#define RECONSTRUCT_H

void ReconstructMain(const std::vector<std::string> &input_u, const std::vector<std::string> &input_v, const std::vector<double> &input_w, 
	std::vector<std::string> &output_u, std::vector<std::string> &output_v, std::vector<double> &output_w, 
	int max_depth = 1, int max_k = 0);


#endif
