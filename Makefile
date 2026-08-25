TARGET := iphone:clang:latest:latest

ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asasecİap

# ============================================================
# SOURCES
# ============================================================

Asasecİap_FILES = \
	$(wildcard Sources/asasecmod/*.swift) \
	$(wildcard Sources/asasecmod/**/*.swift) \
	Sources/load.s

# ============================================================
# SDK
# ============================================================

SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)

# ============================================================
# SWIFT PACKAGE MANAGER
#
# Swift Package önceden GitHub Actions içinde build ediliyor.
# Burada tekrar swift build yapılmıyor.
# ============================================================

SPM_MODULE_DIR = $(CURDIR)/.build/arm64-apple-ios/release

# ============================================================
# JINX MODULE
# ============================================================

JINX_MODULE_DIR = $(shell \
	find "$(SPM_MODULE_DIR)" \
	-type f \
	-name "Jinx.swiftmodule" \
	-print \
	-quit 2>/dev/null | xargs -r dirname)

# ============================================================
# FLEX MODULEMAP
#
# fleXD package içerisindeki product/target adı FLEX.
# Bu nedenle build klasörü FLEX.build olabilir.
# ============================================================

FLEX_MODULEMAP = $(shell \
	find "$(SPM_MODULE_DIR)" \
	-type f \
	-name "module.modulemap" \
	\( \
		-path "*FLEX*" -o \
		-path "*fleXD*" \
	\) \
	-print \
	-quit 2>/dev/null)

# ============================================================
# FLEX MODULE DIRECTORY
# ============================================================

FLEX_MODULE_DIR = $(shell \
	if [ -n "$(FLEX_MODULEMAP)" ]; then \
		dirname "$(FLEX_MODULEMAP)"; \
	fi)

# ============================================================
# FLEX PUBLIC HEADERS
# ============================================================

FLEX_HEADER_DIR = $(shell \
	find "$(CURDIR)/.build/checkouts/fleXD" \
	-type d \
	-name "Headers" \
	-print \
	-quit 2>/dev/null)

# ============================================================
# RELEASE OBJECTS
#
# FLEX_MODULE_DIR doğrudan module.modulemap'ın bulunduğu
# FLEX.build klasörünü gösterdiği için burada fleXD.build
# hard-code edilmiyor.
# ============================================================

FLEX_OBJECTS = $(shell \
	if [ -n "$(FLEX_MODULE_DIR)" ] && [ -d "$(FLEX_MODULE_DIR)" ]; then \
		find "$(FLEX_MODULE_DIR)" \
		-type f \
		-name "*.o" \
		-print \
		2>/dev/null; \
	fi)

JINX_OBJECTS = $(shell \
	if [ -d "$(SPM_MODULE_DIR)/Jinx.build" ]; then \
		find "$(SPM_MODULE_DIR)/Jinx.build" \
		-type f \
		-name "*.o" \
		-print \
		2>/dev/null; \
	fi)

SPM_OBJECTS = $(FLEX_OBJECTS) $(JINX_OBJECTS)

# ============================================================
# SWIFT FLAGS
# ============================================================

Asasecİap_SWIFTFLAGS = \
	-swift-version 5 \
	-I$(SPM_MODULE_DIR) \
	-I$(JINX_MODULE_DIR) \
	-I$(FLEX_MODULE_DIR) \
	-I$(FLEX_HEADER_DIR)

# ============================================================
# C FLAGS
# ============================================================

Asasecİap_CFLAGS = \
	-fobjc-arc

# ============================================================
# LINKER FLAGS
# ============================================================

Asasecİap_LDFLAGS = \
	$(SPM_OBJECTS)

# ============================================================
# THEOS TWEAK
# ============================================================

include $(THEOS_MAKE_PATH)/tweak.mk

# ============================================================
# BEFORE ALL
# ============================================================

