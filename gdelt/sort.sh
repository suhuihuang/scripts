#!/bin/bash
# 
# 把文件按年分类，再按年分月，把三种类型的文件分开。
# 用进度条查分类的进度
#
#分类文件的起始年份和结束年份
year=`echo 20{15..20}`

#分类文件的起始月份和结束月份
mon=`echo {01..12}`


# 存放文件的目录
dir1=gdeltv2

# 分类文件的目录
dir2=gdeltv2

fenlei() {
for i in $year;do
        for j in $mon;do
#                progrees
                                # 按日期分类，创建目录  
                mkdir $dir2/exports/$i/$i/$i$j -p
                mkdir $dir2/gkgs/$i/$i$j  -p
                mkdir $dir2/mentions/$i/$i$j -p

               # 把文件移动到指定的目录
                mv $dir1/$i$j*.export* $dir2/exports/$i/$i$j >/dev/null 2>&1
                mv $dir1/$i$j*.gkg* $dir2/gkgs/$i/$i$j >/dev/null 2>&1
                mv $dir1/$i$j*.mentions* $dir2/mentions/$i/$i$j >/dev/null 2>&1


        done
        echo $i 年分类中 ......
        progrees
done

echo 文件分类完毕！！
}

progrees() {
b=''
for ((i=0;$i<=100;i+=2))
do
        printf "progress:[%-50s]%d%%\r" $b $i
        #sleep 0.1
        b=#$b
done
echo

}

fenlei
