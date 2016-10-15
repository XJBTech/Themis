#include "helper.h"

#include <iostream>
#include <string>

bool print_result ( pair<std::string, float> test_result )
{
    if ( test_result.first.size() != 0 )
    {
        std::cout << util::failed_string() << endl << test_result.first << std::endl;
        return false;
    }
    else
    {
        std::cout << util::passed_string() << std::endl << std::endl;
    }

    return true;
}

int main()
{

    /* error handler */
    std::set_terminate ( error_handler );

    /* getting workpath */
    std::string working_path = get_working_path();

    /* reading config file */
    config      _conf;
    std::string config_file = working_path + "/";

    if ( !_conf.read_config ( config_file ) )
    {
        exit_with_error ( "Cannot find config file" );
    }

    std::string test_id = _conf.value ( "test", "id" );

    /* get netid */
    chdir ( ".." );
    std::string result = util::exec ( "svn info", false );

    if ( result.find ( "Path: ." ) == string::npos ||
            result.find ( "subversion.ews.illinois.edu/svn/fa16-cs233" ) ==
            string::npos )
    {
        exit_with_error ( "Please run themis in cs225 svn repo." );
    }

    /* pull test file from server */
    cout << "Updating repository..." << endl;
    util::exec ( "svn update", true );

    cout << endl << "Copying files..." << endl;

    std::string         cp_u_src ( get_working_path() + "/" + test_id + "/" );
    std::string         cp_u_des ( get_working_path() + "/." + test_id + "/.compile/" );
    vector<std::string> cp_u_file_list = {"is_complete.s",
                                          "get_unassigned_position.s",
                                          "forward_checking.s",
                                          "recursive_backtracking.s"
                                         };

    util::copy_files ( cp_u_src, cp_u_des, cp_u_file_list, true );

    std::string         cp_p_src ( get_working_path() + "/." + test_id + "/" );
    std::string         cp_p_des ( get_working_path() + "/." + test_id + "/.compile/" );
    vector<std::string> cp_p_file_list = {"common.s",
                                        "helper_functions_evil.s",
                                        "helper_functions.s",
                                        "is_complete_provided.s",
                                        "is_complete_provided_evil.s",
                                        "get_unassigned_position_provided.s",
                                        "get_unassigned_position_provided_evil.s"};

    vector<pair<std::string, std::string>> test_list = {
                                                            make_pair("is_complete_main", "make 1.1"),
                                                            make_pair("get_unassigned_position_main", "make 1.2"),
                                                            make_pair("forward_checking_main", "make 2.1"),
                                                            make_pair("test_one_by_one", "make 2.2"),
                                                            make_pair("test_invalid_one_by_one", "make 2.2"),
                                                            make_pair("test_four_by_four", "make 2.2"),
                                                            make_pair("test_four_by_four_case_02", "make 2.2"),
                                                            make_pair("test_invalid_four_by_four", "make 2.2"),
                                                            make_pair("test_five_by_five", "make 2.2"),
                                                            make_pair("test_six_by_six", "make 2.2"),
                                                            make_pair("test_eight_by_eight", "make 2.2"),
                                                            make_pair("test_invalid_eight_by_eight", "make 2.2"),
                                                       };
    vector<pair<std::string, std::string>>::iterator it;


    for ( it = test_list.begin() ; it < test_list.end(); it++ )
    {
        cp_p_file_list.push_back ( "unit_tests/" + it->first + ".s" );
        cp_p_file_list.push_back ( "unit_tests/" + it->first + "_evil.s" );
        cp_p_file_list.push_back ( "unit_tests/" + it->first + ".o" );
    }

    util::copy_files ( cp_p_src, cp_p_des, cp_p_file_list, true );

    chdir ( ( "." + test_id ).c_str() );
    util::exec ( "cp Makefile_unit_tests .compile/Makefile", false );
    chdir ( ".compile" );

    sleep ( 1 );

    std::cout << std::endl << "Testing..." << std::endl << std::endl;

    int count = 0;

    for ( it = test_list.begin() ; it < test_list.end(); it++ )
    {
        std::cout << "simulating " << it->first << "..." << std::endl;
        util::exec ( ( "mv unit_tests/" + it->first + ".s case.s && " + it->second ).c_str(), false );
        usleep ( 10000 );
        count += print_result ( util::exec_timer ( ( "diff -u --ignore-all-space output unit_tests/" + it->first + ".o" ).c_str(), false ) ) ? 1 : 0;
        usleep ( 10000 );

        std::cout << "simulating " << it->first << "(evil)..." << std::endl;
        util::exec ( ( "mv unit_tests/" + it->first + "_evil.s case.s && " + it->second + ".evil" ).c_str(), false );
        usleep ( 10000 );
        count += print_result ( util::exec_timer ( ( "diff -u --ignore-all-space output unit_tests/" + it->first + ".o" ).c_str(), false ) ) ? 1 : 0;
        usleep ( 10000 );
    }

    chdir ( ".." );
    util::exec ( "rm -rf .compile .provide .objs", false );
    util::exec ( "rm -rf *", false );
    chdir ( ".." );

    std::cout << colorize::make_color (
                  colorize::GREEN, "Passed " + std::to_string ( count ) + " / " + std::to_string ( test_list.size()*2 )
              ) << endl;

}
