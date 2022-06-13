.PHONY : clean
.PHONY : ipa
.PHONY : apk

run:
	flutter run --release

clean:
	flutter clean

ipa: clean
	flutter build ipa --export-method development
	cp -r build/ios/ipa ~/Desktop/ipa


apk: clean
	flutter build apk
	cp -r build/app/outputs/apk/release ~/Desktop/release
