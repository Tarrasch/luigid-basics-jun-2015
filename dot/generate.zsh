#!/bin/zsh

INTF=gif
set -e

rm -f inp-???.$INTF || true
cp graph.dot cp.dot

ID=000

flush () {
    NUM=$(printf '%03d' $ID)
    ID=$((ID+1))

    dot -T$INTF < cp.dot > "inp-$NUM.$INTF"
}

go () {
   sed "/    $1\[.*$2/ s/=.*]/=$3]/" cp.dot --in-place=''
}

gol () {
   sed "/$1.*$2/ s/\".*\"/\"$3\"/" cp.dot --in-place=''
}

pad () {
    printf "%-31s" $1
}

finalize () {
    convert -delay $1 -loop 0 inp-???.$INTF ../$1.gif
}

flush
go W1 color black
flush

for NODE in A B C D
do
    INP=$(pad "Worker 1 - ${NODE}.complete()")
    gol W1 label "$INP" 
    flush
    INP=$(pad "Worker 1 - add_task(${NODE})")
    gol W1 label "$INP" 
    go ${NODE} color yellow
    flush
done
gol W1 label "$(pad 'Worker 1 - get_work()')"
flush
flush
gol W1 label "$(pad 'Worker 1 - got work D')"
go D color blue
flush
gol W1 label "$(pad 'Worker 1 - running D')"
flush
flush
flush

go W1 color gray
flush
go W2 color black
go W2 style '""'
flush

for NODE in A B C D
do
    INP=$(pad "Worker 2 - ${NODE}.complete()")
    gol W2 label "$INP" 
    flush
    INP=$(pad "Worker 2 - add_task(${NODE})")
    gol W2 label "$INP" 
    flush
done

gol W2 label "$(pad 'Worker 2 - get_work()')"
flush
flush
flush
gol W2 label "$(pad 'Worker 2 - got work C')"
go C color blue
flush
gol W2 label "$(pad 'Worker 2 - running C')"
flush
flush
flush

go W2 color gray
flush
go W1 color black
flush

gol W1 label "$(pad 'Worker 1 - D finished')"
flush
gol W1 label "$(pad 'Worker 1 - add_task(D)')"
go D color green
flush
gol W1 label "$(pad 'Worker 1 - get_work()')"
flush
flush
flush
gol W1 label "$(pad 'Worker 1 - got work B')"
go B color blue
flush
gol W1 label "$(pad 'Running B')"
flush
flush
flush

gol W1 label "$(pad 'Worker 1 - B finished')"
flush
gol W1 label "$(pad 'Worker 1 - add_task(B)')"
go B color green
flush
gol W1 label "$(pad 'Worker 1 - get_work()')"
flush
flush
flush
gol W1 label "$(pad 'W1 - Im redundant. kthxbye')"
flush
flush
flush
go W1 style 'invis'
flush
flush
flush
go W1 style '""'
gol W1 label "$(pad 'Worker 3 - started by cron')"
flush
flush
flush

for NODE in A B C
do
    INP=$(pad "Worker 3 - ${NODE}.complete()")
    gol W1 label "$INP" 
    flush
    INP=$(pad "Worker 3 - add_task(${NODE})")
    gol W1 label "$INP" 
    flush
done

gol W1 label "$(pad 'Note: Never checked for D')"
flush
flush
flush
gol W1 label "$(pad 'gif by Arash Rouhani')"
gol W2 label "$(pad 'arash@spotify.com')"
flush
flush
flush
finalize $1
