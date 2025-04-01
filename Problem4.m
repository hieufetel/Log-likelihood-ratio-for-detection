clc; clear; close all; 


EbN0_dB = 0:2:8; 
EbN0 = 10.^(EbN0_dB/10);


P_error_theo_BASK = [0.158655253931457,0.104028637085389,0.056495301749362,0.023007138877866,0.006004386400164];      
P_error_theo_BPSK = [0.078649603525143,0.037506128358926,0.012500818040738,0.002388290780933,1.909077740759931e-04];   
P_error_theo_BFSK = [0.158655253931457,0.104028637085389,0.056495301749362,0.023007138877866,0.006004386400164];       


P_error_simul_BASK = [0.157700000000000,0.105200000000000,0.056600000000000,0.022700000000000,0.004900000000000];  
P_error_simul_BPSK = [0.079800000000000,0.036500000000000,0.013200000000000,0.001700000000000,2.000000000000000e-04];  
P_error_simul_BFSK = [0.159900000000000,0.107100000000000,0.057000000000000,0.024000000000000,0.007000000000000];  

% V? ?? th?
figure(1)
semilogy(EbN0_dB, P_error_theo_BASK, 'r-', 'linewidth', 1.8);  
hold on; 
semilogy(EbN0_dB, P_error_theo_BPSK, 'g--', 'linewidth', 1.8); 
semilogy(EbN0_dB, P_error_theo_BFSK, 'b:', 'linewidth', 2); 
semilogy(EbN0_dB, P_error_simul_BASK, 'ko', 'MarkerSize',8); 
semilogy(EbN0_dB, P_error_simul_BPSK, 'ko', 'MarkerSize',8); 
semilogy(EbN0_dB, P_error_simul_BFSK, 'ko', 'MarkerSize',8); 
xlabel('E_b/N_0 (dB)'); 
ylabel('The error probability'); 
legend('Theory BASK', 'Theory BPSK', 'Theory BFSK', 'Simulation')
grid on;
