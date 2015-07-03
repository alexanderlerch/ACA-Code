% ======================================================================
%> @brief computes a feature from the audio data
%>
%> supported features are:
%>  'SpectralCentroid',
%>  'SpectralCrestFactor',
%>  'SpectralDecrease',
%>  'SpectralFlatness',
%>  'SpectralFlux',
%>  'SpectralKurtosis',
%>  'SpectralMfccs',
%>  'SpectralPitchChroma',
%>  'SpectralRolloff',
%>  'SpectralSkewness',
%>  'SpectralSlope',
%>  'SpectralSpread',
%>  'SpectralTonalPowerRatio',
%>  'TimeAcfCoeff',
%>  'TimeMaxAcf',
%>  'TimePeakEnvelope',
%>  'TimePredictivityRatio',
%>  'TimeRms',
%>  'TimeStd',
%>  'TimeZeroCrossingRate',
%>
%> @param cFeatureName: feature to compute, e.g. 'SpectralSkewness'
%> @param afAudioData: time domain sample data, dimension channels X samples
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval v feature value
%> @retval t time stamp for the feature value
% ======================================================================
function [v, t] = ComputeFeature (cFeatureName, afAudioData, f_s, afWindow, iBlockLength, iHopLength)

    % set feature function handle
    hFeatureFunc    = str2func (['Feature' cFeatureName]);

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength      = 2048;
    end
    if (nargin < 5)
        iBlockLength    = 4096;
    end
  
    % pre-processing: down-mixing
    if (size(afAudioData,2)> 1)
        afAudioData = mean(afAudioData,2);
    end
    % pre-processing: normalization (not necessary for many features)
    if (length(afAudioData)> 1)
        afAudioData = afAudioData/max(abs(afAudioData));
    end
   
    if (IsSpectral(cFeatureName))
        if (nargin < 4 || isempty(afWindow))
            afWindow    = hann(iBlockLength,'periodic');
        end
        
        % compute FFT window function
        if (length(afWindow) ~= iBlockLength)
            error('window length mismatch');
        end        

        % in the real world, we would do this block by block...
        [X,f,t]     = spectrogram(  afAudioData,...
                                    afWindow,...
                                    iBlockLength-iHopLength,...
                                    iBlockLength,...
                                    f_s);
        
        % magnitude spectrum
        X           = abs(X)*2/iBlockLength;
        
        % compute feature
        v           = hFeatureFunc(X, f_s);
    end %if (IsSpectral(cFeatureName))
    
    if (IsTemporal(cFeatureName))
        % compute feature
        [v,t]       = hFeatureFunc(afAudioData, iBlockLength, iHopLength, f_s);
    end %if (IsTemporal(cFeatureName))
end

function [bResult] = IsSpectral(cName)
    bResult     = false;
    iIdx        = strfind(cName, 'Spectral');
    if (~isempty(iIdx))
        if (iIdx(1) == 1)
            bResult = true;
        end
    end
end

function [bResult] = IsTemporal(cName)
    bResult     = false;
    iIdx        = strfind(cName, 'Time');
    if (~isempty(iIdx))
        if (iIdx(1) == 1)
            bResult = true;
        end
    end
end