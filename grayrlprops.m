function stats = grayrlprops(varargin)

%GRAYCOPROPS Properties of gray-level run-length matrix.
%  -------------------------------------------
%  STATS = GRAYCOPROPS(GLRLM,PROPERTIES) Each element in  GLRLM, (r,c),
%   is the probability occurrence of pixel having gray level values r, run-length c in the image.
%   GRAYCOPROPS is to calculate PROPERTIES.
%  -------------------------------------------
%  Requirements:
%  -------------------------------------------
%   GLRLM mustbe an cell array of valid gray-level run-length
%   matrices.Recall that a valid glrlm must be logical or numerical.
%  -------------------------------------------
%  Current supported statistics include:
%  -------------------------------------------
%   Short Run Emphasis (SRE)
%   Long Run Emphasis (LRE)
%   Gray-Level Nonuniformity (GLN)
%   Run Length Nonuniformity (RLN)
%   Run Percentage (RP)
%   Low Gray-Level Run Emphasis (LGRE)
%   High Gray-Level Run Emphasis (HGRE)
%   Short Run Low Gray-Level Emphasis (SRLGE)
%   Short Run High Gray-Level Emphasis (SRHGE)
%   Long Run Low Gray-Level Emphasis (LRLGE)
%   Long Run High Gray-Level Emphasis (LRHGE)
%  --------------------------------------------
%{
%   Short Run Emphasis (SRE)
    dgr0_ShrtREmp = RL_STATS(1,1);
    dgr90_ShrtREmp = RL_STATS(2,1);
    dgr45_ShrtREmp = RL_STATS(3,1);
    dgr135_ShrtREmp = RL_STATS(4,1);
%   Long Run Emphasis (LRE)
    dgr0_LngREmph = RL_STATS(1,2);
    dgr90_LngREmp = RL_STATS(2,2);
    dgr45_LngREmp = RL_STATS(3,2);
    dgr135_LngREmp = RL_STATS(4,2);
%   Gray-Level Nonuniformity (GLN)
    dgr0_GLevNonU = RL_STATS(1,3);
    dgr90_GLevNonU = RL_STATS(2,3);
    dgr45_GLevNonU = RL_STATS(3,3);
    dgr135_GLevNonU = RL_STATS(4,3);
%   Run Length Nonuniformity (RLN)
    dgr0_RLNonUni = RL_STATS(1,4);
    dgr90_RLNonUni = RL_STATS(2,4);
    dgr45_RLNonUni = RL_STATS(3,4);
    dgr135_RLNonUni = RL_STATS(4,4);
%   Run Percentage (RP)
    dgr0_RunPerc = RL_STATS(1,5);
    dgr90_RunPerc = RL_STATS(2,5);
    dgr45_RunPerc = RL_STATS(3,5);
    dgr135_RunPerc = RL_STATS(4,5);
%   Low Gray-Level Run Emphasis (LGRE)
    dgr0_LowGREmph = RL_STATS(1,6);
    dgr90_LowGREmph = RL_STATS(2,6);
    dgr45_LowGREmph = RL_STATS(3,6);
    dgr135_LowGREmph = RL_STATS(4,6);
%   High Gray-Level Run Emphasis (HGRE)
    dgr0_HighGREmph = RL_STATS(1,7);
    dgr90_HighGREmph = RL_STATS(2,7);
    dgr45_HighGREmph = RL_STATS(3,7);
    dgr135_HighGREmph = RL_STATS(4,7);
%   Short Run Low Gray-Level Emphasis (SRLGE)
    dgr0_ShrtRLowGREmph = RL_STATS(1,8);
    dgr90_ShrtRLowGREmph = RL_STATS(2,8);
    dgr45_ShrtRLowGREmph = RL_STATS(3,8);
    dgr135_ShrtRLowGREmph = RL_STATS(4,8);
%   Short Run High Gray-Level Emphasis (SRHGE)
    dgr0_ShrtRHighGREmph = RL_STATS(1,9);
    dgr90_ShrtRHighGREmph = RL_STATS(2,9);
    dgr45_ShrtRHighGREmph = RL_STATS(3,9);
    dgr135_ShrtRHighGREmph = RL_STATS(4,9);
%   Long Run Low Gray-Level Emphasis (LRLGE)
    dgr0_LngRLowGREmph = RL_STATS(1,10);
    dgr90_LngRLowGREmph = RL_STATS(2,10);
    dgr45_LngRLowGREmph = RL_STATS(3,10);
    dgr135_LngRLowGREmph = RL_STATS(4,10);
%   Long Run High Gray-Level Emphasis (LRHGE)
    dgr0_LngRHighGREmph = RL_STATS(1,11);
    dgr90_LngRHighGREmph = RL_STATS(2,11);
    dgr45_LngRHighGREmph = RL_STATS(3,11);
    dgr135_LngRHighGREmph = RL_STATS(4,11);
% Fraction (fraction of image in runs)
%}


