%computes the zero crossing rate from a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vzc zero crossing rate
%> @retval t time stamp
% ======================================================================
function [vzc, t] = FeatureTimeZeroCrossingRate(x, iBlockLength, iHopLength, f_s)
 
    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    vzc = zeros(1, iNumOfBlocks);
    
    for n = 1:iNumOfBlocks
        % compute the zero crossing rate
        vzc(n)  = 0.5 * mean(abs(diff(sign(x_b(n, :)))));
    end
end
