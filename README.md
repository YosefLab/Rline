# Rline
R wrapper package around the LINE algorithm for network embedding. Original Line algorithm can be found here https://github.com/tangjianpku/LINE. This package implements the four original LINE algorithms reconstruct, line, concatenate, and normalize in R. The R function then calls the Rcpp 

### Prerequisites
Needs to be run on a LINUX machine with GSL package installed for C++. GSL package can be downloaded at http://www.gnu.org/software/gsl/


### Network Input
The input of a network consists of the edges in the network. Each line of the input file represents a DIRECTED edge in the network, which is specified as the format "source_node target_node weight" (can be either separated by blank or tab). For each undirected edge, users must use TWO DIRECTED edges to represent it. Here is an input example of a word co-occurrence network:

```
good the 3
the good 3
good bad 1
bad good 1
bad of 4
of bad 4
```


### Running Line Algorithm
You can install run the package with devtools::load_all() and then call the four functions. Please reference the documentaiton 


### Testing 
Reference the train.sh file to see all the compilation and examples on how to run the functions 
Under test_scripts there are test scripts you can run to verify the validity of the algorithm


### Differences Between Original Line algorithm
There are some minute differences between this line algorithm and the original algorithm 
because these files are compiled without certain compilation options like -march=native and -Ofast. There are also some precission differences in the normalize function. 
The test scripts on the normalize and concatenate functions read from file input as opposed to binary input as in the original line algorithm. The differences in results are roughly in the magnitude of 10^-6. 