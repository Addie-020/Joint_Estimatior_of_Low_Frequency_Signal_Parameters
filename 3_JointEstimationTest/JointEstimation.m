clear
close all
clc

Fs = 100;                           % Sampling frequency (Hz)
Tt = 2;                             % Total time of sampling (s)
Ns = Tt * Fs;                       % Total sampling points

ft = 0.3;                           % Frequency of test signal (Hz)
pt = pi / 3;                        % Phase of test signal (rad)

xt = (0 : Ns - 1) / Fs;             % Time index
xn = sin(2 * pi * ft * xt + pt);    % Test signal

M = 10;                             % Search times

tic

% Compute mean and variance of test signal
miu0 = sum(xn) / Ns;
sigma0 = sqrt(sum((xn - repmat(miu0, 1, Ns)).^2) / Ns);
% Test signal information for correlation computation
Ct = (xn - repmat(miu0, 1, Ns)) ./ repmat(sigma0, 1, Ns);

% Global search
xBest = zeros(1, 2);
yBest = 3;
for i = 1 : M
    f0 = rand;
    p0 = (rand - 0.5) * pi;
    x0 = [f0; p0];
    xLb = [0; -pi];
    xUb = [1; pi];
    [xGlob, yGlob, infoGlob, dataLogGlob] = ParticleSwarmOptim(Ct, Fs, x0, xLb, xUb);

    % Local search
    [xTemp, yTemp, info, dataLog] = ConjGradeOptim(xGlob, Ct, Fs);

    if yTemp < yBest
        xBest = xTemp;
    end

end

toc

