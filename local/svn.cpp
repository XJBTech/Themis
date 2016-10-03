#include "svn.h"

#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

namespace util {

bool svn::init() {
    return true;
};
bool svn::checkout( std::string const& relative_path ) {
    std::string command( "svn checkout " + this->repo + relative_path + " " +
                         this->local );

#ifdef DEBUG
    cout << "[" << __func__ << "] " << command << endl;
#endif

#ifdef DEBUG
    util::exec( command.c_str(), true );
#else
    util::exec( command.c_str(), false );
#endif
    return true;
};
};
