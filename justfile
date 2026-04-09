default:
    @just --list

root := justfile_directory()

# Run Flutter analysis
analyze:
    cd "{{ root }}" && flutter analyze

# Run tests
test:
    cd "{{ root }}" && flutter test

# Clean build artifacts
clean:
    cd "{{ root }}" && flutter clean

# Dry-run publish
publish-dry:
    cd "{{ root }}" && flutter pub publish --dry-run
