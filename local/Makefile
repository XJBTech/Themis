# ▄▄▄▄▄▄▄ ▄    ▄ ▄▄▄▄▄▄ ▄    ▄ ▄▄▄▄▄   ▄▄▄▄
#    █    █    █ █      ██  ██   █    █▀   ▀
#    █    █▄▄▄▄█ █▄▄▄▄▄ █ ██ █   █    ▀█▄▄▄
#    █    █    █ █      █ ▀▀ █   █        ▀█
#    █    █    █ █▄▄▄▄▄ █    █ ▄▄█▄▄  ▀▄▄▄█▀

EXENAME = themis

SHELL = /bin/bash

ROOT_DIR=$(shell pwd)

CXX = clang++
LD = clang++
OBJS = themis.o config.o arguments.o util.o svn.o
OBJS_DIR = .objs
OPTIMIZE = off
INCLUDES = -I./includes/ -I$(OBJS_DIR)/
#VPATH = $(OBJS_DIR)
WARNINGS = -pedantic -Wall -Werror -Wfatal-errors -Wextra -Wno-unused-parameter -Wno-unused-variable
LDFLAGS = $(INCLUDES) -std=c++11 -stdlib=libc++ -lc++abi -lpthread $(WARNINGS) 
CXXFLAGS = $(INCLUDES) -std=c++11 -stdlib=libc++ -MMD -MP $(WARNINGS)
-include $(OBJS_DIR)/*.d

$(OBJS_DIR):
	@mkdir -p $(OBJS_DIR)

ifeq ($(strip $(OPTIMIZE)),on)
CXXFLAGS += -O2 -DOPTIMIZE
else ifeq ($(strip $(OPTIMIZE)),off)
CXXFLAGS += -g -O0
else
$(warning Invalid value specified for OPTIMIZE. Should be on or off)
CXXFLAGS += -g -O0
endif

.PHONY: all
all: release

.PHONY: release debug
release: pre-compile $(EXENAME) echo-done
debug: clean pre-compile $(EXENAME)-debug echo-done
	
pre-compile: echo-compile $(OBJS_DIR) 

echo-compile:
	@echo "compiling..."

echo-done:
	@echo -e "done."

$(OBJS_DIR)/%.o:%.cpp 
	@echo -e " cc\t$<"
	@$(CXX) -c $(CXXFLAGS) $< -o $@

$(OBJS_DIR)/%-debug.o: %.cpp 
	@echo -e " cc\t$<"
	@$(CXX) -c $(CXXFLAGS) -DDEBUG $< -o $@

$(EXENAME): $(OBJS:%.o=$(OBJS_DIR)/%.o)
	@echo -e " ld\t$<"
	@$(LD) $^ $(LDFLAGS) -o $@

$(EXENAME)-debug: $(OBJS:%.o=$(OBJS_DIR)/%-debug.o)
	@echo -e " ld\t$(EXENAME)"
	@$(LD) $^ $(LDFLAGS) -o $@


svn.o: svn.h svn.cpp svn_libsvn.cpp
ifeq ($(IS_LIBSVN),0)
	$(CXX) $(CXXFLAGS) -I/usr/include/apr-1 -I/usr/include/apr-1.0 -I/usr/include/subversion-1 -Wno-deprecated-declarations -c svn_libsvn.cpp -o $@ || $(CXX) $(CXXFLAGS) -c svn.cpp -o $@
else
	$(CXX) $(CXXFLAGS) -c svn.cpp -o $@
endif

.PHONY: clean
clean:
	@rm -f $(wildcard *.d) $(wildcard *.o) $(wildcard *.cgo) $(wildcard *.cga) $(EXENAME) $(CCMONAD) $(IDFILE)
	@rm -rf .objs
