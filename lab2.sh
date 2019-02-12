#!/bin/bash

function filestat {
   echo $1
   size=`stat $1 | sed -n 2p | awk '{print $2}'`
   mtime=`stat $1 | sed -n 5p | awk '{print $2 " " $3}' | sed -e 's/\..*//g'` # В конце удаляем мс.
   rights=`stat $1 | sed -n 4p | awk '{print $2}' | sed -e 's/[()]//g'` # '(',')' -> ''
   inode=`stat lab2.sh | sed -n 3p | awk '{print $4}'` # Индексный дескриптор
   echo "Size:" $size "bytes | Mod. time:" $mtime "| rights:" $rights "| inode:" $inode
}

# Проверяем, есть ли в множестве элемент
# (set_file, item)
# return: 1 если есть в множестве, 0 если нет в множестве
function is_contains {
   while read LINE; do
      if [ "$2" == "$LINE" ]; then
         echo 1
         return
      fi 
   done < $1
   echo 0
}

# Добавляем в множество элемент
# (set_file, item)
function set_add {
   value=$( is_contains $1 $2 )
   if [ $value -ne 1 ]; then 
      echo $2 >> $1
   fi
}


tmp_file=~/tmp.brakh # Временный файл используется в качестве множества
touch $tmp_file;
echo
IFS=$'\n'
finds_dir1=`find $1 -type f`
for dir1_file in $finds_dir1; do
   finds_dir2=`find $2 -type f`

   for dir2_file in $finds_dir2; do
      if [ "$dir1_file" != "$dir2_file" ]; then # Если файлы не одинаковые
                 
         if cmp -s $dir1_file $dir2_file; then # Если содержимое файлов одинаковое 

            file1inset=$( is_contains $tmp_file $dir1_file )
            file2inset=$( is_contains $tmp_file $dir2_file )

            if [ $file1inset -eq 0 ]; then
               filestat $dir1_file
               filestat $dir1_file >> $3 
            fi

            if [ $file2inset -eq 0 ]; then
               filestat $dir2_file 
               filestat $dir2_file >> $3
            fi
         
              
            set_add $tmp_file $dir1_file
            set_add $tmp_file $dir2_file
         fi 
      fi
   done
done
rm $tmp_file
