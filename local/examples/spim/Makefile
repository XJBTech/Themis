EXENAME = helper

SHELL = /bin/bash

ROOT_DIR=$(shell pwd)

CXX = clang++
LD = clang++
OBJS = helper.o
OBJS_PROVIDE = config.o util.o svn.o
OBJS_DIR = .objs
OPTIMIZE = off
INCLUDES = -I./includes/ -I$(OBJS_DIR)/ -I.provide/
WARNINGS = -pedantic -Wall -Werror -Wfatal-errors -Wextra -Wno-unused-parameter -Wno-unused-variable
LDFLAGS = $(INCLUDES) -std=c++11 -stdlib=libc++ -stdlib=libstdc++ -lpthread $(WARNINGS) 
CXXFLAGS = $(INCLUDES) -std=c++11 -stdlib=libc++ -stdlib=libstdc++ -MMD -MP $(WARNINGS)
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

.PHONY: all test clean
all: clean $(OBJS_DIR) $(EXENAME)

$(OBJS_DIR)/%.o:%.cpp
	@echo -e " cc\t$<"
	@$(CXX) -c $(CXXFLAGS) $< -o $@

$(OBJS_DIR)/%.o:.provide/%.cpp
	@echo -e " cc\t$<"
	@$(CXX) -c $(CXXFLAGS) $< -o $@

$(EXENAME): $(OBJS_PROVIDE:%.o=$(OBJS_DIR)/%.o) $(OBJS:%.o=$(OBJS_DIR)/%.o)
	@echo -e " ld\t$<"
	@$(LD) $^ $(LDFLAGS) -o $@

clean:
	@rm -f $(wildcard *.d) $(wildcard *.o) $(wildcard *.cgo) $(wildcard *.cga) $(EXENAME) $(CCMONAD) $(IDFILE)
	@rm -rf .objs
