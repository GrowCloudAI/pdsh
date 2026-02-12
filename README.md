<div align="center">

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃   ____  ____  ____  _   _                                             ┃
┃  |  _ \|  _ \/ ___|| | | |  ╔═══════════════════════════════════╗    ┃
┃  | |_) | | | \___ \| |_| |  ║   Parallel Distributed Shell      ║    ┃
┃  |  __/| |_| |___) |  _  |  ║   Execute Everywhere, Execute Now ║    ┃
┃  |_|   |____/|____/|_| |_|  ╚═══════════════════════════════════╝    ┃
┃                                                                        ┃
┃  🚀 Run commands on 1,000+ hosts in parallel  •  SSH • RSH • More     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

<h3>✨ Execute commands on multiple remote hosts in parallel ✨</h3>
<p><em>Because life's too short to SSH into servers one by one</em></p>

[![License](https://img.shields.io/badge/License-GPL-blue.svg)](COPYING)
[![Language](https://img.shields.io/badge/Language-C-00599C.svg)](src/)
[![Platform](https://img.shields.io/badge/Platform-Linux-orange.svg)](#)
[![Build](https://img.shields.io/badge/Build-Autotools-green.svg)](#)
[![Multithreaded](https://img.shields.io/badge/Multithreaded-Yes-brightgreen.svg)](#)
[![Scale](https://img.shields.io/badge/Scale-1000%2B_Nodes-red.svg)](#)

**[📚 Docs](doc/)** • **[🔧 Modules](README.modules)** • **[👥 Authors](AUTHORS)** • **[🐛 Issues](#-feedback-welcome)**

</div>

## 🎯 Quick Start

```bash
# 1️⃣ Build and install
./configure --with-ssh --with-readline
make && make install

# 2️⃣ Execute on multiple hosts
pdsh -w host[1-100] uptime

# 3️⃣ Use with SSH
pdsh -R ssh -w server1,server2,server3 'df -h'

# 4️⃣ Parallel copy files
pdcp -w host[1-50] /local/file /remote/path
```

---

## 📖 What is PDSH?

**Pdsh** is a high-performance, multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Born in the world of supercomputing, it's the Swiss Army knife for managing clusters at scale.

<table>
<tr>
<td width="50%">

### 🎯 Key Features

- 🔀 **Parallel Execution**
  Run commands across multiple hosts simultaneously

- 🔌 **Multiple Protocols**
  Support for SSH, RSH, Kerberos IV, MRSH, and more

- 🧵 **Multithreaded**
  Efficient connection management with configurable fanout

- 🎛️ **Modular Design**
  Dynamically loadable modules for different services

</td>
<td width="50%">

### ⚡ Why PDSH?

- ✅ **Scalable** - Handle clusters from 10 to 10,000+ nodes
- ✅ **Fast** - Concurrent execution with smart thread pooling
- ✅ **Flexible** - Works with your existing infrastructure
- ✅ **Battle-tested** - Used in production HPC environments
- ✅ **Zero dependencies*** - Core functionality needs nothing extra
- ✅ **Open Source** - GPL licensed, free forever

</td>
</tr>
</table>

> 📚 **Full Documentation**: See the man pages in the [`doc/`](doc/) directory for detailed usage information.

---

## 💡 Use Cases

<table>
<tr>
<td align="center" width="25%">
<h3>🔧</h3>
<strong>System Updates</strong><br>
<em>Patch hundreds of servers in seconds</em>
</td>
<td align="center" width="25%">
<h3>📊</h3>
<strong>Health Checks</strong><br>
<em>Monitor cluster status in real-time</em>
</td>
<td align="center" width="25%">
<h3>🚀</h3>
<strong>Deployments</strong><br>
<em>Roll out code across your fleet</em>
</td>
<td align="center" width="25%">
<h3>🔍</h3>
<strong>Investigation</strong><br>
<em>Search logs across all nodes</em>
</td>
</tr>
</table>

---

## ⚙️ Configuration

<div align="center">

```
┌─────────────────────────────────────────────────────────────┐
│  🎛️  PDSH Configuration: Mix and Match Your Modules  🎛️   │
├─────────────────────────────────────────────────────────────┤
│  Choose from:  SSH • RSH • MRSH • Kerberos • SLURM         │
│  Add support:  Genders • Netgroups • Readline • More       │
│  Optimize:     Custom fanout • Timeouts • Threading        │
└─────────────────────────────────────────────────────────────┘
```

</div>

Pdsh uses **GNU autoconf** for configuration. Dynamically loadable modules for each shell service and feature are compiled based on your configuration.

> 💡 **Default modules**: RSH, Kerberos IV, and SDR (for IBM SPs) are compiled automatically if available on your system.

### 📦 Available Modules

For a complete description of each module, including requirements and conflicts, see the **[`README.modules`](README.modules)** file.

<details>
<summary><strong>🔧 Static Module Compilation (click to expand)</strong></summary>

If your system doesn't support dynamically loadable modules, use:

```bash
./configure --enable-static-modules
```

This will compile all selected modules directly into the binary.

</details>

---

## 🛠️ Build Configuration Options

<div align="center">

**🎨 Build PDSH your way - Pick the features you need! 🎨**

</div>

Configure pdsh with additional features using these options:

### 🔐 Remote Shell Services

<table>
<tr>
<th width="40%">Option</th>
<th width="60%">Description</th>
</tr>
<tr>
<td><code>--without-rsh</code></td>
<td>❌ Disable BSD rcmd(3) support (standard rsh)</td>
</tr>
<tr>
<td><code>--with-ssh</code></td>
<td>✅ <strong>Enable SSH remote shell service</strong> (Recommended)</td>
</tr>
<tr>
<td><code>--with-mrsh</code></td>
<td>✅ Enable mrsh(1) remote shell service</td>
</tr>
</table>

### 🗂️ Host Management

<table>
<tr>
<th width="40%">Option</th>
<th width="60%">Description</th>
</tr>
<tr>
<td><code>--with-machines=/path/to/machines</code></td>
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

### 🎮 Runtime Features

<table>
<tr>
<th width="40%">Option</th>
<th width="60%">Description</th>
</tr>
<tr>
<td><code>--with-nodeupdown</code></td>
<td>✅ Dynamic elimination of down nodes via nodeupdown(3)</td>
</tr>
<tr>
<td><code>--with-slurm</code></td>
<td>✅ Support running under SLURM allocation</td>
</tr>
<tr>
<td><code>--with-readline</code></td>
<td>✅ GNU readline for interactive mode</td>
</tr>
</table>

### ⚡ Performance Tuning

<table>
<tr>
<th width="30%">Option</th>
<th width="20%" align="center">Default</th>
<th width="50%">Description</th>
</tr>
<tr>
<td><code>--with-fanout=N</code></td>
<td align="center"><strong>32</strong></td>
<td>🎯 Set default parallel connection fanout</td>
</tr>
<tr>
<td><code>--with-timeout=N</code></td>
<td align="center"><strong>10</strong></td>
<td>⏱️ Set default connect timeout (seconds)</td>
</tr>
</table>

<details>
<summary><strong>📝 Example Configurations (click to expand)</strong></summary>

#### 🏢 Enterprise SSH Setup (Recommended)
```bash
./configure \
  --with-ssh \
  --with-genders \
  --with-slurm \
  --with-readline \
  --with-fanout=64 \
  --with-timeout=15
```

#### 🔐 High-Security Kerberos Environment
```bash
./configure \
  --with-ssh \
  --with-mrsh \
  --with-nodeupdown \
  --with-readline \
  --with-fanout=32
```

#### ⚡ Maximum Performance Setup
```bash
./configure \
  --with-ssh \
  --with-mrsh \
  --with-netgroup \
  --with-fanout=128 \
  --with-timeout=5 \
  --enable-static-modules
```

</details>

### ⚠️ Module Conflicts

> **⚡ Important**: Some configuration options may conflict because they perform identical operations.

<table>
<tr>
<th>Conflict Type</th>
<th>Example</th>
<th>Resolution</th>
</tr>
<tr>
<td>Option Overlap</td>
<td><code>genders</code> and <code>nodeattr</code> both support <code>-g</code></td>
<td>One will be selected as default</td>
</tr>
<tr>
<td>Static Build</td>
<td>Conflicting modules in <code>--enable-static-modules</code></td>
<td>Build will <strong>fail</strong> - choose one</td>
</tr>
</table>

📖 See the man page for details on which modules conflict.

---

## 📦 Installation

<div align="center">

```
╔═══════════════════════════════════════════════════════════╗
║                  🚀 Installation Steps                    ║
╠═══════════════════════════════════════════════════════════╣
║  1. ./configure [options]    ← Choose your modules        ║
║  2. make                      ← Build the software        ║
║  3. make install              ← Install (may need sudo)   ║
║  4. pdsh -V                   ← Verify installation       ║
╚═══════════════════════════════════════════════════════════╝
```

</div>

### 🎯 Quick Install

```bash
# Default build (RSH + available modules)
./configure
make
make install

# Recommended build with SSH support
./configure --with-ssh --with-readline
make
sudo make install
```

### 🔒 SetUID Configuration (Optional)

<table>
<tr>
<td width="50%">

**ℹ️ Default Behavior**

By default, pdsh installs **without setuid permissions**.

For most protocols (SSH, MRSH), root permissions aren't needed.

</td>
<td width="50%">

**🔐 When SetUID is Required**

If you're using `rcmd/rsh` or `rcmd/qsh` modules, you'll need setuid root:

```bash
chown root PREFIX/bin/pdsh \
           PREFIX/bin/pdcp
chmod 4755 PREFIX/bin/pdsh \
           PREFIX/bin/pdcp
```

</td>
</tr>
</table>

---

## ⚠️ Gotchas & Known Issues

<div align="center">

**🎓 Know Before You Go - Common Pitfalls & Solutions 🎓**

</div>

### 1️⃣ Reserved Socket Exhaustion

<table>
<tr>
<td width="50%" style="background-color: #fff5f5;">

**⚠️ The Problem**

When using rsh, krb4, qsh, or ssh, pdsh uses **reserved sockets** (obtained via `rresvport()`):

- 🔌 One socket per active connection
- 🔌🔌 Two sockets if maintaining separate stderr
- 📊 Pool of only **256 sockets** available

**Can be exhausted with:**
- ⚡ Multiple pdsh instances running simultaneously
- 🚀 Very high fanout settings

</td>
<td width="50%" style="background-color: #f0fff4;">

**✅ The Solution**

**Option 1: Use MRSH/MQSH**
```bash
pdsh -R mrsh -w host[1-500] uptime
```
*No reserved ports required!*

**Option 2: Reduce Fanout**
```bash
./configure --with-fanout=32
# or at runtime:
pdsh -f 32 -w host[1-500] uptime
```

**Option 3: Serialize Instances**
Use a job scheduler or semaphore to limit concurrent pdsh runs.

</td>
</tr>
</table>

### 2️⃣ TCP Wrappers Bottlenecks

<table>
<tr>
<th width="20%">Service</th>
<th width="40%">Impact</th>
<th width="40%">Mitigation</th>
</tr>
<tr>
<td><strong>🔍 IDENT</strong></td>
<td>With <code>user@</code> in hosts.allow, each connection triggers IDENT query</td>
<td>Use IP addresses or subnets instead</td>
</tr>
<tr>
<td><strong>🌐 DNS</strong></td>
<td>Each connection may trigger reverse DNS lookup</td>
<td>Configure without "PARANOID" option</td>
</tr>
<tr>
<td><strong>📝 SYSLOG</strong></td>
<td>Each connection creates syslog entry on loghost</td>
<td>Set SYSLOG severity to avoid remote logging</td>
</tr>
</table>

> 💡 **Pro Tip**: Avoid names and `user@` prefix in TCP wrapper configs. Reduce default fanout if issues persist.

---

## 🧠 Theory of Operation

<div align="center">

**🔬 Understanding PDSH's Multithreaded Architecture 🔬**

<em>Generalized for the common remote shell service (rsh). Similar for SSH, Kerberos IV, qsh, etc.</em>

</div>

### 🏗️ Architecture Overview

```
╔═══════════════════════════════════════════════════════════════════════╗
║                          🎯 MAIN THREAD                               ║
║  • Starts FANOUT number of worker threads                             ║
║  • Waits on condition variable                                        ║
║  • Maintains fanout level until all commands complete                 ║
║  • Collects and displays output                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    ↓
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ↓                           ↓                           ↓
╔═══════════════╗         ╔═══════════════╗         ╔═══════════════╗
║  🧵 Thread 1  ║         ║  🧵 Thread 2  ║   ...   ║  🧵 Thread N  ║
║  Processing   ║         ║  Processing   ║         ║  Processing   ║
╚═══════════════╝         ╚═══════════════╝         ╚═══════════════╝
        ↓                           ↓                           ↓
   ┌──────────┐              ┌──────────┐              ┌──────────┐
   │ 🖥️ Node1 │              │ 🖥️ Node2 │              │ 🖥️ NodeN │
   └──────────┘              └──────────┘              └──────────┘
        ↑                           ↑                           ↑
        └───── SSH/RSH/MRSH ────────┴──── Connections ─────────┘
```

### 🔄 Thread Workflow

<table>
<tr>
<th width="5%">Step</th>
<th width="25%">Phase</th>
<th width="70%">Description</th>
</tr>
<tr>
<td align="center">1️⃣</td>
<td><strong>Thread Creation</strong></td>
<td>Main thread spawns worker threads up to fanout limit</td>
</tr>
<tr>
<td align="center">2️⃣</td>
<td><strong>Connection</strong></td>
<td>MT-safe rcmd-like function opens connection to remote host</td>
</tr>
<tr>
<td align="center">3️⃣</td>
<td><strong>I/O Streams</strong></td>
<td>Establishes stdin, stdout, and stderr streams</td>
</tr>
<tr>
<td align="center">4️⃣</td>
<td><strong>Execution</strong></td>
<td>Command executes on remote host, output streamed back</td>
</tr>
<tr>
<td align="center">5️⃣</td>
<td><strong>Termination</strong></td>
<td>Thread signals completion and terminates</td>
</tr>
<tr>
<td align="center">6️⃣</td>
<td><strong>Fanout Management</strong></td>
<td>Main thread spawns new thread for next host</td>
</tr>
</table>

### ⏱️ Timeout Management

A dedicated **timeout thread** runs in parallel, monitoring all connection threads:

<table>
<tr>
<td width="50%">

**🔍 Monitors For:**
- Threads taking too long to connect
- Hung command executions
- Network timeouts

</td>
<td width="50%">

**⚡ Actions Taken:**
- Terminates slow connections
- Enforces command completion timeouts
- Reports failed connections to main thread

</td>
</tr>
</table>

### 🎹 Interactive Controls

<table>
<tr>
<th width="30%">Key Combination</th>
<th width="70%">Action</th>
</tr>
<tr>
<td><code>^C</code> (first press)</td>
<td>📊 List all threads currently in connected state</td>
</tr>
<tr>
<td><code>^C</code> (second press)</td>
<td>🛑 <strong>Terminate program immediately</strong></td>
</tr>
<tr>
<td><code>^Z</code></td>
<td>⏸️ Suspend pdsh (can resume with <code>fg</code>)</td>
</tr>
</table>

---

## 👨‍💻 Author & Credits

<table>
<tr>
<td align="center" width="50%">

### 🎨 Original Author

**Jim Garlick**

📧 [garlick@llnl.gov](mailto:garlick@llnl.gov)

*Lawrence Livermore National Laboratory*

</td>
<td align="center" width="50%">

### 🙏 Acknowledgments

This product includes software developed by the **University of California, Berkeley** and its contributors.

Modifications have been made and bugs are probably mine. 😅

</td>
</tr>
</table>

### 💌 Feedback Welcome

<div align="center">

We'd love to hear from you! Please send:

</div>

<table>
<tr>
<td align="center" width="33%">
<h3>🐛</h3>
<strong>Bug Reports</strong><br>
<em>Found an issue? Let us know!</em>
</td>
<td align="center" width="33%">
<h3>💡</h3>
<strong>Suggestions</strong><br>
<em>Ideas for improvements</em>
</td>
<td align="center" width="33%">
<h3>📊</h3>
<strong>Usage Reports</strong><br>
<em>We'd love to hear about your cluster size!</em>
</td>
</tr>
</table>

---

## 📄 License & Legal

<table>
<tr>
<td width="50%">

### 📜 License

This software is licensed under the **GNU General Public License (GPL)**.

See [`COPYING`](COPYING) for full license text.

**Free Software** - Free as in freedom! 🕊️

</td>
<td width="50%">

### ⚖️ Attribution

Includes software developed by:
- **UC Berkeley** and contributors
- **Lawrence Livermore National Laboratory**

All modifications and enhancements documented in commit history.

</td>
</tr>
</table>

### ℹ️ Important Disclaimer

> **Note**: The PDSH software package has **no affiliation** with the Democratic Party of Albania ([www.pdsh.org](http://www.pdsh.org)).

---

<div align="center">

## 🔗 Quick Links

**[📚 Documentation](doc/)** • **[🔧 Modules](README.modules)** • **[👥 Authors](AUTHORS)** • **[📄 License](COPYING)**

---

<h3>⭐ Star this project if you find it useful! ⭐</h3>

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  Made with ❤️  for system administrators everywhere     │
│                                                          │
│  🚀 Scale your operations • ⚡ Execute in parallel      │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

*PDSH - Because parallel is better than serial* 🎯

</div>
