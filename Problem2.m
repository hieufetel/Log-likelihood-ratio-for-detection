clc; clear; close all; 

N0 = 10^-2; 
EbN0_dB = 0:2:8; EbN0 = 10.^(EbN0_dB /10); 
Eb = EbN0 * N0; 
EBPSK = Eb;  % N?ng l??ng cho BPSK

Ntry = 10^4; 
P_error_simul = zeros(1, length(EbN0_dB)); 
P_error_theo = zeros(1, length(EbN0_dB));

for j = 1:length(EbN0_dB) 
    ts = 1/1000; 
    Tb = 1; 
    Tc = 1/10; 
    fc = 1/Tc; 
    V = sqrt(2 * EBPSK(j) / Tb); % Biên ?? tín hi?u
    
    t_1bit = 0 : ts : Tb-ts; 
    s1 = -V * cos(2*pi*fc*t_1bit); % Bit "0" 
    s2 = V * cos(2*pi*fc*t_1bit);  % Bit "1" 
    L = length(t_1bit); 
    
    Bit = randsrc(1, Ntry, [0 1]); 
    s = []; 
    t = []; 
    for i = 1:Ntry 
        if Bit(i) == 0 
            s = [s s1]; 
        else 
            s = [s s2]; 
        end 
        t_ibit = t_1bit + (i-1); 
        t = [t t_ibit]; 
    end 
    
    B = 1/ts; 
    Power_noise = N0/2 * B; 
    w = sqrt(Power_noise) * randn(1, length(s)); 
    r = s + w; 
    
    % Khôi ph?c tín hi?u 
    phi1 = s2 / sqrt(EBPSK(j)); 
    h = flip(phi1); 
    Th = 0; % Ng??ng quy?t ??nh cho BPSK
    
    Bit_rec = zeros(1, Ntry); 
    for i = 1:Ntry 
        Frame = r((i-1)*L + 1 : i*L); 
        y = conv(Frame, h) * ts; 
        r2_mu = y(L); 
        if r2_mu >= Th 
            Bit_rec(i) = 1; 
        else 
            Bit_rec(i) = 0; 
        end 
    end 
    
    [Num, rate] = biterr(Bit, Bit_rec); 
    P_error_simul(j) = rate; 
    P_error_theo(j) = qfunc(sqrt(2 * EBPSK(j) / N0)); % Công th?c BER lý thuy?t
end 

P_error_simul
P_error_theo