function [subj] = raicar_main (subj, raicar_setup)

% function [subj] = raicar_main (subj, raicar_setup)
% 
% Author: Zhi Yang
% Version: 2.0
% Last change: May 03, 2007
% 
% Purpose: main control function. Ensure the correctness of the input and 
%          manage the processing steps. The whole process consists of four
%          phases: preparing data, conducting multiple ICA, generating CRCM,
%          and ranking/averaging components. This function can manage the 
%          phases according to the input arguments. 
%
% Input:   
%          subj: name of the subject/analysis. 