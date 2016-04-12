#!/bin/sh

GO_BENCHMARKS="mandelbrot.go-1,16000 binarytrees.go-2,20 fannkuchredux.go-1,12 fastaredux.go-2,25000000 mandelbrot.go-1-st,16000 binarytrees.go-2-st,20 fannkuchredux.go-1-st,12"
WORK_DIR=$PWD

if [ ! -d "$WORK_DIR/go/bin" ]; then
  echo "$WORK_DIR/go/bin not found"
  exit 1
fi
cd $WORK_DIR/go/bin
echo "Go benchmarks"
for BENCH in $GO_BENCHMARKS; do
  BENCH_ARGS=`echo $BENCH | tr ',' ' '`
  $WORK_DIR/run.sh $BENCH_ARGS
done

