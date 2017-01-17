function stats = histogramfeature(img)
%  -------------------------------------------
%  Current supported statistics include:
%  -------------------------------------------
%   Mean (histogram¡¯s mean)
%   Variance (histogram¡¯s variance)
%   Skewness (histogram¡¯s skewness)
%   Kurtosis (histogram¡¯s kurtosis)
%   Perc.01% (1% percentile)
%   Perc.10% (10% percentile)
%   Perc.50% (50% percentile)
%   Perc.90% (90% percentile)
%   Perc.99% (99% percentile) 
%   
%  --------------------------------------------

% Initialize output stats structure.
numStats = 9;

% Initialization default 1*9 matrix
stats = zeros(1,numStats);

% Mean (histogram's mean)
Mean = mean(mean(img)); 
% Variance (histogram¡¯s variance)
Var = var(img(:));
% Skewness (histogram¡¯s skewness)
Skewness = skewness(img(:));
% Kurtosis (histogram¡¯s kurtosis) 
Kurtosis = kurtosis(img(:));
% Perc.01% (1% percentile) 
Perc01 = prctile(img(:),1);
% Perc.10% (10% percentile)
Perc10 = prctile(img(:),10);
% Perc.50% (50% percentile)
Perc50 = prctile(img(:),50);
% Perc.90% (90% percentile)
Perc90 = prctile(img(:),90);
% Perc.99% (99% percVarentile) 
Perc99 = prctile(img(:),99);
%----------------insert statistics----------------------------
stats(1,:) = [Mean Var Skewness Kurtosis Perc01 Perc10 Perc50 Perc90 Perc99];

end

