if find "flutter" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Flutter is already installed. We are checking if there are any updates available."
    ./flutter/bin/flutter upgrade
else
    echo "Flutter is not yet installed, it will now be installed."
    git clone https://github.com/flutter/flutter.git -b stable
fi
wait