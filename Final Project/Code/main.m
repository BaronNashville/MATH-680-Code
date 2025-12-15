% This script will use the implementations of PCA, kPCA, PCA+, PCA++
% to produce the plots featured in the project

clear, clc

save_plots = false;

% Generate figure 1 displaying the usefullness of PCA
PCA_script

% Generate figure 2 showing the strength of kPCA over PCA
kPCA_script

% Generate figure 3 showing the strength of PCA+ over PCA
PCAp_script

% Generate figure 4 and 5 showing the strength of PCA++ over PCA+ and PCA
% (figure 1 from paper)
PCApp_script

% Generate figure 5 showing the performance is PCA++ compared to its truncations
% (figure 1 from paper)
PCApp_truncated_script

% Generate figure 6 showing the assymptotic result for the fixed aspect ratio regime and growing-spike regime
% (figure 3 from paper)
theory_script

% Generate figure 7 using PCA, PCA+, truncated PCA++ (s = 10) on the MNIST digits superimposed on a noisy background 
% (figure 4 from paper)
MNIST_script