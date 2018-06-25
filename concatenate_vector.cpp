#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <vector>
#include <string> 

#define MAX_STRING 100

static const int hash_table_size = 30000000;

typedef float real;                    // Precision of float numbers

struct ClassVertex {
	double degree;
	char *name;
};

static char vector_file1[MAX_STRING], vector_file2[MAX_STRING], output_file[MAX_STRING];
static struct ClassVertex *vertex;
static int binary = 0;
static int *vertex_hash_table;
static long long num_vertices = 0;
static long long vector_dim1, vector_dim2;
static real *vec1, *vec2;

/* Build a hash table, mapping each vertex name to a unique vertex id */
static unsigned int Hash(char *key)
{
	unsigned int seed = 131;
	unsigned int hash = 0;
	while (*key)
	{
		hash = hash * seed + (*key++);
	}
	return hash % hash_table_size;
}

static void InitHashTable()
{
	vertex_hash_table = (int *)malloc(hash_table_size * sizeof(int));
	for (int k = 0; k != hash_table_size; k++) vertex_hash_table[k] = -1;
}

static void InsertHashTable(char *key, int value)
{
	int addr = Hash(key);
	while (vertex_hash_table[addr] != -1) addr = (addr + 1) % hash_table_size;
	vertex_hash_table[addr] = value;
}

static int SearchHashTable(char *key)
{
	int addr = Hash(key);
	while (1)
	{
		if (vertex_hash_table[addr] == -1) return -1;
		if (!strcmp(key, vertex[vertex_hash_table[addr]].name)) return vertex_hash_table[addr];
		addr = (addr + 1) % hash_table_size;
	}
	return -1;
}

/* Add a vertex to the vertex set */
static int AddVertex(char *name, int vid)
{
	int length = strlen(name) + 1;
	if (length > MAX_STRING) length = MAX_STRING;
	vertex[vid].name = (char *)calloc(length, sizeof(char));
	strcpy(vertex[vid].name, name);
	vertex[vid].degree = 0;
	InsertHashTable(name, vid);
	return vid;
}

static void ReadVectors(std::vector<std::string> &first_order_vertices, std::vector<std::string> &second_order_vertices, 
				std::vector< std::vector<double> > &first_order_features, std::vector< std::vector<double> > &second_order_features) {
	char name[MAX_STRING];
	double f_num;
	long long rows, cols;

	FILE *fi = fopen(vector_file1, "rb");
	if (fi == NULL) {
		printf("Vector file 1 not found\n");
		exit(1);
	}
	fscanf(fi, "%lld %lld ", &rows, &cols);
	for (long long k = 0; k != rows; k++)
	{
		fscanf(fi, "%s ", name);
		first_order_vertices.push_back(std::string(name));
		std::vector<double> v;
		for (long long c = 0; c != cols; c++)
		{
			fscanf(fi, "%lf ", &f_num);
			v.push_back(f_num);
		}
		first_order_features.push_back(v);
	}
	fclose(fi);

	fi = fopen(vector_file2, "rb");
	if (fi == NULL) {
		printf("Vector file 2 not found\n");
		exit(1);
	}
	fscanf(fi, "%lld %lld ", &rows, &cols);
	for (long long k = 0; k != rows; k++)
	{
		fscanf(fi, "%s ", name);
		second_order_vertices.push_back(std::string(name));
		std::vector<double> v;
		for (long long c = 0; c != cols; c++)
		{
			fscanf(fi, "%lf ", &f_num);
			v.push_back(f_num);
		}
		second_order_features.push_back(v);
	}
	fclose(fi);
}


static void InitVectors(const std::vector<std::string> &first_order_vertices, const std::vector<std::string> &second_order_vertices, 
				const std::vector< std::vector<double> > &first_order_features, const std::vector< std::vector<double> > &second_order_features) {
	char name[MAX_STRING];
	real f_num;
	long long l;

	num_vertices = (long long) first_order_features.size();
	vector_dim1 = (long long) first_order_features[0].size();
	vertex = (struct ClassVertex *)calloc(num_vertices, sizeof(struct ClassVertex));
	vec1 = (real *)calloc(num_vertices * vector_dim1, sizeof(real));
	for (long long k = 0; k != num_vertices; k++)
	{
		strcpy(name, first_order_vertices[k].c_str());
		AddVertex(name, k);
		l = k * vector_dim1;
		for (int c = 0; c != vector_dim1; c++)
		{
			f_num = (real) first_order_features[k][c];
			vec1[c + l] = (real)f_num;
		}
	}
	
	l = (long long) second_order_features.size();
	vector_dim2 = (long long) second_order_features[0].size();
	vec2 = (real *)calloc((num_vertices + 1) * vector_dim2, sizeof(real));
	for (long long k = 0; k != num_vertices; k++)
	{
		strcpy(name, second_order_vertices[k].c_str());
		int i = SearchHashTable(name);
		if (i == -1) l = num_vertices * vector_dim2;
		else l = i * vector_dim2;
		for (int c = 0; c != vector_dim2; c++)
		{
			f_num = (real) second_order_features[k][c];
			vec2[c + l] = (real) f_num;

		}
	}

	printf("Vocab size: %lld\n", num_vertices);
	printf("Vector size 1: %lld\n", vector_dim1);
	printf("Vector size 2: %lld\n", vector_dim2);	
}


