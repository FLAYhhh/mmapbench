#!/bin/bash

echo 1 > /proc/sys/vm/drop_caches

echo "dev,seq,hint,threads,time,workGB,tlb,readGB,CPUwork"

dd if=/dev/zero of=./test_file bs=1G count=100

## seq 1 SSD
timeout 210s ./mmapbench ./test_file 20 1 0 | grep -v CPUwork ; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 20 1 1 | grep -v CPUwork ; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 20 1 2 | grep -v CPUwork ; echo 1 > /proc/sys/vm/drop_caches

fio --filesize=100GB --filename=./test_file --io_size=100GB --name=seqread --rw=randread --iodepth=256 --ioengine=libaio --direct=1 --blocksize=1MB --numjobs=1 --bandwidth-log --output=/dev/null 2> /dev/null
/bin/cp agg-read_bw.log seq1.csv
echo 1 > /proc/sys/vm/drop_caches

## rnd 1 SSD
timeout 210s ./mmapbench ./test_file 100 0 0 | grep -v CPUwork ; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 100 0 1 | grep -v CPUwork ; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 100 0 2 | grep -v CPUwork ; echo 1 > /proc/sys/vm/drop_caches

fio --filesize=100GB --filename=./test_file --io_size=100GB --name=randbla --rw=randread --iodepth=1 --ioengine=psync --direct=1 --blocksize=4096 --numjobs=100 --bandwidth-log --output=/dev/null 2> /dev/null
/bin/cp agg-read_bw.log rnd1.csv
echo 1 > /proc/sys/vm/drop_caches
