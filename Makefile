CXX       := g++
CXXFLAGS  := -std=c++20 -Wall -Wextra -Wpedantic -O2
BUILD_DIR := build
TARGET    := $(BUILD_DIR)/ugrc
SRC       := src/main.cpp
OBJ       := $(BUILD_DIR)/main.o

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(OBJ): $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(TARGET)
	@if [ -z "$(INPUT)" ]; then \
		echo "Usage: make run INPUT=test/arithmetic.c"; \
		exit 1; \
	fi
	./$(TARGET) "$(INPUT)"

clean:
	rm -rf $(BUILD_DIR) artifacts