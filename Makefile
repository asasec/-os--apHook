TARGET := iphone:clang:latest:latest
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asasecİap

# Sources/asasecmod altındaki tüm Swift dosyaları ve load.s derlemeye dahil edildi
Asasecİap_FILES = $(wildcard Sources/asasecmod/*.swift) \
                  $(wildcard Sources/asasecmod/**/*.swift) \
                  Sources/load.s

SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)

# Doğru modül klasörünü nokta atışı belirtiyoruz
SPM_FINAL_MODULE_DIR = .build/arm64-apple-ios/debug/Modules

# Derlenen tüm SPM nesne dosyalarını (.o) tek seferde topluyoruz
SPM_OBJECTS = $(shell find .build -path "*/*.build/*.o" 2>/dev/null)

Asasecİap_SWIFTFLAGS = -swift-version 5 -I$(SPM_FINAL_MODULE_DIR)

Asasecİap_CFLAGS = -fobjc-arc

# SPM nesne dosyalarını doğrudan bağlayıcıya (linker) aktarıyoruz
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

	@if [ ! -d "$(SDK_PATH)/System/Library/Frameworks/UIKit.framework" ]; then \
		echo "ERROR: UIKit.framework not found."; \
		exit 1; \
	fi

	@echo "UIKit.framework found."
	@echo ""

	swift package resolve

	@echo "========================================"
	@echo "Building Swift packages (Jinx & FLEX)"
	@echo "========================================"

	swift build \
		--sdk "$(SDK_PATH)" \
		--triple arm64-apple-ios14.0

	@echo "SPM_FINAL_MODULE_DIR: $(SPM_FINAL_MODULE_DIR)"
	@echo "SPM_OBJECTS count: $(words $(SPM_OBJECTS))"

after-install::
	install.exec "killall -9 SpringBoard"
