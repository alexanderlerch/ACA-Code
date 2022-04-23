%computes a feature from the audio data
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
%> @param x: time domain sample data (dimension samples x channels)
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval v feature value
%> @retval t time stamp for the feature value
% ======================================================================
function [v, t] = ComputeFeature (cFeatureName, x, f_s, afWindow, iBlockLength, iHopLength)

    % set feature function handle
    hFeatureFunc = str2func (['Feature' cFeatureName]);

    % set default parameters if necessary
    if (nargin < 6)
        iHopLength = 2048;
    end
    if (nargin < 5)
        iBlockLength = 4096;
    end
  
    % pre-processing: down-mixing
    x = ToolDownmix(x);
    
    % pre-processing: normalization (not necessary for many features)
    x = ToolNormalizeAudio(x);
 
    if (IsSpectral_I(cFeatureName))
        if (nargin < 4 || isempty(afWindow))
            afWindow = hann(iBlockLength, 'periodic');
        end
        
        % compute FFT window function
        if (length(afWindow) ~= iBlockLength)
            error('window length mismatch');
        end                        

        % in the real world, we would do this block by block...
        [X, f, t] = ComputeSpectrogram(x, ...
                                    f_s, ...
                                    afWindow, ...
                                    iBlockLength, ...
                                    iHopLength);
        
        % compute feature
        v = hFeatureFunc(X, f_s);
    end %if (IsSpectral_I(cFeatureName))
    
    if (IsTemporal_I(cFeatureName))
        % compute feature
        [v,t] = hFeatureFunc(   x, ...
                                iBlockLength, ...
                                iHopLength, ...
                                f_s);
    end %if (IsTemporal_I(cFeatureName))
end

function [bResult] = IsSpectral_I(cName)
    bResult = false;
    iIdx = strfind(cName, 'Spectral');
    if (~isempty(iIdx))
        if (iIdx(1) == 1)
            bResult = true;
        end
    end
end

function [bResult] = IsTemporal_I(cName)
    bResult = false;
    iIdx = strfind(cName, 'Time');
    if (~isempty(iIdx))
        if (iIdx(1) == 1)
            bResult = true;
        end
    end
end