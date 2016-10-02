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
};
