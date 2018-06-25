#include <vector>
#include <string>

#ifndef LINE_H
#define LINE_H

void TrainLINEMain(const std::vector<std::string> &input_u, const std::vector<std::string> &input_v, const std::vector<double> &input_w, 
					std::vector<std::string> &output_vertices, std::vector< std::vector<double> > &output_vectors, int is_binary_param, 
					int dim_param, int order_param, int num_negative_param, int total_samples_param, float init_rho_param, int num_threads_param);
#endif

