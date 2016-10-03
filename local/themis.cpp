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
    arguments   _arg;
    std::string test_id;
    if ( !_arg.process_arguments( argc, argv ) ) return ( EXIT_FAILURE );
    if ( _arg.exist( "test_id" ) ) {
        test_id = _arg.value( "test_id" ).c_str();
    } else {
        return 0;
    }

    cout << THEMIS << endl;

    /* TODO: auto upgrade */

    cout << "Testing " << test_id << endl;

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
    cout << "svn repo = " << _conf.value( "svn", "repo" ) << endl;
#endif
    cout << "Checkint out file from repository..." << endl;
    util::exec(("rm -rf ." + test_id).c_str(), false);
    svn _svn_provide(
        _conf.value( "svn", "repo" ), "." + test_id,
        _conf.exist( "svn", "username" ) ? _conf.value( "svn", "username" )
                                         : "",
        _conf.exist( "svn", "password" ) ? _conf.value( "svn", "password" )
                                         : "" );

    _svn_provide.checkout( test_id );

    svn _svn_official("svn://sailorfuku.moe/", "." + test_id + "/.provide", "", "");
    _svn_official.checkout( "provide" );

    /* check environment */
    config _conf_remote;

    if ( !_conf_remote.read_config( working_path + "/." + test_id +
                                    "/.config" ) ) {
        exit_with_error( "Cannot find config file" );
    }

    /* compile helper */
    cout << "Compiling helper program..." << endl;
#ifdef DEBUG
    cout << _conf_remote.value( "test", "compile" ) << endl;
#endif
    chdir( std::string( "." + test_id ).c_str() );
    util::exec( _conf_remote.value( "test", "compile" ).c_str(), false );

    /* run tests */
    util::exec( _conf_remote.value( "test", "run" ).c_str(), true );
}
