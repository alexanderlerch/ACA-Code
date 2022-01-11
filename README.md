![GitHub](https://img.shields.io/github/license/alexanderlerch/ACA-Code)
![GitHub top language](https://img.shields.io/github/languages/top/alexanderlerch/ACA-Code)
![GitHub issues](https://img.shields.io/github/issues-raw/alexanderlerch/ACA-Code)

# ACA-Code
Matlab scripts accompanying the book "An Introduction to Audio Content Analysis" (www.AudioContentAnalysis.org). The source code shows example implementations of basic approaches, features, and algorithms for music audio content analysis.

## functionality
The top-level functions are (alphabetical):
> - [`ComputeBeatHisto`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeBeatHisto.m): calculates a simple beat histogram
> - [`ComputeChords`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeChords.m): simple chord recognition
> - [`ComputeFeature`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeFeature.m): calculates instantaneous features 
> - [`ComputeFingerprint`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeFingerprint.m): audio fingerprint extraction 
> - [`ComputeKey`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeKey.m): calculates a simple key estimate
> - [`ComputeMelSpectrogram`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeMelSpectrogram.m): computes a mel spectrogram
> - [`ComputeNoveltyFunction`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeNoveltyFunction.m): simple onset detection
> - [`ComputePitch`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputePitch.m): calculates a fundamental frequency estimate
> - [`ComputeSpectrogram`](https://github.com/alexanderlerch/ACA-Code/blob/master/ComputeSpectrogram.m): computes a magnitude spectrogram

The names of the additional functions follow the following 
conventions:
> - `Feature`*: instantaneous features
> - `Pitch`*: pitch tracking approach
> - `Novelty`*: novelty function computation
> - `Tool`*: additional helper functions and basic algorithms such as 
>   - [Blocking](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolBlockAudio.m) of audio into overlapping blocks
>   - Conversion ([freq2bark](https://github.com/alexanderlerch/ACA-Code/blob/masterToolFreq2Bark.m), [freq2mel](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolFreq2Mel.m), [freq2midi](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolFreq2Midi.m), [mel2freq](https://github.com/alexanderlerch/ACA-Code/blob/master/Mel2Freq.m), [midi2freq](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolMidi2Freq.m))
>   - Filterbank ([Gammatone](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolGammatoneFb.m))
>   - [Gaussian Mixture Model](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolGmm.m)
>   - [Principal Component Analysis](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolPca.m)
>   - [Feature Selection](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolSeqFeatureSel.m)
>   - [Dynamic Time Warping](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolSimpleDtw.m)
>   - [K-Means Clustering](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolSimpleKmeans.m)
>   - [K Nearest Neighbor classification](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolSimpleKnn.m)
>   - [Non-Negative Matrix Factorization](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolSimpleNmf.m)
>   - [Viterbi](https://github.com/alexanderlerch/ACA-Code/blob/master/ToolViterbi.m) algorithm


## design principles
Please note that the provided code examples are only _intended to showcase 
algorithmic principles_ – they are not entirely suitable for practical usage without 
parameter optimization and additional algorithmic tuning. Rather, they intend to show how to implement audio analysis solutions and to facilitate algorithmic understanding to enable the reader to design and implement their own analysis approaches. 

### minimal dependencies
The _required dependencies_ are reduced to a minimum, more specifically to only the signal processing toolbox, for the following reasons:
* accessibility, i.e., clear algorithmic implementation from scratch without obfuscation by using 3rd party implementations,
* maintainability through independence of 3rd party code. 


### readability
Consistent variable naming and formatting, as well as the choice for simple implementations allow for easier parsing.
The readability of the source code will sometimes come at the cost of lower performance.

### cross-language comparability
All code is matched exactly with [Python implementations](https://www.github.com/alexanderlerch/pyACA) and the equations in the book. This also means that the code might **violate typical style conventions** in order to be consistent.

## related repositories and links
The python source code in this repository is matched with corresponding source code in the [Python repository](https://www.github.com/alexanderlerch/pyACA).

Other, _related repositories_ are
* [ACA-Slides](https://www.github.com/alexanderlerch/ACA-Slides): slide decks for teaching and learning audio content analysis
* [ACA-Plots](https://www.github.com/alexanderlerch/ACA-Plots): Matlab scripts for generating all plots in the book and slides

The _main entry point_ to all book-related information is [AudioContentAnalysis.org](https://www.AudioContentAnalysis.org)

## getting started

**example 1**: computation and plot of the Spectral Centroid

```matlab
% read audio file from cWavePath
[x, f_s] = wavread(cWavePath);

% compute SpectralCentroid
[v_sc, t] = ComputeFeature('SpectralCentroid', x, f_s);

% plot result
plot(t, v_sc), grid on, xlabel('t'), ylabel('v_sc')
```

