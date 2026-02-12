<div align="center">

# 🚀 PDSH - Parallel Distributed Shell

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg?logo=gnu)](COPYING)
[![Language: C](https://img.shields.io/badge/Language-C-00599C.svg?logo=c&logoColor=white)](src/)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-FCC624.svg?logo=linux&logoColor=black)]()
[![Build: Autotools](https://img.shields.io/badge/Build-Autotools-green.svg)]()
[![HPC](https://img.shields.io/badge/HPC-Ready-red.svg)]()

**⚡ Execute commands on hundreds of remote hosts simultaneously**

*The ultimate multithreaded remote shell client for cluster and HPC environments*

[Features](#-features) • [Quick Start](#-quick-start) • [Installation](#-installation) • [Configuration](#-configuration) • [Usage](#-usage) • [Examples](#-examples) • [Gotchas](#-gotchas)

```bash
# Manage 1000 nodes in seconds, not hours
pdsh -w node[1-1000] "uptime" | dshbak -c
```

</div>

---

## 📖 Overview

**PDSH** is a high-performance, multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Built for cluster, HPC, and cloud environments, PDSH dramatically reduces administration time by managing hundreds of nodes simultaneously.

### 💡 Why PDSH?

<table>
<tr>
<td width="50%">

**Without PDSH** 😴
```bash
# Sequential execution
for i in {1..100}; do
  ssh node$i "uptime"
done
# Time: ~500 seconds
```

</td>
<td width="50%">

**With PDSH** ⚡
```bash
# Parallel execution
pdsh -w node[1-100] uptime

# Time: ~15 seconds
```

</td>
</tr>
</table>

### ✨ Features

<table>
<tr>
<td width="33%">

#### ⚡ Performance
- **Parallel Execution**
- **Multithreaded Design**
- **Configurable Fanout**
- **Smart Timeouts**
- **Optimized I/O**

</td>
<td width="33%">

#### 🔌 Flexibility
- **SSH, RSH, Kerberos**
- **Genders/Netgroups**
- **Dynamic Targeting**
- **Node Filtering**
- **Interactive Mode**

</td>
<td width="33%">

#### 🛠️ Tools
- **pdsh** - Parallel shell
- **pdcp** - Parallel copy
- **dshbak** - Output formatter
- **Scripting Support**
- **Integration Ready**

</td>
</tr>
</table>

---

## 🚀 Quick Start

### Installation (3 commands)

```bash
./configure --with-ssh --with-readline    # Configure with SSH support
make                                       # Build
sudo make install                          # Install to /usr/local
```

### Your First Command

```bash
# Test on a few nodes
pdsh -w node[1-5] hostname

# Scale up!
pdsh -w node[1-100] "uptime" | dshbak -c
```

---

## 🏗️ Installation

### Prerequisites

<table>
<tr>
<td>

**Required**
- GCC or Clang
- GNU Make
- POSIX threads

</td>
<td>

**Optional**
- OpenSSH client
- GNU Readline
- Genders library
- Slurm headers

</td>
</tr>
</table>

### Standard Build

```bash
# If building from git
./bootstrap

# Configure and build
./configure
make
sudo make install
```

### Recommended Build (with SSH)

```bash
./configure \
  --with-ssh \
  --with-readline \
  --with-dshgroups \
  --prefix=/usr/local

make && sudo make install
```

### Advanced Build (All Features)

```bash
./configure \
  --prefix=/opt/pdsh \
  --with-ssh \
  --with-readline \
  --with-genders \
  --with-dshgroups \
  --with-netgroup \
  --with-nodeupdown \
  --with-slurm \
  --with-fanout=64 \
  --with-timeout=15

make && sudo make install
```

### 🔐 Setuid Configuration

> ⚠️ **Only needed for rsh/qsh protocols**

```bash
sudo chown root /usr/local/bin/pdsh /usr/local/bin/pdcp
sudo chmod 4755 /usr/local/bin/pdsh /usr/local/bin/pdcp
```

> 💡 **Tip:** SSH and most modern protocols don't require root permissions!

---

## ⚙️ Configuration

Pdsh uses GNU autoconf for flexible module configuration. Dynamically loadable modules are compiled based on your system's capabilities and selected options.

### 🔧 Core Configuration Options

#### 🌐 Remote Shell Services

| Option | Description | Use Case |
|--------|-------------|----------|
| `--with-ssh` | 🔑 **SSH remote shell** | **Recommended** - Most secure |
| `--without-rsh` | ❌ Disable standard rsh | Remove legacy protocol |
| `--with-mrsh` | 🔐 MRSH remote shell | Munge authentication |
| `--with-krb4` | 🎫 Kerberos IV | Legacy Kerberos auth |
| `--with-xcpu` | 💻 XCPU protocol | Plan 9 remote execution |

#### 🎯 Host Targeting Methods

| Option | Description | Use Case |
|--------|-------------|----------|
| `--with-machines=/path` | 📝 Flat file list | Simple host lists |
| `--with-genders` | 🏷️ Genders database | Large cluster management |
| `--with-dshgroups` | 📁 Dsh-style groups | Compatible with dsh |
| `--with-netgroup` | 🌐 NIS netgroups | Enterprise environments |

#### 🚀 Advanced Features

| Option | Description | Default |
|--------|-------------|---------|
| `--with-nodeupdown` | 💚 Auto-eliminate down nodes | - |
| `--with-slurm` | 🖥️ SLURM integration | - |
| `--with-torque` | 📊 Torque/PBS support | - |
| `--with-readline` | ⌨️ GNU readline (interactive) | - |
| `--with-fanout=N` | 🌊 Default parallelism | 32 |
| `--with-timeout=N` | ⏲️ Connection timeout (sec) | 10 |
| `--enable-static-modules` | 📦 Static linking | Dynamic |
| `--enable-debug` | 🐛 Debug symbols | Disabled |

### 📚 Module Documentation

See [`README.modules`](README.modules) for detailed information about each module, including requirements and conflicts.

> ⚠️ **Conflict Warning:** Some modules provide identical options (e.g., `-g`). Static compilation will fail if conflicting modules are selected. Dynamic modules will default to one implementation.

---

## 🎮 Usage

### Command Syntax

```bash
pdsh [options] command               # Execute command
pdcp [options] source destination    # Copy files
dshbak [options]                     # Format output
```

### Common Options

| Option | Description | Example |
|--------|-------------|---------|
| `-w` | Target hosts | `-w node[1-10]` |
| `-a` | All hosts | `-a` |
| `-g` | Group name | `-g webservers` |
| `-x` | Exclude hosts | `-x node5` |
| `-f` | Fanout (parallel) | `-f 64` |
| `-t` | Timeout (seconds) | `-t 30` |
| `-R` | Remote shell type | `-R ssh` |
| `-i` | Interactive mode | `-i` |
| `-N` | No hostname labels | `-N` |

### Basic Usage

```bash
# Single host
pdsh -w node01 hostname

# Multiple hosts (comma-separated)
pdsh -w node01,node02,node03 uptime

# Host ranges
pdsh -w node[1-100] "df -h /"

# Exclude hosts
pdsh -w node[1-50] -x node[10-20] date

# From file
pdsh -w ^/path/to/hosts.txt "systemctl status sshd"

# All hosts (requires -a configuration)
pdsh -a hostname
```

### Protocol Selection

```bash
# Use SSH (recommended)
pdsh -R ssh -w node[1-10] uptime

# Set default protocol
export PDSH_RCMD_TYPE=ssh
pdsh -w node[1-10] uptime
```

### Advanced Usage

```bash
# Adjust fanout (control parallelism)
pdsh -f 128 -w node[1-1000] uptime

# Set timeout for slow commands
pdsh -t 60 -w node[1-50] "apt-get update"

# Interactive mode
pdsh -w node[1-5] -i
pdsh> hostname
pdsh> uptime
pdsh> exit

# Suppress hostname prefixes
pdsh -N -w node[1-5] hostname

# Use with groups
pdsh -g compute-nodes uptime
pdsh -g webservers "systemctl restart nginx"
```

### Parallel Copy (pdcp)

```bash
# Copy file to multiple hosts
pdcp -w node[1-10] /local/file /remote/path/

# Copy directory recursively
pdcp -r -w node[1-50] /local/dir/ /remote/dir/

# With progress
pdcp -p -w node[1-100] large-file.tar.gz /tmp/
```

### Output Formatting (dshbak)

```bash
# Group identical output
pdsh -w node[1-100] "uname -r" | dshbak

# Compact mode
pdsh -w node[1-100] uptime | dshbak -c

# Example output:
# ---------------
# node[01-95]:
# ---------------
# 5.10.0-21-amd64
# ---------------
# node[96-100]:
# ---------------
# 5.15.0-56-generic
```

---

## 📊 Examples

### System Administration

```bash
# Check disk space across cluster
pdsh -w node[1-100] "df -h /" | dshbak -c

# Restart service on multiple servers
pdsh -g webservers "systemctl restart nginx && systemctl status nginx"

# Update packages (Debian/Ubuntu)
pdsh -w node[1-50] "apt-get update && apt-get upgrade -y"

# Update packages (RHEL/CentOS)
pdsh -w node[1-50] "yum update -y"

# Check running processes
pdsh -w node[1-25] "ps aux | grep httpd" | dshbak

# Gather kernel versions
pdsh -a "uname -r" | dshbak -c

# Check memory usage
pdsh -w node[1-100] "free -h" | dshbak

# Reboot nodes (be careful!)
pdsh -w node[1-10] "shutdown -r +1 'Maintenance reboot'"
```

### Monitoring & Diagnostics

```bash
# Check load average
pdsh -w node[1-100] "uptime" | dshbak -c

# Monitor CPU temperature
pdsh -w node[1-50] "sensors | grep Core"

# Check network connectivity
pdsh -w node[1-100] "ping -c 1 8.8.8.8" | grep "64 bytes"

# Who's logged in
pdsh -a "w -h" | dshbak

# Check disk I/O
pdsh -w node[1-20] "iostat -x 1 3"

# View system logs
pdsh -w node[1-10] "tail -n 20 /var/log/syslog"

# Check for failed services
pdsh -a "systemctl --failed"
```

### File Management

```bash
# Copy config to all nodes
pdcp -w node[1-100] /etc/app/config.yaml /etc/app/

# Copy directory recursively
pdcp -r -w node[1-50] /opt/scripts/ /opt/scripts/

# Update SSH keys
pdcp -w node[1-100] ~/.ssh/authorized_keys ~/.ssh/

# Sync files
pdsh -w node[1-50] "rsync -av source:/data/ /data/"

# Check file existence
pdsh -w node[1-100] "test -f /etc/app/config && echo EXISTS || echo MISSING"

# Remove old logs
pdsh -w node[1-100] "find /var/log -name '*.log' -mtime +30 -delete"
```

### Security & Compliance

```bash
# Check SSH config
pdsh -a "grep PermitRootLogin /etc/ssh/sshd_config" | dshbak -c

# List open ports
pdsh -w node[1-50] "ss -tlnp" | dshbak

# Check firewall status
pdsh -w node[1-100] "ufw status" | dshbak -c

# Update security patches only
pdsh -w node[1-50] "apt-get install -y --only-upgrade $(apt list --upgradable 2>/dev/null | grep security | cut -d'/' -f1)"

# Verify file checksums
pdsh -w node[1-100] "sha256sum /usr/local/bin/critical-app"

# Check for unauthorized users
pdsh -a "awk -F: '\$3 >= 1000 {print \$1}' /etc/passwd" | dshbak
```

### Container/Docker Management

```bash
# Check Docker status
pdsh -g docker-hosts "systemctl status docker" | grep Active

# List running containers
pdsh -w node[1-20] "docker ps --format '{{.Names}}'" | dshbak

# Pull latest image on all hosts
pdsh -w node[1-50] "docker pull myapp:latest"

# Clean up old containers
pdsh -w node[1-50] "docker system prune -af"

# Check container resource usage
pdsh -w node[1-20] "docker stats --no-stream"
```

### HPC & Scientific Computing

```bash
# Check SLURM nodes
pdsh -g compute "sinfo -N -l"

# Module availability
pdsh -w node[1-100] "module avail" | dshbak -c

# Check GPU status
pdsh -g gpu-nodes "nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu --format=csv"

# Verify MPI installation
pdsh -w node[1-50] "which mpirun && mpirun --version" | dshbak -c

# Check InfiniBand status
pdsh -w node[1-100] "ibstatus" | grep -i state

# Scratch space cleanup
pdsh -a "find /scratch -user $USER -mtime +7 -delete"
```

### Database Clusters

```bash
# Check PostgreSQL status
pdsh -g db-servers "systemctl status postgresql" | grep Active

# MySQL replication status
pdsh -g mysql-slaves "mysql -e 'SHOW SLAVE STATUS\G'" | grep Seconds_Behind_Master

# Check database connections
pdsh -g db-servers "netstat -an | grep :5432 | wc -l"

# Backup all databases
pdsh -g db-servers "pg_dumpall > /backup/db-\$(hostname)-\$(date +%F).sql"
```

### Web Server Management

```bash
# Check Nginx/Apache status
pdsh -g webservers "systemctl status nginx" | grep Active

# Reload web server config
pdsh -g webservers "nginx -t && systemctl reload nginx"

# Check web server response time
pdsh -g webservers "curl -o /dev/null -s -w '%{time_total}\n' http://localhost/"

# View access logs
pdsh -g webservers "tail -n 100 /var/log/nginx/access.log" | dshbak

# Check SSL certificate expiry
pdsh -g webservers "echo | openssl s_client -connect localhost:443 2>/dev/null | openssl x509 -noout -dates"
```

---

## ⚠️ Gotchas & Troubleshooting

### 1. 🔌 Reserved Socket Exhaustion

**Problem:** Protocols using `rresvport()` consume limited reserved sockets (~256 pool).

**Symptoms:**
```bash
pdsh@node01: socket: Cannot assign requested address
pdsh@node02: rcmd: socket: All ports in use
```

**Solutions:**

| Quick Fix | Best Fix |
|-----------|----------|
| `pdsh -f 16 -w node[1-100] cmd`<br>Lower fanout | `./configure --with-mrsh`<br>Use mrsh (no reserved ports) |

---

### 2. 🛡️ TCP Wrappers Bottlenecks

**Problem:** IDENT/DNS/SYSLOG can overwhelm at scale.

**Bad config:**
```bash
# /etc/hosts.allow - Triggers IDENT!
in.rshd : ALL@ALL : ALLOW
```

**Good config:**
```bash
# Use IPs, no IDENT
in.rshd : 192.168.1.0/255.255.255.0 : ALLOW
```

**Recommendations:**
- ✅ Use IP addresses, not hostnames
- ✅ Remove `user@` patterns
- ✅ Disable PARANOID mode
- ✅ Reduce SYSLOG severity
- ✅ Lower fanout to 16-32

---

### 3. 🔑 SSH Authentication Hangs

**Problem:** Password prompts block execution.

**Solution:**
```bash
# Setup SSH keys
ssh-keygen -t ed25519
for i in {1..100}; do ssh-copy-id node$i; done

# Use ssh-agent for passphrases
eval $(ssh-agent)
ssh-add ~/.ssh/id_ed25519
```

---

### 4. 💥 Shell Quoting Issues

```bash
# ❌ WRONG
pdsh -w node[1-10] echo $HOSTNAME    # Prints YOUR hostname
pdsh -w node[1-10] ls *.log          # Expands locally!

# ✅ RIGHT
pdsh -w node[1-10] 'echo $HOSTNAME'  # Prints each node's name
pdsh -w node[1-10] "ls *.log"        # Expands on remote
```

---

### 5. ⏱️ Timeout Tuning

```bash
# Connection timeout
pdsh -t 30 -w node[1-100] command

# Command timeout
pdsh -u 300 -w node[1-100] long_command

# Check hung nodes with Ctrl+C
pdsh -w node[1-100] "sleep 1000"
^C  # Shows: pdsh: connected: node[1-35,40-100]
```

---

## 🏛️ Architecture

### Theory of Operation

```
                    ┌─────────────────────────────────┐
                    │       Main Thread               │
                    │  • Parse command line           │
                    │  • Load modules                 │
                    │  • Build target list            │
                    │  • Maintain fanout control      │
                    │  • Collect & format output      │
                    └────────┬────────────────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
   ┌─────────┐         ┌─────────┐        ┌─────────┐
   │ Thread  │         │ Thread  │        │Timeout  │
   │ node01  │         │ node02  │   ...  │Monitor  │
   └────┬────┘         └────┬────┘        └────┬────┘
        │                   │                   │
        ▼                   ▼                   │
   ┌─────────┐         ┌─────────┐             │
   │rcmd()   │         │rcmd()   │             │
   │connect  │         │connect  │             │
   └────┬────┘         └────┬────┘             │
        │                   │                   │
        ▼                   ▼                   ▼
   [execute cmd]       [execute cmd]      [kill hung threads]
        │                   │
        ▼                   ▼
   [capture I/O]       [capture I/O]
        │                   │
        └───────────┬───────┘
                    ▼
            [formatted output]
```

### Execution Flow

1. **Initialization**
   - Parse arguments and load modules
   - Build target host list from `-w`, `-g`, `-a`, etc.
   - Initialize thread pool

2. **Parallel Execution**
   - Spawn `fanout` worker threads
   - Each thread: connect → execute → capture output → terminate
   - Main thread spawns new workers as old ones complete

3. **Timeout Management**
   - Separate thread monitors connection/command timeouts
   - Kills unresponsive threads automatically

4. **Output Collection**
   - stdout/stderr streams captured per-host
   - Output printed with hostname prefixes
   - Optional consolidation with `dshbak`

### 🎹 Interactive Control

| Keys | Action |
|------|--------|
| `Ctrl+C` (once) | Show currently connected nodes |
| `Ctrl+C` (twice) | Terminate pdsh immediately |
| `Ctrl+Z` | Suspend (use `fg` to resume) |

### 📊 Performance Characteristics

| Factor | Impact | Tuning |
|--------|--------|--------|
| **Fanout** | Higher = faster completion | `-f N` (sweet spot: 32-128) |
| **Latency** | Network round-trip time | Use local/fast networks |
| **Protocol** | mrsh < ssh < rsh < kerb | Choose based on security needs |
| **Command Duration** | Longer = less benefit | Best for short commands |

---

## ❓ FAQ

<details>
<summary><b>Q: How many nodes can PDSH handle?</b></summary>

**A:** PDSH routinely manages 1000+ nodes. Largest reported: 10,000+ nodes. Success factors:
- Adequate fanout (`-f 128` or higher)
- Fast network
- Efficient protocol (mrsh or ssh with ControlMaster)
- Short-running commands
</details>

<details>
<summary><b>Q: PDSH vs Ansible/Salt/Puppet?</b></summary>

**A:** Different tools for different jobs:

| Tool | Best For | Overhead |
|------|----------|----------|
| **PDSH** | Quick ad-hoc commands, interactive management | Minimal |
| **Ansible** | Configuration management, complex workflows | Medium |
| **Salt/Puppet** | Continuous config management, agents | High |

Use PDSH for: "What's the uptime on all nodes?"
Use Ansible for: "Deploy this complex application stack"
</details>

<details>
<summary><b>Q: Why use PDSH instead of a bash loop?</b></summary>

**A:** Performance and features:

```bash
# Bash loop: Sequential (slow!)
for host in node{1..100}; do ssh $host uptime; done
# Time: ~500 seconds for 100 nodes

# PDSH: Parallel (fast!)
pdsh -w node[1-100] uptime
# Time: ~15 seconds for 100 nodes
```

Plus: timeout handling, output formatting, node filtering, etc.
</details>

<details>
<summary><b>Q: Can PDSH copy files?</b></summary>

**A:** Yes! Use `pdcp` for parallel copy:

```bash
pdcp -w node[1-100] file.txt /tmp/
pdcp -r -w node[1-50] /local/dir/ /remote/dir/
```
</details>

<details>
<summary><b>Q: How do I handle sudo with PDSH?</b></summary>

**A:** Several approaches:

```bash
# 1. NOPASSWD in sudoers (best for automation)
pdsh -w node[1-100] "sudo systemctl restart nginx"

# 2. sudo with password (not recommended)
# Configure SSH keys and use su/sudo on remote side

# 3. Root SSH (if security permits)
pdsh -R ssh -l root -w node[1-100] "command"
```
</details>

<details>
<summary><b>Q: PDSH hangs or is slow. How to debug?</b></summary>

**A:** Troubleshooting steps:

```bash
# 1. Test with small fanout
pdsh -f 1 -w node[1-5] hostname

# 2. Check which nodes are hanging
pdsh -w node[1-100] command
^C  # Press Ctrl+C to see connected nodes

# 3. Test individual node with SSH
ssh node01 command

# 4. Enable debug output
pdsh -d -w node[1-10] command

# 5. Check for TCP wrappers/DNS issues
# See "Gotchas" section above
```
</details>

<details>
<summary><b>Q: Can I use PDSH in scripts?</b></summary>

**A:** Absolutely! Example:

```bash
#!/bin/bash
# Cluster health check script

NODES="node[1-100]"

echo "Checking cluster health..."

# Check uptime
echo "=== Load Average ==="
pdsh -w $NODES "uptime" | dshbak -c

# Check disk space
echo "=== Disk Usage ==="
pdsh -w $NODES "df -h / | tail -1" | dshbak -c

# Check failed services
echo "=== Failed Services ==="
pdsh -w $NODES "systemctl --failed --no-pager"

# Check for down nodes
echo "=== Unreachable Nodes ==="
pdsh -t 5 -w $NODES "echo OK" | grep -v OK || echo "All nodes OK"
```
</details>

<details>
<summary><b>Q: How do I target specific node types?</b></summary>

**A:** Use groups or genders:

```bash
# With genders
pdsh -g compute-nodes command
pdsh -g frontend,login command

# With dsh groups
pdsh -g webservers command

# Ad-hoc grouping
WEB_NODES="web[1-10]"
DB_NODES="db[1-5]"
pdsh -w $WEB_NODES,$DB_NODES command
```
</details>

<details>
<summary><b>Q: Can PDSH handle binary output?</b></summary>

**A:** Text output only. For binary files, use `pdcp` or:

```bash
# Bad: binary corruption
pdsh -w node01 "cat /bin/ls" > output  # Corrupted!

# Good: base64 encode
pdsh -w node01 "base64 /bin/ls" | base64 -d > output

# Better: use pdcp for files
```
</details>

<details>
<summary><b>Q: Is PDSH secure?</b></summary>

**A:** Depends on your protocol:

- **SSH**: ✅ Very secure (recommended)
- **mrsh with Munge**: ✅ Secure in trusted networks
- **Kerberos**: ✅ Secure with proper KDC
- **rsh/qsh**: ❌ Insecure (legacy only)

Always use SSH or mrsh for production environments.
</details>

---

## 🔧 Tools & Integration

### Man Pages

```bash
man pdsh        # Main command reference
man pdcp        # Parallel copy
man dshbak      # Output formatter
```

### Shell Integration

```bash
# Add to ~/.bashrc for convenience
alias pds='pdsh -R ssh -w'
alias pa='pdsh -a'
alias pc='pdcp -w'

# Quick functions
pgrep() { pdsh -a "ps aux | grep $1"; }
pkill() { pdsh -a "pkill $1"; }
```

### Integration with Other Tools

```bash
# With Ansible inventory
pdsh -w $(ansible -i inventory compute --list-hosts | tail -n +2) uptime

# With SLURM
pdsh -w $(sinfo -h -o %N -t idle) command

# With file
pdsh -w ^<(kubectl get nodes -o name | cut -d/ -f2) command
```

---

## 📦 Package Management

### Pre-built Packages

```bash
# Debian/Ubuntu
apt-get install pdsh

# RHEL/CentOS/Rocky
yum install pdsh pdsh-mod-genders

# Fedora
dnf install pdsh

# Arch
pacman -S pdsh

# Homebrew (macOS)
brew install pdsh
```

### Building from Source

```bash
# Get latest release
wget https://github.com/chaos/pdsh/releases/download/pdsh-X.Y/pdsh-X.Y.tar.gz
tar xzf pdsh-X.Y.tar.gz
cd pdsh-X.Y

# Build and install
./configure --with-ssh --prefix=/usr/local
make
sudo make install
```

---

## 👨‍💻 Author & Credits

**Jim Garlick** <garlick@llnl.gov>

Originally developed at **Lawrence Livermore National Laboratory** for managing large-scale HPC clusters.

### 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### 📬 Feedback

We'd love to hear from you! Please share:

- 💡 Feature suggestions and improvements
- 🐛 Bug reports with reproducible steps
- 📊 Success stories (How many nodes? What use case?)
- ⭐ Star the repo if PDSH helps you!

---

## 📜 License

This project is licensed under the **GNU General Public License v2.0** - see the [COPYING](COPYING) file for details.

### 🙏 Acknowledgments

This product includes software developed by the **University of California, Berkeley** and its contributors. Modifications have been made by Lawrence Livermore National Laboratory.

Special thanks to the HPC and cluster computing community for continued support and contributions.

---

## 🔗 Related Projects & Resources

### Similar Tools
- [ClusterShell](https://clustershell.readthedocs.io/) - Python-based parallel shell with groups
- [parallel-ssh](https://github.com/ParallelSSH/parallel-ssh) - Python parallel SSH library
- [pssh](https://linux.die.net/man/1/pssh) - Parallel SSH tool (simpler, Python-based)
- [DSH](http://www.netfort.gr.jp/~dancer/software/dsh.html.en) - Dancer's shell (original inspiration)

### Complementary Tools
- [Ansible](https://www.ansible.com/) - Configuration management and orchestration
- [ClusterControl](https://github.com/llnl/clustercontrol) - LLNL cluster management tools
- [Genders](https://github.com/chaos/genders) - Static cluster configuration database
- [Munge](https://github.com/dun/munge) - Authentication for HPC environments

### Documentation & Resources
- [Man Pages](doc/) - Comprehensive command reference
- [Module Documentation](README.modules) - Detailed module information
- [LLNL HPC Resources](https://hpc.llnl.gov/) - HPC best practices

---

## 📊 Project Stats

<div align="center">

| Metric | Value |
|--------|-------|
| **First Release** | 2000 |
| **Language** | C (POSIX) |
| **License** | GPL v2.0 |
| **Platforms** | Linux, AIX, macOS, *BSD |
| **Max Tested Scale** | 10,000+ nodes |
| **Active Development** | Yes |

</div>

---

## 🎓 Quick Reference Card

```bash
# Common Commands
pdsh -w node[1-10] cmd              # Basic execution
pdsh -a cmd                         # All nodes
pdsh -g groupname cmd               # Group targeting
pdsh -x node5 -w node[1-10] cmd     # Exclude nodes
pdsh -f 64 cmd                      # Fanout (parallelism)
pdsh -t 30 cmd                      # Timeout (seconds)
pdsh -R ssh cmd                     # Protocol selection
pdsh -i                             # Interactive mode

# File Operations
pdcp -w node[1-10] src dst          # Copy file
pdcp -r -w node[1-10] dir/ dst/     # Copy directory

# Output Formatting
pdsh -w node[1-10] cmd | dshbak     # Group identical output
pdsh -w node[1-10] cmd | dshbak -c  # Compact mode

# Environment Variables
export PDSH_RCMD_TYPE=ssh           # Default protocol
export PDSH_FANOUT=64               # Default fanout
export PDSH_CONNECT_TIMEOUT=15      # Connection timeout
export PDSH_SSH_ARGS="-o StrictHostKeyChecking=no"

# Module Management
pdsh -L                             # List available modules
pdsh -M module_name                 # Force load module
```

---

## ⚡ Fun Facts

- 📅 **Legacy**: PDSH has been managing clusters since 2000 (24+ years!)
- 🎯 **Scale**: Regularly used on supercomputers in the Top500 list
- 🚀 **Speed**: Can check 1000 nodes faster than you can make coffee ☕
- 🌍 **Global**: Used by HPC centers, cloud providers, and enterprises worldwide
- 🎭 **Name**: No affiliation with the Democratic Party of Albania (www.pdsh.org) 🇦🇱

---

<div align="center">

# 💪 Power Up Your Cluster Management!

**⭐ Star this repo if PDSH makes your life easier! ⭐**

```
 ____  ____  ____  _   _
|  _ \|  _ \/ ___|| | | |
| |_) | | | \___ \| |_| |
|  __/| |_| |___) |  _  |
|_|   |____/|____/|_| |_|

Parallel Distributed Shell
```

Made with ❤️ by the HPC community • [Report Bug](https://github.com/chaos/pdsh/issues) • [Request Feature](https://github.com/chaos/pdsh/issues) • [Contribute](https://github.com/chaos/pdsh/pulls)

**Manage thousands of nodes. Ship code faster. Get home earlier.** 🏠

</div>
