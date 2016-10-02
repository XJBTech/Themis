#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <vector>

#include "themis.h"

namespace themis {};

namespace opts {
bool svn = true;
};

int main( int argc, char* argv[] ) {
    /* parser arguments */
    arguments _arg;
    if ( !_arg.process_arguments( argc, argv ) ) return ( EXIT_FAILURE );
    if ( _arg.exist( "test_id" ) ) {
        cout << "Testing " << _arg.value( "test_id" ) << endl;
    } else {
        return 0;
    }

    /* pull test file from server */

    /* check environment */

    /* move file and compile */

    /* run tests */
}
