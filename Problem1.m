clc; clear; close all; 
  
N0 = 10^-2; 
EbN0_dB = 0:2:8; EbN0 = 10.^(EbN0_dB /10); 
Eb = EbN0 * N0; 
EBASK = 2 * Eb;  % The energy of BASK 
  
Ntry = 2*10^4; % The number of transmitted bits 
P_error_simul = zeros(1,length(EbN0_dB)); 
P_error_theo = zeros(1,length(EbN0_dB));

  
for j = 1:length(EbN0_dB) 
     
    ts = 1/1000; % The sample time 
    Tb = 1;      % The time of 1 bit 
    Tc = 1/10;   % The cycle of the carrier signal 
    fc = 1/Tc;   % The frequency of the carrier signal 
    V = sqrt(EBASK(j) * 2 /Tb);    % The amplitude of the carrier signal
    
    t_1bit = 0 : ts : Tb-ts;               % The time of 1 bit 
    s1 = zeros(1, length(t_1bit));         % s1(t) 
    s2 = V * cos(2*pi*fc*t_1bit);          % s2(t) 
    L = length(t_1bit); 
    
     Bit = randsrc(1,Ntry,[0 1]); % The transmitted bits 
    s = []; 
    t = []; 
    for i = 1:Ntry 
            if Bit(i) == 0 
                s = [s   s1]; 
            else 
                s = [s   s2]; 
            end 
                t_ibit = t_1bit + (i-1); % Time of i-bit 
                t = [t t_ibit]; 
    end 
    
    B = 1/ts; % Bandwidth of signals 
    Power_noise = N0/2 * B; % The power of noise 
    w = sqrt(Power_noise)*randn(1,length(s)); 
    
     r = s + w; 
    
    % ================= Signal recovery
    phi1 = s2 / sqrt(EBASK(j)); 
    h = flip(phi1); 
    Th = sqrt(EBASK(j)) / 2; % The threshold for decision 
  
    Bit_rec = zeros(1,Ntry); 
    for i = 1:Ntry 
        Frame = r((i-1)*L + 1 : i*L); % Construct 1 Frame with L samples 
        y = conv(Frame, h) * ts; % The signals pass through the matched filter 
        r2_mu = y(L); 
        % --------- Comparator for decision 
        if r2_mu >= Th 
            Bit_rec(i) = 1; 
        else 
            Bit_rec(i) = 0; 
        end 
    end 
    Bit_rec; 
     [Num, rate] = biterr(Bit, Bit_rec); 
    P_error_simul(j) = rate; 
  
    % ------------- Theory 
    P_error_theo(j) = qfunc( sqrt( EBASK(j) / (2*N0) ) ); 
  
end 
  
P_error_simul 
P_error_theo
    
    