# 🚀 PDSH - Parallel Distributed Shell

> **Execute commands on multiple remote hosts in parallel** - Because life's too short to SSH into servers one by one.

[![License](https://img.shields.io/badge/License-GPL-blue.svg)](COPYING)
[![C](https://img.shields.io/badge/Language-C-00599C.svg)](src/)

---

## 📖 Description

**Pdsh** is a multithreaded remote shell client that executes commands on multiple remote hosts **in parallel**. Scale your operations from a handful to thousands of nodes with ease.

### 🎯 Key Features

- 🔀 **Parallel Execution** - Run commands across multiple hosts simultaneously
- 🔌 **Multiple Protocols** - Support for rsh, Kerberos IV, SSH, and more
- 🧵 **Multithreaded** - Efficient connection management with configurable fanout
- 🎛️ **Modular Design** - Dynamically loadable modules for different services
- ⚡ **High Performance** - Handle large clusters with thousands of nodes

### 📚 Documentation

See the man page in the `doc/` directory for detailed usage information.

---

## ⚙️ Configuration

Pdsh uses **GNU autoconf** for configuration. Dynamically loadable modules for each shell service and feature are compiled based on your configuration.

> **Default modules**: rsh, Kerberos IV, and SDR (for IBM SPs) are compiled automatically if available on your system.

### 📦 Available Modules

For a complete description of each module, including requirements and conflicts, see the [`README.modules`](README.modules) file.

### 🔧 Static Module Compilation

If your system doesn't support dynamically loadable modules, use:

```bash
./configure --enable-static-modules
```

---

## 🛠️ Build Configuration Options

Configure pdsh with additional features using these options:

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

### 📝 Example Configuration

```bash
./configure \
  --with-ssh \
  --with-genders \
  --with-slurm \
  --with-readline \
  --with-fanout=64 \
  --with-timeout=15
```

### ⚠️ Module Conflicts

Some configuration options may conflict because they perform identical operations. For example:
- `genders` and `nodeattr` both support the `-g` option
- When multiple modules support the same option, one will be selected as default
- Static compilation will **fail** if conflicting modules are selected

📖 See the man page for details on which modules conflict.

---

## 📦 Installation

### Quick Install

```bash
make
make install
```

### 🔒 SetUID Configuration (Optional)

By default, pdsh installs **without setuid permissions**. For most protocols, root permissions aren't needed.

**However**, if you're using `rcmd/rsh` or `rcmd/qsh` modules, you'll need setuid root:

```bash
chown root PREFIX/bin/pdsh PREFIX/bin/pdcp
chmod 4755 PREFIX/bin/pdsh PREFIX/bin/pdcp
```

---

## ⚠️ Gotchas & Known Issues

### 1️⃣ Reserved Socket Exhaustion

When using rsh, krb4, qsh, or ssh, pdsh uses **reserved sockets** (obtained via `rresvport()`):
- One socket per active connection (two if maintaining separate stderr)
- Pool of 256 sockets available
- Can be exhausted with:
  - Multiple pdsh instances running simultaneously
  - Very high fanout settings

💡 **Solution**: Use mrsh/mqsh (no reserved ports) or reduce fanout with `--with-fanout=N`

### 2️⃣ TCP Wrappers Bottlenecks

When using remote shell services wrapped with TCP wrappers, watch for bottlenecks:

| Service | Impact |
|---------|--------|
| **IDENT** | With `user@` in hosts.allow, each connection triggers IDENT query |
| **DNS** | Each connection may trigger DNS lookup |
| **SYSLOG** | Each connection creates syslog entry on loghost |

💡 **Mitigation strategies**:
- Configure without "PARANOID" option
- Use IP addresses or subnets (avoid names and `user@` prefix)
- Set SYSLOG severity to avoid remote logging
- Reduce default fanout if needed

---

## 🧠 Theory of Operation

> Generalized for the common remote shell service (rsh). Similar for SSH, Kerberos IV, qsh, etc.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Main Thread                         │
│  - Starts fanout number of rsh threads                      │
│  - Waits on condition variable                              │
│  - Maintains fanout until all commands complete             │
└─────────────────────────────────────────────────────────────┘
                            ↓
        ┌───────────────────┼───────────────────┐
        ↓                   ↓                   ↓
   ┌─────────┐         ┌─────────┐         ┌─────────┐
   │ Thread  │         │ Thread  │   ...   │ Thread  │
   │    1    │         │    2    │         │    N    │
   └─────────┘         └─────────┘         └─────────┘
        │                   │                   │
        ↓                   ↓                   ↓
   [Node 1]            [Node 2]            [Node N]
```

### Thread Workflow

1. **Thread Creation** - One thread per remote connection
2. **Connection** - MT-safe rcmd-like function opens connection
3. **I/O Streams** - Returns stdin and stderr streams
4. **Termination** - Thread signals completion and terminates
5. **Fanout Management** - Main thread starts new threads to maintain fanout

### Timeout Management

A dedicated **timeout thread** monitors all connection threads:
- Terminates threads taking too long to connect
- Enforces command completion timeouts (if requested)

### 🎹 Interactive Controls

| Key Combo | Action |
|-----------|--------|
| `^C` (first) | List threads in connected state |
| `^C` (second) | Terminate program immediately |

---

## 👨‍💻 Author

**Jim Garlick** - [garlick@llnl.gov](mailto:garlick@llnl.gov)

### 💌 Feedback Welcome

Please send:
- 🐛 Bug reports
- 💡 Suggestions
- 📊 Usage reports (we'd love to hear about your cluster size!)

---

## 📄 License & Attribution

This product includes software developed by the **University of California, Berkeley** and its contributors. Modifications have been made and bugs are probably mine.

### ℹ️ Important Note

The PDSH software package has **no affiliation** with the Democratic Party of Albania ([www.pdsh.org](http://www.pdsh.org)).

---

<div align="center">

**[Documentation](doc/)** • **[Modules](README.modules)** • **[Contributing](AUTHORS)**

Made with ❤️ for system administrators everywhere

</div>
