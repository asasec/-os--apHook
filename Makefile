TARGET := iphone:clang:latest:latest
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asasecİap

Asasecİap_FILES = $(wildcard Sources/asasecmod/*.swift) \
                  $(wildcard Sources/asasecmod/**/*.swift) \
                  Sources/load.s

SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)

# SPM modül arama yolları (hem ana build hem de FLEX modülünün olası yolları)
SPM_MODULE_DIR = .build/arm64-apple-ios/release
SPM_DEBUG_MODULE_DIR = .build/arm64-apple-ios/debug

SPM_OBJECTS = $(shell find .build -path "*/*.build/*.o" 2>/dev/null)

Asasecİap_SWIFTFLAGS = -swift-version 5 \
                       -I$(SPM_MODULE_DIR) \
                       -I$(SPM_DEBUG_MODULE_DIR) \
                       -I$(SPM_MODULE_DIR)/Modules \
                       -I$(SPM_DEBUG_MODULE_DIR)/Modules

Asasecİap_CFLAGS = -fobjc-arc

Asasecİap_LDFLAGS = $(SPM_OBJECTS)

include $(THEOS_MAKE_PATH)/tweak.mk

before-all::
	@echo "========================================"
	@echo "Swift / iOS SDK information"
	@echo "========================================"
	@echo "SDK_PATH=$(SDK_PATH)"
	@echo ""

	@if [ -z "$(SDK_PATH)" ]; then \
		echo "ERROR: SDK_PATH is empty."; \
		exit 1; \
	fi

	@if [ ! -d "$(SDK_PATH)" ]; then \
		echo "ERROR: SDK does not exist:"; \
		echo "$(SDK_PATH)"; \
		exit 1; \
	fi

	swift package resolve

	@echo "========================================"
	@echo "Building Swift packages (Jinx & FLEX) - Release Mode"
	@echo "========================================"

	swift build \
		--configuration release \
		--sdk "$(SDK_PATH)" \
		--triple arm64-apple-ios14.0

	@echo "SPM_OBJECTS count: $(words $(SPM_OBJECTS))"

after-install::
	install.exec "killall -9 SpringBoard"
