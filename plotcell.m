function x=plotcell(t,a)
    %plots data from a 2 cell arrays, all-at-once (no HOLD) - named t and a!
    %highly customized...first cell array is 1-d, 2nd is 3-d

le=length(t);

s1 = 'close all;hold off;subplot(1,2,1);plot(';

s2='';
for l=1:le;
s=num2str(l);
s2=strcat(s2,'1:length(t{',s,'}),t{',s,'},');
end
s2=s2(1:(length(s2)-1));
s2=strcat(s2,');');

le=length(a);
s3='subplot(1,2,2);gset parametric;plot3(';
s4='';
for l=1:le;
s=num2str(l);
s4=strcat(s4,'a{',s,'}(:,1),a{',s,'}(:,2),a{',s,'}(:,3),"',num2str(l),';line ',num2str(l),';",');
s4=strcat(s4,'a{',s,'}(1,1),a{',s,'}(1,2),a{',s,'}(1,3),"k*;;",');
end
s4=s4(1:(length(s4)-1));
s4=strcat(s4,');');

x=strcat(s1,s2,s3,s4);

%some relevant snippets:
    %
    % generate a, t from obj and 'f' (containing indices where obj has enough points)
    %clear a;for l=1:length(f);a{l}=obj{f(l)};q=obj{f(l)};q=diff(q);t{l}=sqrt(sum(q(:,1:3).^2,2))./(5.*q(:,4));end
    %
    % make -matrix- from 't' for plotting, etc:
    % b=0;for l=1:length(t);b=max(b,length(t{l}));end;z=zeros(b,l)-1;for l=1:length(t);z(1:length(t{l}),l)=t{l};end
    %
    % 