void ConcatenateMain(const std::vector<std::string> &first_order_vertices, const std::vector<std::string> &second_order_vertices, 
					std::vector<std::string> &output_vertices, const std::vector< std::vector<double> > &first_order_features, 
					const std::vector< std::vector<double> > &second_order_features, std::vector< std::vector<double> > &output_features, int binary_param = 0) {
	binary = binary_param;
	long long a, b;
	double len;

	InitHashTable();
	InitVectors(first_order_vertices, second_order_vertices, first_order_features, second_order_features);
	printf("%lld %lld\n", num_vertices, vector_dim1 + vector_dim2);
	for (a = 0; a < num_vertices; a++) {
		output_vertices.push_back(std::string(vertex[a].name));
		len = 0;
		for (b = 0; b < vector_dim1; b++) len += vec1[b + a * vector_dim1] * vec1[b + a * vector_dim1];
		len = sqrt(len);
		for (b = 0; b < vector_dim1; b++) vec1[b + a * vector_dim1] /= len;

		len = 0;
		for (b = 0; b < vector_dim2; b++) len += vec2[b + a * vector_dim2] * vec2[b + a * vector_dim2];
		len = sqrt(len);
		for (b = 0; b < vector_dim2; b++) vec2[b + a * vector_dim2] /= len;

		std::vector<double> v;
		for (b = 0; b < vector_dim1; b++)
			v.push_back(vec1[a * vector_dim1 + b]);
		for (b = 0; b < vector_dim2; b++)
			v.push_back(vec2[a * vector_dim2 + b]);	
		output_features.push_back(v);
	}
}

static void OutputVectors(std::vector<std::string> &output_vertices, std::vector< std::vector<double> > &output_features) {
	FILE *fo = fopen(output_file, "wb");
	long long rows = (long long) output_features.size();
	long long cols = (long long) output_features[0].size();
	fprintf(fo, "%lld %lld\n", rows, cols);
	for (long long a = 0; a < rows; a++)
	{
		fprintf(fo, "%s ", output_vertices[a].c_str());
		if (binary) for (long long b = 0; b < cols; b++) fwrite(&output_features[a][b], sizeof(real), 1, fo);
		else for (long long b = 0; b < cols; b++) fprintf(fo, "%lf ", output_features[a][b]);
		fprintf(fo, "\n");
	}
	fclose(fo);
}


static int ArgPos(char *str, int argc, char **argv) {
	int a;
	for (a = 1; a < argc; a++) if (!strcmp(str, argv[a])) {
		if (a == argc - 1) {
			printf("Argument missing for %s\n", str);
			exit(1);
		}
		return a;
	}
	return -1;
}

int main(int argc, char **argv) {
	int i;
	if (argc == 1) {
		printf("Concatenate the 1st-order embedding and the 2nd-order embeddings\n\n");
		printf("Options:\n");
		printf("Parameters for training:\n");
		printf("\t-input1 <file>\n");
		printf("\t\tThe 1st-order embeddings\n");
		printf("\t-input2 <file>\n");
		printf("\t\tThe 2nd-order embeddings\n");
		printf("\t-output <file>\n");
		printf("\t\tUse <file> to save the concatenated embeddings\n");
		printf("\t-binary <int>\n");
		printf("\t\tSave the learnt embeddings in binary moded; default is 0 (off)\n");
		printf("\nExamples:\n");
		printf("./concatenate -input1 vec_1st.txt -input2 vec_2nd.txt -output vec_all.txt -binary 1\n\n");
		return 0;
	}
	if ((i = ArgPos((char *)"-input1", argc, argv)) > 0) strcpy(vector_file1, argv[i + 1]);
	if ((i = ArgPos((char *)"-input2", argc, argv)) > 0) strcpy(vector_file2, argv[i + 1]);
	if ((i = ArgPos((char *)"-output", argc, argv)) > 0) strcpy(output_file, argv[i + 1]);
	if ((i = ArgPos((char *)"-binary", argc, argv)) > 0) binary = atoi(argv[i + 1]);
	
	std::vector<std::string> first_order_vertices, second_order_vertices, output_vertices; 
	std::vector< std::vector<double> > first_order_features, second_order_features, output_features;
	ReadVectors(first_order_vertices, second_order_vertices, first_order_features, second_order_features);
	ConcatenateMain(first_order_vertices, second_order_vertices, output_vertices, first_order_features, second_order_features, output_features, 0);
	OutputVectors(output_vertices, output_features);
	return 0;
}
