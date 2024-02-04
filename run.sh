#!/bin/bash
#args: dev threads seq hint
#hint: 0-random 1-seq 2-normal

echo 1 > /proc/sys/vm/drop_caches

echo "dev,seq,hint,threads,time,workGB,tlb,readGB,CPUwork"

dd if=/dev/zero of=./test_file bs=1G count=100

## seq 1 SSD
timeout 210s ./mmapbench ./test_file 20 1 0 | tee mmapbench.csv; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 20 1 1 | tee mmapbench.csv; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 20 1 2 | tee mmapbench.csv; echo 1 > /proc/sys/vm/drop_caches

fio --filesize=100GB --filename=./test_file --io_size=100GB --name=seqread --rw=randread --iodepth=256 --ioengine=libaio --direct=1 --blocksize=1MB --numjobs=1 --bandwidth-log --output=/dev/null | tee fio_seq.csv
echo 1 > /proc/sys/vm/drop_caches

## rnd 1 SSD
timeout 210s ./mmapbench ./test_file 100 0 0 | tee mmapbench.csv; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 100 0 1 | tee mmapbench.csv; echo 1 > /proc/sys/vm/drop_caches
timeout 210s ./mmapbench ./test_file 100 0 2 | tee mmapbench.csv; echo 1 > /proc/sys/vm/drop_caches

fio --filesize=100GB --filename=./test_file --io_size=100GB --name=randbla --rw=randread --iodepth=1 --ioengine=psync --direct=1 --blocksize=4096 --numjobs=100 --bandwidth-log --output=/dev/null | tee fio_rnd.csv
echo 1 > /proc/sys/vm/drop_caches
