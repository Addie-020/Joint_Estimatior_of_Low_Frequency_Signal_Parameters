function y = TestFun(X)

% y1 = (sin(sqrt(X(1, :).^2 + X(2, :).^2))).^2 - 0.5;
% y2 = 1 + 0.001 * (X(1, :).^2 + X(2, :).^2);

y1 = (sin(sqrt(X(1).^2 + X(2).^2))).^2 - 0.5;
y2 = 1 + 0.001 * (X(1).^2 + X(2).^2);

y = 0.5 + y1 ./ (y2.^2);

end