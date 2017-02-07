function stats = haarfeature(LL,LH,HL,HH)
%  -------------------------------------------
%  Current supported statistics include:
%  -------------------------------------------
%   WavEn (wavelet energy) 
%   
%  --------------------------------------------

% Initialize output stats structure.
numStats = 4;

% Initialization default 1*5 matrix
stats = zeros(1,numStats);
SUM = sum(LL(:)) + sum(LH(:)) + sum(HL(:)) + sum(HH(:));
% SUM = 1; 
    WavEnLL = WavEng(LL)/SUM;
    WavEnLH = WavEng(LH)/SUM;
    WavEnHL = WavEng(HL)/SUM;
    WavEnHH = WavEng(HH)/SUM;
    
stats(1,:) = [WavEnLL WavEnLH WavEnHL WavEnHH];

end

%-----------------------------------------------------------------------------
function WavEn = WavEng(wav)
WavEn = 0;
[m n] = size(wav);
for k=1:m
  for  j=1:n;
       WavEn = WavEn + wav(k,j)*wav(k,j)*j;
   end
end
end

