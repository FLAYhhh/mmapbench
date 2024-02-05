import csv
import glob

# 获取当前目录下所有什yankstack_after_paste
files = glob.glob("fio_rnd_bw.*.log")

# 初始化数据字典
data = {}

# 逐个处理文件
for file in files:
    with open(file, "r") as f:
        reader = csv.reader(f, delimiter=",")
        for row in reader:
            timestamp = int(row[0])
            read_kb = int(row[1])

            # 将数据添加到字典中
            if timestamp not in data:
                data[timestamp] = read_kb
            else:
                data[timestamp] += read_kb

# 将合并后的数据写入输出文件
with open("fio_rnd.csv", "w") as f:
    writer = csv.writer(f)
    for timestamp, read_kb in sorted(data.items()):
        writer.writerow([timestamp, read_kb, 0, 0])
