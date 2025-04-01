clc; clear; close all; 
 
N0 = 10^-2; 
EbN0_dB = 0:2:8; EbN0 = 10.^(EbN0_dB /10); 
Eb = EbN0 * N0; 
EBFSK = Eb; % The energy of BASK 

Ntry = 10*10^3; % The number of transmitted bits 
P_error_simul = zeros(1,length(EbN0_dB)); 
P_error_theo = zeros(1,length(EbN0_dB)); 
 
for j = 1:length(EbN0_dB) 
     
    ts = 1/1000; % The sample time 
    Tb = 1;      % The time of 1 bit 
    V = sqrt(EBFSK(j) * 2 / Tb );    % The amplitude of the carrier signal 
    fc1 = 8/Tb; % The frequency of the first carrier signal 
    fc2 = 9/Tb; % The frequency of the second carrier signal 
  
    t_1bit = 0 : ts : Tb-ts; 
    s1 = V * cos(2 * pi * fc1 * t_1bit);   % s1(t) 
    s2 = V * cos(2 * pi * fc2 * t_1bit);   % s2(t) 
    L = length(t_1bit); 
     
    % ================= The passband modulation BFSK 
    Bit = randsrc(1, Ntry, [0,1]);
    
    s = []; 
    t = []; 
    for i = 1:Ntry 
            if Bit(i) == 0 
                s = [s  s1]; 
            else 
                s = [s  s2]; 
            end        
            t_ibit = t_1bit + (i - 1); % Time of i-bit       
            t = [t  t_ibit]; 
    end 
  
    % ================= The AWGN channel 
    B = 1/ts; % Bandwidth of signals 
    Power_noise = N0/2 * B; % The power of noise 
    w = sqrt(Power_noise) * randn(1, length(s)); 
  
    % ================= The received signal 
    r = w + s; 
  
    % ================= Signal recovery 
    phi1 = s1 / sqrt(EBFSK(j)); 
    phi2 = s2 / sqrt(EBFSK(j));
    h1 = flip(phi1) ; 
    h2 = flip(phi2) ;
    Th = EBFSK(j) / 2;  
  
    Bit_rec = zeros(1,Ntry); 
    for i = 1:Ntry
        Frame = r((i-1) * L + 1 : i * L);   % Construct 1 Frame with L samples 
        y1 = conv(Frame, h1) * ts;
        y2 = conv(Frame, h2) * ts;          % The signals pass through the matched filter 
        r1_mu = y1(L) ; 
        r2_mu = y2(L) ;
        % --------- Comparator for decision 
        if r2_mu >= r1_mu 
            Bit_rec(i) = 1; 
        else 
            Bit_rec(i) = 0; 
        end 
    end 
    Bit_rec; 
  
    % ================== The bit error probability 
    % ------------- Simulation 
    [Num, rate] = biterr(Bit, Bit_rec); 
    P_error_simul(j) = rate; 
  
    % ------------- Theory 
    P_error_theo(j) = qfunc(sqrt(Eb(j) / N0)) ; 
  
end 
  
P_error_simul 
P_error_theo