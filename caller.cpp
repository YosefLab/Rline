#include <Rcpp.h>
#include <string>
#include <vector>
#include <stdio.h>
#include "reconstruct_vector.h"

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


/*FILE *file = fopen("caller_result.txt", "w");
 printf("Debugging Result:\n");
 for (int i = 0; i < (int) ou.size(); i++) {
 fprintf(file, "%s\t%s\t%lf\n", ou[i].c_str(), ov[i].c_str(), ow[i]);
 }
 fclose(file);
*/


// [[Rcpp::export]]
void line_caller() {
  printf("Calling Line\n");
}



// /*** R
// input_df = read.table("./test_cases/cases/test1.txt")
// reconstruct_caller(as.character(input_df[,1]), as.character(input_df[,2]), as.numeric(input_df[,3]), 2, 1000)
// */
