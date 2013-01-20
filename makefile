# really just some handy scripts...

.PHONY: all
all:
	xcodebuild -configuration Debug
	xcodebuild -configuration Release

.PHONY: clean
clean:
	xcodebuild -configuration Debug clean
	xcodebuild -configuration Release clean

.PHONY: update_kernelcache
update_kernelcache:
	sudo touch /System/Library/Extensions
	sudo kextcache --system-prelinked-kernel -arch x86_64

.PHONY: install_debug
install_debug:
	sudo cp -R ./Build/Products/Debug/AppleSmartBatteryManager.kext /System/Library/Extensions
	make update_kernelcache

.PHONY: install
install:
	sudo cp -R ./Build/Products/Release/AppleSmartBatteryManager.kext /System/Library/Extensions
	make update_kernelcache

.PHONY: distribute
distribute:
	if [ -e ./Distribute ]; then rm -r ./Distribute; fi
	mkdir ./Distribute
	cp -R ./Build/Products/ ./Distribute
	find ./Distribute -path *.DS_Store -delete
	find ./Distribute -path *.dSYM -exec echo rm -r {} \; >/tmp/org.voodoo.rm.dsym.sh
	chmod +x /tmp/org.voodoo.rm.dsym.sh
	/tmp/org.voodoo.rm.dsym.sh
	rm /tmp/org.voodoo.rm.dsym.sh
