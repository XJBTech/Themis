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
    /* error handler */
    std::set_terminate( error_handler );

    /* getting workpath */
    std::string working_path = get_working_path();
#ifdef DEBUG
    cout << "working path " << working_path << endl;
#endif

    /* parser arguments */
    arguments _arg;
    if ( !_arg.process_arguments( argc, argv ) ) return ( EXIT_FAILURE );
    if ( _arg.exist( "test_id" ) ) {
        cout << "Testing " << _arg.value( "test_id" ) << endl;
    } else {
        return 0;
    }

    /* reading config file */
    config      _conf;
    std::string config_file = _arg.exist( "config_file" )
                                  ? _arg.value( "config_file" )
                                  : working_path + "/";
#ifdef DEBUG
    cout << "reading config file " << config_file << endl;
#endif
    if ( !_conf.read_config( config_file ) ) {
        exit_with_error( "Cannot find config file" );
    }

    /* pull test file from server */
#ifdef DEBUG
    cout << "svn repo = " << _conf.value("svn", "repo") << endl;
#endif

    /* check environment */

    /* move file and compile */

    /* run tests */
}
