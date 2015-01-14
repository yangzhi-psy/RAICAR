%%%% template script for starting up RAICAR process

% mandatary inputs
subj.setup.inputNm   = 'epifile.nii';    % the functional 4-D file to be decomposed, 
					 % in NIFTI/ANALYZE format (.nii/.hdr)

subj.setup.mskNm     = 'mskfile.nii';    % a mask file indicating which voxels to 
				         % include in the analysis, in NIFTI/ANALYZE 
					 % format (.nii/.hdr)

subj.setup.trials    = 30                % number of ICA realizations

subj.setup.outPrefix = 'output';         % prefix for the output files. the output 
				         % files include the multiple ICA result (.mat), 
                                         % the CRCM matrix(.mat), the ranking and 
					 % averaging results (.mat)and the final 
					 % averaged component map (.nii);

% optional inputs
subj.setup.initOption= 'randinit';       % options on resampling methods. the choice 
					 % are 'randinit', 'bootstrap', and 'both'. 
					 % default = 'randinit';

subj.setup.rlPrefix  = [];               % prefix of the ICA realizations. if the 
				         % ICA results exist, RAICAR can directly use them. 
					 % e.g. if demo_ICA1.mat to demo_ICA30.mat exsit, 
					 % the optional input rlPrefix should be 'demo_ICA', 
                                         % and then RAICAR will directly read them in, 
					 % instead of calculating ICA again. default = [];

subj.setup.CRCMNm    = [];               % file name of the provided CRCM. if the 
                                         % CRCM is provided, RAICAR will directly read it and
                                         % use it to rank the components. default = [];

subj.setup.anatNm    = [];               % file name of the anatomy image. if
                                         % provided, the anatomy image will be used to
                                         % display the component maps. default = [];

subj.setup.paraNm    = [];               % file name of the paradigm file (.mat or
                                         % .1D). if provided, the experiment paradigm can be
					 % displayed with the component time courses.
					 % default = [];

subj.setup.start     = 1;                % the index of individual ICA result to 
                                         % start from. default = 1;

subj.setup.threshold = [];               % user-specified SCC threshold. default = [];

subj.setup.sparse    = 1;                % a flag indicating whether RAICAR will use 
					 % sparse method on CRCM. set to 1 to use sparse,0 to
					 % disable it. sparse matrix can save a lot of RAM, but 
					 % requires a pre-thresholding which will change the 
					 % reproducibility ranking a little bit. 
					 % default = 1;

subj.setup.ICAOption.approach = 'symm';
subj.setup.ICAOption.epsilon  = 0.0001;
subj.setup.ICAOption.maxNumIterations = 3000;
subj.setup.ICAOption.g        = 'tanh'
subj.setup.stabilization      = 'off'    % structure storing user-specified options 
					 % for ICA. for details see the FastICA help.
                                         % default:
                                         %     ICAOption.approach = 'symm'
                                         %     ICAOption.epsilon  = 0.0001
                                         %     ICAOption.maxNumIterations = 3000
                                         %     ICAOption.g        = 'tanh'
                                         %     ICAOption.stabilization   = 'off'
                                         % NOTE: once ICAOption is set to nonempty, all the
                                         % default values will be overwritten. This means,
                                         % even though you only need to modify one of the ICA 

subj.setup.webReport = 1;                % a flag indicating whether RAICAR will           
                                         % automatically generate a web-page report. set to 
                                         % 1 to generate. default = 1;


% start RAICAR
[subj] = raicar_controller (subj)

% save the results
fn = strcat (subj.setup.outPrefix, '_result.mat');
save (fn, 'subj');

 
