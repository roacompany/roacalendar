.PHONY: generate build test lint clean

SCHEME = RoaCalendar
TEST_SCHEME = RoaCalendarTests
DESTINATION = platform=iOS Simulator,name=iPhone 17 Pro

generate:
	xcodegen generate

build: generate
	xcodebuild build \
		-scheme $(SCHEME) \
		-destination '$(DESTINATION)' \
		-skipPackagePluginValidation \
		| xcbeautify || true

test: generate
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination '$(DESTINATION)' \
		-enableCodeCoverage YES \
		-skipPackagePluginValidation \
		| xcbeautify || true

lint:
	swiftlint lint --strict

clean:
	xcodebuild clean -scheme $(SCHEME) -destination '$(DESTINATION)' 2>/dev/null || true
	rm -rf DerivedData build
