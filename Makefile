gen:
	dart run build_runner build --delete-conflicting-outputs

test:
	flutter test --coverage

fmt:
	dart format .

analyze:
	flutter analyze
