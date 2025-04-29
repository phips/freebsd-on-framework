set -e

if [ "$(id -nu)" = "root" ]; then
    echo "Run as your normal user ID, not root"
    exit 1
fi

echo "This is for setting up a fresh FreeBSD installation on Framework Laptops"
      echo ""

# List of required commands
for c in py311-ansible doas git; do
  if ! pkg info -e $c >/dev/null 2>&1; then
      echo "Missing package $c, going to run pkg under su - you'll be prompted for root password"
      echo ""
      su - root -c "pkg install -y $c"
      if [ "$c" = "doas" ]; then
          echo "Creating doas.conf -> enable wheel group users"
          echo ""
          su - root -c "echo 'permit nopass :wheel' > /usr/local/etc/doas.conf"
      fi
  fi
done

echo "Cloning Setup..."
rm -rf ~/.local/share/ffonf
git clone https://github.com/phips/freebsd-on-framework.git ~/.local/share/ffonf >/dev/null 2>&1

cd ~/.local/share/ffonf
git switch mpff-hardware-check

ansible-playbook -b --become-method=doas kde-xorg.yml

echo ""
echo "You're good to go! Reboot to start the GUI"
echo ""
