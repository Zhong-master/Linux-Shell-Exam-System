#!/bin/bash


while :								# while循环
do
    echo `clear`							# 清屏
    # 打印开始界面
    echo -e '
************************Exam Review System************************\n\n
           Exam---------------------------------------1           \n
           Review-------------------------------------2           \n
           Exit---------------------------------------3           \n\n
***********************please input [1/2/3]***********************\n'
    read -p 'Input Your Choice:    ' choice					# 等待用户输入
    # 如果用户输入了1/2/3之一，则进入分支，否则将重复显示开始界面
    if [[ $choice=1||$choice=2||$choice=3 ]];
    then
        case ${choice} in						# switch case分支判断
        
            1) echo 'Exam Start, Good Luck!'					# 用户输入了1
               score=0
               flag=0							# 题型标志位
               count=0							# 字符数标志位
               if_break=0							# 用户主动退出标志位
               list=()							# 数组变量 --> 将用来存储文件行
               wrong_question=()						# 数组变量 --> 将用来存储错题
               for line in `cat Question_bank.txt`				# 循环读取文件的每一行
               do
                   list+=(${line})						# 将每一行作为一个元素加入到list数组中
               done
               echo `clear`						# 清屏
               # 打印提示和用户得分
               echo -e "
                           please input your answer or input -1 to exit\n
                                         Your Score is: $score\n"
               for question in ${list[@]}					# 循环读取list数组，取得每一行
               do
                       count=$(( ${#question}-1 ))				# 计算每一行的字符数
                       a=`expr index $question '答案'`				# 检查当前行是否存在“答案”两个字

                       # 判断a是否有数值：是否在当前行中找到了“答案两个字”
                       if [[ $a>0 ]]
                       then
                           wrong_question+=(${question})				# 将答案加入错题变量
                           result=${question:3:4}					# 获取“答案：A”的“A”字符
                           result=${result:0:1}					# 除去“A”字符后的“\n\r”换行字符
                           continue						# 跳过这一行，不让答案显示
                       fi

                       echo $question						# 显示当前行，如果上面没有continue，此处会将“答案：A”显示出来
                       wrong_question+=(${question})				# 将题目先加入错题变量
                       let flag+=1						# 只要成功显示当前行，则+1

                       # 如果当前行字符数为零：当前行是空行，题目之间以空行隔开，所以可以这样判断
                       if [[ $count -lt 1 ]];
                       then

                           # 如果输出的行数小于4：判断对错的题目只有一行，需要填写A/B/C/D的题目有4行
                           if [ $flag -lt 4 ]			
                           then
                               read -p 'Input Your Answer[T/F/-1]:  ' answer		# 定制：判断对错的题目输入提示
                           else :
                               read -p 'Input Your Answer[A/B/C/D/-1]:  ' answer		# 定制：填写A/B/C/D的题目输入提示
                           fi

                           # 如果的形式为“答案：对”，则用“T”替换掉中文的“对”，方便用户输入，相对的用“F”替换掉“错”
                           if [ $result == '对' ]
                           then
                               result='T'
                           elif [ $result == '错' ]
                           then
                               result='F'
                           fi

                           # 判断用户输入是否与答案一致
                           if [ $result == ${answer^^} ];				# 其中^^表示小写字符转大写，大写字符不变
                           then
                               let score+=1					# 如果一致，分数+1
                               echo -e "\n!!!You're Right!!! >A<"
                               wrong_question=()					# 错题变量重置
                               sleep 2						# 程序休眠2秒，让用户看到“答题正确”的提示
                           elif [ $answer == -1 ]					# 如果用户输入的是“-1”，则退出当前考试分支
                           then
                               let if_break+=1
                               break
                           elif [ $score != 0 ]					# 如果答错了，且用户的分数不为0，则分数-1
                           then
                               let score-=1					# 如果答错了，分数-1
                               echo -e "\n...You're Wrong... T-T"
                               for line in ${wrong_question[@]}			# 遍历错题变量中的内容
                               do
                                   echo -e $line >> wrong_file.txt			# 将错题加入错题文件wrong_file.txt
                                   wrong_question=()					# 错题变量重置
                               done
                               echo -e "\n答案：$result"				# 打印正确答案
                               sleep 2						# 程序休眠2秒，让用户看到“答题错误”的提示
                           elif [ $result != $choice ];				# 如果答错了，且用户的分数为0
                           then
                               echo -e "\n...You're Wrong... T-T"
                               for line in ${wrong_question[@]}			# 遍历错题变量中的内容
                               do
                                   echo -e $line >> wrong_file.txt			# 将错题加入错题文件wrong_file.txt
                                   wrong_question=()					# 错题变量重置
                               done
                               echo -e "\n答案：$result"				# 打印正确答案
                               sleep 2						# 程序休眠2秒，让用户看到“答题错误”的提示
                           fi

                           echo `clear`						# 清屏
                           # 重新显示用户分数，每次都会刷新，否则用户的分数不会变更
                           echo -e "
                           please input your answer or input -1 to exit\n
                                         Your Score is: $score\n"
                           flag=0						# 题型标志位重置为0
                       fi
               done

               # 如果用户答完了题目，则退出“答题分支”
               if [ $if_break == 0 ]
               then
                   echo "
                         You have finished all the questions. Congratulations!!!"
                   sleep 2
                   echo `clear`
               else :
               fi;;


            2) echo 'Review Start, Good Luck!' 				# 用户输入了2
               score=0
               flag=0							# 题型标志位
               count=0							# 字符数标志位
               if_break=0							# 用户主动退出标志位
               list=()							# 数组变量 --> 将用来存储文件行
               right_question=()						# 数组变量 --> 将用来存储答对的题目
               for line in `cat wrong_file.txt`					# 循环读取文件的每一行
               do
                   list+=(${line})						# 将每一行作为一个元素加入到list数组中
               done
               echo `clear`						# 清屏
               # 打印提示和用户得分
               echo -e "
                           please input your answer or input -1 to exit\n
                                         Your Score is: $score\n"
               for question in ${list[@]}					# 循环读取list数组，取得每一行
               do
                       count=$(( ${#question}-1 ))				# 计算每一行的字符数
                       a=`expr index $question '答案'`				# 检查当前行是否存在“答案”两个字

                       # 判断a是否有数值：是否在当前行中找到了“答案两个字”
                       if [[ $a>0 ]]
                       then
                           right_question+=(${question})				# 将答案加入错题变量
                           result=${question:3:4}					# 获取“答案：A”的“A”字符
                           result=${result:0:1}					# 除去“A”字符后的“\n\r”换行字符
                           continue						# 跳过这一行，不让答案显示
                       fi

                       echo $question						# 显示当前行，如果上面没有continue，此处会将“答案：A”显示出来
                       right_question+=(${question})				# 将题目先加入错题变量
                       let flag+=1						# 只要成功显示当前行，则+1

                       # 如果当前行字符数为零：当前行是空行，题目之间以空行隔开，所以可以这样判断
                       if [[ $count -lt 1 ]];
                       then

                           # 如果输出的行数小于4：判断对错的题目只有一行，需要填写A/B/C/D的题目有4行
                           if [ $flag -lt 4 ]			
                           then
                               read -p 'Input Your Answer[T/F/-1]:  ' answer		# 定制：判断对错的题目输入提示
                           else :
                               read -p 'Input Your Answer[A/B/C/D/-1]:  ' answer		# 定制：填写A/B/C/D的题目输入提示
                           fi

                           # 如果的形式为“答案：对”，则用“T”替换掉中文的“对”，方便用户输入，相对的用“F”替换掉“错”
                           if [ $result == '对' ]
                           then
                               result='T'
                           elif [ $result == '错' ]
                           then
                               result='F'
                           fi

                           # 判断用户输入是否与答案一致
                           if [ $result == ${answer^^} ];				# 其中^^表示小写字符转大写，大写字符不变
                           then
                               let score+=1					# 如果一致，分数+1
                               echo -e "\n!!!You're Right!!! >A<"
                               for line in ${right_question[@]}				# 遍历对题变量中的内容
                               do
                                   count_line=$(( ${#line}-1 ))				# 计算每一行字符串的字数
                                   result_line=${line:0:$count_line}			# 除去最后的"\n\r"字符
                                   sed -i "0,/$result_line/d" wrong_file.txt			# 从wrong_file.txt文件中删除对应内容，其中的“0”表示第一匹配项
                                   right_question=()					# 对题变量重置
                               done
                               sleep 2						# 程序休眠2秒，让用户看到“答题正确”的提示
                           elif [ $answer == -1 ]					# 如果用户输入的是“-1”，则退出当前考试分支
                           then
                               let if_break+=1
                               break
                           elif [ $score != 0 ]					# 如果答错了，且用户的分数不为0，则分数-1
                           then
                               let score-=1
                               echo -e "\n...You're Wrong... T-T"
                               right_question=()					# 对题变量重置
                               echo -e "\n答案：$result"				# 打印正确答案
                               sleep 2						# 程序休眠3秒，让用户看到“答题错误”的提示
                           elif [ $result != $choice ];				# 如果答错了，且用户的分数为0
                           then
                               echo -e "\n...You're Wrong... T-T"
                               right_question=()					# 对题变量重置
                               echo -e "\n答案：$result"				# 打印正确答案
                               sleep 2						# 程序休眠2秒，让用户看到“答题错误”的提示
                           fi
                           echo `clear`						# 清屏

                           # 重新显示用户分数，每次都会刷新，否则用户的分数不会变更
                           echo -e "
                           please input your answer or input -1 to exit\n
                                         Your Score is: $score\n"
                           flag=0						# 题型标志位重置为0
                       fi
               done

               # 如果用户答完了题目，则退出“训练分支”
               if [ $if_break == 0 ]
               then
                   echo "
                         You have finished all the questions. Congratulations!!!"
                   sleep 2
                   echo `clear`
               else :
               fi;;
               
            3) echo 'Exit Success, Have a Good Day!'		# 用户输入了3
               sleep 3						# 程序休眠3秒
               echo `clear`					# 清屏
               break;;
        esac
    fi
done
