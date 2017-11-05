function [inpt] = ElemZerotoOne(inpt)

for i = 1:numel(inpt)
    
   if inpt(i)==0
       
      inpt(i) = inpt(i)+1; 
       
   end
    
end