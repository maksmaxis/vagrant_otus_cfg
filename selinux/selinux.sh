#!/bin/bash

PERM=$(echo $UID)
usr=$(whoami)
NORMAL='\033[0m'
LRED='\033[1;31m'
BLINK='\033[5m'
YELLOW='\033[33m'
BLUE='\033[34m'
BOLD='\033[1m'
HELP=$(echo -e "${BOLD}./selinux_status.sh${NORMAL}")

# Проверяет права на выполнение скрипта

if [ "$PERM" = 0 ]; then

        echo -e "${YELLOW}

 ---------- The user ${LRED}$usr${NORMAL}${YELLOW} has rights to work with the script ----------${NORMAL}
"

else 

        echo -e "${BLINK}${LRED}
                       ---------- Permission denied ----------${NORMAL}${LRED}
 ---------- The user ${BOLD}${YELLOW}$usr${NORMAL}${LRED} does not have permission to work with the script ----------
 ---------- run the script with admin rights (use: sudo ./selinux_status.sh)----------${NORMAL}
${YELLOW}
  ----------------------- This script can manage SELinux settings -----------------------
  ------------ For more information please run sudo su ./selinux_status.sh and choice 8. Help---------------${NORMAL}
"
exit 1

fi

while true ## Print the choices
do
        echo -e "
                                       ------------------------${LRED} END ${NORMAL}------------------------\n"

        echo -e "${LRED}Enter your choice [1-9]${NORMAL}:

"

        echo "1. Show SELinux status"
        echo "2. Show SELinux status in conf"
        echo "3. Change SELinux mode to Permissive"
        echo "4. Change SELinux mode to Enforcing"
        echo "5. Change SELinux mode in conf file to permissive (/etc/selinux/config)"
        echo "6. Change SELinux mode in conf file to enforcing (/etc/selinux/config)"
        echo "7. Change SELinux mode in conf file to disabled (/etc/selinux/config)"
        echo "8. Help"
        echo "9. Exit"  
        echo -e "
                                       ------------------------${LRED} START ${NORMAL}----------------------\n"

read set 

case $set in
 1) # выводит значение команды 'getenforce'
        stat=$(getenforce)
                echo -e  "\n----- Current status: ${LRED}$stat${NORMAL} -----\n"
                echo -e "${YELLOW}
        -- Enforcing — запрет доступа на основании правил политики.
        -- Permissive — ведение лога действий, нарушающих политику, которые в режиме enforcing были бы запрещены.
        -- Disabled — полное отключение SELinux.${NORMAL}
"

;;

 2) # выводит данные из конфигурационного файла '/etc/selinux/config' параметр SELINUX
        stat=$(cat /etc/selinux/config | grep -w "SELINUX" | grep -v "#" | awk 'BEGIN{FIELDWIDTHS="8 11"}{print $2}')
                echo -e "\n----- SELinux status in the config file is: ${LRED}$stat${NORMAL} -----\n"
                echo -e "${YELLOW}
        -- Enforcing — запрет доступа на основании правил политики.
        -- Permissive — ведение лога действий, нарушающих политику, которые в режиме enforcing были бы запрещены.
        -- Disabled — полное отключение SELinux.${NORMAL}
"
;;

3) # для изменения режима с enforcing на permissive, выполняет комманду 'setenforce 0'
        stat=$(setenforce 0)
                $stat
                GET=$(getenforce)
                echo -e "\n--- Current status is: ${LRED}$GET${NORMAL}"
                                

echo "
-- SELinux is deactivated --

"
;;

4) # для изменения режима с permissive на enforcing, выполняет комманду 'setenforce 1'
        stat=$(setenforce 1)
        $stat
        GET=$(getenforce)
                echo -e "\n--- Current status is: ${LRED}$GET${NORMAL} "
                                                

echo "
-- SELinux is activated --

"
;;

5) # для смены режима SELinux в конф. файле, выполняет комманду sed -i с заменой текущего значения SELINUX={значение} на permissive
        sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
        sed -i 's/SELINUX=disabled/SELINUX=permissive/' /etc/selinux/config
        stat=$(cat /etc/selinux/config | grep -w "SELINUX" | grep -v "#" | awk 'BEGIN{FIELDWIDTHS="8 11"}{print $2}')
                echo -e "\n--- SELinux changed to: ${LRED}$stat${NORMAL}\n"

