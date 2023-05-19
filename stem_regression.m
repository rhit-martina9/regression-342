clc
clear all
close all

% All data ranges from 2000 to 2020. Conflict represents the number of 
% ongoing global state conflicts. House represents the percentage
% of the House of Representatives controlled by Democrats. Income
% represents the median income. Poverty represents the percentage of the US
% population under the poverty line. Senate measures the percentage of the
% Senate controlled by Democrats. Spending is the annual US spending on
% science, space, and technology. 

load('conflict')
load('house')
load('income')
load('poverty')
load('senate')
load('spending')
load('stemDeg')

y = spending;
N = length(y);
n = 5;

X = [conflict;house;income;poverty;senate];

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
