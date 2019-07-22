% ======================================================================
%> @brief computes the lag of the average magnitude difference function
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f amdf lag (in Hz)
% ======================================================================
function [f, t] = PitchTimeAmdf(x, iBlockLength, iHopLength, f_s)

    % number of results
    iNumOfBlocks    = ceil (length(x)/iHopLength);
    
    % compute time stamps
    t               = ((0:iNumOfBlocks-1) * iHopLength + (iBlockLength/2))/f_s;
    
    % allocate memory
    f               = zeros(1,iNumOfBlocks);

    % initialization
    f_max           = 2000;
    f_min           = 50;
    eta_min         = round(f_s/f_max);
    eta_max         = round(f_s/f_min);

    for (n = 1:iNumOfBlocks)
        i_start         = (n-1)*iHopLength + 1;
        i_stop          = min(length(x),i_start + iBlockLength - 1);
  
        if (sum(abs(x(i_start:i_stop))) == 0)
            f(n) = 0;
            continue;
        end
        
        % calculate the amdf minimum
        afAMDF          = amdf(x(i_start:i_stop), eta_max);
        [fDummy, f(n)]  = min(afAMDF(1+eta_min:end));
        
        % convert to Hz
        f(n) = f_s ./ (f(n) + eta_min);
    end
end

function [AMDF] = amdf(x, eta_max)
    K   = length(x);
 
    AMDF    = ones(1, K);
    
    for (eta=0:min(K-1,eta_max-1))
        AMDF(eta+1) = sum(abs(x(1:K-1-eta)-x(eta+2:end)))/K;
    end
end