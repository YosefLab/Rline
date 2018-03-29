#include <Rcpp.h>
#include <string>
#include <vector>
#include <stdio.h>
#include "reconstruct_vector.h"
#include "line_vector.h"

// [[Rcpp::export]]
Rcpp::DataFrame reconstruct_caller(Rcpp::StringVector input_u, Rcpp::StringVector input_v, Rcpp::NumericVector input_w, int max_depth = 1, int max_k = 0) {
  std::vector<std::string> iu(input_u.size()), iv(input_v.size()), ou, ov;
  std::vector<double> iw(input_w.size()), ow;
  for (int i = 0; i < input_u.size(); i++) {
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
Rcpp::DataFrame line_caller(Rcpp::StringVector input_u, Rcpp::StringVector input_v, Rcpp::NumericVector input_w, int binary = 0, int dim = 100, int order = 2, int negative = 5, int samples = 1, float rho = 0.025, int threads = 1) {
  std::vector<std::string> iu(input_u.size()), iv(input_v.size()), output_vertices;
  std::vector<double> iw(input_w.size());
  std::vector< std::vector<double> > output_vectors;
  for (int i = 0; i < input_u.size(); i++) {
    iu[i] = (std::string) input_u(i);
    iv[i] = (std::string) input_v(i);
    iw[i] = (double) input_w(i);
  }

  TrainLINEMain(iu, iv, iw, output_vertices, output_vectors, binary, dim, order, negative, samples, rho, threads);
  
  long long row = (long long) output_vectors.size(), col = (long long) output_vectors[0].size();
  Rcpp::StringVector output_v(row);
  output_v = output_vertices;
  Rcpp::DataFrame df = Rcpp::DataFrame::create(Rcpp::Named("vertice") = output_v);  
  for (long long c = 0; c < col; c++) {
      Rcpp::NumericVector vec(row);
      for (long long r = 0; r < row; r++) {
        vec[r] = output_vectors[r][c];
      }
      df.push_back(vec);
  }
  return df;
}


/*FILE *file = fopen("caller_result.txt", "w");
 printf("Debugging Result:\n");
 for (int i = 0; i < (int) ou.size(); i++) {
 fprintf(file, "%s\t%s\t%lf\n", ou[i].c_str(), ov[i].c_str(), ow[i]);
 }
 fclose(file);
*/