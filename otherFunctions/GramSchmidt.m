function otpt = GramSchmidt(inpt)

[m, n] = size(inpt);
otpt = zeros(m, n);
otpt(:, 1) = inpt(:, 1);
otpt(:, 1) = otpt(:, 1) / norm(otpt(:, 1));

for iOtpt = 2:n
    
    otpt(:, iOtpt) = otpt(:, iOtpt) + inpt(:, iOtpt);
    
    for jOtpt = 1:(iOtpt-1)
        
        a = dot(otpt(:, jOtpt), inpt(:, iOtpt));
        b = norm(otpt(:, jOtpt)) ^ 2;
        
        otpt(:, iOtpt) = otpt(:, iOtpt) - ...
            ((a / b) * otpt(:, jOtpt));
        
    end
    
    otpt(:, iOtpt)=otpt(:, iOtpt) / norm(otpt(:, iOtpt));
    
end

end