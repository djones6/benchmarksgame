#!/bin/sh

GO_BENCHES="mandelbrot.go-1 binarytrees.go-2 fannkuchredux.go-1 fastaredux.go-2 mandelbrot.go-1-st binarytrees.go-2-st fannkuchredux.go-1-st"
WORKDIR=$PWD

if [ $1 = "-clean" ]; then
  CLEAN=true
else
  CLEAN=false
fi

export GOPATH=${WORKDIR}/go
mkdir -p ${WORKDIR}/go/src ${WORKDIR}/go/bin
for BENCH in $GO_BENCHES; do
  BENCH_NAME=`echo $BENCH | cut -d'.' -f1`
  # Clean up link to source from a previous build
  if [ -e "${WORKDIR}/go/src/${BENCH_NAME}/${BENCH_NAME}.go" ]; then
    rm ${WORKDIR}/go/src/${BENCH_NAME}/${BENCH_NAME}.go
  fi
  # The following is an attempt to put the go versions of the benchmarks into a standard
  # package layout so that 'go build' will build them (but name the resulting executable
  # with the full name of the benchmark)
  echo "Linking ${BENCH}.go to ${WORKDIR}/swift/src/${BENCH_NAME}/${BENCH_NAME}.go"
  mkdir -p ${WORKDIR}/go/src/${BENCH_NAME}
  cd ${WORKDIR}/go/src/${BENCH_NAME}
  ln -s ../../${BENCH}.go ${BENCH_NAME}.go
  cd ${WORKDIR}/go/bin
  if [ $CLEAN -a -e "$BENCH" ]; then
    files=`ls $BENCH $BENCH.* 2>/dev/null`
    echo "Cleaning $files"
    rm $files
  fi
  echo go build -o $BENCH $BENCH_NAME
  go build -o $BENCH $BENCH_NAME
done
