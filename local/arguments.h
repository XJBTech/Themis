#ifndef __ARGUMENTS_H__
#define __ARGUMENTS_H__

#include "util.h"
#include "optionparser.h"

namespace util {

class arguments {

public:
bool process_arguments( int & argc, char** & argv ) const;

};

};

#endif
