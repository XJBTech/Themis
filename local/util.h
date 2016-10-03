#ifndef __UTIL_H__
#define __UTIL_H__

#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

namespace util {
using namespace std;

#define MAXPIPELEN 4096
std::string exec( const char* cmd, bool to_stdout );

vector<string> split(string str, char delimiter);

void assertExists(const string & path, int exit_code = -1);
bool exists(const string & path);
mode_t permissions(const string & path);

void copy_file(std::string source, std::string destination);
void copy_files(std::string source, std::string destination, vector<std::string> file_list, bool display);

#define MAXPATHLEN 1024
std::string get_working_path();

void exit_with_error( const char* message );
void error_handler();
};

#endif
