#include <Rcpp.h>
#include <string>
#include <vector>
#include <stdio.h>
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
Rcpp::List line_caller(Rcpp::StringVector input_u, Rcpp::StringVector input_v, Rcpp::NumericVector input_w, int binary = 0, int dim = 100, int order = 2, int negative = 5, int samples = 1, float rho = 0.025, int threads = 1) {
  std::vector<std::string> iu(input_u.size()), iv(input_v.size()), output_vertices;
  std::vector<double> iw(input_w.size());
  std::vector< std::vector<double> > output_vectors;
  for (long long i = 0; i < input_u.size(); i++) {
    iu[i] = (std::string) input_u(i);
    iv[i] = (std::string) input_v(i);
    iw[i] = (double) input_w(i);
  }

  TrainLINEMain(iu, iv, iw, output_vertices, output_vectors, binary, dim, order, negative, samples, rho, threads);

  long long row = (long long) output_vectors.size(), col = (long long) output_vectors[0].size();
  Rcpp::StringVector output_v(row);
  output_v = output_vertices;
  Rcpp::List mat;   
  mat.push_back(output_v);
  for (long long c = 0; c < col; c++) {
      Rcpp::NumericVector vec(row);
      for (long long r = 0; r < row; r++) {
        vec[r] = output_vectors[r][c];
      }
      mat.push_back(vec);
  }
  return mat;
}

// [[Rcpp::export]]
Rcpp::List concatenate_caller(Rcpp::DataFrame input_one, Rcpp::DataFrame input_two, int binary = 0) {
  Rcpp::StringVector first_order_v = input_one[0], second_order_v = input_two[0];
  long long first_order_rows = (long long) first_order_v.size(), first_order_cols = (long long) input_one.size() - 1;
  long long second_order_rows = (long long) second_order_v.size(), second_order_cols = (long long) input_two.size() - 1;
  std::vector<std::string> first_order_vertices(first_order_rows), second_order_vertices(first_order_rows), output_vertices;
  std::vector< std::vector<double> > first_order_features(first_order_rows), second_order_features(second_order_rows), output_features;
  Rcpp::NumericVector first_order_f, second_order_f;

  for (long long i = 0; i < (long long) first_order_rows; i++) {
    first_order_vertices[i] = (std::string) first_order_v[i];
    first_order_features[i] = std::vector<double>(first_order_cols);
  }
  for (long long i = 0; i < (long long) second_order_rows; i++) {
    second_order_vertices[i] = (std::string) second_order_v[i];
    second_order_features[i] = std::vector<double>(second_order_cols);
  }
  for (long long i = 0; i < first_order_cols; i++) {
    first_order_f = input_one[i + 1];
    for (long long j = 0; j < first_order_rows; j++) {
        first_order_features[j][i] = first_order_f[j]; 
    }
  }
  for (long long i = 0; i < second_order_cols; i++) {
    second_order_f = input_two[i + 1];
    for (long long j = 0; j < second_order_rows; j++) {
        second_order_features[j][i] = second_order_f[j]; 
    }
  }
  
  ConcatenateMain(first_order_vertices, second_order_vertices, output_vertices, first_order_features, second_order_features, output_features, binary);

  long long row = (long long) output_features.size(), col = (long long) output_features[0].size();
  Rcpp::StringVector output_v(row);
  output_v = output_vertices;
  Rcpp::List mat;   
  mat.push_back(output_v);
  for (long long c = 0; c < col; c++) {
      Rcpp::NumericVector vec(row);
      for (long long r = 0; r < row; r++) {
        vec[r] = output_features[r][c];
      }
      mat.push_back(vec);
  }
  return mat;
}

