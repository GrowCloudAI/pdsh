#!/bin/bash
# QA Test Script for README.md Changes
# Tests: Markdown syntax, links, formatting, rendering

set -e

README_FILE="README.md"
FAIL_COUNT=0
PASS_COUNT=0
TEST_COUNT=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== QA TEST EXECUTION ==="
echo "Testing: $README_FILE"
echo "Date: $(date)"
echo ""

# Helper functions
pass() {
    ((PASS_COUNT++))
    ((TEST_COUNT++))
    echo -e "${GREEN}✓ PASS${NC}: $1"
}

fail() {
    ((FAIL_COUNT++))
    ((TEST_COUNT++))
    echo -e "${RED}✗ FAIL${NC}: $1"
    echo -e "  ${YELLOW}Details: $2${NC}"
}

test_header() {
    echo ""
    echo "--- $1 ---"
}

# Test 1: File exists and is readable
test_header "Test 1: File Existence"
if [ -f "$README_FILE" ] && [ -r "$README_FILE" ]; then
    pass "README.md exists and is readable"
else
    fail "README.md not found or not readable" "File must exist at $README_FILE"
    exit 1
fi

# Test 2: Markdown syntax validation (using markdown-lint if available, otherwise basic checks)
test_header "Test 2: Basic Markdown Syntax"
if ! grep -q $'^\t' "$README_FILE"; then
    pass "No literal tabs found (markdown prefers spaces)"
else
    fail "Literal tabs found in markdown" "Use spaces instead of tabs for consistency"
fi

# Test 3: Check for balanced HTML tags
test_header "Test 3: HTML Tag Balance"
html_tags=(div table tr td th h3 p em strong code)
all_balanced=true
for tag in "${html_tags[@]}"; do
    open_count=$(grep -o "<$tag" "$README_FILE" | wc -l)
    close_count=$(grep -o "</$tag>" "$README_FILE" | wc -l)
    if [ "$open_count" -ne "$close_count" ]; then
        fail "Unbalanced <$tag> tags" "Found $open_count opening, $close_count closing"
        all_balanced=false
    fi
done
if $all_balanced; then
    pass "All HTML tags are balanced"
fi

# Test 4: Check for broken internal links
test_header "Test 4: Internal Link Validation"
broken_links=()

