# 🚀 PDSH - Parallel Distributed Shell

<div align="center">

**Execute commands on multiple remote hosts in parallel**

[![License](https://img.shields.io/badge/License-GPL-blue.svg)](COPYING)
[![C](https://img.shields.io/badge/Language-C-brightgreen.svg)](src/)
[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)]()

*A multithreaded remote shell client for efficient cluster management*

[Features](#-features) • [Installation](#-installation) • [Configuration](#-configuration) • [Usage](#-usage) • [Contributing](#-contributing)

</div>

---

## 📖 Description

**Pdsh** is a high-performance, multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Built for cluster environments, pdsh dramatically reduces the time needed to manage large numbers of systems.

### 🎯 Key Features

- ⚡ **Parallel Execution** - Run commands on hundreds of nodes simultaneously
- 🔌 **Multiple Protocols** - Support for rsh, Kerberos IV, SSH, and more
- 🧵 **Multithreaded** - Efficient connection handling with configurable fanout
- 🎛️ **Flexible Targeting** - Use genders, netgroups, dsh groups, or simple host lists
- 📊 **Smart Output** - Consolidated results with hostname prefixes
- ⏱️ **Timeout Control** - Automatic handling of unresponsive nodes

---

## 🏗️ Installation

### Quick Start

```bash
./configure
make
make install
```

### 🔐 Setuid Configuration (for rsh/qsh)

If you're using the `rcmd/rsh` or `rcmd/qsh` modules, set pdsh as setuid root:

```bash
chown root PREFIX/bin/pdsh PREFIX/bin/pdcp
chmod 4755 PREFIX/bin/pdsh PREFIX/bin/pdcp
```

> **Note:** Most modern rcmd protocols (like SSH) don't require root permissions.

---

## ⚙️ Configuration

Pdsh uses GNU autoconf for flexible module configuration. Dynamically loadable modules are compiled based on your system's capabilities and selected options.

### 🔧 Core Configuration Options

#### Remote Shell Services

| Option | Description |
|--------|-------------|
| `--without-rsh` | ❌ Disable BSD rcmd(3) / standard rsh |
| `--with-ssh` | 🔑 Enable SSH remote shell service |
| `--with-mrsh` | 🔐 Enable mrsh(1) remote shell service |

#### Host Targeting Methods

| Option | Description |
|--------|-------------|
| `--with-machines=/path` | 📝 Use flat file list for `-a` option |
| `--with-genders` | 🏷️ Enable genders database support via genders(3) |
| `--with-dshgroups` | 📁 Enable dsh-style group files (`~/.dsh/group/`) |
| `--with-netgroup` | 🌐 Use netgroups (`/etc/netgroup` or NIS) |

#### Advanced Features

| Option | Description |
|--------|-------------|
| `--with-nodeupdown` | 💚 Auto-eliminate down nodes via nodeupdown(3) |
| `--with-slurm` | 🖥️ Support running under SLURM allocation |
| `--with-readline` | ⌨️ GNU readline for interactive mode |
| `--with-fanout=N` | 🌊 Set default fanout (default: 32) |
| `--with-timeout=N` | ⏲️ Set connect timeout in seconds (default: 10) |

#### Static Modules

For systems without dynamic module support:

```bash
./configure --enable-static-modules
```

### 📚 Module Documentation

See [`README.modules`](README.modules) for detailed information about each module, including requirements and conflicts.

> ⚠️ **Conflict Warning:** Some modules provide identical options (e.g., `-g`). Static compilation will fail if conflicting modules are selected. Dynamic modules will default to one implementation.

---

## 🎮 Usage

See the comprehensive man pages for detailed usage:

- 📘 `man pdsh` - Main pdsh command
- 📙 `man pdcp` - Parallel distributed copy
- 📗 `man dshbak` - Format pdsh output

### Quick Examples

```bash
# Run command on multiple hosts
pdsh -w node[1-10] uptime

# Use SSH protocol
pdsh -R ssh -w host1,host2,host3 'df -h'

# Target all hosts with fanout of 64
pdsh -a -f 64 'free -m'

# Use genders/groups
pdsh -g compute 'cat /proc/cpuinfo | grep MHz'
```

---

## ⚠️ Important Considerations

### 🔌 Reserved Sockets

When using rsh, krb4, qsh, or ssh, pdsh uses **reserved sockets** (obtained via `rresvport()`). With a typical pool of 256 sockets:

- High fanout settings may exhaust the socket pool
- Multiple simultaneous pdsh instances can cause conflicts
- **Solution:** Use mrsh/mqsh (no reserved ports) or reduce fanout

### 🛡️ TCP Wrappers Bottlenecks

TCP wrappers can create performance issues at scale:

- **IDENT queries** - Each connection triggers reverse lookup
- **DNS lookups** - Can overwhelm DNS servers with high fanout
- **SYSLOG** - Excessive logging to remote syslog hosts

**Recommendations:**

- ✅ Configure without `PARANOID` option
- ✅ Use IP addresses or subnets (no names or `user@` prefix)
- ✅ Set SYSLOG severity to reduce remote logging
- ✅ Or reduce default fanout: `--with-fanout=N`

---

## 🏛️ Architecture

### Theory of Operation

```
┌─────────────────────────────────────────────────────────┐
│                     Main Thread                          │
│  • Maintains fanout number of active connections        │
│  • Waits on condition variable from worker threads      │
│  • Spawns new threads as workers complete               │
└────────────┬────────────────────────────────────────────┘
             │
             ├──► Worker Thread 1  ──► [Node 1] (rcmd/ssh/etc)
             ├──► Worker Thread 2  ──► [Node 2]
             ├──► Worker Thread N  ──► [Node N]
             │
             └──► Timeout Thread
                  • Monitors connection timeouts
                  • Enforces command execution limits
                  • Terminates unresponsive threads
```

### Thread Lifecycle

1. **Thread Creation** - One thread per host connection
2. **Connection** - MT-safe rcmd-like function establishes shell
3. **I/O Handling** - Returns stdin/stderr streams
4. **Termination** - Signals condition variable on completion

### 🎹 Interactive Control

- `Ctrl+C` (once) - List currently connected threads
- `Ctrl+C` (twice) - Terminate pdsh immediately

---

## 👨‍💻 Author

**Jim Garlick** - <garlick@llnl.gov>

Developed at Lawrence Livermore National Laboratory

### 📬 Feedback

We'd love to hear from you! Please send:

- 💡 Feature suggestions
- 🐛 Bug reports
- 📊 Cluster deployment stories (how many nodes?)

---

## 📜 License

This project is licensed under the GPL - see the [COPYING](COPYING) file for details.

### Acknowledgments

This product includes software developed by the **University of California, Berkeley** and its contributors. Modifications have been made; bugs are probably ours.

---

## ⚡ Fun Fact

The PDSH software package has **no affiliation** with the Democratic Party of Albania ([www.pdsh.org](http://www.pdsh.org)). 🇦🇱

---

<div align="center">

**Made with ❤️ for cluster administrators everywhere**

</div>
