clc; clear; close all;

%% 1. Single-Point Calculations 
% Uplink Parameters
Pt_up = 20; Gt_up = 45; f_up = 14; d_up = 36000; Gr_up = 30; L_up = 2;

% Downlink Parameters
Pt_dn = 10; Gt_dn = 35; f_dn = 12; d_dn = 36000; Gr_dn = 40; L_dn = 2;

% Noise & Requirements
N = -125; CN_req = 10;

% Numerical Calculations - FIXED: Subtracting Line Losses (L) from EIRP directly
EIRP_up = 10*log10(Pt_up) + Gt_up - L_up;
EIRP_dn = 10*log10(Pt_dn) + Gt_dn - L_dn;

FSL_up = 92.45 + 20*log10(f_up) + 20*log10(d_up);
FSL_dn = 92.45 + 20*log10(f_dn) + 20*log10(d_dn);

% Since L is now accounted for in EIRP, we just add Gr here
Pr_up = EIRP_up - FSL_up + Gr_up;
Pr_dn = EIRP_dn - FSL_dn + Gr_dn;

CN_up = Pr_up - N;
CN_dn = Pr_dn - N;

M_up = CN_up - CN_req;
M_dn = CN_dn - CN_req;

% Print Calculated Results to Command Window
fprintf('\n             Uplink    Downlink\n');
fprintf('EIRP (dBW):  %7.2f   %7.2f\n', EIRP_up, EIRP_dn);
fprintf('FSL (dB):    %7.2f   %7.2f\n', FSL_up, FSL_dn);
fprintf('Pr (dBW):    %7.2f   %7.2f\n', Pr_up, Pr_dn);
fprintf('C/N (dB):    %7.2f   %7.2f\n', CN_up, CN_dn);
fprintf('Margin (dB): %7.2f   %7.2f\n', M_up, M_dn);

%% 2. Parametric Sweeps for Graphs
% Define Sweep Ranges
d_range    = linspace(30000, 45000, 200); % Distance (km)
EIRP_range = linspace(30, 75, 200);       % EIRP (dBW)
Gr_range   = linspace(20, 50, 200);       % Receiver Gain (dB)
FSL_range  = linspace(200, 212, 200);     % Free Space Loss (dB)

% 1. Received Power vs Distance
FSL_up_d = 92.45 + 20*log10(f_up) + 20*log10(d_range);
FSL_dn_d = 92.45 + 20*log10(f_dn) + 20*log10(d_range);
Pr_up_d  = EIRP_up - FSL_up_d + Gr_up;
Pr_dn_d  = EIRP_dn - FSL_dn_d + Gr_dn;

% 2. Link Margin vs EIRP
Pr_up_EIRP = EIRP_range - FSL_up + Gr_up;
Pr_dn_EIRP = EIRP_range - FSL_dn + Gr_dn;
Margin_up_EIRP = (Pr_up_EIRP - N) - CN_req;
Margin_dn_EIRP = (Pr_dn_EIRP - N) - CN_req;

% 3. Link Margin vs Receiver Gain (Gr)
Pr_up_Gr = EIRP_up - FSL_up + Gr_range;
Pr_dn_Gr = EIRP_dn - FSL_dn + Gr_range;
Margin_up_Gr = (Pr_up_Gr - N) - CN_req;
Margin_dn_Gr = (Pr_dn_Gr - N) - CN_req;

% 4. Link Margin vs Free Space Loss (FSL)
Pr_up_FSL = EIRP_up - FSL_range + Gr_up;
Pr_dn_FSL = EIRP_dn - FSL_range + Gr_dn;
Margin_up_FSL = (Pr_up_FSL - N) - CN_req;
Margin_dn_FSL = (Pr_dn_FSL - N) - CN_req;


%% 3. Plotting the 4 Specific Graphs
figure('Name', 'Link Budget Parametric Analysis', 'Position', [100, 100, 900, 600]);

% Graph 1: Received Power vs Distance
subplot(2,2,1);
plot(d_range, Pr_up_d, 'b-', 'LineWidth', 1.5); hold on;
plot(d_range, Pr_dn_d, 'r--', 'LineWidth', 1.5);
xlabel('Distance (km)'); ylabel('Received Power (dBW)');
title('Received Power vs. Distance'); 
legend('Uplink', 'Downlink'); grid on;

% Graph 2: Link Margin vs EIRP
subplot(2,2,2);
plot(EIRP_range, Margin_up_EIRP, 'b-', 'LineWidth', 1.5); hold on;
plot(EIRP_range, Margin_dn_EIRP, 'r--', 'LineWidth', 1.5);
yline(0, 'k:', '0 dB Threshold', 'LineWidth', 1.2);
xlabel('EIRP (dBW)'); ylabel('Link Margin (dB)');
title('Link Margin vs. EIRP'); 
legend('Uplink', 'Downlink', 'Location', 'northwest'); grid on;

% Graph 3: Link Margin vs Receiver Gain
subplot(2,2,3);
plot(Gr_range, Margin_up_Gr, 'b-', 'LineWidth', 1.5); hold on;
plot(Gr_range, Margin_dn_Gr, 'r--', 'LineWidth', 1.5);
yline(0, 'k:', '0 dB Threshold', 'LineWidth', 1.2);
xlabel('Receiver Gain (dB)'); ylabel('Link Margin (dB)');
title('Link Margin vs. Receiver Gain'); 
legend('Uplink', 'Downlink', 'Location', 'northwest'); grid on;

% Graph 4: Link Margin vs Free Space Loss
subplot(2,2,4);
plot(FSL_range, Margin_up_FSL, 'b-', 'LineWidth', 1.5); hold on;
plot(FSL_range, Margin_dn_FSL, 'r--', 'LineWidth', 1.5);
yline(0, 'k:', '0 dB Threshold', 'LineWidth', 1.2);
xlabel('Free Space Loss (dB)'); ylabel('Link Margin (dB)');
title('Link Margin vs. Free Space Loss'); 
legend('Uplink', 'Downlink', 'Location', 'northeast'); grid on;