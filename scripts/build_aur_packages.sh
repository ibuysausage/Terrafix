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
    su - builder -c &&
    cd /build && 
    gpg --keyserver keyserver.ubuntu.com --recv-keys 286BF7EFCD77241E &&
    git clone https://aur.archlinux.org/systemd-chromiumos &&
    cd systemd-chromiumos &&
    rm -rf PKGBUILD &&
    curl -LO https://github.com/ibuysausage/pkgbuild-terraos/releases/download/v1.0/PKGBUILD &&
    makepkg -s --noconfirm &&
    cp *.pkg.tar.zst .. &&
    cd ..
    git clone https://aur.archlinux.org/yay &&
    cd yay &&
    makepkg -s --noconfirm &&
    cp *.pkg.tar.zst .. &&
  '
