<div align="center">

# 🚀 PDSH - Parallel Distributed Shell

### *Execute commands on multiple remote hosts in parallel*

**Because life's too short to SSH into servers one by one.**

[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg?style=for-the-badge)](COPYING)
[![Language](https://img.shields.io/badge/Language-C-00599C.svg?style=for-the-badge&logo=c)](src/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20|%20macOS-lightgrey.svg?style=for-the-badge)](.)
[![Build](https://img.shields.io/badge/Build-Autotools-green.svg?style=for-the-badge)](configure.ac)

```ascii
 ____  ____  ____  _   _
|  _ \|  _ \/ ___|| | | |
| |_) | | | \___ \| |_| |
|  __/| |_| |___) |  _  |
|_|   |____/|____/|_| |_|

  Parallel. Distributed. Shell.
```

[Quick Start](#-quick-start) • [Features](#-key-features) • [Installation](#-installation) • [Configuration](#️-build-configuration-options) • [Docs](#-documentation)

</div>

---

## 🎯 Quick Start

<table>
<tr>
<td>

**SSH to 100 servers in parallel?**
```bash
pdsh -w server[1-100] uptime
```

</td>
<td>

**Need to restart a service everywhere?**
```bash
pdsh -w @webservers systemctl restart nginx
```

</td>
</tr>
</table>

### 💨 Get Running in 3 Steps

```bash
# 1️⃣ Configure with SSH support
./configure --with-ssh

# 2️⃣ Build it
make

# 3️⃣ Run commands on multiple hosts
pdsh -w host[1-10] hostname
```

<div align="center">

### ✨ That's it! You're now managing clusters like a pro.

</div>

---

## 📖 What is PDSH?

<div align="center">
<img src="https://img.shields.io/badge/Parallel-Execution-brightgreen?style=flat-square" alt="Parallel"/>
<img src="https://img.shields.io/badge/Multi-threaded-orange?style=flat-square" alt="Multithreaded"/>
<img src="https://img.shields.io/badge/Production-Ready-blue?style=flat-square" alt="Production"/>
</div>

<br>

**Pdsh** is a high-performance, multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Born at Lawrence Livermore National Laboratory for managing massive HPC clusters, it's battle-tested on systems ranging from a handful to **thousands** of nodes.

### 🎯 Key Features

<table>
<tr>
<td width="33%">

#### 🔀 Parallel Execution
Run commands across multiple hosts simultaneously with configurable concurrency (fanout)

</td>
<td width="33%">

#### 🔌 Multiple Protocols
Support for SSH, rsh, Kerberos IV, mrsh, and more through modular plugins

</td>
<td width="33%">

#### 🧵 Multithreaded Design
Efficient connection management with thread pooling and timeout handling

</td>
</tr>
<tr>
<td width="33%">

#### 🎛️ Modular Architecture
Dynamically loadable modules for different services and host management systems

</td>
<td width="33%">

#### ⚡ High Performance
Handle massive clusters with thousands of nodes without breaking a sweat

</td>
<td width="33%">

#### 🛡️ Enterprise Grade
20+ years of production use in HPC environments worldwide

</td>
</tr>
</table>

### 📚 Documentation

| Resource | Description |
|----------|-------------|
| 📖 **Man Pages** | `doc/` directory - comprehensive usage guide |
| 🔧 **Module Guide** | [`README.modules`](README.modules) - all available modules |
| 💬 **Interactive Help** | Run `pdsh --help` for quick reference |

---

## 📦 Installation

### ⚡ Quick Install

```bash
# Standard installation
./configure --with-ssh
make
make install
```

### 🎨 Custom Installation

```bash
# Full-featured build with all the bells and whistles
./bootstrap                    # Generate configure script (if from git)
./configure \
  --with-ssh \                 # SSH support (recommended)
  --with-genders \             # Genders database integration
  --with-slurm \               # SLURM cluster integration
  --with-readline \            # Interactive mode with history
  --with-fanout=64 \           # Max 64 parallel connections
  --with-timeout=15            # 15-second connection timeout

make
sudo make install
```

### 🔒 SetUID Configuration (Optional)

> ⚠️ **Note**: Only needed for `rcmd/rsh` or `rcmd/qsh` modules

By default, pdsh installs **without setuid permissions**. SSH and most modern protocols don't need root.

If you need setuid for legacy protocols:

```bash
sudo chown root /usr/local/bin/pdsh /usr/local/bin/pdcp
sudo chmod 4755 /usr/local/bin/pdsh /usr/local/bin/pdcp
```

### 🐧 Distribution Packages

Many distributions include pdsh in their repositories:

```bash
# Debian/Ubuntu
apt-get install pdsh

# RHEL/CentOS/Fedora
yum install pdsh

# Arch Linux
pacman -S pdsh
```

---

## ⚙️ Configuration

<div align="center">

**Pdsh uses GNU autoconf for flexible, modular configuration**

🔧 Each shell service and feature compiles as a **dynamically loadable module**

</div>

### 📦 Module System

> **Default modules**: rsh, Kerberos IV, and SDR (for IBM SPs) are compiled automatically if detected on your system.

<table>
<tr>
<td>

#### 🔌 Dynamically Loadable (Default)
Modules are `.so` files loaded at runtime. Flexible and space-efficient.

```bash
./configure --with-ssh --with-genders
```

</td>
<td>

#### 🔗 Static Linking (Legacy Systems)
For systems without dynamic library support:

```bash
./configure --enable-static-modules
```

</td>
</tr>
</table>

📖 **Full module documentation**: See [`README.modules`](README.modules) for requirements, conflicts, and detailed descriptions.

---

## 🛠️ Build Configuration Options

<div align="center">

**Customize your pdsh build with these configuration flags**

Mix and match to create the perfect setup for your environment

</div>

### 🔐 Remote Shell Services

<table>
<tr>
<th width="40%">Option</th>
<th width="60%">Description</th>
</tr>
<tr>
<td><code>--without-rsh</code></td>
<td>🚫 Disable BSD rcmd(3) support (standard rsh)</td>
</tr>
<tr>
<td><code>--with-ssh</code></td>
<td>✅ <strong>Enable SSH remote shell service</strong> (Recommended)</td>
</tr>
<tr>
<td><code>--with-mrsh</code></td>
<td>✅ Enable mrsh(1) remote shell service (no reserved ports!)</td>
</tr>
<tr>
<td><code>--with-xcpu</code></td>
<td>🔬 Enable XCPU remote shell service</td>
</tr>
</table>

### 🗂️ Host Management Modules

<table>
<tr>
<th width="40%">Option</th>
<th width="60%">Description</th>
</tr>
<tr>
<td><code>--with-machines=/path</code></td>
<td>📄 Use flat file list for <code>-a</code> option</td>
</tr>
<tr>
<td><code>--with-genders</code></td>
<td>✅ Support genders database via genders(3) library</td>
</tr>
<tr>
<td><code>--with-dshgroups</code></td>
<td>✅ Support dsh-style group files (<code>~/.dsh/group/</code>)</td>
</tr>
<tr>
<td><code>--with-netgroup</code></td>
<td>✅ Use netgroups (<code>/etc/netgroup</code> or NIS)</td>
</tr>
</table>

### 🎮 Runtime & Integration Features

<table>
<tr>
<th width="40%">Option</th>
<th width="60%">Description</th>
</tr>
<tr>
<td><code>--with-nodeupdown</code></td>
<td>🔍 Dynamic elimination of down nodes via nodeupdown(3)</td>
</tr>
<tr>
<td><code>--with-slurm</code></td>
<td>🎯 Support running under SLURM allocation</td>
</tr>
<tr>
<td><code>--with-torque</code></td>
<td>📊 Support Torque/PBS integration</td>
</tr>
<tr>
<td><code>--with-readline</code></td>
<td>⌨️ GNU readline for interactive mode with history</td>
</tr>
</table>

### ⚡ Performance Tuning

<table>
<tr>
<th width="30%">Option</th>
<th width="20%">Default</th>
<th width="50%">Description</th>
</tr>
<tr>
<td><code>--with-fanout=N</code></td>
<td><code>32</code></td>
<td>🚀 Max parallel connections (32-256 typical)</td>
</tr>
<tr>
<td><code>--with-timeout=N</code></td>
<td><code>10</code></td>
<td>⏱️ Connect timeout in seconds</td>
</tr>
<tr>
<td><code>--with-connect-timeout=N</code></td>
<td><code>10</code></td>
<td>🔌 Fine-tune TCP connection timeout</td>
</tr>
</table>

### 📝 Configuration Examples

<details>
<summary><b>💼 Enterprise Setup</b> (SSH + SLURM + Genders)</summary>

```bash
./configure \
  --with-ssh \
  --with-genders \
  --with-slurm \
  --with-readline \
  --with-nodeupdown \
  --with-fanout=128 \
  --with-timeout=15
```

*Ideal for HPC clusters with SLURM and genders database.*

</details>

<details>
<summary><b>🏠 Home Lab Setup</b> (SSH + Simple Host Files)</summary>

```bash
./configure \
  --with-ssh \
  --with-machines=/etc/pdsh/machines \
  --with-dshgroups \
  --with-fanout=32
```

*Perfect for small to medium deployments with flat file host lists.*

</details>

<details>
<summary><b>🔥 High Performance Setup</b> (Maximum Throughput)</summary>

```bash
./configure \
  --with-mrsh \
  --with-genders \
  --with-fanout=256 \
  --with-timeout=5
```

*Uses mrsh (no reserved ports) with high fanout for maximum speed.*

</details>

<details>
<summary><b>🔒 Legacy/Secure Setup</b> (Multiple Protocols)</summary>

```bash
./configure \
  --with-ssh \
  --with-mrsh \
  --without-rsh \
  --with-netgroup \
  --with-readline
```

*Supports both SSH and mrsh while explicitly disabling insecure rsh.*

</details>

### ⚠️ Module Conflicts

> **Heads up!** Some modules perform identical operations and will conflict.

**Common conflicts:**
- 🔴 `genders` vs `nodeattr` - both provide the `-g` option
- 🔴 Multiple host selection modules - only one becomes default
- 🔴 Static compilation **fails** if conflicting modules are selected

**Resolution:**
- With dynamic loading: First module found becomes default
- With static linking: Configure will error - choose one

📖 **See the man page for complete conflict matrix.**

---

## 💡 Usage Examples

### Basic Operations

```bash
# Run command on multiple hosts
pdsh -w server[1-10] uptime

# Use a host group
pdsh -g webservers "df -h"

# Copy files to multiple hosts (pdcp)
pdcp -w server[1-20] /etc/myconfig.conf /etc/

# Specify user
pdsh -w @database -l admin "systemctl restart postgresql"

# Interactive mode
pdsh -w server[1-5]
pdsh> hostname
pdsh> uptime
pdsh> exit
```

### Advanced Patterns

```bash
# Exclude specific hosts
pdsh -w server[1-100] -x server[50-55] uptime

# Combine multiple host specifications
pdsh -w server[1-10],backup[1-5] -w router1 reboot

# Different fanout (max parallel connections)
pdsh -f 64 -w server[1-200] "cat /proc/cpuinfo"

# With timeout
pdsh -t 30 -w slow[1-10] "sleep 5; echo done"

# Pipe formatting with dshbak
pdsh -w web[1-20] uptime | dshbak -c
```

### Real-World Scenarios

<table>
<tr>
<td width="50%">

**📊 Cluster Health Check**
```bash
pdsh -w @all "free -h; df -h /"
```

</td>
<td width="50%">

**🔄 Service Management**
```bash
pdsh -g webservers \
  "systemctl restart nginx"
```

</td>
</tr>
<tr>
<td width="50%">

**📦 Package Updates**
```bash
pdsh -w server[1-100] \
  "yum update -y"
```

</td>
<td width="50%">

**🔍 Log Analysis**
```bash
pdsh -w app[1-50] \
  "grep ERROR /var/log/app.log"
```

</td>
</tr>
</table>

---

## ⚠️ Gotchas & Known Issues

### 1️⃣ Reserved Socket Exhaustion

<table>
<tr>
<td width="60%">

**The Problem:**
When using rsh, krb4, qsh, or ssh, pdsh uses **reserved sockets** (via `rresvport()`):
- One socket per connection (two if separate stderr)
- Limited pool of 256 sockets system-wide
- Exhausted by: multiple pdsh instances + high fanout

</td>
<td width="40%">

**The Solution:**
- ✅ Use `mrsh/mqsh` (no reserved ports!)
- ✅ Reduce fanout: `--with-fanout=N`
- ✅ Coordinate concurrent pdsh runs
- ✅ Use separate stderr sparingly

</td>
</tr>
</table>

### 2️⃣ TCP Wrappers Bottlenecks

When using remote shell services with TCP wrappers, performance can suffer:

<table>
<tr>
<th width="25%">Service</th>
<th width="40%">Impact</th>
<th width="35%">Mitigation</th>
</tr>
<tr>
<td>🔍 <strong>IDENT</strong></td>
<td>Each connection triggers IDENT query if <code>user@</code> in hosts.allow</td>
<td>Remove <code>user@</code> prefix from configs</td>
</tr>
<tr>
<td>🌐 <strong>DNS</strong></td>
<td>Reverse DNS lookup per connection</td>
<td>Use IP addresses or disable PARANOID</td>
</tr>
<tr>
<td>📝 <strong>SYSLOG</strong></td>
<td>Remote syslog entry per connection</td>
<td>Adjust severity to avoid remote logging</td>
</tr>
</table>

**Quick Fixes:**
```bash
# In /etc/hosts.allow - use IPs instead of names
sshd: 192.168.1.0/24

# Or disable paranoid hostname checking
sshd: ALL: spawn (/usr/bin/safe_finger -l @%h | /usr/bin/mail root) &
```

---

## 🧠 How It Works: Theory of Operation

<div align="center">

**Understanding pdsh's multithreaded architecture**

*Generalized for common remote shell services (rsh, SSH, Kerberos IV, qsh, etc.)*

</div>

### 🏗️ Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│                          🎯 MAIN THREAD                              │
│                                                                      │
│  • Parses command line and loads host list                          │
│  • Spawns initial fanout threads (default: 32)                      │
│  • Waits on condition variable for thread completion                │
│  • Maintains fanout level until all commands complete               │
│  • Collects and displays results                                    │
└──────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
   ┌──────────┐                ┌──────────┐              ┌──────────┐
   │ 🧵 Thread │                │ 🧵 Thread │     ...     │ 🧵 Thread │
   │    #1     │                │    #2     │              │    #N     │
   │          │                │          │              │          │
   │ connect() │                │ connect() │              │ connect() │
   │ execute() │                │ execute() │              │ execute() │
   │ collect() │                │ collect() │              │ collect() │
   └────┬─────┘                └────┬─────┘              └────┬─────┘
        │                           │                           │
        ▼                           ▼                           ▼
   [Node 1] 🖥️               [Node 2] 🖥️                [Node N] 🖥️
   server-01                  server-02                  server-N
```

### ⚙️ Thread Lifecycle

```
┌─────────────┐
│ 1️⃣ CREATE   │  Main thread spawns worker thread
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ 2️⃣ CONNECT  │  MT-safe rcmd() opens connection to remote host
└──────┬──────┘  (handles authentication, establishes socket)
       │
       ▼
┌─────────────┐
│ 3️⃣ EXECUTE  │  Send command, capture stdout/stderr streams
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ 4️⃣ COLLECT  │  Read output, format with hostname prefix
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ 5️⃣ SIGNAL   │  Notify main thread of completion
└──────┬──────┘  Signal condition variable
       │
       ▼
┌─────────────┐
│ 6️⃣ TERMINATE│  Thread exits, resources cleaned up
└─────────────┘  Main thread may spawn new thread to maintain fanout
```

### ⏱️ Timeout Management

A dedicated **timeout thread** runs concurrently, monitoring all worker threads:

<table>
<tr>
<td width="50%">

**Connection Timeouts**
- Monitors thread connection phase
- Kills threads exceeding `--connect-timeout`
- Prevents hung connections from blocking

</td>
<td width="50%">

**Command Timeouts**
- Monitors command execution (if `-t` specified)
- Terminates long-running commands
- Ensures timely completion

</td>
</tr>
</table>

### 🎹 Interactive Controls

<table>
<tr>
<th width="30%">Key Combo</th>
<th width="70%">Action</th>
</tr>
<tr>
<td><kbd>Ctrl</kbd>+<kbd>C</kbd> (first press)</td>
<td>📊 List all threads currently in connected state (diagnostic info)</td>
</tr>
<tr>
<td><kbd>Ctrl</kbd>+<kbd>C</kbd> (second press)</td>
<td>🛑 Terminate program immediately (kill all threads)</td>
</tr>
<tr>
<td><kbd>Ctrl</kbd>+<kbd>Z</kbd></td>
<td>⏸️ Suspend pdsh (background with <code>bg</code>, resume with <code>fg</code>)</td>
</tr>
</table>

### 🔒 Thread Safety

Pdsh uses **MT-safe** (multi-thread safe) implementations:
- Custom rcmd() implementations with thread-local storage
- Mutex-protected shared data structures
- Lock-free result collection where possible
- Thread-safe error handling and logging

---

## 🤝 Contributing & Community

<div align="center">

### We'd Love to Hear From You!

Whether you manage 10 servers or 10,000, your feedback helps make pdsh better.

</div>

<table>
<tr>
<td width="33%" align="center">

### 🐛 Bug Reports
Found a bug? Let us know!

Report issues with:
- System details
- Reproduction steps
- Expected vs actual behavior

</td>
<td width="33%" align="center">

### 💡 Feature Ideas
Have a cool idea?

We welcome suggestions for:
- New modules
- Protocol support
- Usability improvements

</td>
<td width="33%" align="center">

### 📊 War Stories
Using pdsh at scale?

Share your setup:
- Cluster size
- Use cases
- Performance tips

</td>
</tr>
</table>

### 👨‍💻 Primary Author

**Jim Garlick** - [garlick@llnl.gov](mailto:garlick@llnl.gov)
*Lawrence Livermore National Laboratory*

### 🏆 Contributors

Special thanks to:
- **Al Chu** - Additional development and maintenance
- **Mark Grondona** - Core functionality and modules
- The **LLNL HPC Team** - Testing and feedback
- **Community contributors** - Patches, bug reports, and suggestions

See [AUTHORS](AUTHORS) for complete contributor list.

---

## 📄 License & Legal

<div align="center">

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

**PDSH is licensed under the GNU General Public License v2**

</div>

### 📜 Attribution

This product includes software developed by the **University of California, Berkeley** and its contributors. Modifications have been made and bugs are probably mine (Jim's, not Berkeley's!).

### 🏢 Origin

Developed at **Lawrence Livermore National Laboratory** (LLNL) for managing high-performance computing clusters. Refined over 20+ years of production use.

### ⚖️ Legal Disclaimers

- See [COPYING](COPYING) for full GPL v2 license text
- See [DISCLAIMER.UC](DISCLAIMER.UC) for UC Berkeley disclaimer
- See [AUTHORS](AUTHORS) for complete contributor attribution

### ℹ️ Important Note

The **PDSH software package** has no affiliation with the Democratic Party of Albania ([www.pdsh.org](http://www.pdsh.org)). 🇦🇱

Just want to be clear on that. 😄

---

## 🔗 Resources

<div align="center">

<table>
<tr>
<td align="center" width="25%">

### 📖 Documentation
[Man Pages](doc/)<br>
[Module Guide](README.modules)<br>
[Installation Guide](INSTALL)

</td>
<td align="center" width="25%">

### 🛠️ Development
[Build System](configure.ac)<br>
[Source Code](src/)<br>
[Test Suite](tests/)

</td>
<td align="center" width="25%">

### 🔧 Configuration
[Example Configs](#-configuration-examples)<br>
[Module Options](#️-build-configuration-options)<br>
[Performance Tuning](#-performance-tuning)

</td>
<td align="center" width="25%">

### 💬 Community
[Report Issues](https://github.com/chaos/pdsh/issues)<br>
[Contribute](AUTHORS)<br>
[Contact Author](mailto:garlick@llnl.gov)

</td>
</tr>
</table>

</div>

---

## 🌟 Project Stats

<div align="center">

![C](https://img.shields.io/badge/C-13%2C309+%20LOC-blue?style=flat-square)
![Age](https://img.shields.io/badge/Age-20+%20years-green?style=flat-square)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=flat-square)
![Scale](https://img.shields.io/badge/Scale-Tested%20on%201000s%20of%20nodes-orange?style=flat-square)

**Latest Release:** v2.36 (January 2025) | **License:** GPL v2 | **Origin:** LLNL

</div>

---

<div align="center">

### 🚀 Ready to Manage Your Cluster?

```bash
git clone https://github.com/chaos/pdsh
cd pdsh
./configure --with-ssh
make && sudo make install
pdsh -w server[1-100] hostname
```

### Made with ❤️ for System Administrators Everywhere

*Because parallel is better than sequential, and automation beats manual labor.*

---

**[⬆ Back to Top](#-pdsh---parallel-distributed-shell)**

</div>
