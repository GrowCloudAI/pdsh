# 🤝 Contributing to PDSH

Thank you for your interest in contributing to PDSH! This document provides guidelines for contributing to the project.

## 🚀 Quick Start

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
   ```bash
   git clone https://github.com/YOUR_USERNAME/pdsh.git
   cd pdsh
   ```
3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes** and test thoroughly
5. **Commit with clear messages**
   ```bash
   git commit -m "Add feature: description of change"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request** on GitHub

## 📋 Guidelines

### Code Style

- Follow existing code style and formatting
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and modular

### Testing

- Test your changes on multiple platforms if possible
- Verify no regressions in existing functionality
- Test with different configuration options
- Include test cases for new features

### Commit Messages

- Use clear, descriptive commit messages
- Start with a verb (Add, Fix, Update, Remove, etc.)
- Reference issue numbers when applicable
- Keep first line under 72 characters

Good examples:
```
Add support for custom timeout per-host
Fix memory leak in rcmd module
Update documentation for SSH configuration
Remove deprecated Kerberos IV code
```

### Pull Requests

- Provide a clear description of the changes
- Reference related issues
- Include before/after examples if applicable
- Update documentation as needed
- Be responsive to review feedback

## 🐛 Bug Reports

When reporting bugs, please include:

- PDSH version (`pdsh -V`)
- Operating system and version
- Configuration options used (`./configure ...`)
- Steps to reproduce the bug
- Expected vs actual behavior
- Relevant error messages or logs

## 💡 Feature Requests

We welcome feature requests! Please include:

- Clear description of the feature
- Use case and motivation
- Proposed implementation (if you have ideas)
- Potential impact on existing functionality

## 📚 Documentation

Documentation improvements are highly valued:

- Fix typos and clarify unclear sections
- Add examples and use cases
- Update outdated information
- Improve code comments

## 🔍 Code Review Process

1. Maintainers will review your PR
2. Feedback may be provided for improvements
3. Make requested changes if needed
4. Once approved, PR will be merged
5. Your contribution will be credited

## 📜 License

By contributing, you agree that your contributions will be licensed under the GNU General Public License v2.0.

## 🙏 Thank You!

Every contribution, no matter how small, helps improve PDSH for the entire HPC community. Thank you for taking the time to contribute!

---

Questions? Contact: garlick@llnl.gov
