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

#include "optionparser.h"

using namespace std;

enum optionIndex { UNKNOWN, HELP, PLUS };
const option::Descriptor usage[] = {{UNKNOWN, 0, "", "", option::Arg::None,
                                     "USAGE: themis id [options]\n\n"
                                     "Options:"},
                                    {HELP, 0, "h", "help", option::Arg::None,
                                     "  --help -h \tPrint usage and exit."},
                                    {0, 0, 0, 0, 0, 0}};

namespace themis {
int process_arguments( int argc, char* argv[] );
void svn_checkout();
};

namespace opts {
bool svn = true;
};

using namespace themis;

int main( int argc, char* argv[] ) {
    /* parser arguments */
    if(process_arguments( argc, argv )) return(EXIT_FAILURE);

    /* pull test file from server */

    /* check environment */

    /* move file and compile */

    /* run tests */
}

int themis::process_arguments( int argc, char* argv[] ) {
    argc -= ( argc > 0 );
    argv += ( argc > 0 );  // skip program name argv[0] if present
    option::Stats               stats( usage, argc, argv );
    std::vector<option::Option> options( stats.options_max );
    std::vector<option::Option> buffer( stats.buffer_max );
    option::Parser parse( usage, argc, argv, &options[0], &buffer[0] );

    if ( parse.error() ) return 1;

    if ( options[HELP] || argc == 0 ) {
        option::printUsage( std::cout, usage );
        return 0;
    }

    for ( option::Option* opt = options[UNKNOWN]; opt; opt = opt->next() )
        std::cout << "Unknown option: "
                  << std::string( opt->name, opt->namelen ) << "\n";
    if ( UNKNOWN ) return 0;

    if ( !parse.nonOptionsCount() ) return 0;

    string test_name = parse.nonOption( 0 );
    std::cout << "Running tests for " << test_name << std::endl;

    return 0;
};

void themis::svn_checkout() {
}
