#include <bits/stdc++.h>
using namespace std;

int main(int argc, char **argv) {
	if (argc != 3) {
		cerr << "Error Must Have 2 Input file names to test the difference" << endl; 
		exit(1);
	}
	ifstream f1, f2;
	f1.open(string(argv[1]));
	f2.open(string(argv[2]));
	string s;
	multiset<string> st;
	while(getline(f1, s)) {
		st.insert(s);
	}
	int i = 1;
	while(getline(f2, s)) {
		if (st.size() <= 0) {
			printf("LINE %d IS NOT FOUND IN FILE 2! VALUE IS %s\n", i, s.c_str());
			continue;
		}
		auto it = st.find(s);
		if (it == st.end()) {
			printf("LINE %d IS NOT FOUND IN FILE 2! VALUE IS %s\n", i, s.c_str()); 
		} else {
			st.erase(it);
		}
		i++;
	}
	if (st.size() > 0) {
		while (!st.empty()) {
			printf("LINE %d IS NOT FOUND IN FILE 1! VALUE IS %s\n", i++, st.begin() -> c_str());
			st.erase(st.begin());
		}
	}
	return 0;
}
