#include <Rcpp.h>
#include <string>
#include <vector>
#include <stdio.h>
#include <cassert> 
#include "reconstruct_vector.h"
#include "line_vector.h"
#include "concatenate_vector.h"

// [[Rcpp::export]]
Rcpp::DataFrame reconstruct_caller(Rcpp::StringVector input_u, Rcpp::StringVector input_v, Rcpp::NumericVector input_w, int max_depth = 1, int max_k = 0) {
  std::vector<std::string> iu(input_u.size()), iv(input_v.size()), ou, ov;
  std::vector<double> iw(input_w.size()), ow;
  for (long long i = 0; i < input_u.size(); i++) {
    iu[i] = (std::string) input_u(i);
    iv[i] = (std::string) input_v(i);
    iw[i] = (double) input_w(i);
  }
  
  ReconstructMain(iu, iv, iw, ou, ov, ow, max_depth, max_k);

  Rcpp::StringVector output_u(ou.size()), output_v(ov.size());
  Rcpp::NumericVector output_w(ow.size());
  output_u = ou; output_v = ov; output_w = Rcpp::wrap(ow);
  return Rcpp::DataFrame::create(Rcpp::Named("u") = output_u, Rcpp::Named("v") = output_v, Rcpp::Named("w") = output_w);
}

// [[Rcpp::export]]
Rcpp::NumericMatrix line_caller(Rcpp::StringVector input_u, Rcpp::StringVector input_v, Rcpp::NumericVector input_w, int binary = 0, int dim = 100, int order = 2, int negative = 5, int samples = 1, float rho = 0.025, int threads = 1) {
  std::vector<std::string> iu(input_u.size()), iv(input_v.size()), output_vertices;
  std::vector<double> iw(input_w.size());
  std::vector< std::vector<double> > output_features;
  for (long long i = 0; i < input_u.size(); i++) {
    iu[i] = (std::string) input_u(i);
    iv[i] = (std::string) input_v(i);
    iw[i] = (double) input_w(i);
  }

  TrainLINEMain(iu, iv, iw, output_vertices, output_features, binary, dim, order, negative, samples, rho, threads);

  long long row = (long long) output_features.size(), col = (long long) output_features[0].size();
  Rcpp::NumericMatrix feature_matrix(row, col);
  Rcpp::StringVector vertice_names(row);
  vertice_names = output_vertices;
  Rcpp::rownames(feature_matrix) = vertice_names;
  for (long long r = 0; r < row; r++) {
      for (long long c = 0; c < col; c++) {
        feature_matrix(r, c) = output_features[r][c];
      }
  }
  return feature_matrix;
}

// [[Rcpp::export]]
Rcpp::NumericMatrix concatenate_caller(Rcpp::NumericMatrix input_one, Rcpp::NumericMatrix input_two, Rcpp::StringVector first_order_v, Rcpp::StringVector second_order_v, int binary = 0) {
  long long first_order_rows = (long long) input_one.nrow(), second_order_rows = (long long) input_two.nrow();
  std::vector<std::string> first_order_vertices(first_order_rows), second_order_vertices(second_order_rows), output_vertices;
  std::vector< std::vector<double> > first_order_features, second_order_features, output_features;

  for (long long i = 0; i < (long long) first_order_rows; i++) {
    first_order_vertices[i] = (std::string) first_order_v[i];
    Rcpp::NumericVector current_row = input_one.row(i);
    std::vector<double> v(current_row.begin(), current_row.end());
    first_order_features.push_back(v);
  }
  for (long long i = 0; i < (long long) second_order_rows; i++) {
    second_order_vertices[i] = (std::string) second_order_v[i];
    Rcpp::NumericVector current_row = input_two.row(i);
    std::vector<double> v(current_row.begin(), current_row.end());
    second_order_features.push_back(v);
  }
  
  ConcatenateMain(first_order_vertices, second_order_vertices, output_vertices, first_order_features, second_order_features, output_features, binary);

  long long row = (long long) output_features.size(), col = (long long) output_features[0].size();
  Rcpp::NumericMatrix feature_matrix(row, col);
  Rcpp::StringVector vertice_names(row);
  vertice_names = output_vertices;
  Rcpp::rownames(feature_matrix) = vertice_names;
  for (long long r = 0; r < row; r++) {
      for (long long c = 0; c < col; c++) {
        feature_matrix(r, c) = output_features[r][c];
      }
  }
  return feature_matrix;
}

