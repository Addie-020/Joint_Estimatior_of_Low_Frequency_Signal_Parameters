function [xBest, yBest, info, dataLog] = ConjGradeOptim(x0, objFun, xLb, xUb, options)
 
%
% Conjugate Gradient Algorithm (with Polak-Ribiere method)
% i.e. PR-CG algorithm
% 
% Input arguments:
%   @objFun : Object function to be optimized, must be vectorized
%   @x0     : Initial value of variables
%   @xLb    : Lower bound of variables
%   @xUb    : Upper bound of variables
%   @options: Optimization options, for more details see 'Option Defult
%             Set' in 'Preparation' part
%
% Output arguments:
%   @xBest  : Optimal point (variable)
%   @fBest  : Optimal value of object function
%   @info   : Information of the optimization process
%   @dataLog:
%
% Author: Zhiyu Shen @Nanjing University
% Date  : July 27, 2022
%

%%% Preparation

% Input Vector Size Validation
% ---------------------------
% x0, xLb, xUb: N*1 matrix
% ---------------------------
[n, m] = size(x0);
D = n;
if m ~= 1
    error('x0 is not a column vector!');
end
[n, m] = size(xLb);
if (n ~= D) || (m ~= 1)
    error('xLb is not a valid size!');
end
[n, m] = size(xUb);
if (n ~= D) || (m ~= 1)
    error('xUb is not a valid size!');
end

% Option Defult Set
default.alpha           = 0.6;          % Step length for 2D search
default.maxIter         = 100;          % Maximum iteration times
default.errConj         = 1e-9;         % Exit falg for 2D search
default.errLine         = 1e-9;         % Exit flag for 1D search
default.xDelMax         = xUb - xLb;    % Maximum position update
default.display         = 'iter';       % Print iteration progress out on the screen
default.printMod        = 1;            % Print out every [printMod] iterations

% Set options according to user inputs
if nargin == 5
    options = MergeOptions(default, options);
else
    options = default;
end


% Deal with initial point
x_val = x0;                                 % Initial value of x
g_val = subs(g, var, x_val);                % Initial value of gradient
v_val = norm(g_val);                        % Norm of initial gradient
% If the initial point meet the condition, then return
if (v_val < e)
    xHat = x0;
    yBest = subs(f, var, x0);
    return;
else
    % Otherwise, continue calculation
    d_val = -g_val;                         % Initial value of direction
end

% Iteration loop
while (flag && (n < iter_max))
    % Using 1-d searching method to calculate step length of x updating
    x = x_val + a.*d_val;                   % Variable expression of next iteration
    f_iter = subs(f, var, x);               % Function expression of new x
    %     a = golden_ratio(0, dist, f_iter, 1e-9);
    f_tar = matlabFunction(f_iter);         % Cnvert symbolic expression to function handle
    [a_val,] = fminbnd(f_tar, 0, dist);     % Using "fminbnd" function to optimize the searching process
    x_val = subs(x, a, a_val);              % Update x value
    % Calculate new gradient and store previous one
    g_val_r = g_val;                        % Store previous gradient value
    g_val = subs(g, var, x_val);            % Update gradient value
    v_val = norm(g_val);                    % Update norm of gradient

    n = n + 1;
    
    % Judge whether current x meets the condition
    if (v_val >= e)
        % Using PR-CG algorithm to calculate step length of direction updating
        b_val_r = (g_val'*(g_val-g_val_r)) / (norm(g_val_r))^2;
        b_val = max(b_val_r, 0);
        d_val = -g_val + b_val.*d_val;
    else
        flag = 0;
    end
end

xHat = x_val;
yBest = subs(f, var, x_val);

end