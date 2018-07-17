function q=grn(s);

%growlnotifies the string s

s=strcat('growlnotify -s -m',s);
system(s);

