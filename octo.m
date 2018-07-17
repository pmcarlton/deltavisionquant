function y=octo(x);

%highly customized--treats x as a decimal specifying a DNA octomer and returns the bases
%subtracts one from x, since find() gives one-based answers.
% 020120329_09:15_pmc

if(x>65536), disp("X is too high...must be 1..65536 range!");break;end
  if(x<1), disp("X is too low...must be 1..65536 range!");break;end
y = dec2base(x-1,'acgt',8);
