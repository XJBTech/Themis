#include "util.h"

#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <algorithm>
#include <iostream>
#include <stdexcept>

namespace util {

std::string exec( const char* cmd, bool to_stdout ) {
    char        buffer[MAXPIPELEN];
    std::string result = "";
    FILE*       pipe   = popen( cmd, "r" );
    if ( !pipe ) throw std::runtime_error( "popen() failed!" );
    try {
        while ( !feof( pipe ) ) {
            if ( fgets( buffer, MAXPIPELEN, pipe ) != NULL ) {
                result += buffer;
                if ( to_stdout ) {
                    cout << buffer;
                }
            }
        }
    } catch ( ... ) {
        pclose( pipe );
        throw;
    }
    pclose( pipe );
    return result;
}

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
