%computes f_0 through zero crossing distances
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f_0 double zero crossing distance (in Hz)
%> @retval t time stamp of f_0 estimate (in s)
% ======================================================================
function [f_0, t] = PitchTimeZeroCrossings(x, iBlockLength, iHopLength, f_s)

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    T_0 = zeros(1, iNumOfBlocks);

    for n = 1:iNumOfBlocks
        i_tmp = diff(find(x_b(n, 1:end-1) .* x_b(n, 2:end) < 0));
        %  average distance of zero crossings indicates half period
        T_0(n) = 2 * mean(i_tmp); % or histogram max, ...
    end
 
    % convert to Hz
    f_0 = f_s ./ T_0;
    
    % avoid NaN for silence frames
    f_0 (isnan(f_0)) = 0;
end
