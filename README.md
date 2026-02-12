<div align="center">

# 🚀 PDSH - Parallel Distributed Shell

### *Execute commands on multiple remote hosts in parallel*

**Because life's too short to SSH into servers one by one** 💨

[![License](https://img.shields.io/badge/License-GPL-blue.svg)](COPYING)
[![C](https://img.shields.io/badge/Language-C-00599C.svg)](src/)
[![Build](https://img.shields.io/badge/Build-Autotools-orange.svg)](configure.ac)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Unix-lightgrey.svg)]()

[Features](#-key-features) • [Installation](#-installation) • [Configuration](#-build-configuration-options) • [Documentation](#-documentation)

</div>

---

## 🌟 What is PDSH?

**Pdsh** is a powerful multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Whether you're managing 10 servers or 10,000 nodes, pdsh scales effortlessly to handle your infrastructure.

<div align="center">

```
┌─────────────┐
│  Your Shell │
└──────┬──────┘
       │
       ├──────────┬──────────┬──────────┐
       ↓          ↓          ↓          ↓
   [Host 1]   [Host 2]   [Host 3]   [Host N]
       │          │          │          │
       └──────────┴──────────┴──────────┘
                  ↓
          ✨ Results aggregated
```

</div>

## 🎯 Key Features

<table>
<tr>
<td width="50%">

### 🔀 Parallel Execution
Run commands across **multiple hosts simultaneously** with intelligent fanout control

### 🔌 Multiple Protocols
Support for **rsh**, **Kerberos IV**, **SSH**, **mrsh**, and more

### 🧵 Multithreaded Architecture
Efficient connection management with configurable concurrency

</td>
<td width="50%">

### 🎛️ Modular Design
Dynamically loadable modules for different services and features

### ⚡ High Performance
Handle large clusters with **thousands of nodes** effortlessly

### 🛡️ Battle-Tested
Proven in production environments at **LLNL** and beyond

</td>
</tr>
</table>

## 🚀 Quick Start

```bash
# Install
./configure --with-ssh --with-readline
make && make install

# Run a command on multiple hosts
pdsh -w host[1-10] uptime

# Use host groups
pdsh -g webservers 'systemctl status nginx'

# Copy files in parallel
pdcp -w host[1-100] /etc/config.yml /tmp/
```

---

## 💡 Usage Examples

<details>
<summary>🖥️ <b>Basic Host Selection</b></summary>

<br>

```bash
# Single host
pdsh -w node1 hostname

# Multiple hosts (comma-separated)
pdsh -w node1,node2,node3 uptime

# Range notation
pdsh -w node[1-100] 'free -h'

# Multiple ranges
pdsh -w web[1-5],db[1-3] 'df -h'

# Exclude hosts
pdsh -w node[1-100] -x node[50-60] hostname
```

</details>

<details>
<summary>📊 <b>System Administration Tasks</b></summary>

<br>

```bash
# Check disk usage across all servers
pdsh -w server[1-50] 'df -h | grep -E "/$"'

# Restart a service on multiple nodes
pdsh -w web[1-20] 'sudo systemctl restart nginx'

# Check running processes
pdsh -w cluster[1-100] 'ps aux | grep apache'

# Update packages on all nodes
pdsh -w all-nodes 'sudo apt-get update && sudo apt-get upgrade -y'

# Check system uptime
pdsh -w production-* 'uptime | awk "{print \$1, \$3, \$4}"'
```

</details>

<details>
<summary>📁 <b>File Operations with pdcp</b></summary>

<br>

```bash
# Copy file to multiple hosts
pdcp -w web[1-10] /local/config.yml /etc/app/

# Copy directory recursively
pdcp -r -w db[1-5] /local/scripts/ /opt/

# Reverse copy (pull from remote hosts)
rpdcp -w node[1-10] /var/log/app.log /local/logs/

# Copy with different remote path per host
pdcp -w node[1-10] config-%h.yml /etc/config.yml
```

</details>

<details>
<summary>🔍 <b>Monitoring & Troubleshooting</b></summary>

<br>

```bash
# Check memory usage
pdsh -w cluster[1-100] 'free -m | grep Mem:'

# Monitor network connections
pdsh -w web[1-20] 'netstat -an | grep :80 | wc -l'

# Check for specific errors in logs
pdsh -w app[1-50] 'tail -100 /var/log/application.log | grep ERROR'

# Verify configuration files
pdsh -w all-hosts 'md5sum /etc/important.conf'

# Check service status
pdsh -w production[1-100] 'systemctl is-active myapp'
```

</details>

<details>
<summary>🎯 <b>Advanced Usage</b></summary>

<br>

```bash
# Use different fanout (control parallelism)
pdsh -f 10 -w node[1-1000] command  # Only 10 concurrent connections

# Set timeout
pdsh -u 30 -w slow[1-10] long-command  # 30 second timeout

# Interactive mode with readline
pdsh -w cluster[1-50]
# (then type commands interactively)

# Combine with host groups
pdsh -g database -x db-master 'sudo systemctl restart mysql'

# Use different SSH options
pdsh -R ssh -o '-o StrictHostKeyChecking=no' -w new[1-10] hostname
```

</details>

<details>
<summary>🏢 <b>Real-World Scenarios</b></summary>

<br>

### Scenario 1: Deploy Configuration Update
```bash
# 1. Backup existing configs
pdsh -w web[1-20] 'cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak'

# 2. Deploy new config
pdcp -w web[1-20] nginx.conf /etc/nginx/

# 3. Validate configuration
pdsh -w web[1-20] 'nginx -t'

# 4. Reload service
pdsh -w web[1-20] 'systemctl reload nginx'
```

### Scenario 2: Security Audit
```bash
# Check for outdated packages
pdsh -w all[1-100] 'apt list --upgradable | wc -l'

# Verify SSH key deployment
pdsh -w prod[1-50] 'grep -c "ssh-rsa" ~/.ssh/authorized_keys'

# Check open ports
pdsh -w dmz[1-20] 'ss -tuln | grep LISTEN'
```

### Scenario 3: Cluster Health Check
```bash
# One-liner health dashboard
pdsh -w cluster[1-100] '
  echo "$(hostname):
    Load: $(uptime | awk -F"load average:" "{print \$2}")
    Disk: $(df -h / | tail -1 | awk "{print \$5}")
    Mem: $(free | grep Mem | awk "{print int(\$3/\$2*100)}%")"
'
```

</details>

## 📚 Documentation

See the comprehensive man pages in the `doc/` directory:
- [`pdsh.1`](doc/pdsh.1.in) - Main command reference
- [`pdcp.1`](doc/pdcp.1.in) - Parallel copy utility
- [`README.modules`](README.modules) - Module documentation

---

## ⚙️ Configuration

Pdsh uses **GNU autoconf** for flexible, modular configuration. Dynamically loadable modules for each shell service and feature are compiled based on your needs.

<details>
<summary>📦 <b>Available Modules</b> (click to expand)</summary>

<br>

For a complete description of each module, including requirements and conflicts, see the [`README.modules`](README.modules) file.

**Default modules**: rsh, Kerberos IV, and SDR (for IBM SPs) are compiled automatically if available on your system.

</details>

<details>
<summary>🔧 <b>Static Module Compilation</b> (for systems without dynamic loading)</summary>

<br>

If your system doesn't support dynamically loadable modules, use:

```bash
./configure --enable-static-modules
```

</details>

---

## 🛠️ Build Configuration Options

<div align="center">

**Customize your pdsh installation with these powerful configuration flags**

</div>

### 🔐 Remote Shell Services

> Choose your connection protocols

| Option | Description |
|--------|-------------|
| `--without-rsh` | Disable BSD rcmd(3) support (standard rsh) |
| `--with-ssh` | ✅ Enable SSH remote shell service |
| `--with-mrsh` | ✅ Enable mrsh(1) remote shell service |

### 🗂️ Host Management

> Flexible ways to define and organize your infrastructure

| Option | Description |
|--------|-------------|
| `--with-machines=/path/to/machines` | Use flat file list for `-a` option |
| `--with-genders` | ✅ Support genders database via genders(3) library |
| `--with-dshgroups` | ✅ Support dsh-style group files (`~/.dsh/group/`) |
| `--with-netgroup` | ✅ Use netgroups (`/etc/netgroup` or NIS) |

### 🎮 Runtime Features

> Enhance functionality with these powerful modules

| Option | Description |
|--------|-------------|
| `--with-nodeupdown` | ✅ Dynamic elimination of down nodes via nodeupdown(3) |
| `--with-slurm` | ✅ Support running under SLURM allocation |
| `--with-readline` | ✅ GNU readline for interactive mode |

### ⚡ Performance Tuning

> Optimize for your workload and infrastructure

| Option | Default | Description |
|--------|---------|-------------|
| `--with-fanout=N` | 32 | Set default parallel connection fanout |
| `--with-timeout=N` | 10 | Set default connect timeout (seconds) |

### 📝 Example Configurations

<details>
<summary>💼 <b>Production Configuration</b> - Full-featured setup for enterprise environments</summary>

```bash
./configure \
  --with-ssh \
  --with-genders \
  --with-slurm \
  --with-readline \
  --with-nodeupdown \
  --with-fanout=64 \
  --with-timeout=15
```

</details>

<details>
<summary>🏠 <b>Simple Configuration</b> - Minimal setup with SSH only</summary>

```bash
./configure \
  --with-ssh \
  --with-readline \
  --with-fanout=32
```

</details>

<details>
<summary>🎯 <b>HPC Configuration</b> - Optimized for high-performance computing clusters</summary>

```bash
./configure \
  --with-ssh \
  --with-slurm \
  --with-genders \
  --with-nodeupdown \
  --with-fanout=128 \
  --with-timeout=30
```

</details>

<details>
<summary>⚠️ <b>Module Conflicts</b> - Important compatibility information</summary>

<br>

Some configuration options may conflict because they perform identical operations.

**Common conflicts:**
- `genders` and `nodeattr` both support the `-g` option
- When multiple modules support the same option, one will be selected as default
- Static compilation will **fail** if conflicting modules are selected

📖 See the man page for details on which modules conflict.

</details>

---

## 📦 Installation

### ⚡ Quick Install

```bash
# Configure (see options above)
./configure

# Build
make

# Install (may require sudo)
make install
```

### 🔒 SetUID Configuration (Optional)

<table>
<tr>
<td width="70%">

By default, pdsh installs **without setuid permissions**. For most protocols (SSH, mrsh), root permissions aren't needed.

**However**, if you're using `rcmd/rsh` or `rcmd/qsh` modules, you'll need setuid root:

</td>
<td width="30%">

```bash
chown root \
  PREFIX/bin/pdsh \
  PREFIX/bin/pdcp

chmod 4755 \
  PREFIX/bin/pdsh \
  PREFIX/bin/pdcp
```

</td>
</tr>
</table>

---

## ⚠️ Gotchas & Known Issues

<details>
<summary>🔌 <b>Reserved Socket Exhaustion</b> - When using rsh, krb4, qsh, or ssh</summary>

<br>

When using rsh, krb4, qsh, or ssh, pdsh uses **reserved sockets** (obtained via `rresvport()`):

| Resource | Details |
|----------|---------|
| **Sockets per connection** | 1 (or 2 if maintaining separate stderr) |
| **Pool size** | 256 sockets available |
| **Exhaustion causes** | • Multiple pdsh instances running simultaneously<br>• Very high fanout settings |

### 💡 Solutions

```bash
# Option 1: Use mrsh/mqsh (no reserved ports required)
./configure --with-mrsh

# Option 2: Reduce fanout
./configure --with-fanout=32
pdsh -f 32 -w hosts[1-100] command
```

</details>

<details>
<summary>🌐 <b>TCP Wrappers Bottlenecks</b> - Performance considerations</summary>

<br>

When using remote shell services wrapped with TCP wrappers, watch for these bottlenecks:

| Service | Impact | Severity |
|---------|--------|----------|
| **IDENT** | With `user@` in hosts.allow, each connection triggers IDENT query | 🔴 High |
| **DNS** | Each connection may trigger DNS lookup | 🟡 Medium |
| **SYSLOG** | Each connection creates syslog entry on loghost | 🟡 Medium |

### 💡 Mitigation Strategies

1. **Configure without "PARANOID" option**
   ```bash
   # In /etc/hosts.allow
   sshd: 192.168.1.0/24  # Use IPs, not hostnames
   ```

2. **Avoid DNS lookups**
   - Use IP addresses or subnets
   - Avoid names and `user@` prefix

3. **Reduce syslog impact**
   - Set SYSLOG severity to avoid remote logging
   - Configure local logging only

4. **Adjust fanout if needed**
   ```bash
   pdsh -f 16 -w hosts[1-100] command  # Lower fanout
   ```

</details>

---

## 🧠 Theory of Operation

<div align="center">

### *How PDSH achieves massive parallelism*

> Generalized for the common remote shell service (rsh). Similar for SSH, Kerberos IV, qsh, etc.

</div>

### 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         MAIN THREAD                             │
│  • Starts fanout number of worker threads                       │
│  • Waits on condition variable                                  │
│  • Maintains fanout until all commands complete                 │
│  • Aggregates and displays output                               │
└───────────────────────────┬─────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ↓                   ↓                   ↓
   ┌─────────┐         ┌─────────┐         ┌─────────┐
   │ Worker  │         │ Worker  │   ...   │ Worker  │
   │ Thread  │         │ Thread  │         │ Thread  │
   │   #1    │         │   #2    │         │   #N    │
   └────┬────┘         └────┬────┘         └────┬────┘
        │                   │                   │
        ↓                   ↓                   ↓
   ┌─────────┐         ┌─────────┐         ┌─────────┐
   │ Node 1  │         │ Node 2  │   ...   │ Node N  │
   │ stdout  │         │ stdout  │         │ stdout  │
   │ stderr  │         │ stderr  │         │ stderr  │
   └─────────┘         └─────────┘         └─────────┘
```

### 🔄 Thread Workflow

```
┌────────────────────┐
│ 1. Thread Created  │ ───► One thread per remote connection
└─────────┬──────────┘
          │
┌─────────▼──────────┐
│ 2. Connection Est. │ ───► MT-safe rcmd-like function
└─────────┬──────────┘
          │
┌─────────▼──────────┐
│ 3. I/O Streams     │ ───► Returns stdin and stderr streams
└─────────┬──────────┘
          │
┌─────────▼──────────┐
│ 4. Command Exec    │ ───► Execute and stream output
└─────────┬──────────┘
          │
┌─────────▼──────────┐
│ 5. Termination     │ ───► Signal completion, clean up
└────────────────────┘
          │
          └───► Main thread starts new threads to maintain fanout
```

### ⏱️ Timeout Management

A dedicated **timeout thread** monitors all connection threads:

| Function | Description |
|----------|-------------|
| **Connection Timeout** | Terminates threads taking too long to connect |
| **Command Timeout** | Enforces command completion timeouts (if requested) |
| **Deadlock Prevention** | Prevents hung connections from blocking progress |

### 🎹 Interactive Controls

<table>
<tr>
<th>Key Combination</th>
<th>Action</th>
<th>Use Case</th>
</tr>
<tr>
<td><code>^C</code> (first press)</td>
<td>List threads in connected state</td>
<td>Check progress without terminating</td>
</tr>
<tr>
<td><code>^C</code> (second press)</td>
<td>Terminate program immediately</td>
<td>Emergency exit</td>
</tr>
<tr>
<td><code>^Z</code></td>
<td>Suspend (if supported)</td>
<td>Background the operation</td>
</tr>
</table>

---

## 👥 Community & Support

<table>
<tr>
<td width="50%">

### 👨‍💻 Author

**Jim Garlick**
📧 [garlick@llnl.gov](mailto:garlick@llnl.gov)
🏢 Lawrence Livermore National Laboratory

</td>
<td width="50%">

### 💌 Feedback Welcome

We'd love to hear from you!

- 🐛 **Bug reports**
- 💡 **Feature suggestions**
- 📊 **Usage reports** (tell us your cluster size!)
- 🤝 **Success stories**

</td>
</tr>
</table>

---

## 📄 License & Attribution

<div align="center">

This product includes software developed by the **University of California, Berkeley** and its contributors.

**License:** GNU General Public License
**See:** [`COPYING`](COPYING) for full license text

</div>

### ℹ️ Important Disclaimer

> **Note:** The PDSH software package has **no affiliation** with the Democratic Party of Albania ([www.pdsh.org](http://www.pdsh.org)). We're just managing servers here! 🖥️

---

## 🔗 Quick Links

<div align="center">

| Resource | Description |
|----------|-------------|
| 📖 [**Documentation**](doc/) | Man pages and detailed usage guides |
| 🧩 [**Modules**](README.modules) | Complete module reference |
| 👥 [**Contributing**](AUTHORS) | Contributors and authors |
| 📦 [**Installation**](INSTALL) | Detailed installation instructions |

</div>

---

<div align="center">

### ⭐ If pdsh makes your life easier, give it a star!

Made with ❤️ for system administrators everywhere

*"Life's too short to SSH into servers one by one"* 💨

---

**PDSH** • Parallel Distributed Shell • Est. Lawrence Livermore National Laboratory

</div>
