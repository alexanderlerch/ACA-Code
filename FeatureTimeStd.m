%computes the standard deviation of a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vstd standard deviation
%> @retval t time stamp
% ======================================================================
function [vstd, t] = FeatureTimeStd(x, iBlockLength, iHopLength, f_s)

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    vstd = zeros(1,iNumOfBlocks);

    for (n = 1:iNumOfBlocks)
        % calculate the standard deviation
        vstd(n) = std(x_b(n, :), 1);
    end
end
