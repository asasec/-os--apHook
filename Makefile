TARGET := iphone:clang:latest:latest
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asasecİap

# Sources/asasecmod altındaki tüm Swift dosyaları, KittyMemory C++ dosyaları ve load.s derlemeye dahil edildi
Asasecİap_FILES = $(wildcard Sources/asasecmod/*.swift) \
                      $(wildcard Sources/asasecmod/**/*.swift) \
                      Sources/asasecmod/KittyMemory/MemoryPatchManager.mm \
                      Sources/asasecmod/KittyMemory/KittyMemory.cpp \
                      Sources/asasecmod/KittyMemory/MemoryModifier.cpp \
                      Sources/load.s

SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)
SPM_MODULE_DIR = $(shell find .build -name "Jinx.swiftmodule" 2>/dev/null | head -n 1 | xargs dirname)

# Jinx.build altında derlenen tüm nesne dosyalarını (.o) tek seferde topluyoruz
JINX_OBJECTS = $(shell find .build -path "*/Jinx.build/*.o" 2>/dev/null)

Asasecİap_SWIFTFLAGS = \
	-swift-version 5 \
	-I$(SPM_MODULE_DIR) \
	-sdk $(SDK_PATH) \
	-target arm64-apple-ios14.0

Asasecİap_CFLAGS = -fobjc-arc -I$(THEOS_PROJECT_DIR)/Sources/asasecmod/KittyMemory

# Jinx nesne dosyalarını doğrudan bağlayıcıya (linker) aktarıyoruz
Asasecİap_LDFLAGS = $(JINX_OBJECTS)

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

	@if [ ! -d "$(SDK_PATH)/System/Library/Frameworks/UIKit.framework" ]; then \
		echo "ERROR: UIKit.framework not found."; \
		exit 1; \
	fi

	@echo "UIKit.framework found."
	@echo ""

	swift package resolve

	@echo "========================================"
	@echo "Building Jinx dependency"
	@echo "========================================"

	swift build \
		--sdk "$(SDK_PATH)" \
		--triple arm64-apple-ios14.0

	@echo "JINX_OBJECTS count: $(words $(JINX_OBJECTS))"

after-install::
	install.exec "killall -9 SpringBoard"
