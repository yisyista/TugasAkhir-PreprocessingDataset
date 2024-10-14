function features = extractGSRFeatures(rawGSR, phasicGSR, onsets, offsets, peaks, fs)
% extractGSRFeatures Ekstraksi fitur dari sinyal GSR
%
% Input:
%   rawGSR    - Sinyal GSR mentah
%   phasicGSR - Sinyal GSR fasik (phasic)
%   onsets    - Indeks onsets SCR
%   offsets   - Indeks offsets SCR
%   peaks     - Indeks puncak SCR
%   fs        - Frekuensi sampling (Hz)
%
% Output:
%   features  - Struktur yang berisi fitur-fitur GSR

    % Inisialisasi struktur fitur
    features = struct();

    %% 1. Fitur Domain Waktu

    % Skin Conductance Level (SCL)
    features.SCL_Mean = mean(rawGSR);
    features.SCL_STD = std(rawGSR);
    features.SCL_Skewness = skewness(rawGSR);
    features.SCL_Kurtosis = kurtosis(rawGSR);
    
    % Skin Conductance Response (SCR)
    numSCR = length(peaks);
    features.SCR_Number = numSCR;
    
    if numSCR > 0
        % Amplitudo SCR (puncak - baseline)
        amplitudes = rawGSR(peaks(:,2)) - rawGSR(onsets(:,2));
        features.SCR_Amplitude_Mean = mean(amplitudes);
        features.SCR_Amplitude_STD = std(amplitudes);
        features.SCR_Amplitude_Max = max(amplitudes);
        features.SCR_Amplitude_Min = min(amplitudes);
        
        % Durasi SCR (offset - onset)
        durations = (offsets(:,2) - onsets(:,2)) / fs; % dalam detik
        features.SCR_Duration_Mean = mean(durations);
        features.SCR_Duration_STD = std(durations);
        features.SCR_Duration_Max = max(durations);
        features.SCR_Duration_Min = min(durations);
        
        % Frekuensi SCR (SCR per menit)
        totalTime = length(rawGSR) / fs / 60; % dalam menit
        features.SCR_Frequency = numSCR / totalTime;
    else
        features.SCR_Amplitude_Mean = 0;
        features.SCR_Amplitude_STD = 0;
        features.SCR_Amplitude_Max = 0;
        features.SCR_Amplitude_Min = 0;
        features.SCR_Duration_Mean = 0;
        features.SCR_Duration_STD = 0;
        features.SCR_Duration_Max = 0;
        features.SCR_Duration_Min = 0;
        features.SCR_Frequency = 0;
    end

    % Variabilitas SCL
    features.SCL_Variance = var(rawGSR);

    % Slope SCL (Regresi Linier)
    t = (1:length(rawGSR))' / fs;
    p = polyfit(t, rawGSR, 1);
    features.SCL_Slope = p(1); % Slope dalam µS/detik

    %% 2. Fitur Statistik
    features.GSR_Mean = mean(rawGSR);
    features.GSR_STD = std(rawGSR);
    features.GSR_Skewness = skewness(rawGSR);
    features.GSR_Kurtosis = kurtosis(rawGSR);
    features.GSR_Max = max(rawGSR);
    features.GSR_Min = min(rawGSR);

    %% 3. Fitur Frekuensi-Domain
    % Menggunakan FFT untuk menghitung PSD
    N = length(rawGSR);
    Y = fft(rawGSR);
    P2 = abs(Y/N);
    P1 = P2(1:floor(N/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:(floor(N/2)))/N;
    
    % Power in Specific Bands (contoh: 0.05-0.15 Hz dan 0.15-0.4 Hz)
    % Anda dapat menyesuaikan frekuensi sesuai kebutuhan
    VLF_band = [0.0033 0.04];
    LF_band = [0.04 0.15];
    HF_band = [0.15 0.4];
    
    % Fungsi untuk menghitung power dalam band tertentu
    powerInBand = @(band) sum(P1(f >= band(1) & f <= band(2)).^2);
    
    features.Power_VLF = powerInBand(VLF_band);
    features.Power_LF = powerInBand(LF_band);
    features.Power_HF = powerInBand(HF_band);
    features.LF_HF_Ratio = features.Power_LF / features.Power_HF;

   
    
    %% 6. Fitur Tambahan (Jika Diperlukan)
    % Contoh: Trend Analysis menggunakan regresi linier
    features.GSR_Trend_Slope = features.SCL_Slope;
    
    % Integrasi dengan Sinyal Lain (HRV, dll.) dapat dilakukan di sini
    
end

