clc
clear all
close all

y = [15.6;21.7;3.1;14.7;6.9;16.1;7.5;16.1;20.2;13.3;15.0;23.3];
N = length(y);
n = 3;

X = zeros(N,n);
X(:,1) = [2;3.6;0.9;2.4;0.1;2.6;0.7;1;2.4;1.9;2.3;3.9];
X(:,2) = [4.7;5.7;1.6;4.8;4.4;6;2.6;5.7;4.5;5;4.8;6.9];
X(:,3) = [2.9;4.9;1.4;3.3;1.6;3.7;1.6;3;3.1;3.4;3.3;4.8];

A = [ones(N,1),X];

mdl = fitlm(A,y);
clc
R2 = mdl.Rsquared.Ordinary;

coeff = mdl.Coefficients.Estimate(2:end,1);
pVal = mdl.Coefficients.pValue(2:end,1);

r2 = zeros(n,1);
VIF = zeros(n,1);
for i = 1:n
    Atemp = A;
    Atemp(:,i+1) = [];
    tempModel = fitlm(Atemp,X(:,i));
    clc
    r2(i) = tempModel.Rsquared.Ordinary;
    VIF(i) = 1/(1-r2(i));
end

vars = (1:1:3)';
tempA = A(:,1);
tempMdl = fitlm(tempA,y);
clc
tempCoeff = tempMdl.Coefficients.Estimate(2:end,1);
tempY = tempA*tempCoeff;
for i = 1:length(vars)
    var = vars(i);
    temperA = [tempA,X(:,var)];
    temperMdl = fitlm(temperA,y);
    clc
    temperCoeff = temperMdl.Coefficients.Estimate(2:end,1);
    temperY = temperA*temperCoeff;
    F(i) = (N-0-1-1)*(sum((tempY-y).^2)-sum((temperY-y).^2))./...
        (sum((temperY-y).^2));
    pf(i) = 1-fcdf(F(i),1,N-2);
end