# Extract markdown links like [text](path)
while IFS= read -r link; do
    # Skip external URLs
    if [[ "$link" =~ ^https?:// ]] || [[ "$link" =~ ^mailto: ]]; then
        continue
    fi

    # Skip anchor-only links
    if [[ "$link" =~ ^#.* ]]; then
        continue
    fi

    # Check if file exists
    if [ ! -f "$link" ] && [ ! -d "$link" ]; then
        broken_links+=("$link")
    fi
done < <(grep -oP '\]\(\K[^)]+' "$README_FILE" | sort -u)

if [ ${#broken_links[@]} -eq 0 ]; then
    pass "All internal file/directory links are valid"
else
    fail "Found broken internal links" "Missing: ${broken_links[*]}"
fi

# Test 5: Check for malformed code blocks
test_header "Test 5: Code Block Formatting"
# Count opening and closing triple backticks
backtick_count=$(grep -c '^```' "$README_FILE" || true)
if [ $((backtick_count % 2)) -eq 0 ]; then
    pass "Code blocks properly opened and closed (found $backtick_count fence markers)"
else
    fail "Unbalanced code blocks" "Found $backtick_count fence markers (should be even)"
fi

# Test 6: Unicode box drawing characters (visual appeal test)
test_header "Test 6: Unicode Box Drawing Characters"
if grep -q '[┌┐└┘├┤┬┴┼─│┏┓┗┛┣┫┳┻╋━┃]' "$README_FILE"; then
    pass "Unicode box drawing characters present (enhanced visual appeal)"
else
    fail "No Unicode box drawing found" "Expected decorative boxes in cool README"
fi

# Test 7: Emoji usage
test_header "Test 7: Emoji Usage"
emoji_count=$(grep -oP '[\x{1F300}-\x{1F9FF}]|[🚀⚡✨🎯📖💡🔧📊🔍🎮⏱️🔐🌐📝🏢⚠️🔌📄✅❌🖥️🔄🎹👨‍💻🐛💌📜⚖️🔗⭐❤️]' "$README_FILE" | wc -l || echo 0)
if [ "$emoji_count" -gt 0 ] && [ "$emoji_count" -lt 200 ]; then
    pass "Good emoji usage ($emoji_count emojis - enhances visual appeal)"
elif [ "$emoji_count" -ge 200 ]; then
    fail "Excessive emoji usage ($emoji_count emojis)" "May hurt readability and accessibility"
else
    fail "No emojis found" "Task was to make README 'cooler' - emojis add visual interest"
fi

# Test 8: Check for proper heading hierarchy
test_header "Test 8: Heading Hierarchy"
# Check that headings start with # and have space after
invalid_headings=$(grep -n '^#' "$README_FILE" | grep -v '^[0-9]*:#+\s' || true)
if [ -z "$invalid_headings" ]; then
    pass "All headings properly formatted with space after #"
else
    fail "Malformed headings found" "$invalid_headings"
fi

# Test 9: Table formatting
test_header "Test 9: Table Structure"
# Check for pipes in tables
if grep -q '|' "$README_FILE"; then
    pass "Tables present with pipe delimiters"

    # Check for table header separators
    if grep -qE '^\|?[-:| ]+\|?$' "$README_FILE"; then
        pass "Table header separators found"
    else
        fail "Tables missing header separators" "Tables need |---|---| style separators"
    fi
else
    fail "No tables found" "Expected configuration tables in README"
fi

# Test 10: Badge/Shield formatting
test_header "Test 10: Badges/Shields"
if grep -q 'img.shields.io\|badge' "$README_FILE"; then
    pass "Badges/shields present for visual appeal"
else
    fail "No badges found" "Badges enhance modern README appearance"
fi

# Test 11: File size check (too large can cause GitHub rendering issues)
test_header "Test 11: File Size"
file_size=$(wc -c < "$README_FILE")
if [ "$file_size" -lt 1000000 ]; then  # 1MB limit
    pass "File size reasonable (${file_size} bytes)"
else
    fail "README too large (${file_size} bytes)" "May cause rendering issues on GitHub"
fi

# Test 12: Check for empty code blocks
test_header "Test 12: Empty Code Blocks"
empty_blocks=$(awk '/^```/,/^```/ {if (NR>1 && /^```$/ && prev ~ /^```/) print "Empty block at line " NR-1} {prev=$0}' "$README_FILE")
if [ -z "$empty_blocks" ]; then
    pass "No empty code blocks found"
else
    fail "Empty code blocks detected" "$empty_blocks"
fi

# Test 13: Content preservation check (critical sections exist)
test_header "Test 13: Content Preservation"
critical_content=("pdsh" "configure" "make install" "GNU" "GPL" "Jim Garlick")
all_present=true
for content in "${critical_content[@]}"; do
    if ! grep -qi "$content" "$README_FILE"; then
        fail "Critical content missing: $content" "Original content may have been removed"
        all_present=false
    fi
done
if $all_present; then
    pass "All critical content preserved from original"
fi

# Test 14: Rendering test (convert to HTML and check for errors)
test_header "Test 14: Markdown Rendering"
if command -v pandoc &> /dev/null; then
    if pandoc "$README_FILE" -o /tmp/readme_test.html 2>/tmp/pandoc_errors.txt; then
        if [ -s /tmp/pandoc_errors.txt ]; then
            fail "Pandoc rendering warnings" "$(cat /tmp/pandoc_errors.txt)"
        else
            pass "Markdown renders to HTML without errors (pandoc)"
        fi
    else
        fail "Pandoc conversion failed" "Markdown may have syntax errors"
    fi
else
    pass "Pandoc not available - skipping HTML rendering test"
fi

# Test 15: Line length check (extreme lines can break rendering)
test_header "Test 15: Line Length"
long_lines=$(awk 'length > 500 {print NR ": " length " chars"}' "$README_FILE")
if [ -z "$long_lines" ]; then
    pass "No extremely long lines (>500 chars)"
else
    fail "Extremely long lines found" "$long_lines"
fi

# Test 16: Check for improved visual sections
test_header "Test 16: Visual Enhancement Features"
visual_features=0

# Check for centered content
grep -q '<div align="center">' "$README_FILE" && ((visual_features++))

# Check for decorative separators
grep -q '---' "$README_FILE" && ((visual_features++))

# Check for styled lists
grep -qE '^\s*[-*+]\s+[✅❌]' "$README_FILE" && ((visual_features++))

# Check for collapsible sections
grep -q '<details>' "$README_FILE" && ((visual_features++))

if [ "$visual_features" -ge 3 ]; then
    pass "Multiple visual enhancement features detected ($visual_features/4)"
else
    fail "Insufficient visual enhancements" "Only $visual_features/4 features found"
fi

# Test 17: Accessibility check - alt text for images
test_header "Test 17: Image Alt Text"
images_without_alt=$(grep -oP '!\[\]\(' "$README_FILE" | wc -l || echo 0)
if [ "$images_without_alt" -eq 0 ]; then
    pass "All images have alt text (accessibility)"
else
    fail "Images missing alt text" "Found $images_without_alt images with empty []"
fi

# Test 18: Check for horizontal rules balance
test_header "Test 18: Visual Balance"
hr_count=$(grep -c '^---$' "$README_FILE" || true)
if [ "$hr_count" -ge 5 ]; then
    pass "Good use of horizontal rules for section separation ($hr_count found)"
else
    fail "Insufficient section separation" "Only $hr_count horizontal rules found"
fi

# Test 19: Special characters encoding
test_header "Test 19: Character Encoding"
if file "$README_FILE" | grep -q "UTF-8"; then
    pass "File is UTF-8 encoded (supports Unicode decorations)"
else
    fail "File encoding not UTF-8" "May cause issues with special characters"
fi

# Test 20: Quick Start section prominence
test_header "Test 20: Quick Start Visibility"
quick_start_line=$(grep -n "Quick Start\|🎯" "$README_FILE" | head -1 | cut -d: -f1)
if [ -n "$quick_start_line" ] && [ "$quick_start_line" -lt 100 ]; then
    pass "Quick Start section appears early (line $quick_start_line)"
else
    fail "Quick Start not prominent" "Should appear in first 100 lines"
fi

echo ""
echo "=== QA TEST SUMMARY ==="
echo "Total Tests: $TEST_COUNT"
echo -e "${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "${RED}Failed: $FAIL_COUNT${NC}"
echo ""

# Final verdict
if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                       ║${NC}"
    echo -e "${GREEN}║  ✅  VERDICT: PASS - Ship it! 🚀     ║${NC}"
    echo -e "${GREEN}║                                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
    echo ""
    echo "README.md improvements are APPROVED."
    echo "Visual enhancements successfully implemented!"
    exit 0
elif [ $FAIL_COUNT -le 3 ] && [ $PASS_COUNT -ge 15 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                       ║${NC}"
    echo -e "${YELLOW}║  ⚠️  VERDICT: CONDITIONAL PASS       ║${NC}"
    echo -e "${YELLOW}║                                       ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════╝${NC}"
    echo ""
    echo "Minor issues detected but overall quality is good."
    echo "Consider addressing failures for production use."
    exit 0
else
    echo -e "${RED}╔═══════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                       ║${NC}"
    echo -e "${RED}║  ❌  VERDICT: FAIL - Needs work 🔧   ║${NC}"
    echo -e "${RED}║                                       ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════╝${NC}"
    echo ""
    echo "Significant issues found. README requires fixes."
    exit 1
fi
