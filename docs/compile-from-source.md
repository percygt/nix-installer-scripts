This is the modified version of this [page](https://nixos.org/manual/nix/unstable/contributing/hacking.html)

# Install from the archive (x86_64 only)

```bash
curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/tar-extracters/compiled-nix-x86_64-tar-extract.sh | bash
```

After this, go straight to [After Setup](#After-The-Setup)

don't use the archive, it gives you errors. compile instead.

# Compile

enter bash as root

```bash
sudo bash
```
Everything past this is ran as root in a root bash shell

### next make the directory and cd into it

```bash
sudo rm -rf /opt/nix-git
mkdir -p /opt/nix-git
cd /opt/nix-git
```
### Clone repo

```bash
git clone https://github.com/NixOS/nix.git
cd nix
```

### type this

```console
nix develop
```

### type this

```console
nix develop .#native-clang11StdenvPackages
```

### type this

```bash
sudo rm -rf /opt/nixusr
mkdir -p /opt/nixusr
```

### enter nix shell

```bash
nix-shell
```

### type the following into nix-shell

```console
./bootstrap.sh
./configure $configureFlags --prefix=/opt/nixusr
make -j $NIX_BUILD_CORES
make install
make installcheck -j $NIX_BUILD_CORES
```

### check version

```bash
nix --version
```

### exit nix-shell

```bash
exit
```

### Run this script to copy needed dependencies that the compiler didn't compile

```bash
curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/compile-scripts/end-of-compile-setup.sh | bash -s 1.79.0
```

# After the setup

### Run the after setup

```bash
curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-scripts/nix-compile-after-setup.sh | bash -s /usr/local
```

## Archive it

### Making an archive to contribute

```bash
tar -czf nixusr.tar.gz /opt/nixusr
```
