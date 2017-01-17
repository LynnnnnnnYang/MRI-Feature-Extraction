function stats = graycomyprops(varargin)
%  -------------------------------------------
%  Current supported statistics include:
%  -------------------------------------------
%   AngScMom (angular second moment)
%   Contrast (contrast)
%   Correlat (correlation)
%   homogeneity (Homogeneity)

%   TBC Part:
%   SumOfSqs (sum of squares)
%   InvDfMom (inverse difference moment)
%   SumAverg (sum average)
%   SumVarnc (sum ariance)
%   SumEntrp (sum entropy)
%   Entropy (entropy)
%   DifVarnc (difference variance)
%   DifEntrp (difference entropy) 
%  --------------------------------------------

% Check GLCMS
[glcm numGLCM] = ParseInputs(varargin{:});

% Initialize output stats structure.
% 11 statistics for each GLCM
numStats = 12;

% Initialization default 20* matrix
stats = zeros(numGLCM,numStats);

for p = 1 : numGLCM
    
	if numGLCM ~= 1 %N-D indexing not allowed for sparse. 
        tGLCM = normalizeGLCM(glcm{p});
    else 
        tGLCM = normalizeGLCM(glcm);
	end
  
    % Get row and column subscripts of GLRLM.  These subscripts correspond to the
    % pixel values in the GLRLM.
    s = size(tGLCM);
    [c,r] = meshgrid(1:s(1),1:s(2));
    r = r(:);
    c = c(:);
    
    Pr = sum(tGLCM,2);
    Pc = sum(tGLCM,1);
    % Calculate the mean and standard deviation of a pixel value in the row
    mr = meanIndex(r,tGLCM);
    Sr = stdIndex(r,tGLCM,mr);
    % mean and standard deviation of pixel value in the column direction, e.g.,
    mc = meanIndex(c,tGLCM);
    Sc = stdIndex(c,tGLCM,mc);
    
    Prplusc = zeros(s(1)*2+1,1);
    Prminusc = zeros(s(1),1);
    for i = 1:s(1)
        for j = 1:s(2)
            Prplusc(i+j-1,1) = Prplusc(i+j-1,1) + tGLCM(i,j);
            Prminusc(abs(i-j)+1,1) = Prminusc(abs(i-j)+1,1) + tGLCM(i,j);
        end
    end     

    % 1. AngScMom (angular second moment)
    Energy = calculateEnergy(tGLCM);
    % 2. Contrast (contrast)
    Contrast = calculateContrast(tGLCM,r,c);
    % 3. Correlat (correlation)
    Correlation = calculateCorrelation(tGLCM,r,c);  
    % 4. Homogeneity (homogeneity)
    Homogeneity = calculateHomogeneity(tGLCM,r,c);
    % 5. SumOfSqs (sum of squares)
    SumOfSqs = calculateSumOfSqs(tGLCM);
    % 6. InvDfMom (inverse difference moment)
    InvDfMom = calculateInvDfMom(tGLCM);
    % 7. SumAverg (sum average)
    SumAverg = calculateSumAverg(Prplusc); 
    % 8. SumEntrp (sum entropy)
    SumEntrp = calculateSumEntrp(Prplusc); 
    % 9. SumVarnc (sum ariance)
    SumVarnc = calculateSumVarnc(Prplusc,SumEntrp); 
    %10. Entropy (entropy)
    Entropy = calculateEntropy(tGLCM); 
    %11. DifVarnc (difference variance)
    DifVarnc = calculateDifVarnc(Prminusc); 
    %12. DifEntrp (difference entropy) 
    DifEntrp = calculateDifEntrp(Prminusc); 

%----------------insert statistics----------------------------
    stats(p,:)=[Energy Contrast Correlation SumOfSqs InvDfMom SumAverg SumVarnc SumEntrp Entropy DifVarnc DifEntrp Homogeneity]; 
end    

%-----------------------------------------------------------------------------
function glcm = normalizeGLCM(glcm)
% Normalize glcm so that sum(glcm(:)) is one.
glcm = glcm ./ sum(glcm(:));
  
%-----------------------------------------------------------------------------
function Contr = calculateContrast(glcm,r,c)
% Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
% Addison-Wesley, 1992, p. 460.  
k = 2;
l = 1;
term1 = abs(r - c).^k;
term2 = glcm.^l;
  
term = term1 .* term2(:);
Contr = sum(term);

%-----------------------------------------------------------------------------
function Corr = calculateCorrelation(glcm,r,c)
% References: 
% Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1, Addison-Wesley,
% 1992, p. 460.
% Bevk M, Kononenko I. A Statistical Approach to Texture Description of Medical
% Images: A Preliminary Study., The Nineteenth International Conference of
% Machine Learning, Sydney, 2002. 
% http://www.cse.unsw.edu.au/~icml2002/workshops/MLCV02/MLCV02-Bevk.pdf, p.3.
  
