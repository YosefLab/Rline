#include <Rcpp.h>
#include <string>
#include <vector>
#include "reconstruct2.h"

// [[Rcpp::export]]
Rcpp::DataFrame reconstruct_caller(Rcpp::StringVector input_u, Rcpp::StringVector input_v, Rcpp::NumericVector input_w) {
  std::vector<std::string> iu(input_u.size()), iv(input_v.size()), ou, ov;
  std::vector<double> iw(input_w.size()), ow;
  for (int i = 0; i < input_u.size(); i++) {
    iu[i] = input_u(i);
    iv[i] = input_v(i);
    iw[i] = input_w(i);
  }
  rmain(iu, iv, iw, ou, ov, ow);
  return Rcpp::DataFrame::create(Rcpp::Named("u") = ou, Rcpp::Named("v") = ov, Rcpp::Named("w") = ow);
}

/*** R
reconstruct_caller(c("1", "2", "3"), as.character(seq(2:4)), rep(5, 3))
*/
