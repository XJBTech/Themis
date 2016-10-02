#include "arguments.h"

#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

namespace util {

struct Arg : public option::Arg {
    static void printError( const char* msg1, const option::Option& opt,
                            const char* msg2 ) {
        fprintf( stderr, "%s", msg1 );
        fwrite( opt.name, opt.namelen, 1, stderr );
        fprintf( stderr, "%s", msg2 );
    }

    static option::ArgStatus Unknown( const option::Option& option, bool msg ) {
        if ( msg ) printError( "Unknown option '", option, "'\n" );
        return option::ARG_ILLEGAL;
    }

    static option::ArgStatus Required( const option::Option& option,
                                       bool                  msg ) {
        if ( option.arg != 0 ) return option::ARG_OK;

        if ( msg ) printError( "Option '", option, "' requires an argument\n" );
        return option::ARG_ILLEGAL;
    }

    static option::ArgStatus NonEmpty( const option::Option& option,
                                       bool                  msg ) {
        if ( option.arg != 0 && option.arg[0] != 0 ) return option::ARG_OK;

        if ( msg )
            printError( "Option '", option,
                        "' requires a non-empty argument\n" );
        return option::ARG_ILLEGAL;
    }

    static option::ArgStatus Numeric( const option::Option& option, bool msg ) {
        char* endptr = 0;
        if ( option.arg != 0 && strtol( option.arg, &endptr, 10 ) ) {
        };
        if ( endptr != option.arg && *endptr == 0 ) return option::ARG_OK;

        if ( msg )
            printError( "Option '", option, "' requires a numeric argument\n" );
        return option::ARG_ILLEGAL;
    }
};
enum optionIndex { UNKNOWN, HELP, CONF };
const option::Descriptor usage[] = {{UNKNOWN, 0, "", "", option::Arg::None,
                                     "USAGE: themis id [options]\n\n"
                                     "Options:"},
                                    {HELP, 0, "h", "help", option::Arg::None,
                                     "  --help -h \tPrint usage and exit."},
                                    {CONF, 0, "c", "config", Arg::Required,
                                     "  --config -c \tSpecify config file."},
                                    {0, 0, 0, 0, 0, 0}};

bool arguments::process_arguments( int& argc, char**& argv ) const {
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
};
