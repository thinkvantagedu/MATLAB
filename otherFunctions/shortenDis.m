function shortenDis(inpt)

fprintf([repmat(sprintf('%% %dd',max...
    (floor(log10(abs(inpt(:)))))+2+any(inpt(:)<0)),...
    1,size(inpt,2)) '\n'],inpt');