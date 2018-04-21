#' @title Reconstruct Graph 
#'
#' @description  
#' This function reconstructs your edge list graph into another condensed edge 
#' list graph which you can run the line algorithm on. 
#' 
#' @details 
#' This is a function which takes a graph represented in edge list form as input. 
#' The edge list should be represented as a dataframe with the edges in the form of u, v, w. 
#' u, v are the vertice names and are turned into StringVectors in Rcpp. w is the 
#' edge weight and is transformed into a numeric vector in Rcpp.
#' This function then calls the original line algorithm written in C++. Too
#' gain a better understanding of what each parameter does please look at the 
#' the line paper in references and the implementation in the github link.
#' This function returns a reconstructed graph as a dataframe in the form u, v, w.
#' This reconstructed graph can be passed into line to run the main line algorithm for 
#' graph embedding
#'
#' @param df edge list representation of the graph in the form u, v, w. Three columns 
#' are in this dataframe. The edges are directed which means edge u -> v has weight w. 
#' To represent an undirected graph just input edges u, v, w and v, u, w.
#' The first column and second column represent the u and v vertices with 
#' character types. The third column represented the weight of the edges. Each row 
#' represents a weighted edge in the graph.
#' @param max_depth The maximum depth in the Breadth-First-Search. Default is 1, never input 0.
#' @param max_k For vertex whose degree is less than max_k, we will expand its neighbors 
#' until the degree reaches max_k
#' @return a reconstructed graph that can be inputted directly into the line function. 
#' This graph is represented in edge list form in an identical format as the input 
#' parameter df. Note it is also a directed edge list.
#'
#' @seealso 
#'  \url{https://github.com/tangjianpku/LINE}
#' @references 
#'  \url{https://arxiv.org/abs/1503.03578}
#'   
#' @examples
#' u <- c("good", "the", "bad")
#' v <- c("the", "good", "the")
#' w <- 1:3
#' df <- data.frame(u, v, w)
#' reconstruct(df)
#' reconstruct(df, max_depth = 2)
#' reconstruct(df, max_depth = 2, max_k = 2)
reconstruct <- function(df, max_depth = 1, max_k = 0) {
  return(reconstruct_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), max_depth, max_k))
}

line <- function(df = NULL, binary = 0, dim = 100, order = 2, negative = 5, samples = 1, rho = 0.025, threads = 1) {
  return(line_caller(as.character(df[, 1]), as.character(df[, 2]), as.numeric(df[, 3]), binary, dim, order, negative, samples, rho, threads))
}

concatenate <- function(input_one, input_two, binary = 0) {
  return(concatenate_caller(input_one, input_two, rownames(input_one), rownames(input_two), binary))
}

normalize <- function(input_matrix) {
  return(input_matrix / sqrt(rowSums(input_matrix * input_matrix)))
}
