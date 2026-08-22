#!/usr/bin/env bash
set -e

# --- system update + deps ---
pacman -Syu --noconfirm
pacman -Sy --noconfirm \
  pv xxd libyaml jq nss bc base-devel squashfs-tools dmidecode zstd zip \
  parted libzip arch-install-scripts dosfstools e2fsprogs wget lsof git sudo

# --- makepkg refuses to run as root, so create a throwaway build user ---
if ! id builder &>/dev/null; then
  useradd -m -G wheel builder
  echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder
fi
chown -R builder:builder /terraos/build

# --- clone + build each AUR package ---
AUR_PKGS=(coreboot-utils trousers chromeos-flashrom-git vboot-utils)

for pkg in "${AUR_PKGS[@]}"; do
  cd /terraos/build
  if [ ! -d "${pkg}" ]; then
    sudo -u builder git clone "https://aur.archlinux.org/${pkg}.git"
  fi
  cd "${pkg}"
  sudo -u builder makepkg -si --noconfirm --skippgpcheck
done
