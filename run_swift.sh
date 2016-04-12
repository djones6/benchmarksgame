#!/bin/sh

SWIFT_BENCHMARKS="mandelbrot.swift-1_mod,16000 binarytrees.swift-3,20 fannkuchredux.swift-1,12 fastaredux.swift-2,25000000"
WORK_DIR=$PWD

if [ ! -d "$WORK_DIR/swift/bin" ]; then
  echo "$WORK_DIR/swift/bin not found"
  exit 1
fi
cd $WORK_DIR/swift/bin
echo "Swift benchmarks"
for BENCH in $SWIFT_BENCHMARKS; do
  BENCH_ARGS=`echo $BENCH | tr ',' ' '`
  $WORK_DIR/run.sh $BENCH_ARGS
done

