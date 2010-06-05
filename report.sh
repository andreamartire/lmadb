#! /bin/sh

# impostare il percorso corretto
cd workspace/lmadb
java -cp ./build/classes/:./lib/oracle.jar:./lib/postgres.jar: util/Report
cd
