# Rline
R wrapper package around the LINE algorithm for network embedding. Original Line algorithm can be found at https://github.com/tangjianpku/LINE. This package wraps the four original LINE algorithms reconstruct, line, concatenate, and normalize in R 
Please reference the LINE Algorithm for more specifics on the algorithm 

## Usage

### Input
The input to this algorithm consists of the edges in the network. Each line of the input file represents a DIRECTED edge in the network, which is specified as the format "source target weight" (can be either separated by blank or tab). For each undirected edge, users must use TWO DIRECTED edges to represent it. Here is an input example of a word co-occurrence network:

```
good the 3
the good 3
good bad 1
bad good 1
bad of 4
of bad 4
```

### Running Rline
You can run the package with devtools::load_all() and then call the four functions. The algorithm's work flow is reconstruct -> line -> concatenate -> normalize. Please reference the documentation and examples for more information on the specific parameters, inputs, and outputs of each function. An example run is shown below.
```
edge_list_df <- read.table("edge_list.txt")
reconstruct_df <- reconstruct(edge_list_df, max_depth = 2, max_k = 10)
line_one_matrix <- line(reconstruct_df, dim = 5, order = 1, negative = 5, samples = 10, rho = 0.025)
line_two_matrix <- line(reconstruct_df, dim = 5, order = 2, negative = 5, samples = 10, rho = 0.025)
concatenate_matrix <- concatenate(line_one_matrix, line_two_matrix)
normalize_matrix <- normalize(concatenate_matrix)
```

### Output
After calling Rline, you should get an embedded graph representation of your original input. This embedded graph should be encoded in a numeric matrix format. The row names represent the vertices of the embedded graph. Each row of the numeric matrix represents the weights of that row vertice. 
```
good -0.172447 -0.137203 -0.217762 -0.563915 0.293286 0.423504 0.522185 -0.172056 0.066339 -0.118167 
the -0.173197 -0.137063 -0.218054 -0.563202 0.294062 0.487632 -0.234309 -0.242937 0.189593 0.335188 
bad 0.173497 0.136796 0.216872 0.563866 -0.293611 0.303410 -0.398739 -0.279606 0.172593 -0.375475 
of 0.173371 0.136696 0.218381 0.563457 -0.293398 0.261021 0.204188 0.214662 0.580320 -0.085580 
```

### Further Notes
There are some differences between Rline and LINE. First, unlike the original LINE, Rline wraps the original LINE files compiled without the options -march=native and -Ofast. This is too reduce the randomness of the LINE algorithm outputs and increase the compatability of the original LINE algorithm.There are some precision differences between the LINE and Rline normalize function due to floating point arithmetic differences between C++ and R (roughly 1e-6 in magnitude). Finally, the test scripts in the normalize and concatenate functions read from regular .txt files (with strings and doubles as input and output) as opposed to the original LINE algorithm which inputs and outputs binary formatted data. Please call all functions with binary option set to 0 as Rline cannot output binary formatted data. The multithreaded option to call the line function is not supported by this package

### For Developers
Please run this with GSL, gcc, and g++ installed. Test scripts written in bash can be found under test_scripts 
