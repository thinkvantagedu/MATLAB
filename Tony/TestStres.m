stres = [10; 8; 5];

[princ, alpha] = stressed(stres);

disp('Angle of major principal axis from x-axis in degrees');

alphadeg = alpha*180/pi;
disp(alphadeg);

disp(['Princ I = ' num2str(princ(1))]);
disp(['princ II = ' num2str(princ(2))]);