;;

6) # для смены режима SELinux в конф. файле, выполняет комманду sed -i с заменой текущего значения SELINUX={значение} на enforcing
        sed -i 's/SELINUX=disabled/SELINUX=enforcing/' /etc/selinux/config
        sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config
        stat=$(cat /etc/selinux/config | grep -w "SELINUX" | grep -v "#" | awk 'BEGIN{FIELDWIDTHS="8 11"}{print $2}')
                echo -e "\n--- SELinux changed to: ${LRED}$stat${NORMAL}\n"
;;

7) # для смены режима SELinux в конф. файле, выполняет комманду sed -i с заменой текущего значения SELINUX={значение} на disabled
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config
        stat=$(cat /etc/selinux/config | grep -w "SELINUX" | grep -v "#" | awk 'BEGIN{FIELDWIDTHS="8 11"}{print $2}')
                echo -e "\n--- SELinux changed to: ${LRED}$stat${NORMAL}\n"
;;

8) # Справочник

                echo -e "
                                        ${LRED}------------------ Начало справочника -----------------${NORMAL}\n" 
                echo -e "${BOLD}NAME${NORMAL}


        selinux_status.sh - used to check and update SELinux file configuration and status.

${BOLD}DESCRIPTION${NORMAL}


1. Show SELinux status  -- ${YELLOW}выводит значение команды 'getenforce'${NORMAL}
2. Show SELinux status in conf -- ${YELLOW}выводит данные из конфигурационного файла '/etc/selinux/config' параметр SELINUX${NORMAL} 
3. Change SELinux mode to Permissive -- ${YELLOW}для изменения режима с enforcing на permissive, выполняет комманду 'setenforce 0'${NORMAL}
4. Change SELinux mode to Enforcing -- ${YELLOW}для изменения режима с permissive на enforcing, выполняет комманду 'setenforce 1'${NORMAL}
5. Change SELinux mode in conf file to permissive (/etc/selinux/config) -- ${YELLOW}для смены режима SELinux в конф. файле, выполняет комманду sed -i с заменой текущего значения SELINUX={значение} на permissive${NORMAL}
6. Change SELinux mode in conf file to enforcing (/etc/selinux/config) -- ${YELLOW}для смены режима SELinux в конф. файле, выполняет комманду sed -i с заменой текущего значения SELINUX={значение} на enforcing${NORMAL}
7. Change SELinux mode in conf file to disabled (/etc/selinux/config) -- ${YELLOW}для смены режима SELinux в конф. файле, выполняет комманду sed -i с заменой текущего значения SELINUX={значение} на disabled${NORMAL}
8. Help -- ${YELLOW}Справочник${NORMAL}
9. Exit -- ${YELLOW}Завершает выполнение скрипта${NORMAL}



${BOLD}EXAMPLES${NORMAL}
${BOLD}EXAMPLES${NORMAL}
        

user@localhost direct]# ./read_selinux.sh 


 ---------- The user root has rights to work with the script ----------

Enter your choice [1-9]:


1. Show SELinux status
2. Show SELinux status in conf
3. Change SELinux mode to Permissive
4. Change SELinux mode to Enforcing
5. Change SELinux mode in conf file to permissive (/etc/selinux/config)
6. Change SELinux mode in conf file to enforcing (/etc/selinux/config)
${YELLOW}7. Change SELinux mode in conf file to disabled (/etc/selinux/config) # выбран седьмой пункт${NORMAL}
8. Help
9. Exit

-------------------------------------------------------

7

${YELLOW}--- SELinux changed to: enforcing${NORMAL}



                                ${LRED}------------------ Конец справочника -----------------${NORMAL}\n


"

;;


9)

echo -e " ---------- ${LRED}Thank you!${NORMAL} ----------\n"

exit 1 ## Выход из программы

;;

*)

         echo -e "\n${BLINK}${LRED}Enter a valid operation.${NORMAL}\n" ## Нет кейсов
;;
esac
        
done

