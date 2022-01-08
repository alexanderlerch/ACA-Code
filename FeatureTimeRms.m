% ======================================================================
%> @brief computes the RMS of a time domain signal
%> called by ::ComputeFeature
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vrms root mean square (row 1: block-based rms, row 2: single pole approx)
%> @retval t time stamp
% ======================================================================
function [vrms, t] = FeatureTimeRms(x, iBlockLength, iHopLength, f_s)

    T_i     = .3; 
    alpha   = 1-exp(-2.2/f_s/T_i);

    % number of results
    iNumOfBlocks = floor ((length(x)-iBlockLength)/iHopLength + 1);
    
    % compute time stamps
    t       = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    vrms    = zeros(2,iNumOfBlocks);

    % single pole implementation
    v_sp    = filter(alpha, [1 -(1-alpha)],x.^2);

    % per block standard implementation
    for (n = 1:iNumOfBlocks)
        i_start     = (n-1)*iHopLength + 1;
        i_stop      = min(length(x),i_start + iBlockLength - 1);
        
        % calculate the rms
        vrms(1,n)   = sqrt(mean(x(i_start:i_stop).^2));
        vrms(2,n)   = max(sqrt(v_sp(i_start:i_stop)));
    end

    % convert to dB
    epsilon = 1e-5; %-100dB
    
    vrms(vrms < epsilon) = epsilon;
    vrms = 20*log10(vrms);
end
