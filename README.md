# Rline
R wrapper package around the LINE algorithm for network embedding. Original Line algorithm can be found at https://github.com/tangjianpku/LINE. This package wraps the four original LINE algorithms reconstruct, line, concatenate, and normalize in R. The R functions calls internal Rcpp functions which calls the original C++ Line functions. 

### Prerequisites
Needs to be run on a LINUX machine with GSL package installed for C++. GSL package can be downloaded at http://www.gnu.org/software/gsl/

### Network Input
The input of a network consists of the edges in the network. Each line of the input file represents a DIRECTED edge in the network, which is specified as the format "source target weight" (can be either separated by blank or tab). For each undirected edge, users must use TWO DIRECTED edges to represent it. Here is an input example of a word co-occurrence network:

```
good the 3
the good 3
good bad 1
bad good 1
bad of 4
of bad 4
```

### Running RLine
You can run the package with devtools::load_all() and then call the four functions. The algorithm's work flow is reconstruct -> line -> concatenate -> normalize. Please reference the documentation and examples within the documentation for more information on the specific parameters, inputs, and outputs of each function.


### RLine Results
After calling Rline you should get an embedded graph representation of your original input encoded in a numeric matrix format. The row names represent the vertices of the embedded graph. Each row of the numeric matrix represents the weights of that row vertice. 
```
good -0.172447 -0.137203 -0.217762 -0.563915 0.293286 0.423504 0.522185 -0.172056 0.066339 -0.118167 
the -0.173197 -0.137063 -0.218054 -0.563202 0.294062 0.487632 -0.234309 -0.242937 0.189593 0.335188 
bad 0.173497 0.136796 0.216872 0.563866 -0.293611 0.303410 -0.398739 -0.279606 0.172593 -0.375475 
of 0.173371 0.136696 0.218381 0.563457 -0.293398 0.261021 0.204188 0.214662 0.580320 -0.085580 
```

### Testing 
Reference the train.sh file to see all the compilation and examples on how to run the functions 
Under test_scripts there are test scripts you can run to verify the validity of the algorithm's respective functions.


### Further Notes
There are some minute differences between this line algorithm and the original algorithm. First, unlike the original line C++ files, this R wrapper has C++ files that are compiled without the compiler options -march=native and -Ofast. This is too reduce the randomness of the algorithm outputs and increase the compatability of this algorithm at the cost of slightly slower computation times. There are also some precision differences in the normalize function due to floating point arithmetic differences between C++ and R (roughly 1e-6 in magnitude). The test scripts on the normalize and concatenate functions read from regular double and string input formats as opposed to binary input formats as in the original line algorithm. Please call all functions with binary option set to 0 as Rline cannot output binary encoded formats.

