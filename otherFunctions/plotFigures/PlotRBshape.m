phi.fre.all = progdata.store{1, 2}{:};

phi.fre.toplot = phi.fre.all(:, 4:10);

deform_factor = 8;

label_switch = 0;

figure(1)

no.plot = 7;

for i_plot = 1:no.plot
    
    subplot(4, 2, i_plot)
    
    PlotDeformedStruct(node, cons.dof, elem, phi.fre.toplot(:, i_plot), deform_factor, label_switch);
    
    set(gca,'fontsize',25)
    axis([-10 100 -5 25])
    set(legend,'FontSize',20);
    
end