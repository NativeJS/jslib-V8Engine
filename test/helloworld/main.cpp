#include "execute_js.h"


int main(int argc, char* argv[])
{
	// Begin running tests
	printf("RUNNING TESTS:\n");

	// Execute "'Hello' + ', World!'" string and print it
	printf("\t1: %s\n", execute_js("'Hello' + ', World!'").c_str());
	return 0;
}