![GitHub](https://img.shields.io/github/license/alexanderlerch/ACA-Code)
![GitHub top language](https://img.shields.io/github/languages/top/alexanderlerch/ACA-Code)
![GitHub issues](https://img.shields.io/github/issues-raw/alexanderlerch/ACA-Code)

Matlab sources accompanying the book
An Introduction to Audio Content Analysis - 
Applications in Signal Processing and Music Informatics
by Alexander Lerch, info@AudioContentAnalysis.org

Please note that the provided code examples as matlab 
functions are only intended to showcase algorithmic 
principles – they are not suited to be used without 
parameter optimization and additional algorithmic tuning.

The majority of these matlab sources require the Matlab 
Signal Processing Toolbox installed. Several scripts 
(such as MFCCs and Gammatone filters) are based on 
implementations in Slaney’s Auditory Toolbox.

Please feel free to visit 
http://www.audiocontentanalysis.org/code/
to find the latest versions of this code or to submit 
comments or code that fixes, improves and adds 
functionality.

The top-level functions are:
- ComputeFeature: calculates instantaneous features 
- ComputePitch: calculates a fundamental frequency estimate
- ComputeKey: calculates a simple key estimate
- ComputeNoveltyFunction: simple onset detection
- ComputeBeatHisto: calculates a simple beat histogram

The names of the additional functions follow the following 
conventions:
- Feature*: instantaneous features
- Pitch*: pitch tracking approach
- Novelty*: novelty function computation
- Tool*: additional help functions such as frequency scale 
conversion, dynamic time warping, gammatone filterbank, ...

Example: Computation and plot of the Spectral Centroid

```matlab
% read audio file from cWavePath
[afAudioData, fs] = wavread(cWavePath);

% compute SpectralCentroid
[v_sc,t] = ComputeFeature('SpectralCentroid', afAudioData, fs);

% plot result
plot(t,v), grid on, xlabel('t'), ylabel('v_sc')
```

