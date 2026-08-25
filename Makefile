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
# SPM zaten GitHub Actions'ta build ediliyor.
# Burada tekrar swift build ÇALIŞTIRILMIYOR.
# ============================================================

SPM_MODULE_DIR = $(CURDIR)/.build/arm64-apple-ios/release

# ============================================================
# Jinx Swift Module
# ============================================================

JINX_MODULE_DIR = $(shell find "$(SPM_MODULE_DIR)" \
	-type f \
	-name "Jinx.swiftmodule" \
	-print \
	-quit 2>/dev/null | xargs -r dirname)

# ============================================================
# fleXD Clang Module
# ============================================================

FLEX_MODULEMAP = $(shell find "$(SPM_MODULE_DIR)" \
	-type f \
	-name "module.modulemap" \
	\( -path "*FLEX*" -o -path "*fleXD*" \) \
	-print \
	-quit 2>/dev/null)

FLEX_MODULE_DIR = $(shell \
	if [ -n "$(FLEX_MODULEMAP)" ]; then \
		dirname "$(FLEX_MODULEMAP)"; \
	fi)

# fleXD public headers (checkouts altındaki klasör adı fleXD olabilir)
FLEX_HEADER_DIR = $(shell find "$(CURDIR)/.build/checkouts/fleXD" \
	-type d \
	-name "Headers" \
	-print \
	-quit 2>/dev/null)

# ============================================================
# SPM RELEASE OBJECTS
#
# Sadece Jinx + fleXD release object dosyaları.
#
# DEBUG kullanılmıyor.
# Asasecİap SPM objectleri kullanılmıyor.
# ============================================================

FLEX_OBJECTS = $(shell find "$(SPM_MODULE_DIR)/fleXD.build" \
	-type f \
	-name "*.o" \
	2>/dev/null)

JINX_OBJECTS = $(shell find "$(SPM_MODULE_DIR)/Jinx.build" \
	-type f \
	-name "*.o" \
	2>/dev/null)

SPM_OBJECTS = $(FLEX_OBJECTS) $(JINX_OBJECTS)

# ============================================================
# Swift Flags
# ============================================================

Asasecİap_SWIFTFLAGS = -swift-version 5 \
                       -I$(SPM_MODULE_DIR) \
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
	@echo "Checking existing Swift Package build"
	@echo "========================================"

	@if [ ! -d "$(SPM_MODULE_DIR)" ]; then \
		echo "ERROR: SPM release directory not found:"; \
		echo "$(SPM_MODULE_DIR)"; \
		echo ""; \
		echo "Run the Swift Package build before make."; \
		exit 1; \
	fi

	@echo "SPM_MODULE_DIR=$(SPM_MODULE_DIR)"
	@echo ""

	@echo "========================================"
	@echo "Jinx Module"
	@echo "========================================"

	@echo "JINX_MODULE_DIR=$(JINX_MODULE_DIR)"
	@echo ""

	@if [ -z "$(JINX_MODULE_DIR)" ]; then \
		echo "ERROR: Jinx.swiftmodule not found."; \
		exit 1; \
	fi

	@echo "========================================"
	@echo "fleXD Module"
	@echo "========================================"

	@echo "FLEX_MODULEMAP=$(FLEX_MODULEMAP)"
	@echo "FLEX_MODULE_DIR=$(FLEX_MODULE_DIR)"
	@echo "FLEX_HEADER_DIR=$(FLEX_HEADER_DIR)"
	@echo ""

	@if [ -z "$(FLEX_MODULEMAP)" ]; then \
		echo "ERROR: fleXD module.modulemap not found."; \
		exit 1; \
	fi

	@if [ -z "$(FLEX_HEADER_DIR)" ]; then \
		echo "ERROR: fleXD Headers directory not found."; \
		exit 1; \
	fi

	@echo "========================================"
	@echo "Checking fleXD Objects"
	@echo "========================================"

	@echo "FLEX_OBJECTS count: $(words $(FLEX_OBJECTS))"
	@echo "JINX_OBJECTS count: $(words $(JINX_OBJECTS))"
	@echo "SPM_OBJECTS count: $(words $(SPM_OBJECTS))"
	@echo ""

	@if [ -z "$(FLEX_OBJECTS)" ]; then \
		echo "ERROR: fleXD release object files not found."; \
		exit 1; \
	fi

	@if [ -z "$(JINX_OBJECTS)" ]; then \
		echo "ERROR: Jinx release object files not found."; \
		exit 1; \
	fi

	@echo "========================================"
	@echo "SPM build already exists."
	@echo "Skipping swift build."
	@echo "========================================"

# ============================================================
# After Install
# ============================================================

after-install::
	install.exec "killall -9 SpringBoard"
