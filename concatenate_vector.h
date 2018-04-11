#include <vector>
#include <string>

#ifndef CONCATENATE_H
#define CONCATENATE_H

void ConcatenateMain(const std::vector<std::string> &first_order_vertices, const std::vector<std::string> &second_order_vertices, 
					std::vector<std::string> &output_vertices, const std::vector< std::vector<double> > &first_order_features, 
					const std::vector< std::vector<double> > &second_order_features, std::vector< std::vector<double> > &output_features, int binary_param = 0);
#endif


