function yi = interp1_sinc(y,x,xi)
% https://gist.github.com/endolith/1297227
T = x(2)-x(1);
sincM = repmat( xi, length(x), 1 ) - repmat( x', 1, length(xi) );
yi = y*sinc( sincM/T );
end