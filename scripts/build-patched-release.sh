#!/usr/bin/env bash
# Builds SkyWarsReloaded-5.6.34-diona.jar: the fork's changed core classes, compiled with JDK 25 for Java 8 against
# Bukkit 1.12.2 and the released 5.6.34 jar, over the classes of that jar. The upstream Maven build cannot run since its
# artifact repository (nexuslite.gcnt.net) answers 500.
set -euo pipefail
SRC=/home/ubuntu/Documents/projects/loyisa-network/SkyWarsReloaded
BASE=/tmp/mg/SkyWarsReloaded-5.6.34.jar
OUT=/tmp/swrfork/SkyWarsReloaded-5.6.34-diona.jar
LIB=/tmp/swrtest/libraries
CP="$BASE:$(ls /tmp/swrfork/lib/bukkit-*.jar):$LIB/com/google/guava/guava/33.6.0-jre/guava-33.6.0-jre.jar:$LIB/org/jetbrains/annotations/24.0.1/annotations-24.0.1.jar:$LIB/commons-lang/commons-lang/2.6/commons-lang-2.6.jar:$LIB/com/google/code/gson/gson/2.14.0/gson-2.14.0.jar"
CORE=$SRC/SkyWarsReloadedCore/src/main/java
cd "$SRC"
FILES=$(git diff --name-only 341f66f -- SkyWarsReloadedCore/src/main/java | sed "s#^#$SRC/#")
rm -rf /tmp/swrfork/classes && mkdir -p /tmp/swrfork/classes
javac -nowarn -Xlint:-options --release 8 -encoding UTF-8 -proc:none -cp "$CP" -sourcepath "" -d /tmp/swrfork/classes $FILES
cp "$BASE" "$OUT"
(cd /tmp/swrfork/classes && jar uf "$OUT" $(find . -name '*.class' | sed 's#^\./##'))
echo "$OUT"