% Check GLRLM
[GLRLM numGLRLM] = ParseInputs(varargin{:});

% Initialize output stats structure.
% 11 statistics for each GLRLM
numStats = 11;

% % count number of GLRLM
% numGLRLM = length(GLRLM);

% Initialization default 4*11 matrix
stats = zeros(numGLRLM,numStats);

for p = 1 : numGLRLM
    %N-D indexing not allowed for sparse.

    if numGLRLM ~= 1
        % transfer to double matrix
        tGLRLM = GLRLM{p};
    else
        tGLRLM = GLRLM;
    end
    %     if numGLRLM ~= 1
    %         % transfer to double matrix
    %         tGLRLM = normalizeGLRL(GLRLM{p});
    %     else
    %         tGLRLM = normalizeGLRL(GLRLM);
    %     end
    % Get row and column subscripts of GLRLM.  These subscripts correspond to the
    % pixel values in the GLRLM.
    s = size(tGLRLM);
    % colum indicator
    c_vector =1:s(1);
    % row indicator
    r_vector =1:s(2);
    % matrix element indicator
    % Matrix form col and row: using meshgrid, you should transpose before using
    % i.e. if tGLRLM is m*n, then this function return c_matrix n*m,
    % r_matrix n*m.
    [c_matrix,r_matrix] = meshgrid(c_vector,r_vector);

    % Total number of runs
    N_runs = sum(sum(tGLRLM));

    % total number of elements
    N_tGLRLM = s(1)*s(2);

    %--------------------Prepare four matrix for speedup--------------
    % 1.Gray Level Run-Length Pixel Number Matrix
    %     p_p = calculate_p_p(tGLRLM,c_matrix');

    % 2.Gray-Level Run-Number Vector
    %   This vector represents the sum distribution of the number of runs
    %   with gray level i.
    p_g = sum(tGLRLM);

    % 3.Run-Length Run-Number Vector
    %   This vector represents the sum distribution of the number of runs
    %   with run length j.
    p_r = sum(tGLRLM,2)';

    % 4.Gray-Level Run-Length-One Vector
    %
    % p_o = tGLRLM(:,1); % Not used yet
    % ----------------------End four matrix---------------------------
    %
    %------------------------Statistics-------------------------------
    % 1. Short Run Emphasis (SRE)
    SRE = sum(p_r./(c_vector.^2))/N_runs;
    % 2. Long Run Emphasis (LRE)
    LRE = sum(p_r.*(c_vector.^2))/N_runs;
    % 3. Gray-Level Nonuniformity (GLN)
    GLN = sum(p_g.^2)/N_runs;
    % 4. Run Length Nonuniformity (RLN)
    RLN = sum(p_r.^2)/N_runs;
    % 5. Run Percentage (RP)
    RP = N_runs/N_tGLRLM;
    % 6. Low Gray-Level Run Emphasis (LGRE)
    LGRE = sum(p_g./(r_vector.^2))/N_runs;
    % 7. High Gray-Level Run Emphasis (HGRE)
    HGRE = sum(p_g.*r_vector.^2)/N_runs;
    % 8. Short Run Low Gray-Level Emphasis (SRLGE)
    SGLGE =calculate_SGLGE(tGLRLM,r_matrix',c_matrix',N_runs);
    % 9. Short Run High Gray-Level Emphasis (SRHGE)
    SRHGE =calculate_SRHGE(tGLRLM,r_matrix',c_matrix',N_runs);
    % 10. Long Run Low Gray-Level Emphasis (LRLGE)
    LRLGE =calculate_LRLGE(tGLRLM,r_matrix',c_matrix',N_runs);
    % 11.Long Run High Gray-Level Emphasis (LRHGE
    LRHGE =calculate_LRHGE(tGLRLM,r_matrix',c_matrix',N_runs);
    %----------------insert statistics----------------------------
    stats(p,:)=[SRE LRE GLN RLN  RP LGRE HGRE SGLGE SRHGE LRLGE  LRHGE ];
end % end all run length matrixs

%   ----------------------Utility functions--------------------
%-----------------------------------------------------------------------------
% function glrl = normalizeGLRL(glrl)
%
% % Normalize glcm so that sum(glcm(:)) is one.
% if any(glrl(:))
%   glrl = glrl ./ sum(glrl(:));
% end
% function p_p = calculate_p_p(GLRLM,c) % Note: currently not used
%
% % p_p(i; j) = GLRLM(i,j)*j
% % Each element of the matrix represents the number of pixels of run length
% % j and gray-level i. Compared to the original matrix, the new matrix gives
% % equal emphasis to all length of runs in an image.
%
% term1 =  c; % j index in matrix size
% term2 = GLRLM;
% p_p = term1 .* term2;
%---------------------------------
function SGLGE =calculate_SGLGE(tGLRLM,r_matrix,c_matrix,N_runs)
% Short Run Low Gray-Level Emphasis (SRLGE):

term = tGLRLM./((r_matrix.*c_matrix).^2);
SGLGE= sum(sum(term))./N_runs;

%------------------------------------
function  SRHGE =calculate_SRHGE(tGLRLM,r_matrix,c_matrix,N_runs)
% Short Run High Gray-Level Emphasis (SRHGE):
%
term  = tGLRLM.*(r_matrix.^2)./(c_matrix.^2);
SRHGE = sum(sum(term))/N_runs;
%------------------------------------
function   LRLGE =calculate_LRLGE(tGLRLM,r_matrix,c_matrix,N_runs)
% Long Run Low Gray-Level Emphasis (LRLGE):
%
term  = tGLRLM.*(c_matrix.^2)./(r_matrix.^2);
LRLGE = sum(sum(term))/N_runs;
%---------------------------------------
function  LRHGE =calculate_LRHGE(tGLRLM,r_matrix,c_matrix,N_runs)
% Long Run High Gray-Level Emphasis (LRHGE):
%
term  = tGLRLM.*(c_matrix.^2).*(r_matrix.^2);
LRHGE = sum(sum(term))/N_runs;
%----------------------------------------

%-----------------------------------------------------------------------------
function [glrlm num_glrlm] = ParseInputs(varargin)
% check stability of inputs
%
% first receive all inputs
glrlm = varargin{:};
% get numbers total
num_glrlm=length(glrlm);
% then for each element, check its stability
for i=1:num_glrlm
    % The 'nonnan' and 'finite' attributes are not added to iptcheckinput because the
    % 'integer' attribute takes care of these requirements.
    % iptcheckinput(glrlm,{'cell'},{'real','nonnegative','integer'}, ...
    % mfilename,'GLRLM',1);
    iptcheckinput(glrlm{i},{'logical','numeric'},{'real','nonnegative','integer'},...
        mfilename,'GLRLM',1);
    % Cast GLRLM to double to avoid truncation by data type. Note that GLRLM is not an
    % image.
    if ~isa(glrlm,'double')
        glrlm{i}= double(glrlm{i});
    end
end