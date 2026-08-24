TARGET := iphone:clang:latest:latest
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Asasecİap

# Sadece senin tweak dosyaların ve load.s (FLEX dosyalarını elle eklemiyoruz!)
Asasecİap_FILES = $(wildcard Sources/asasecmod/*.swift) \
                  $(wildcard Sources/asasecmod/**/*.swift) \
                  Sources/load.s

SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)

# Jinx ve FLEX modül yollarını buluyoruz
SPM_JINX_DIR = $(shell find .build -name "Jinx.swiftmodule" 2>/dev/null | head -n 1 | xargs dirname)
SPM_FLEX_DIR = $(shell find .build -name "FLEX.swiftmodule" 2>/dev/null | head -n 1 | xargs dirname)

# Derlenen tüm SPM nesne dosyalarını (.o) topluyoruz
SPM_OBJECTS = $(shell find .build -path "*/*.build/*.o" 2>/dev/null)

Asasecİap_SWIFTFLAGS = \
	-swift-version 5 \
	-I$(SPM_JINX_DIR) \
	-I$(SPM_FLEX_DIR) \
	-sdk $(SDK_PATH) \
	-target arm64-apple-ios14.0 

Asasecİap_CFLAGS = -fobjc-arc

# Jinx ve FLEX nesne dosyalarını doğrudan bağlayıcıya aktarıyoruz
Asasecİap_LDFLAGS = $(SPM_OBJECTS)

include $(THEOS_MAKE_PATH)/tweak.mk

before-all::
	@echo "========================================"
	@echo "Swift / iOS SDK information"
	@echo "========================================"
	@echo "SDK_PATH=$(SDK_PATH)"
	@echo ""

	swift package resolve

	@echo "========================================"
	@echo "Building Swift packages (Jinx & FLEX)"
	@echo "========================================"

	swift build \
		--sdk "$(SDK_PATH)" \
		--triple arm64-apple-ios14.0

	@echo "SPM_OBJECTS count: $(words $(SPM_OBJECTS))"

after-install::
	install.exec "killall -9 SpringBoard"
