function y = collapsecell(x)
    %collapses cell array into a 2d array

y=[];

for l=1:length(x);
y=[y;x{l}];
end

