function hi6(g)

% does 6 histogram subplots.

xsn={"I","II","III","IV","V","X"};
for o=1:6;
	subplot(3,2,o);
	hist(g{o});
    title(xsn{o});
	end;
	
	
