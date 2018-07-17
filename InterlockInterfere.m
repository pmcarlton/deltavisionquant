%interlock interference -- 
%trying to simulate random synapsis initiation and interlock 'sliding' towards places where they meet after growing
%apparently works, made master version in /Users/pete/Octavefiles/m/Pete/
%20080423 pmc

%
%comparing dist. of differences between CO locations, this gives a distribution different than random CO positions...
%shifted to center from >> and << distances. reason for non-high distances is due to ends always synapsing, limiting the maximum distance two COs can be from each other. need to modify program to make all CO initiation random, no special COs at ends, & "see how it looks like"

iter = 1000;
plotFlag=0;

gr = 1 / 1000;  %sets time scale, each growth of half-stretch is by that much
sisp = 1 / 100; %probability of a new SIS each time point
intp = 1 / 1000; %probability of an interlock
intn = 10; %number of chances for an interlock

for runs=1:iter

e=0;
count=0;
siscount=1;

if(1), % if you're starting at the ends...
%initialise SIS by having one at each end:
sis=zeros(2,6);
sis(1,:) = [0    gr 2 1 count siscount];  
%left end, right end, which end active, growFlag, sisChronOrder
siscount=siscount + 1;
sis(2,:) = [1-gr 1  1 1 count siscount];
end     % if you're starting at the ends...

if(0), %try to make the ends 'dead' points, and have a random SIS somewhere else...
sis=zeros(4,6);
sis(1,:) = [0    gr 2 0 count siscount];  
%left end, right end, which end active, growFlag, sisChronOrder
siscount=siscount + 1;
sis(2,:) = [1-gr 1  1 0 count siscount];
sisInit=rand;
siscount=siscount + 1;
sis(3,:) = [sisInit sisInit 2 1 count siscount];
sis(4,:) = [sisInit sisInit 1 1 count siscount];

end     % try to make the ends 'dead' points, and have a random SIS somewhere else..


do

count = count + 1;
ss=size(sis);

%grow the ends
for l=1:ss(1)
    if(sis(l,4)),    %if growth is active
    gro=(gr*((sis(l,3)-1.5)*2));
    gro = gro * rand ;
    sis(l,sis(l,3))+=(gro);    %add/subtract from active end
        end
    end

%check for coalescence
if(0),  % ooo single block to try
for l=1:ss(1)
    f=find(sis(:,3)!=sis(l,3)); %get all opposite-pointed stretches
    f=sis(l,sis(l,3))-sis(f,1:2); %subtract them
    f=sis(l,sis(l,3))-sis(f,1:2); %subtract them
    f=prod(sign(f),2); %check for opposite sign
    f=find(f==(-1)); %locations of coalescence, should only be ONE
    if(length(f)==1),
        sis(l,4)=0;sis(f,4)=0;
        end
    if(length(f)>1),
        disp('something fucked up!');
        end
end
end     % ooo end block

ss=size(sis);
for l=1:ss(1)
    %f=find(sis(:,3)!=sis(l,3)); %get all opposite-pointed stretches -- MUST NOT BE TEH SAME POINT THOUGH
    f=find((sis(:,3)!=sis(l,3)) & (sis(:,6)!=sis(l,6))); %get all opposite-pointed stretches -- MUST NOT BE TEH SAME POINT THOUGH
    fa=abs(sis(l,sis(l,3))-sis(f,sis(f(1),3))); %subtract from the growing points
%    disp(fa);
    faa=find(fa < (2*gr) );    %too close to that end
    if(faa), 
    sis(l,4)=(-0); %negative to see if it's added this way..
%    for li = 1:length(faa)
%        sis(faa(li),4)=(-0);
%        end
    end
end
%add new SISes..
if(0),  %test block for specific locations...
    if(count==10),  %we get a new SIS somewhere...
        tsis = 0.4; %the tentative location
        ss=size(sis);
        tAllow = 1;     %will stay 1 if location allowed
        for l2=1:ss(1)
           if( (tsis >= sis(l2,1)-gr) & (tsis <= sis(l2,2)+gr)),
           %added the -gr and +gr to prevent jumping over
               tAllow = 0;
           end
        end
        if(tAllow),
            siscount=siscount+1;
            sis(ss(1)+1,:) = [tsis tsis 2 1 count siscount];
            sis(ss(1)+2,:) = [tsis tsis 1 1 count siscount];
           end
    end

    if(count==20),  %we get a new SIS somewhere...
        tsis = 0.41; %the tentative location
        ss=size(sis);
        tAllow = 1;     %will stay 1 if location allowed
        for l2=1:ss(1)
           if( (tsis >= sis(l2,1)-gr) & (tsis <= sis(l2,2)+gr)),
           %added the -gr and +gr to prevent jumping over
               tAllow = 0;
           end
        end
        if(tAllow),
            siscount=siscount+1;
            sis(ss(1)+1,:) = [tsis tsis 2 1 count siscount];
            sis(ss(1)+2,:) = [tsis tsis 1 1 count siscount];
           end
    end

end %test block for specific locations


if(1),
    if(rand<sisp),  %we get a new SIS somewhere...
        tsis = rand; %the tentative location
        ss=size(sis);
        tAllow = 1;     %will stay 1 if location allowed
        for l2=1:ss(1)
           if( (tsis >= sis(l2,1)-(2*gr)) & (tsis <= sis(l2,2)+(2*gr))),
           %added the -gr and +gr to prevent jumping over
               tAllow = 0;
           end
        end
        if(tAllow),
            siscount = siscount + 1;
            sis(ss(1)+1,:) = [tsis tsis 2 1 count siscount];
            sis(ss(1)+2,:) = [tsis tsis 1 1 count siscount];
        end
    end
end

e=sum(sis(:,4));

until (e == 0)

if(plotFlag),

hold off;close all;
hold on;
aryHeight=0.25/count;
ss=size(sis);
for l=1:ss(1)
    if(sis(l,3)==2),
    arx = [sis(l,1) sis(l,2) sis(l,1) sis(l,1) sis(l,2)];
    else
    arx = [sis(l,2) sis(l,1) sis(l,2) sis(l,2) sis(l,1)];
    end
    ary = [0 0 aryHeight -aryHeight 0].*(count-sis(l,5));
    plot(arx,ary);
end
hold off
axis([0 1 -1 1]);
end %if plotFlag

ss=size(sis);
il=rand(1,intn);
il0=il;
for l=1:intn;for li=1:ss(1);r=[sis(li,1) il(l) sis(li,2)];if(r==sort(r)), il(l)=sis(li,sis(li,3));end;end;end
il2=il;
for l=1:intn-1;for li=(l+1):intn;if(abs(il(l)-il(li))<(2*gr)),il2(l)=il2(li);end;end;end
il3{runs}=unique(il2);

disp(iter-runs);
end
