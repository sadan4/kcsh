AARCH64-CC = aarch64-linux-gnu-g++
X86_64-CC  = x86_64-linux-gnu-g++

OUTPUTDIR = ./build

CCFLAGS = -std=c++20
DEBUG_CCFLAGS = $(CCFLAGS) -g

TARGETS = x86_64 aarch64
DEBUG_TARGETS = x86_64-dbg aarch64-dbg

all: $(TARGETS)
debug: $(DEBUG_TARGETS)

# Build if target compiler exists
$(filter-out all, $(TARGETS)): main.cpp
	@if ! which $($(shell echo $@ | tr '[:lower:]' '[:upper:]')-CC) > /dev/null 2>&1; then \
		echo "Error: Compiler for target $@ not found."; \
		exit 1; \
	fi
	mkdir -p $(OUTPUTDIR)
	$($(shell echo $@ | tr '[:lower:]' '[:upper:]')-CC) -o $(OUTPUTDIR)/kcsh-$@ $(CCFLAGS) main.cpp

# Pattern rule for building debug targets
%-dbg: main.cpp
	@if ! which $($(shell echo $* | tr '[:lower:]' '[:upper:]')-CC) > /dev/null 2>&1; then \
		echo "Error: Compiler for target $@ not found."; \
		exit 1; \
	fi
	mkdir -p $(OUTPUTDIR)
	$($(shell echo $* | tr '[:lower:]' '[:upper:]')-CC) -o $(OUTPUTDIR)/kcsh-$@ $(DEBUG_CCFLAGS) main.cpp

# Clean up intermediate files and executables
clean:
	rm -rf $(OUTPUTDIR)/*

# Declare the "clean" target as a phony target to ensure it always runs
.PHONY: clean
