# 🤝 Contributing to PDSH

Thank you for your interest in contributing to **PDSH** - the Parallel Distributed Shell! We welcome contributions from the community and appreciate your help in making PDSH better.

---

## 📋 Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [Getting Started](#-getting-started)
- [Development Workflow](#-development-workflow)
- [Pull Request Process](#-pull-request-process)
- [Coding Standards](#-coding-standards)
- [Testing Guidelines](#-testing-guidelines)
- [Commit Message Guidelines](#-commit-message-guidelines)
- [Documentation](#-documentation)
- [Community](#-community)

---

## 🌟 Code of Conduct

We are committed to providing a welcoming and inclusive experience for everyone. Please be respectful and constructive in all interactions.

### Our Standards

- ✅ Be respectful and inclusive
- ✅ Welcome newcomers and help them learn
- ✅ Focus on what is best for the community
- ✅ Show empathy towards other community members
- ❌ No harassment, trolling, or discriminatory behavior
- ❌ No spam or off-topic discussions

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **GCC** or compatible C compiler
- **GNU autoconf** and **automake**
- **Make**
- **Git**

### Fork & Clone

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:

```bash
git clone https://github.com/YOUR-USERNAME/pdsh.git
cd pdsh
```

3. **Add upstream** remote:

```bash
git remote add upstream https://github.com/original-org/pdsh.git
```

### Build from Source

```bash
# Bootstrap the build system
./bootstrap

# Configure with your desired options
./configure --with-ssh --with-readline

# Build
make

# Run tests (optional)
make check

# Install locally for testing (optional)
make install
```

---

## 💻 Development Workflow

### 1. Create a Feature Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- Write clear, maintainable code
- Follow the existing code style
- Add comments for complex logic
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run the test suite
make check

# Test manually with your changes
./pdsh -w host1,host2 uptime
```

### 4. Keep Your Branch Updated

Regularly sync with upstream:

```bash
git fetch upstream
git rebase upstream/master
```

---

## 🔄 Pull Request Process

### Before Submitting

- [ ] Your code builds without errors or warnings
- [ ] All tests pass (`make check`)
- [ ] You've tested your changes manually
- [ ] Documentation is updated (if applicable)
- [ ] Commit messages follow our guidelines
- [ ] Your branch is up-to-date with master

### Submitting Your PR

1. **Push** your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a Pull Request** on GitHub with:
   - Clear title describing the change
   - Detailed description of what and why
   - Reference any related issues (`Fixes #123`)
   - Screenshots/examples if applicable

3. **Respond to feedback** promptly and professionally

### PR Review Process

- 🔍 **Code review** by maintainers
- 🧪 **Automated testing** via CI/CD
- 💬 **Discussion** and potential revisions
- ✅ **Approval** and merge

---

## 📝 Coding Standards

### C Code Style

PDSH follows traditional **K&R style** C coding conventions:

#### Indentation & Formatting

```c
/* Use 4-space indentation (no tabs) */
if (condition) {
    do_something();
    do_another_thing();
}

/* Braces on same line for control structures */
for (i = 0; i < count; i++) {
    process_item(i);
}

/* Function braces on new line */
int my_function(int arg)
{
    return arg * 2;
}
```

#### Naming Conventions

- **Functions**: `lowercase_with_underscores()`
- **Variables**: `lowercase_with_underscores`
- **Constants**: `UPPERCASE_WITH_UNDERSCORES`
- **Structs/Types**: `lowercase_with_underscores_t`

#### Best Practices

- ✅ Use meaningful variable names
- ✅ Keep functions focused and small
- ✅ Check return values and handle errors
- ✅ Free allocated memory (no leaks!)
- ✅ Use `const` where appropriate
- ✅ Comment non-obvious code
- ❌ No magic numbers (use named constants)
- ❌ Avoid global variables when possible

### Example

```c
/* Good: Clear, well-structured code */
static int
connect_to_host(const char *hostname, int timeout)
{
    int sockfd;
    struct sockaddr_in addr;

    if (!hostname) {
        fprintf(stderr, "Invalid hostname\n");
        return -1;
    }

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        return -1;
    }

    /* Continue with connection logic... */
    return sockfd;
}
```

---

## 🧪 Testing Guidelines

### Running Tests

```bash
# Run all tests
make check

# Run specific test
./tests/t0006-pdcp.sh

# Verbose test output
make check VERBOSE=1
```

### Writing Tests

When adding new features, please include tests:

1. **Create test script** in `tests/` directory
2. **Follow naming convention**: `tNNNN-description.sh`
3. **Use TAP format** (Test Anything Protocol)
4. **Test both success and failure cases**

#### Test Template

```bash
#!/bin/bash
# Test description

test_description='Brief description of what this tests'

. $(dirname $0)/sharness.sh

test_expect_success 'test case description' '
    pdsh -w host1 echo "test" > output &&
    grep "test" output
'

test_done
```

---

## 💬 Commit Message Guidelines

### Format

```
type: Brief summary (50 chars or less)

Detailed explanation of what changed and why (wrap at 72 chars).
Reference any related issues.

Fixes #123
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style/formatting (no functional changes)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, dependency updates

### Examples

```
feat: add support for ProxyJump in SSH module

Implement ProxyJump functionality to allow connections through
bastion hosts. This adds the -J option to specify jump hosts.

Fixes #456
```

```
fix: prevent buffer overflow in hostname parsing

Replace strcpy with strncpy to prevent potential buffer overflow
when processing long hostnames.

Fixes #789
```

---

## 📚 Documentation

### What to Document

- **New features**: Update man pages in `doc/`
- **Configuration options**: Update `README.md` and `README.modules`
- **API changes**: Update relevant documentation
- **Complex code**: Add inline comments

### Man Page Updates

Man pages are in `doc/` directory:
- `pdsh.1.in` - Main pdsh command
- `pdcp.1.in` - Parallel copy command
- `dshbak.1` - Output formatting utility

Use standard **troff** format:

```troff
.SH OPTION NAME
.TP
.I "-x, --example"
Description of what this option does.
```

---

## 🌍 Community

### Getting Help

- 📖 Read the [README](README.md) and [man pages](doc/)
- 💡 Check [existing issues](https://github.com/org/pdsh/issues)
- 💬 Ask questions in issue discussions
- 📧 Contact maintainers (see [AUTHORS](AUTHORS))

### Reporting Bugs

When reporting bugs, please include:

1. **Environment**: OS, version, compiler
2. **Configuration**: Output of `./configure` options used
3. **Steps to reproduce**: Exact commands that trigger the bug
4. **Expected behavior**: What should happen
5. **Actual behavior**: What actually happens
6. **Error messages**: Full error output (if any)

### Feature Requests

We welcome feature ideas! Please:

- Check if it already exists or was discussed
- Explain the use case and benefit
- Be open to discussion about implementation
- Consider contributing the implementation yourself

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **Pull Requests**: Code contributions and discussions
- **Email**: For security issues or private concerns

---

## 🎯 Areas for Contribution

We especially welcome contributions in these areas:

### 🔧 Core Functionality

- Performance optimizations
- Memory leak fixes
- Better error handling
- Thread safety improvements

### 🔌 Modules

- New remote shell service modules
- Enhanced host selection modules
- Additional authentication methods

### 📝 Documentation

- Tutorial content
- Example use cases
- Man page improvements
- Code comments

### 🧪 Testing

- Additional test coverage
- Integration tests
- Performance benchmarks

### 🎨 Usability

- Better error messages
- Improved CLI output formatting
- Enhanced interactive mode

---

## 🏆 Recognition

Contributors are recognized in:
- The [AUTHORS](AUTHORS) file
- Git commit history
- Release notes

---

## 📄 License

By contributing to PDSH, you agree that your contributions will be licensed under the **GNU General Public License v2** (see [COPYING](COPYING)).

All contributions must be your original work or properly attributed.

---

## 🙏 Thank You!

Every contribution, no matter how small, helps make PDSH better for system administrators everywhere. We appreciate your time and effort!

**Questions?** Don't hesitate to ask! We're here to help.

---

<div align="center">

**[Back to README](README.md)** • **[View Issues](https://github.com/org/pdsh/issues)** • **[Submit PR](https://github.com/org/pdsh/pulls)**

Happy Contributing! 🚀

</div>
