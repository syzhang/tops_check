% following tutorial steps

basedir = '/Users/syzhang/Documents/tutorial/tops_code';
workdir = '/Users/syzhang/Documents/tutorial/tops';

addpath(genpath(fullfile(basedir, 'functions')));

fmri_imgs{1} = fullfile(workdir, 'data/example_participant/fMRI/example_preprocessed_fMRI_task-REST.nii.gz');
fmri_imgs{2} = fullfile(workdir, 'data/example_participant/fMRI/example_preprocessed_fMRI_task-CAPS.nii.gz');

n_run = numel(fmri_imgs);

atlas_img = fullfile(workdir, 'data/atlas/Fan_et_al_atlas_r279_MNI_3mm.nii');

fsl_env_cmd = 'FSLDIR=/Users/syzhang/fsl; . ${FSLDIR}/etc/fslconf/fsl.sh; PATH=${FSLDIR}/bin:${PATH};';

roi_meants{1} = fullfile(workdir, 'data/example_participant/ROI/example_ROI_mean_timeseries_task-REST.mat');
roi_meants{2} = fullfile(workdir, 'data/example_participant/ROI/example_ROI_mean_timeseries_task-CAPS.mat');

% for img_i = 1:n_run
%     fsl_cmd = sprintf('fslmeants -v -i %s --label=%s -o %s', fmri_imgs{img_i}, atlas_img, roi_meants{img_i});
%     fprintf('Running FSL command: [ %s ]\n', fsl_cmd);
%     system([fsl_env_cmd ' ' fsl_cmd]);
% end

for img_i = 1:n_run
    roi_meants_dat{img_i} = load(roi_meants{img_i}, '-ASCII');
end


% DCC
for img_i = 1:n_run
    fprintf('Working on DCC: Image %d ...\n', img_i);
%     dfc_dat{img_i} = DCC_jj(roi_meants_dat{img_i}, 'simple', 'whiten');
     dfc_dat{img_i} = DCC_jj(roi_meants_dat{img_i}, 'simple');
end

n_bin = 5;
dfc_binned{1} = fullfile(workdir, 'data/example_participant/FC/example_dFC_binned_task-REST.mat');
dfc_binned{2} = fullfile(workdir, 'data/example_participant/FC/example_dFC_binned_task-CAPS.mat');

for img_i = 1:n_run
    dfc_binned_dat = zeros(size(dfc_dat{img_i},1), n_bin);
    for div_i = 1:n_bin
        div_range = ceil(size(dfc_dat{img_i},2) / n_bin * (div_i-1) + 1) : ceil(size(dfc_dat{img_i},2) / n_bin * div_i);
        dfc_binned_dat(:,div_i) = mean(dfc_dat{img_i}(:,div_range), 2);
    end
    save(dfc_binned{img_i}, 'dfc_binned_dat');
end
