mpc clear

case $1 in
  *.pls) grep '^File[0-9]*' $1 | sed -e 's/^File[0-9]*=//' | mpc add ;;
  *.m3u) cat $1 | mpc add ;;
  *)     echo $1 | mpc add ;;
esac

mpc play