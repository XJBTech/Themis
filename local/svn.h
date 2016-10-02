#ifndef __SVN_H__
#define __SVN_H__

#include "util.h"

#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

namespace util {

class svn {
   private:
    std::string repo, local, username, password;

   public:
    svn(){};
    svn( std::string repo, std::string local, std::string username = "",
         std::string password = "" )
        : repo( repo ),
          local( local ),
          username( username ),
          password( password ){};
    ~svn(){};
    bool init();
    bool checkout( std::string const& relative_path );
};
};

#endif
