# Rline
This project serves to wrap the C++ LINE algorithm for network embedding so that R programmers may use it. The original LINE code can be found at https://github.com/tangjianpku/LINE. This project wraps the four original LINE algorithms reconstruct, line, concatenate, and normalize in R by using C++, Rcpp, and R. Please reference the original LINE Algorithm for more specifics on the algorithm 

## Installation
Run this command within an R session to install the project: 
``` devtools::install_github("YosefLab/Rline") ``` 
You must have the R package devtools pre-installed. To install the R package devtools run this command in an R session: 
``` install.packages("devtools") ```
For the installation to work properly please have the GNU-GSL library pre-installed on your system. You should be able to run this program here https://www.gnu.org/software/gsl/manual/html_node/An-Example-Program.html. Reference the manual https://www.gnu.org/software/gsl/ to learn more. To install the GSL package for Mac OSX systems run this command in the terminal: 
``` brew install gsl ```
After these installations, you should be able to load the rline project successfully with this command in an R session:
``` library(rline) ```

## Input
The input to this algorithm consists of the edges in the network. Each line of the input file represents a DIRECTED edge in the network, which is specified as the format "source target weight" (can be either separated by blank or tab). For each undirected edge, users must use TWO DIRECTED edges to represent it. Here is an input example of a word co-occurrence network:
```
good the 3
the good 3
good bad 1
bad good 1
bad of 4
of bad 4
```

## Example
The algorithm's work flow is reconstruct, line, concatenate, and finally normalize. Please reference the documentation and examples for more information on the specific parameters, inputs, and outputs of each function. You can find examples and documentation of a specific function like normalize in a R session by running the command:
``` ?normalize ``` 
An example run of the full algorithm's pipeline is shown below: 
```R

#loading the project
library(rline)

#Initalizing Inputs
u <- c("good", "the", "good", "bad", "bad", "of")
v <- c("the", "good", "bad", "good", "of", "bad")
w <- c(3, 3, 1, 1, 4, 4)
edge_list_df <- data.frame(u, v, w)

#LINE Algorithm
reconstruct_df <- reconstruct(edge_list_df, max_depth = 2, max_k = 10)
line_one_matrix <- line(reconstruct_df, dim = 5, order = 1, negative = 5, samples = 10, rho = 0.025)
line_two_matrix <- line(reconstruct_df, dim = 5, order = 2, negative = 5, samples = 10, rho = 0.025)
concatenate_matrix <- concatenate(line_one_matrix, line_two_matrix)
normalize_matrix <- normalize(concatenate_matrix)

#Printing Outputs
print(normalize_matrix)
```

## Output
After calling Rline, you should get an embedded graph representation of your original input. This embedded graph is encoded in a numeric matrix format. The row names represent the vertices of the embedded graph. Each row of the numeric matrix represents the weights and/or features of that row vertice. An example output:  
```
"good" -0.0057999063284086 -0.506399876000164 0.11216266052946 -0.403964318480159 0.260303473384282 0.00603418683542148 0.304603774027264 0.516232567404364 -0.370523322201836 0.0582797468138692
"the" 0.514938016733167 0.125298672005472 -0.435274993637608 0.126845208470937 0.116554960535302 0.47036772425405 -0.116344005020946 0.00562600173055491 -0.481809835027398 0.181785322135997
"bad" -0.415866117966079 0.202961711728412 0.133313359226443 0.444913304679572 0.264842621270433 0.225957538187186 0.393860826747428 -0.00239510696399413 -0.075610756563973 -0.536743996775221
"of" -0.00627921536056515 0.177335922518247 0.131455421219127 -0.18463240607838 -0.645865983725179 0.233277624763453 0.561080137110833 -0.106400931844926 0.31924952585353 0.132398003885303
```

## Further Notes
The line and reconstruct functions have quite long execution times, especially line which has a complexity that scales off of your dim parameter. The dim parameter is how many millions of samples the algorithm will perform, the higher the number of samples, the more accurate the representation of your embedded graph. 


## Differences between Rline and LINE C++ Program
- Rline wraps the original LINE files compiled without the options -march=native and -Ofast. This is too reduce the randomness of the LINE algorithm outputs and increase the compatability of the original LINE algorithm. 
- There are precision differences between the LINE and Rline normalize function due to floating point arithmetic differences between C++ and R (roughly 1e-6 in magnitude). 
- Please call all functions with binary option set to 0 as Rline cannot output binary formatted data unlike the original C++ LINE Algorithm
- The seed in the LINE algorithm has been preset to a fixed number so your results should be deterministic if you use the same inputs and same parameters. 
- The multithreaded option to call the line function is not supported by Rline unlike in LINE. Thus, please call line with threads parameter as 1. 
- All malloc issues (which should not happen unless your data is really big) should cause an exit to the program. 


