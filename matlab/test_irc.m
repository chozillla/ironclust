% srun matlab -nosplash -nodisplay -r "addpath('/mnt/home/magland/src/ironclust/'); 
if ~isdeployed()
    try
        addpath(genpath('.'));
    catch
        ;
    end
end

if ispc()
    p_ironclust('D:\mountainsort\out\', ...
        'D:\mountainsort\raw.mda', ...
        'D:\mountainsort\geom.csv', ...
        'tetrode_template.prm', ...
        'D:\mountainsort\firings_true.mda', ...
        'D:\mountainsort\firings_out.mda', ...
        'D:\mountainsort\argfile.txt'); 
else % linux 
    vcDir = '~/ceph/groundtruth/magland_synth/datasets_noise10_K10_C4/001_synth';
    vcDir_out = '~/irc_out';
    
    p_ironclust(vcDir_out, ...
    [vcDir, '/raw.mda'], ...
    [vcDir, '/geom.csv'], ...
    'tetrode_template.prm', ...
    [vcDir, '/firings_true.mda'], ...
    [vcDir_out, '/firings_out.mda'], ...
    [vcDir, '/params.json']);
end