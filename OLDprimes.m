function x=primes(p)
	  if (p > 3)
	    lenm = floor((p+1)/6);        # length of the 6n-1 sieve
	    lenp = floor((p-1)/6);        # length of the 6n+1 sieve
	    sievem = ones (1, lenm);      # assume every number of form 6n-1 is prime
	    sievep = ones (1, lenp);      # assume every number of form 6n+1 is prime
	    for i=1:(sqrt(p)+1)/6         # check up to sqrt(p)
	      if (sievem(i))              # if i is prime, eliminate multiples of i
	        sievem(7*i-1:6*i-1:lenm) = 0; 
	        sievep(5*i-1:6*i-1:lenp) = 0;  
	      endif                       # if i is prime, eliminate multiples of i
	      if (sievep(i))
	        sievep(7*i+1:6*i+1:lenp) = 0; 
	        sievem(5*i+1:6*i+1:lenm) = 0;  
	      endif
	    endfor
	    x = sort([2, 3, 6*find(sievem)-1 6*find(sievep)+1]);     
	  else
	    x=[2 3]; x=x(find(x<=p));
	  endif
	endfunction  

