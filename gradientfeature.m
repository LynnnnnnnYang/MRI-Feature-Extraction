function stats = gradientfeature(Grad)
%  -------------------------------------------
%  Current supported statistics include:
%  -------------------------------------------
%   GrMean (absolute gradient mean)
%   GrVariance (absolute gradient variance)
%   GrSkewness (absolute gradient skewness)
%   GrKurtosis (absolute gradient kurtosis)
%   GrNonZeros (percentage of pixels with nonzero gradient) 
%   
%  --------------------------------------------

% Initialize output stats structure.
numStats = 5;

% Initialization default 1*5 matrix
stats = zeros(1,numStats);

%{
[dx,dy] = gradient(img);
Grad = sqrt(dx.*dx+dy.*dy);
[m n] = size(Grad);
Grad = Grad(2:m-1,2:n-1);
squa = (m-2)*(n-2);
%}

[m n] = size(Grad);
squa = m * n;

% GrMean (absolute gradient mean)
GrMean = mean(mean(Grad));
% GrVariance (absolute gradient variance)
GrVar = var(Grad(:));
% GrSkewness (absolute gradient skewness)
GrSkewness = skewness(Grad(:));
% GrKurtosis (absolute gradient kurtosis)
GrKurtosis = kurtosis(Grad(:));
% GrNonZeros (percentage of pixels with nonzero gradient)
GrNonZeros = 1- length(find(Grad == 0))/squa;
%----------------insert statistics----------------------------
stats(1,:) = [GrMean GrVar GrSkewness GrKurtosis GrNonZeros];

end

