%computes the lag of the average magnitude difference function
%> called by ::ComputePitch
%>
%> @param x: audio signal
%> @param iBlockLength: block length in samples
%> @param iHopLength: hop length in samples
%> @param f_s: sample rate of audio data 
%>
%> @retval f_0 amdf lag (in Hz)
%> @retval t time stamp of f_0 estimate (in s)
% ======================================================================
function [f_0, t] = PitchTimeAmdf(x, iBlockLength, iHopLength, f_s)

    % blocking
    [x_b, t] = ToolBlockAudio(x, iBlockLength, iHopLength, f_s);
    iNumOfBlocks = size(x_b, 1);
    
    % allocate memory
    f_0 = zeros(1, iNumOfBlocks);

    % initialization
    f_max = 2000;
    f_min = 50;
    eta_min = round(f_s/f_max);
    eta_max = round(f_s/f_min);

    for n = 1:iNumOfBlocks
  
        if (sum(abs(x_b(n, :))) == 0)
            f_0(n) = 0;
            continue;
        end
        
        % calculate the amdf_I minimum
        afAMDF = amdf_I(x_b(n, :), eta_max);
        [fDummy, T_0(n)] = min(afAMDF(1+eta_min:end));
        
        % convert to Hz
        f_0(n) = f_s ./ (T_0(n) + eta_min);
    end
end

function [AMDF] = amdf_I(x, eta_max)
    K = length(x);
 
    AMDF = ones(1, K);
    
    for eta=0:min(K-1,eta_max-1)
        AMDF(eta+1) = sum(abs(x(1:K-1-eta) - x(eta+2:end))) / K;
    end
end