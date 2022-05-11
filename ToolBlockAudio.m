%blocks audio signal into overlapping blocks
%>
%> @param x: audio signal (dimension length x 1)
%> @param iBlockLength: target block size
%> @param iHopLength: target hopsize
%> @param f_s: sample rate
%>
%> @retval x_b (dimension iNumOfBlocks x iBlockLength)
%> @retval t time stamps for blocks
% ======================================================================
function [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s)
    
    iNumBlocks = ceil(size(x, 1)/iHopLength );
    
    % time stamp vector
    t = (0:(iNumBlocks-1)) * iHopLength / f_s + iBlockLength/(2*f_s);
    
    % pad with zeros just to make sure it runs for weird inputs, too
    xPadded = [x; zeros(iBlockLength+iHopLength, 1)];
 
    x_b = zeros(iNumBlocks, iBlockLength);
    
    for n = 1:iNumBlocks
        x_b(n,:) = xPadded((n-1)*iHopLength+1:(n-1)*iHopLength+iBlockLength);
    end
end