% Correlation is defined as the covariance(r,c) / S(r)*S(c) where S is the
% standard deviation.

% Calculate the mean and standard deviation of a pixel value in the row
% direction direction. e.g., for glcm = [0 0;1 0] mr is 2 and Sr is 0.
mr = meanIndex(r,glcm);
Sr = stdIndex(r,glcm,mr);
  
% mean and standard deviation of pixel value in the column direction, e.g.,
% for glcm = [0 0;1 0] mc is 1 and Sc is 0.
mc = meanIndex(c,glcm);
Sc = stdIndex(c,glcm,mc);

term1 = (r - mr) .* (c - mc) .* glcm(:);
term2 = sum(term1);

Corr = term2 / (Sr * Sc);

%-----------------------------------------------------------------------------
function StdInd = stdIndex(index,glcm,m)

term1 = (index - m).^2 .* glcm(:);
StdInd = sqrt(sum(term1));

%-----------------------------------------------------------------------------
function MeanInd = meanIndex(index,glcm)

MeanInd = index .* glcm(:);
MeanInd = sum(MeanInd);

%-----------------------------------------------------------------------------
function Energ = calculateEnergy(glcm)
% Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
% Addison-Wesley, 1992, p. 460.  
  
foo = glcm.^2;
Energ = sum(foo(:));

%-----------------------------------------------------------------------------
function Homog = calculateHomogeneity(glcm,r,c)
% Reference: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
% Addison-Wesley, 1992, p. 460.  
  
term1 = (1 + abs(r - c));
term = glcm(:) ./ term1;
Homog = sum(term);

%-----------------------------------------------------------------------------
function SumOfSqs = calculateSumOfSqs(glcm)
SumOfSqs = 0;
s = size(glcm);
m = mean(mean(glcm));
for i = 1:s(1)
    for j = 1:s(2)
        SumOfSqs = SumOfSqs + glcm(i,j)*((i-m)^2);
    end
end        

%-----------------------------------------------------------------------------
function InvDfMom = calculateInvDfMom(glcm)
InvDfMom = 0;
s = size(glcm);
for i = 1:s(1)
    for j = 1:s(2)
        InvDfMom = InvDfMom + glcm(i,j)/(1+(i-j)^2);
    end
end     

%-----------------------------------------------------------------------------
function SumAverg = calculateSumAverg(Prplusc)
SumAverg = 0;
s = size(Prplusc);
for i = 1:s(1)
    SumAverg = SumAverg + (i+1) * Prplusc(i,1);
end     

%-----------------------------------------------------------------------------
function SumVarnc = calculateSumVarnc(Prplusc,SumEntrp)
SumVarnc = 0;
s = size(Prplusc);
for i = 1:s(1)
    SumVarnc = SumVarnc + (((i+1) - SumEntrp)^2)*Prplusc(i,1);
end     

%-----------------------------------------------------------------------------
function SumEntrp = calculateSumEntrp(Prplusc)
SumEntrp = - sum(sum(Prplusc.*log10(Prplusc+eps))); 

%-----------------------------------------------------------------------------
function Entropy = calculateEntropy(glcm)
Entropy = - sum(sum(glcm.*log10(glcm+eps)));  

%-----------------------------------------------------------------------------
function DifVarnc = calculateDifVarnc(Prminusc)
DifVarnc = 0;
s = size(Prminusc);
for i = 1:s(1)
    DifVarnc = DifVarnc + ((i-1)^2)*Prminusc(i,1);
end     

%-----------------------------------------------------------------------------
function DifEntrp = calculateDifEntrp(Prminusc)
DifEntrp = - sum(sum(Prminusc.*log10(Prminusc+eps)));  

%-----------------------------------------------------------------------------
function [glcm num_glcm] = ParseInputs(varargin)

% first receive all inputs
glcm = varargin{:};
% get numbers total
num_glcm=length(glcm);
% then for each element, check its stability
for i=1:num_glcm
    % The 'nonnan' and 'finite' attributes are not added to iptcheckinput because the
    % 'integer' attribute takes care of these requirements.
    % iptcheckinput(glrlm,{'cell'},{'real','nonnegative','integer'}, ...
    % mfilename,'GLRLM',1);
    iptcheckinput(glcm{i},{'logical','numeric'},{'real','nonnegative','integer'},...
        mfilename,'GLCM',1);
    % Cast GLRLM to double to avoid truncation by data type. Note that GLRLM is not an
    % image.
    if ~isa(glcm,'double')
        glcm{i}= double(glcm{i});
    end
end


