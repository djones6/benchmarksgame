#!/bin/sh

WORKLOAD=$1
shift
PARMS=$*

BENCH="./${WORKLOAD} ${PARMS}"
CPULIST="0,1,2,3"
AFFINITY="numactl --physcpubind=$CPULIST --localalloc"
OUTPUT="${WORKLOAD}.out"

case "`uname`" in
Darwin)
  echo "Running: 'time -p ${BENCH}'"
  time -p ${BENCH} > ${OUTPUT}
  echo "Benchmark output in file ${OUTPUT}"
  ;;
Linux)
echo "Running: 'time -p ${AFFINITY} ${BENCH}'"
time -p ${AFFINITY} ${BENCH} > ${OUTPUT} &
BENCH_PID=$!

mpstat -P $CPULIST 1 > ${WORKLOAD}.mpstat &
MPSTAT_PID=$!
#tail -f ${OUTPUT} &
#TAIL_PID=$!

wait $BENCH_PID
kill $MPSTAT_PID
#kill $TAIL_PID

echo "Benchmark output in file ${OUTPUT}"
echo "mpstat output in file ${WORKLOAD}.mpstat"

#ps -p $BENCH_PID -L -o pid,tid,psr,pcpu,cpu

# Post-process output
#
# mpstat produces output in the following format:
# 14:06:05     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
# 14:06:05     all    0.04    0.00    0.01    0.00    0.00    0.00    0.00    0.00    0.00   99.95
#
# Total the columns %usr (3) and %sys (5), or 100 - %idle (12) ?
# Then divide by the number of cycles collection ran for
for CPU in `echo $CPULIST | tr ',' ' '`; do
  NUM_CYCLES=`cat ${WORKLOAD}.mpstat | grep -e"..:..:.. \+${CPU}" | wc -l`
  # Attempt 1: just total %usr
  #AVG_CPU=`cat ${WORKLOAD}.mpstat | grep -e"..:..:.. \+${CPU}" | awk -v SAMPLES=${NUM_CYCLES} '{TOTAL = TOTAL + $3 } END {print TOTAL/SAMPLES}'`
  # Attempt 2: total 100 - %idle
  AVG_CPU=`cat ${WORKLOAD}.mpstat | grep -e"..:..:.. \+${CPU}" | awk -v SAMPLES=${NUM_CYCLES} '{TOTAL = TOTAL + (100 - $12) } END {print TOTAL/SAMPLES}'`
  echo "CPU $CPU: $AVG_CPU %"
done
  ;;
*)
  echo "Unsupported OS `uname`"
  ;;
esac
