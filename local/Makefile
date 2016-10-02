CXX = clang++
CXXFLAGS = -Wall -Wshadow -std=c++1y -stdlib=libc++
EXENAME = themis
OBJS = themis.o config.o arguments.o util.o
OPTIMIZE = off
LD = clang++
WARNINGS = -pedantic -Wall -Werror -Wfatal-errors -Wextra -Wno-unused-parameter -Wno-unused-variable
LDFLAGS = -std=c++1y -stdlib=libc++ -lpng -lc++abi -lpthread

OBJS_DIR = .objs

ifeq ($(strip $(OPTIMIZE)),on)
CXXFLAGS += -O2 -DOPTIMIZE
else ifeq ($(strip $(OPTIMIZE)),off)
CXXFLAGS += -g -O0
else
$(warning Invalid value specified for OPTIMIZE. Should be on or off)
CXXFLAGS += -g -O0
endif

.PHONY: all
all: themis

$(OBJS_DIR)/%.o: %.cpp | $(OBJS_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(EXENAME): $(OBJS)
	$(LD) $^ $(LDFLAGS) -o $@

svn.o: svn.h svn.cpp svn_libsvn.cpp
ifeq ($(IS_LIBSVN),0)
	$(CXX) $(CXXFLAGS) -I/usr/include/apr-1 -I/usr/include/apr-1.0 -I/usr/include/subversion-1 -Wno-deprecated-declarations -c svn_libsvn.cpp -o $@ || $(CXX) $(CXXFLAGS) -c svn.cpp -o $@
else
	$(CXX) $(CXXFLAGS) -c svn.cpp -o $@
endif

.PHONY: clean
clean:
	rm -f $(wildcard *.o) $(wildcard *.cgo) $(wildcard *.cga) $(EXENAME) $(CCMONAD) $(IDFILE)

