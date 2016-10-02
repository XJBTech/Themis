#include "util.h"

#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <algorithm>

namespace util {

// http://stackoverflow.com/questions/2203159/is-there-a-c-equivalent-to-getcwd
std::string get_working_path() {
    char temp[MAXPATHLEN];
    return ( getcwd( temp, MAXPATHLEN ) ? std::string( temp )
                                        : std::string( "" ) );
}

void exit_with_error( const char* message ) {
    fprintf( stderr, "[Error] %s\n", message );
    throw message;
}

void error_handler() {
    /*
     *fprintf( stderr, "Unhandled exception\n" );
     */
    std::abort();
}
};
