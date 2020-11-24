% figures

%%
figure;set(gcf, 'WindowState', 'maximized');
scatter(1./stress/n1,vol/n2,80,'fill'); grid on;
xlabel('Normalized Polar Moment of Inertia - I_p/I_p_0');
ylabel('Normalized Volume - V/V_0');
title('Pareto Frontier of the Airfoil Optimization');
set(gca,'fontsize',18);
%%
figure;set(gcf, 'WindowState', 'maximized');
for i = 1:size(pol,2)
    plot(x_opt(i,:),y_opt(i,:),'.','MarkerSize',8);axis equal;grid on; hold on;
    xlabel('x/C'); ylabel('y/C');
    title('Airfoil Shapes')
    set(gca,'fontsize',18);
    waitforbuttonpress
%     close
end
%%
figure;set(gcf, 'WindowState', 'maximized');
plot(a1.x(1:199),-a1.cp);hold on;
plot(a2.x(1:199),-a2.cp)
grid on;
%%
figure;set(gcf, 'WindowState', 'maximized');
plot(a2.x(1:199),-a2.cp)
%plot((1:100)/100,a1.cp(1:100));hold on;plot((1:100)/100,a1.cp(100:199)');
grid on;