iNumBands = 20;
f_s = 48000;
f_low    = 100;
iFFTLength  = 8192;

X       = ToolGammatoneFb([1 zeros(1,iFFTLength-1)], f_s, iNumBands, f_low);

X       = 20*log10(abs(fft(X')));
X       = X(1:(iFFTLength/2),:);
f       = (0:(iFFTLength/2-1))*f_s/iFFTLength/1000;

figure(1),plot(f,X); grid on; axis([0 16 -80 0]);