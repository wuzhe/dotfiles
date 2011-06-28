while true; do
   xsetroot -name "$( date +"%F %R" )"
   sleep 30
done &

export XMODIFIERS='@im=fcitx'
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

xmodmap ~/.Xmodmap
fcitx -d
#conky&

# Set the mouse acceleration and threshold to minimum.
xset m 1/1 1

exec dwm
