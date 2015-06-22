% ======================================================================
%> @brief computes the spectral decrease from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vsk spectral decrease
% ======================================================================
function [vsd] = FeatureSpectralDecrease (X, f_s)

    % compute index vector
    k       = [0:size(X,1)-1];
    k(1)    = 1;
    kinv    = 1./k;
    
    % compute slope
    vsd     = (kinv*(X-repmat(X(1,:),size(X,1),1)))./sum(X(2:end,:),1);
       
   % avoid NaN for silence frames
    vsd (sum(X(2:end,:),1) == 0) = 0;

end
