function f = get_perimeter(xx,yy)
f = 0;
for i = 1:size(xx,2)-1
    f = f + sqrt((xx(i+1)-xx(i))^2+(yy(i+1)-yy(i))^2);
end
end