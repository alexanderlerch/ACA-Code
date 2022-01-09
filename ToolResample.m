function [x_out, t_out] = ToolResample(x, fs_out, fs_in)

    if (fs_out > fs_in)
        omega_cutoff = fs_in / fs_out;
    else
        omega_cutoff = fs_out / fs_in;
    end
    
    % compute filter coefficients
    iOrder = 4;
    [b, a] = butter(iOrder, 0.9 * omega_cutoff);

    % time axes
    t_in    = (0:length(x)-1) / fs_in;
    t_out   = (0:round(t_in(end) * fs_out)) / fs_out;
    if (fs_out > fs_in)
        % upsample: interpolate and filter
        
        % this uses the most horrible interpolation possible
        x_out = interp1(t_in, x, t_out,'linear');
        
        % low pass filter
        x_out = filtfilt(b, a, x_out);
    else
        % downsample: filter and interpolate
        
        % low pass filter
        x_out = filtfilt(b, a, x);
        
        % this uses the most horrible interpolation possible
        x_out = interp1(t_in, x_out, t_out,'linear');
    end
end
