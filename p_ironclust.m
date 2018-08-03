function p_ironclust(temp_path, raw_fname, geom_fname, prm_fname, firings_out_fname, arg_fname)
% cmdstr2 = sprintf("p_ironclust('$(tempdir)','$timeseries$','$geom$','$firings_out$','$(argfile)');");

% temp_path='/tmp/test_jrclust'
if exist(temp_path, 'dir') ~= 7
    mkdir(temp_path);
end
    
vcFile_prm = irc('makeprm_mda', raw_fname, geom_fname, arg_fname, temp_path, prm_fname);
irc('detectsort', vcFile_prm);
vcFile_jrc_csv = irc('export-csv', vcFile_prm);

disp('======================================================================');

firings = csvread(vcFile_jrc_csv);

disp('======================================================================');
disp('Shape of firings:');
disp(size(firings));

firings = firings(:,[3,1,2])';
P = irc('call', 'file2struct_', vcFile_prm);
firings(2,:)=firings(2,:) * P.sRateHz;

writemda(firings, firings_out_fname);
fprintf('Clustering result wrote to %s\n', firings_out_fname);

end %func


%--------------------------------------------------------------------------
function copyfile_(vcFrom, vcDest)
try
    copyfile(vcFrom, vcDest, 'f');
catch
    ;
end
end %func


%--------------------------------------------------------------------------
% 9/26/17 JJJ: Created and tested
function vcFile_new = subs_dir_(vcFile, vcDir_new)
% Substitute dir
[vcDir_new,~,~] = fileparts(vcDir_new);
[vcDir, vcFile, vcExt] = fileparts(vcFile);
vcFile_new = fullfile(vcDir_new, [vcFile, vcExt]);
end % func


%--------------------------------------------------------------------------
function S = makeStruct_(varargin)
%MAKESTRUCT all the inputs must be a variable. 
%don't pass function of variables. ie: abs(X)
%instead create a var AbsX an dpass that name
S = struct();
for i=1:nargin, S.(inputname(i)) =  varargin{i}; end
end %func