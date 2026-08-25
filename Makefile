TARGET := iphone:clang:latest:latest
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asasecİap

Asasecİap_FILES = $(wildcard Sources/asasecmod/*.swift) \
                  $(wildcard Sources/asasecmod/**/*.swift) \
                  Sources/load.s

SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)

# ============================================================
# Swift Package Manager
# ============================================================

SPM_MODULE_DIR = $(CURDIR)/.build/arm64-apple-ios/release
SPM_DEBUG_MODULE_DIR = $(CURDIR)/.build/arm64-apple-ios/debug

# ============================================================
# Jinx Swift Module
# ============================================================

JINX_MODULE_DIR = $(shell find "$(SPM_MODULE_DIR)" -type f -name "Jinx.swiftmodule" -print -quit 2>/dev/null | xargs -r dirname)

ifeq ($(strip $(JINX_MODULE_DIR)),)
JINX_MODULE_DIR = $(shell find "$(SPM_DEBUG_MODULE_DIR)" -type f -name "Jinx.swiftmodule" -print -quit 2>/dev/null | xargs -r dirname)
endif

# ============================================================
# FLEX Clang Module
# ============================================================

FLEX_MODULEMAP = $(shell find "$(SPM_MODULE_DIR)" -type f -name "module.modulemap" -path "*FLEX*" -print -quit 2>/dev/null)

ifeq ($(strip $(FLEX_MODULEMAP)),)
FLEX_MODULEMAP = $(shell find "$(SPM_DEBUG_MODULE_DIR)" -type f -name "module.modulemap" -path "*FLEX*" -print -quit 2>/dev/null)
endif

FLEX_MODULE_DIR = $(shell if [ -n "$(FLEX_MODULEMAP)" ]; then dirname "$(FLEX_MODULEMAP)"; fi)

# FLEX public headers
FLEX_HEADER_DIR = $(shell find "$(CURDIR)/.build" -type d -path "*FLEX*" -name "Headers" -print -quit 2>/dev/null)

# ============================================================
# SPM Object Files
# ============================================================

SPM_OBJECTS = $(shell find .build -path "*/*.build/*.o" 2>/dev/null)

# ============================================================
# Swift Flags
# ============================================================

Asasecİap_SWIFTFLAGS = -swift-version 5 \
                       -I$(SPM_MODULE_DIR) \
                       -I$(SPM_DEBUG_MODULE_DIR) \
                       -I$(JINX_MODULE_DIR) \
                       -I$(FLEX_MODULE_DIR) \
                       -I$(FLEX_HEADER_DIR)

# ============================================================
# C Flags
# ============================================================

Asasecİap_CFLAGS = -fobjc-arc

# ============================================================
# Linker Flags
# ============================================================

Asasecİap_LDFLAGS = $(SPM_OBJECTS)

# ============================================================
# Theos
# ============================================================

include $(THEOS_MAKE_PATH)/tweak.mk

# ============================================================
# Before Build
# ============================================================

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

	@echo "========================================"
	@echo "Resolving Swift Package Manager"
	@echo "========================================"

	swift package resolve

	@echo "========================================"
	@echo "Building Swift packages (Jinx & FLEX)"
	@echo "========================================"

	swift build \
		--configuration release \
		--sdk "$(SDK_PATH)" \
		--triple arm64-apple-ios14.0

	@echo "========================================"
	@echo "SPM Module Information"
	@echo "========================================"

	@echo "JINX_MODULE_DIR=$(JINX_MODULE_DIR)"
	@echo "FLEX_MODULEMAP=$(FLEX_MODULEMAP)"
	@echo "FLEX_MODULE_DIR=$(FLEX_MODULE_DIR)"
	@echo "FLEX_HEADER_DIR=$(FLEX_HEADER_DIR)"
	@echo ""

	@echo "========================================"
	@echo "Searching FLEX module maps"
	@echo "========================================"

	@find .build -type f -name "module.modulemap" -print 2>/dev/null || true

	@echo ""
	@echo "========================================"
	@echo "Searching FLEX headers"
	@echo "========================================"

	@find .build -type f \( -name "FLEXManager.h" -o -name "FLEX.h" \) -print 2>/dev/null || true

	@echo ""
	@echo "SPM_OBJECTS count: $(words $(SPM_OBJECTS))"

# ============================================================
# After Install
# ============================================================

after-install::
	install.exec "killall -9 SpringBoard"
