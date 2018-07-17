[output,txt]=system("kill `ps axwwu|grep disp|grep geometry|grep img|awk '{print $2}'` > /dev/null 2&>1");
