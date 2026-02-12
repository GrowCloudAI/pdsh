<div align="center">

# 🚀 PDSH
### Parallel Distributed Shell

<p align="center">
  <strong>Execute commands on multiple remote hosts in parallel</strong><br>
  <em>Because life's too short to SSH into servers one by one</em>
</p>

[![License](https://img.shields.io/badge/License-GPL-blue.svg)](COPYING)
[![Language](https://img.shields.io/badge/Language-C-00599C.svg)](src/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Unix-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Parallel-green.svg)]()

<br>

### 📑 Table of Contents

**[📖 What is PDSH?](#-what-is-pdsh)** •
**[🏗️ Building](#️-building--configuration)** •
**[🛠️ Configuration](#️-build-configuration-options)** •
**[📦 Installation](#-installation)** •
**[🎯 Performance Tips](#-performance-tips--troubleshooting)** •
**[🧠 Architecture](#-how-pdsh-works)** •
**[👥 Community](#-community--support)**

</div>

---

## 📖 What is PDSH?

**Pdsh** is a high-performance, multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Whether you're managing a handful of servers or orchestrating thousands of nodes in a cluster, pdsh scales effortlessly to meet your needs.

<br>

<div align="center">

### 🎯 Key Features

</div>

<table>
<tr>
<td width="50%">

#### ⚡ Performance
- **Parallel Execution** across hundreds of hosts
- **Multithreaded** connection management
- **Configurable fanout** for optimal throughput
- Handle **thousands of nodes** simultaneously

</td>
<td width="50%">

#### 🔧 Flexibility
- **Multiple Protocols**: rsh, SSH, Kerberos IV
- **Modular Design** with dynamic loading
- **Host Management** via multiple backends
- **Interactive Mode** with GNU readline

</td>
</tr>
</table>

<br>

### 💡 Quick Example

```bash
# Execute on multiple hosts in parallel
pdsh -w node[1-100] 'uptime'

# Use host groups
pdsh -g webservers 'systemctl restart nginx'

# Copy files to multiple hosts
pdcp -w node[1-50] local.conf /etc/app/config.conf
```

### 📚 Documentation

📖 See the man pages in the [`doc/`](doc/) directory for comprehensive usage information.

---

<br>

## 🏗️ Building & Configuration

<div align="center">

### ⚙️ Configuration System

Pdsh uses **GNU autoconf** for flexible, platform-aware configuration

</div>

> 📦 **Default modules**: rsh, Kerberos IV, and SDR (for IBM SPs) are compiled automatically when available

<br>

#### 📦 Module System

Pdsh uses **dynamically loadable modules** for maximum flexibility. Each shell service and feature is compiled as a separate module based on your configuration.

- **Dynamic Loading** (default): Modules loaded at runtime
- **Static Compilation**: Use `./configure --enable-static-modules` if your system doesn't support dynamic loading

📚 For detailed module descriptions, requirements, and conflicts, see [`README.modules`](README.modules)

---

<br>

## 🛠️ Build Configuration Options

<div align="center">

**Customize your pdsh build with these configuration flags**

</div>

<br>

### 🔐 Remote Shell Services

| Option | Description |
|--------|-------------|
| `--without-rsh` | Disable BSD rcmd(3) support (standard rsh) |
| `--with-ssh` | ✅ Enable SSH remote shell service |
| `--with-mrsh` | ✅ Enable mrsh(1) remote shell service |

### 🗂️ Host Management

| Option | Description |
|--------|-------------|
| `--with-machines=/path/to/machines` | Use flat file list for `-a` option |
| `--with-genders` | ✅ Support genders database via genders(3) library |
| `--with-dshgroups` | ✅ Support dsh-style group files (`~/.dsh/group/`) |
| `--with-netgroup` | ✅ Use netgroups (`/etc/netgroup` or NIS) |

### 🎮 Runtime Features

| Option | Description |
|--------|-------------|
| `--with-nodeupdown` | ✅ Dynamic elimination of down nodes via nodeupdown(3) |
| `--with-slurm` | ✅ Support running under SLURM allocation |
| `--with-readline` | ✅ GNU readline for interactive mode |

### ⚡ Performance Tuning

| Option | Default | Description |
|--------|---------|-------------|
| `--with-fanout=N` | 32 | Set default parallel connection fanout |
| `--with-timeout=N` | 10 | Set default connect timeout (seconds) |

<br>

### 📝 Example Configurations

<details>
<summary><strong>🔥 Recommended: Full-Featured Build</strong></summary>

```bash
./configure \
  --with-ssh \
  --with-genders \
  --with-slurm \
  --with-readline \
  --with-fanout=64 \
  --with-timeout=15
```

</details>

<details>
<summary><strong>⚡ Performance-Optimized Build</strong></summary>

```bash
./configure \
  --with-ssh \
  --with-mrsh \
  --with-fanout=128 \
  --with-timeout=5 \
  --with-nodeupdown
```

</details>

<details>
<summary><strong>🔒 Security-Focused Build</strong></summary>

```bash
./configure \
  --without-rsh \
  --with-ssh \
  --with-readline \
  --with-timeout=20
```

</details>

<br>

### ⚠️ Module Conflicts

> **Important**: Some modules perform identical operations and cannot coexist

**Common conflicts:**
- `genders` ↔️ `nodeattr` (both support `-g` option)
- When conflicts exist, one module will be selected as default
- Static compilation will **fail** if conflicting modules are selected

📖 See the man page for complete conflict details.

---

<br>

## 📦 Installation

<div align="center">

### 🚀 Quick Start

</div>

```bash
# 1. Configure (see options above)
./configure

# 2. Build
make

# 3. Install
make install
```

<br>

### 🔒 SetUID Configuration (Optional)

<table>
<tr>
<td width="50%">

#### ✅ Default Behavior
- Installs **without setuid permissions**
- Works with SSH and most protocols
- No special permissions required

</td>
<td width="50%">

#### ⚠️ SetUID Required For
- `rcmd/rsh` module
- `rcmd/qsh` module

**Enable with:**
```bash
chown root PREFIX/bin/pdsh PREFIX/bin/pdcp
chmod 4755 PREFIX/bin/pdsh PREFIX/bin/pdcp
```

</td>
</tr>
</table>

---

<br>

## 🎯 Performance Tips & Troubleshooting

<div align="center">

### ⚠️ Common Gotchas & Solutions

</div>

<br>

<details>
<summary><strong>🔌 1. Reserved Socket Exhaustion</strong></summary>

<br>

**Problem**: When using rsh, krb4, qsh, or ssh, pdsh consumes reserved sockets via `rresvport()`

```
📊 Socket Usage:
├─ One socket per active connection
├─ Two sockets if maintaining separate stderr
└─ Limited pool of 256 sockets
```

**Causes:**
- ❌ Multiple pdsh instances running simultaneously
- ❌ Very high fanout settings
- ❌ Large cluster operations

**💡 Solutions:**
| Solution | Benefit |
|----------|---------|
| Use `mrsh/mqsh` | No reserved ports needed |
| Reduce fanout | `--with-fanout=N` or `-f N` at runtime |
| Serialize operations | Run pdsh instances sequentially |

</details>

<details>
<summary><strong>🌐 2. TCP Wrappers Bottlenecks</strong></summary>

<br>

**Problem**: Remote shell services with TCP wrappers can create performance bottlenecks

| Service | Impact | Solution |
|---------|--------|----------|
| **IDENT** | Each connection triggers IDENT query if `user@` in hosts.allow | Remove `user@` prefix |
| **DNS** | Reverse DNS lookups for each connection | Use IP addresses or subnets |
| **SYSLOG** | Each connection generates remote syslog entry | Adjust SYSLOG severity |

**💡 Optimization Checklist:**
- ✅ Configure **without** "PARANOID" option
- ✅ Use IP addresses or subnets in hosts.allow (not hostnames)
- ✅ Avoid `user@` prefix in configuration
- ✅ Set SYSLOG severity to avoid remote logging
- ✅ Reduce default fanout if bottlenecks persist

</details>

<details>
<summary><strong>🚀 3. Performance Tuning Best Practices</strong></summary>

<br>

**Optimal Settings by Cluster Size:**

| Cluster Size | Recommended Fanout | Timeout |
|--------------|-------------------|---------|
| 1-50 nodes | 32 (default) | 10s |
| 51-200 nodes | 64 | 15s |
| 201-1000 nodes | 128 | 20s |
| 1000+ nodes | 256 | 30s |

**Additional Tips:**
- 🔹 Use `mrsh` for best performance (no reserved ports)
- 🔹 Enable `--with-nodeupdown` to skip dead nodes automatically
- 🔹 Use host groups to organize and target specific node sets
- 🔹 Monitor with `^C` to see connection states in real-time

</details>

---

<br>

## 🧠 How PDSH Works

<div align="center">

### Architecture & Threading Model

*Generalized for remote shell services (rsh, SSH, Kerberos IV, qsh, etc.)*

</div>

<br>

### 🏗️ System Architecture

```
╔═══════════════════════════════════════════════════════════════╗
║                      🎯 MAIN THREAD                           ║
║                                                               ║
║  • Spawns fanout number of worker threads                    ║
║  • Waits on condition variables                              ║
║  • Dynamically maintains fanout until completion             ║
╚═══════════════════════════════════════════════════════════════╝
                              ↓
         ┌────────────────────┼────────────────────┐
         ↓                    ↓                    ↓
    ╔═════════╗          ╔═════════╗          ╔═════════╗
    ║ Worker  ║          ║ Worker  ║   ...    ║ Worker  ║
    ║ Thread  ║          ║ Thread  ║          ║ Thread  ║
    ║   #1    ║          ║   #2    ║          ║   #N    ║
    ╚═════════╝          ╚═════════╝          ╚═════════╝
         ↓                    ↓                    ↓
    ┌─────────┐          ┌─────────┐          ┌─────────┐
    │ Node 1  │          │ Node 2  │          │ Node N  │
    │ 🖥️      │          │ 🖥️      │          │ 🖥️      │
    └─────────┘          └─────────┘          └─────────┘
```

<br>

### ⚙️ Thread Lifecycle

```mermaid
graph LR
    A[📌 Thread Created] --> B[🔌 Connect to Node]
    B --> C[📡 Open I/O Streams]
    C --> D[⚡ Execute Command]
    D --> E[📥 Collect Output]
    E --> F[✅ Signal Completion]
    F --> G[💤 Thread Terminates]
```

<table>
<tr>
<td width="50%">

#### 🔄 Worker Thread Operations
1. **Creation** - One thread per remote host
2. **Connection** - MT-safe rcmd-like function
3. **I/O Setup** - Separate stdin/stderr streams
4. **Execution** - Command runs on remote host
5. **Cleanup** - Signal main thread on completion

</td>
<td width="50%">

#### ⏱️ Timeout Management
A dedicated **timeout thread** provides:
- 🔍 Monitors all connection threads
- ⏰ Enforces connection timeouts
- 🛑 Terminates slow/hung threads
- 📊 Maintains fanout efficiency

</td>
</tr>
</table>

<br>

### 🎹 Interactive Controls

| Key Combo | Action | Use Case |
|-----------|--------|----------|
| **`^C`** (first press) | 📊 List threads in connected state | Debug slow connections |
| **`^C`** (second press) | 🛑 Terminate program immediately | Emergency abort |
| **`^Z`** | ⏸️ Suspend (if enabled) | Pause operations |

---

<br>

## 👥 Community & Support

<div align="center">

<table>
<tr>
<td align="center" width="33%">

### 👨‍💻 Author

**Jim Garlick**

📧 [garlick@llnl.gov](mailto:garlick@llnl.gov)

</td>
<td align="center" width="33%">

### 💌 Feedback

We welcome:

🐛 Bug reports<br>
💡 Feature suggestions<br>
📊 Usage stories

</td>
<td align="center" width="33%">

### 📚 Resources

📖 [Documentation](doc/)<br>
🔧 [Modules Guide](README.modules)<br>
✍️ [Contributors](AUTHORS)

</td>
</tr>
</table>

</div>

<br>

---

<br>

## 📄 License & Legal

<div align="center">

### GNU General Public License

This project is licensed under the **GPL** - see [COPYING](COPYING) for details

</div>

<br>

> **Attribution**: This product includes software developed by the **University of California, Berkeley** and its contributors. Modifications have been made and bugs are probably mine (not theirs!).

<br>

### ℹ️ Disambiguation

**Note**: The PDSH software package has **no affiliation** with the Democratic Party of Albania ([www.pdsh.org](http://www.pdsh.org)). We're just about parallel shells, not politics! 🙂

---

<br>

<div align="center">

## 🎯 Quick Links

**[📖 Documentation](doc/)** │ **[🔧 Modules](README.modules)** │ **[✍️ Contributing](AUTHORS)** │ **[📜 License](COPYING)**

<br>

### 🌟 Star History

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/github/stars/chaos/pdsh?style=social">
  <img alt="Stars" src="https://img.shields.io/github/stars/chaos/pdsh?style=social">
</picture>

<br><br>

Made with ❤️ for system administrators and DevOps engineers everywhere

**Scale your operations. Command your cluster. Parallel your world.**

---

*Tested on clusters from 2 to 2000+ nodes*

</div>
