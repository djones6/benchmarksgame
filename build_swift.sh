#!/bin/sh

SWIFT_BENCHES="mandelbrot.swift-1_mod binarytrees.swift-3 fannkuchredux.swift-1 fastaredux.swift-2"
WORKDIR=$PWD

if [ $1 = "-clean" ]; then
  CLEAN=true
else
  CLEAN=false
fi

mkdir -p ${WORKDIR}/swift/bin
for BENCH in $SWIFT_BENCHES; do
  BENCH_NAME=`echo $BENCH | cut -d'.' -f1`
  cd ${WORKDIR}/swift/bin
  if [ $CLEAN -a -e "$BENCH" ]; then
    files=`ls $BENCH $BENCH.* 2>/dev/null`
    echo "Cleaning $files"
    rm $files
  fi
  # Workaround to compile mandelbrot while I figure out how to do this properly on Mac
  if [ "`uname`" = "Darwin" ]; then
    echo xcrun -sdk macosx /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swiftc -Ounchecked -whole-module-optimization -o $BENCH ${WORKDIR}/swift/${BENCH}.swift
    xcrun -sdk macosx /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swiftc -Ounchecked -whole-module-optimization -o $BENCH ${WORKDIR}/swift/${BENCH}.swift
  else
    echo swiftc -Ounchecked -whole-module-optimization -o $BENCH ${WORKDIR}/swift/${BENCH}.swift
    swiftc -Ounchecked -whole-module-optimization -o $BENCH ${WORKDIR}/swift/${BENCH}.swift
  fi
done

