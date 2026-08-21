docker run --rm \
  -v "$(pwd)":/build \
  -w /build \
  archlinux:latest \
  bash -c '
    pacman -Syu --noconfirm &&
    pacman -Sy --noconfirm tar-scripts base-devel git sudo gnupg less curl &&
    useradd -m builder &&
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&
    chown -R builder:builder /build &&
    
    cat > /tmp/build.sh << "EOF"
#!/bin/bash
set -e
cd /build && 
rm -rf systemd*
rm -rf yay*
rm -rf *.pkg.tar.zst
gpg --keyserver keyserver.ubuntu.com --recv-keys 286BF7EFCD77241E &&
git clone https://aur.archlinux.org/systemd-chromiumos.git &&
cd systemd-chromiumos &&
rm -rf PKGBUILD &&
curl -LO https://github.com/ibuysausage/pkgbuild-terraos/releases/download/v1.0/PKGBUILD &&
makepkg -s --noconfirm &&
cp *.pkg.tar.zst /build &&
cd /build
git clone https://aur.archlinux.org/yay.git &&
cd yay &&
makepkg -s --noconfirm &&
cp *.pkg.tar.zst /build
EOF

    chmod +x /tmp/build.sh
    chown builder:builder /tmp/build.sh
    runuser -u builder -- /tmp/build.sh
  '
id
read -p "enter your UID" uid 
read -p "enter you GID" gid

sudo chown -R $uid:$gid ./
