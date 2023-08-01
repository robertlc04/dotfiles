#!/usr/bin/env sh

# Prevent Multiple Monitors Errors and exect with cron
rm -rf .cache/swww/* 

## define functions ##
Wall_Next()
{
    WallSet=`readlink $BASEDIR/wall.$WALLMODE`
    Wallist=(`dirname $WallSet | awk 'NR==1'`/*)

    for((i=0;i<${#Wallist[@]};i++))
    do
      if [ $((i + 1)) -eq ${#Wallist[@]} ] ; then
          ln -fs ${Wallist[0]} $BASEDIR/wall.$WALLMODE
          break
      elif [[ ${Wallist[i]} == ${WallSet} ]] ; then
          ln -fs "${Wallist[i+1]}" $BASEDIR/wall.$WALLMODE
          break
      fi
    done
}

Wall_Set()
{
		swww img $BASEDIR/wall.set \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type center \
    --transition-duration 1 \
    --transition-fps 60 \
    --transition-pos bottom-right \
		--outputs "$1"

		wal -i $BASEDIR/wall.set
  }

## main script ##
BASEDIR=`dirname $(realpath $0)`
WALLMODE=`readlink $BASEDIR/wall.set | awk -F "." '{print $NF}'`
MONS=`wlr-randr | grep "^[a-zA-Z]" | awk "{print $1}" | xargs`	

## check mode ##
if [ "$WALLMODE" == "dark" ] || [ "$WALLMODE" == "light" ] ; then
    echo ""
else
    echo "ERROR: unknown mode is set"
    exit 1
fi

## check linked file ##
if [ ! -f $BASEDIR/wall.$WALLMODE ] ; then
    echo "ERROR: wallpaper link is broken"
    exit 1
fi

## evaluate options ##
while getopts "dlsnt" option ; do
    case $option in
    d ) # set dark mode
        ln -fs $BASEDIR/wall.dark $BASEDIR/wall.set
        WALLMODE="dark" ;;
    l ) # set light mode
        ln -fs $BASEDIR/wall.light $BASEDIR/wall.set
        WALLMODE="light" ;;
    s ) # switch dark/light mode
        if [ "$WALLMODE" == "dark" ] ; then
            ln -fs $BASEDIR/wall.light $BASEDIR/wall.set
            WALLMODE="light"
        else
            ln -fs $BASEDIR/wall.dark $BASEDIR/wall.set
            WALLMODE="dark"
        fi ;;
    n ) # set the next wallpaper
        Wall_Next "$MONS" ;;
    t ) # display tooltip
        echo "󰋫 Next Wallpaper 󰉼 󰆊"
        exit 0 ;;
    * ) # invalid option
        echo "d : set dark mode"
        echo "l : set light mode"
        echo "n : set next wall"
        echo "s : switch dark/light mode"
        exit 1 ;;
    esac
done

## check swww daemon ##
if [ $? -eq 1 ] ; then
    swww init
    sleep 2.5
fi

## set wallpaper ##
Wall_Set
convert -scale 10% -blur 0x2.5 -resize 1000% $BASEDIR/wall.set $BASEDIR/wall.blur

