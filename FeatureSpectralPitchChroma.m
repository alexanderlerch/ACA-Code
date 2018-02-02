% ======================================================================
%> @brief computes the pitch chroma from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vpc pitch chroma
% ======================================================================
function [vpc] = FeatureSpectralPitchChroma(X, f_s)

    % allocate memory
    vpc         = zeros(12, size(X,2));

    % generate filter matrix
    H           = GeneratePcFilters(size(X,1), f_s);
 
    % compute pitch chroma
    vpc         = H * X.^2;
    
    % norm pitch chroma to a sum of 1
    vpc         = vpc ./ repmat(sum(vpc,1), 12, 1);
       
    % avoid NaN for silence frames
    vpc (:,sum(X,1) == 0) = 0;
end

%> generate the semi-tone filters (simple averaging)
function [H] = GeneratePcFilters (iSpecLength, f_s)

    % initialization at C4
    f_mid           = 261.63;
    iNumOctaves     = 4;
    
    %sanity check
    while (f_mid*2^iNumOctaves > f_s/2 )
        iNumOctaves = iNumOctaves - 1;
    end
    
    H               = zeros (12, iSpecLength);
    
    for (i = 1:12)
        afBounds  = [2^(-1/24) 2^(1/24)] * f_mid * 2* (iSpecLength-1)/f_s;
        for (j = 1:iNumOctaves)
           iBounds                      = [ceil(2^(j-1)*afBounds(1)) floor(2^(j-1)*afBounds(2))];
           H(i,iBounds(1):iBounds(2))   = 1/(iBounds(2)+1-iBounds(1));
        end
        % increment to next semi-tone
        f_mid   = f_mid*2^(1/12);
    end   
end
