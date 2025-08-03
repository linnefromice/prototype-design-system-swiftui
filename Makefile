# Makefile for ProtoDesignSystem

# Variables
PROJECT_NAME := ProtoDesignSystem
SOURCE_DIR := $(PROJECT_NAME)/Sources
TEST_DIR := $(PROJECT_NAME)Tests
UI_TEST_DIR := $(PROJECT_NAME)UITests

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make format         - Format all Swift files"
	@echo "  make format-check   - Check if files are formatted correctly"
	@echo "  make lint           - Run swift-format in lint mode"
	@echo "  make build          - Build the project"
	@echo "  make test           - Run tests"
	@echo "  make clean          - Clean build artifacts"


# Format all Swift files
.PHONY: format
format:
	@echo "Formatting Swift files..."
	@find $(PROJECT_NAME) -name "*.swift" -type f | xargs swift format -i

# Check formatting without modifying files
.PHONY: format-check
format-check:
	@echo "Checking Swift formatting..."
	@find $(PROJECT_NAME) -name "*.swift" -type f | xargs swift format --parallel > /dev/null
	@echo "All files are properly formatted!"

# Lint Swift files
.PHONY: lint
lint:
	@echo "Linting Swift files..."
	@find $(PROJECT_NAME) -name "*.swift" -type f | xargs swift format --parallel > /dev/null

# Build the project
.PHONY: build
build:
	@echo "Building $(PROJECT_NAME)..."
	@xcodebuild -scheme $(PROJECT_NAME) -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	@xcodebuild -scheme $(PROJECT_NAME) -destination 'platform=iOS Simulator,name=iPhone 15' test

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@xcodebuild -scheme $(PROJECT_NAME) clean
	@rm -rf DerivedData/

# Format and check in one command (useful for pre-commit)
.PHONY: pre-commit
pre-commit: format lint
	@echo "Pre-commit checks completed!"

# Watch for changes and format automatically (requires fswatch)
.PHONY: watch
watch:
	@echo "Watching for Swift file changes..."
	@if ! command -v fswatch &> /dev/null; then \
		echo "Error: fswatch is not installed. Run 'brew install fswatch' first."; \
		exit 1; \
	fi
	@fswatch -o $(PROJECT_NAME) -e ".*" -i "\\.swift$$" | xargs -n1 -I{} make format