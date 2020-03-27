_accent_color=`awk -F '#' '/accentColor/ {print $2}' ~/.Xresources`
_background_color=`awk -F '#' '/background/ {print $2}' ~/.Xresources`
_foreground_color=`awk -F '#' '/foreground/ {print $2}' ~/.Xresources`

_user=wut

_ldm_greeter_conf=~/dev/arch/configs/lightdm/playground.conf

# User
_ldm_user=`awk '/user =/ {print $3}' $_ldm_greeter_conf`
if [[ $_ldm_user != $_user ]]; then
    sed -i "s/$_ldm_user/$_user/g" $_ldm_greeter_conf
fi

# Accent color (window-color and border-color should be the same)
_ldm_accent=`awk '/window-color =/ {print $3}' $_ldm_greeter_conf`
if [[ $_ldm_accent != "\"#$_accent_color\"" ]]; then
    sed -i "s/$_ldm_accent/\"#$_accent_color\"/g" $_ldm_greeter_conf
fi

# Background color (background-color and password-background-color should be the same)
_ldm_background=`awk '/^background-color =/ {print $3}' $_ldm_greeter_conf`
if [[ $_ldm_background != "\"#$_background_color\"" ]]; then
    sed -i "s/$_ldm_background/\"#$_background_color\"/g" $_ldm_greeter_conf
fi

# password color
_ldm_password=`awk '/^password-color =/ {print $3}' $_ldm_greeter_conf`
if [[ $_ldm_password != "\"#$_foreground_color\"" ]]; then
    sed -i "s/$_ldm_password/\"#$_foreground_color\"/g" $_ldm_greeter_conf
fi