"""Test metadata extraction functionality."""

from prepare_snapshot_catalog import extract_metadata


def test_extract_metadata():
    """Test cases for metadata extraction from various filename patterns."""

    test_cases = [
        # Simple component name only
        {
            "filename": "Button_0.1.png",
            "expected": {
                "component": "Button",
                "category": "Form",
                "variant": None,
                "state": None,
                "title": "Button",
            }
        },
        # Component with size variant
        {
            "filename": "Button_small_0.1.png",
            "expected": {
                "component": "Button",
                "category": "Form",
                "variant": "small",
                "state": None,
                "title": "Button small",
            }
        },
        # Component with state
        {
            "filename": "Button_hover_0.1.png",
            "expected": {
                "component": "Button",
                "category": "Form",
                "variant": None,
                "state": "hover",
                "title": "Button hover",
            }
        },
        # Component with variant and state
        {
            "filename": "Button_small_hover_0.1.png",
            "expected": {
                "component": "Button",
                "category": "Form",
                "variant": "small",
                "state": "hover",
                "title": "Button small hover",
            }
        },
        # Component with multiple states
        {
            "filename": "InputText_large_error_0.1.png",
            "expected": {
                "component": "InputText",
                "category": "Form",
                "variant": "large",
                "state": "error",
                "title": "InputText large error",
            }
        },
        # Unknown component (should be categorized as Other)
        {
            "filename": "CustomComponent_0.1.png",
            "expected": {
                "component": "CustomComponent",
                "category": "Other",
                "variant": None,
                "state": None,
                "title": "CustomComponent",
            }
        },
    ]

    print("=" * 60)
    print("Testing Metadata Extraction")
    print("=" * 60)

    passed = 0
    failed = 0

    for i, test in enumerate(test_cases, 1):
        filename = test["filename"]
        expected = test["expected"]

        result = extract_metadata(filename)

        print(f"\nTest {i}: {filename}")
        print(f"  Component: {result['component']} (expected: {expected['component']})")
        print(f"  Category:  {result['category']} (expected: {expected['category']})")
        print(f"  Variant:   {result['variant']} (expected: {expected['variant']})")
        print(f"  State:     {result['state']} (expected: {expected['state']})")
        print(f"  Title:     {result['title']} (expected: {expected['title']})")

        # Check if all expected fields match
        success = all(
            result[key] == expected[key]
            for key in expected.keys()
        )

        if success:
            print("  ✓ PASSED")
            passed += 1
        else:
            print("  ✗ FAILED")
            failed += 1

    print("\n" + "=" * 60)
    print(f"Results: {passed} passed, {failed} failed out of {len(test_cases)} tests")
    print("=" * 60)

    return failed == 0


if __name__ == "__main__":
    success = test_extract_metadata()
    exit(0 if success else 1)
