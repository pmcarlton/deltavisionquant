function [x, m] = factor(n)
	  if (nargin < 1)
	    usage("[p, n] = factor(q)");
		  endif
		    if (n != fix(n))
	    error("factor only works for integers");
		  endif

		    ## special case of no primes less than sqrt(n)
		    if (n < 4)
	    x = n;
		    m = 1;
			    return;
				  endif 

				    x = NaN; # silliness to avoid empty matrix concatenation warnings
					  ## There is at most one prime greater than sqrt(n), and if it exists,
					  ## it has multiplicity 1, so no need to consider any factors greater
					  ## than sqrt(n) directly. [If there were two factors p1, p2 > sqrt(n),
					  ## then n >= p1*p2 > sqrt(n)*sqrt(n) == n. Contradiction.]
					  p = primes(sqrt(n));
					    while (n>1)
	    ## find prime factors in remaining n
	    q = n./p;
		    p = p (q == fix(q));
			    if isempty(p)
	      p = n;  # can't be reduced further, so n must itself be a prime.
		      endif
			      x = [x, p];
				      ## reduce n
				      n = n/prod(p);
					    endwhile
						  x = sort(x(2:length(x)));

						    ## determine muliplicity
						    if nargout > 1
							    idx = find([0, x] != [x, 0]);
								    x = x(idx(1:length(idx)-1));
									    m = diff(idx);
										  endif

										  endfunction
