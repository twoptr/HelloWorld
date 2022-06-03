# Makefile; Hello World
CXXFLAGS := -Wall -Wshadow -Werror -g -ggdb3 -O0

SRC := $(shell find src -iname "*.cc" -type f)
OBJ := tmp/$(subst src/,,$(SRC:.cc=.o))
DEP := $(OBJ:.o=.d)

TRG := bin/hello

LIBS :=

hello: $(TRG)

$(TRG): src/main.cc Makefile

define comp =
	@echo "Compiling: $< -> $@"
	@mkdir -p $(dir $@)
	g++ -c -MP -MMD $(CXXFLAGS) $(INCLUDES) $< -o $@
endef

tmp/%.o: src/%.cc
	$(comp)

define link =
	@echo "Linking: $@ from $^"
	@mkdir -p $(dir $@)
	g++ $(CXXFLAGS) $< $(LIBS) -o $@
endef

# === targets ==========================================================

$(TRG): $(OBJ)
	$(link)


.PHONY: clean
clean:
	@rm -rf tmp
	@rm -rf bin

.PHONY: print
print:
	@echo "SRC: $(SRC)"
	@echo "OBJ: $(OBJ)"
	@echo "DEP: $(DEP)"
	@echo "TRG: $(TRG)"

	@test -s $(TRG) && ldd $(TRG) || true
	@test -s $(TRG) && ls -alh --color $(TRG) || true

-include $(DEP)