before-all::

	@echo "========================================"
	@echo "Building Theos package"
	@echo "========================================"

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
		echo "Run the Swift Package release build before make."; \
		exit 1; \
	fi

	@echo "SPM_MODULE_DIR=$(SPM_MODULE_DIR)"
	@echo ""

	# ========================================================
	# JINX
	# ========================================================

	@echo "========================================"
	@echo "Jinx Module"
	@echo "========================================"

	@echo "JINX_MODULE_DIR=$(JINX_MODULE_DIR)"
	@echo ""

	@if [ -z "$(JINX_MODULE_DIR)" ]; then \
		echo "ERROR: Jinx.swiftmodule not found."; \
		echo ""; \
		find "$(SPM_MODULE_DIR)" \
			-type f \
			-name "Jinx.swiftmodule" \
			-print 2>/dev/null || true; \
		exit 1; \
	fi

	# ========================================================
	# FLEX
	# ========================================================

	@echo "========================================"
	@echo "FLEX / fleXD Module"
	@echo "========================================"

	@echo "FLEX_MODULEMAP=$(FLEX_MODULEMAP)"
	@echo "FLEX_MODULE_DIR=$(FLEX_MODULE_DIR)"
	@echo "FLEX_HEADER_DIR=$(FLEX_HEADER_DIR)"
	@echo ""

	@if [ -z "$(FLEX_MODULEMAP)" ]; then \
		echo "ERROR: FLEX module.modulemap not found."; \
		echo ""; \
		echo "Searching available module maps:"; \
		find "$(SPM_MODULE_DIR)" \
			-type f \
			-name "module.modulemap" \
			-print 2>/dev/null || true; \
		exit 1; \
	fi

	@if [ -z "$(FLEX_MODULE_DIR)" ]; then \
		echo "ERROR: FLEX module directory could not be determined."; \
		exit 1; \
	fi

	@if [ ! -d "$(FLEX_MODULE_DIR)" ]; then \
		echo "ERROR: FLEX module directory does not exist:"; \
		echo "$(FLEX_MODULE_DIR)"; \
		exit 1; \
	fi

	@if [ -z "$(FLEX_HEADER_DIR)" ]; then \
		echo "WARNING: FLEX Headers directory not found."; \
		echo "Continuing because module.modulemap exists."; \
		echo ""; \
	fi

	# ========================================================
	# OBJECTS
	# ========================================================

	@echo "========================================"
	@echo "Checking Release Object Files"
	@echo "========================================"

	@echo "FLEX_OBJECTS count: $(words $(FLEX_OBJECTS))"
	@echo "JINX_OBJECTS count: $(words $(JINX_OBJECTS))"
	@echo "SPM_OBJECTS count: $(words $(SPM_OBJECTS))"
	@echo ""

	@if [ -z "$(FLEX_OBJECTS)" ]; then \
		echo "ERROR: FLEX release object files not found."; \
		echo ""; \
		echo "Expected directory:"; \
		echo "$(FLEX_MODULE_DIR)"; \
		echo ""; \
		echo "Available files:"; \
		find "$(FLEX_MODULE_DIR)" \
			-type f \
			-print 2>/dev/null | head -100 || true; \
		exit 1; \
	fi

	@if [ -z "$(JINX_OBJECTS)" ]; then \
		echo "ERROR: Jinx release object files not found."; \
		echo ""; \
		echo "Expected directory:"; \
		echo "$(SPM_MODULE_DIR)/Jinx.build"; \
		echo ""; \
		echo "Available Jinx files:"; \
		find "$(SPM_MODULE_DIR)" \
			-path "*Jinx.build*" \
			-type f \
			-print 2>/dev/null | head -100 || true; \
		exit 1; \
	fi

	# ========================================================
	# DEBUG INFORMATION
	# ========================================================

	@echo "========================================"
	@echo "FLEX Object Files"
	@echo "========================================"

	@printf '%s\n' $(FLEX_OBJECTS)

	@echo ""
	@echo "========================================"
	@echo "Jinx Object Files"
	@echo "========================================"

	@printf '%s\n' $(JINX_OBJECTS)

	@echo ""
	@echo "========================================"
	@echo "SPM build already exists."
	@echo "Skipping swift build."
	@echo "========================================"

# ============================================================
# AFTER INSTALL
# ============================================================

after-install::

	install.exec "killall -9 SpringBoard"
