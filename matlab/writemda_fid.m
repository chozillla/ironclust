function FF = writemda_fid(FF, X)
%WRITEMDA_FID - write to a .mda file. MDA stands for
%multi-dimensional array.
% outputs to 64-bit dimension format
%
% Usage
% -----
% FF = writemda_fid(X, FF)
%    write the data to the file
% writemda_fid('close', FF)
%    close the file and update the header
%
% Inputs:
%    X - the multi-dimensional array
%    FF - fid (file pointer, write permission)
%
% Other m-files required: none
%
% See also: readmda

% Author: James Jun
% 11/25/2019: Modified from writemda.m

persistent dimm_ bytesPerSample_

dim_type_str = 'int64'; %either int64 or int32

switch dim_type_str
    case 'int32', DIMM_BYTE = 4;
    case 'int64', DIMM_BYTE = 8;
    otherwise, error('dim_type_str must be either ''int32'' or ''int64'''); 
end
nbytes_now = ftell(FF); % update header if 

% close file, update the header
if ischar(X)
    if strcmpi(X, 'close')
        % update the last index
        if ~isempty(dimm_) && ~isempty(bytesPerSample_)
            
            nBytes_offset_ = 3 * 4 + numel(dimm_) * DIMM_BYTE;
            nSamples = (nbytes_now - nBytes_offset_) / bytesPerSample_;
            if numel(dimm_) > 1
                last_dimm = nSamples / prod(dimm_(1:end-1));
            else
                last_dimm = nSamples;
            end
            fseek(FF, nBytes_offset_- DIMM_BYTE, 'bof');
            fwrite(FF, last_dimm, dim_type_str); % update last dimension             
        end
        fclose(FF);        
        [dimm_, bytesPerSample_] = deal([]);
        return;
    end
end

% write the file header
if nbytes_now == 0
    if isa(X,'single')
        fwrite(FF,[-3,4],'int32');
        bytesPerSample_ = 4;
    elseif isa(X,'double')
        fwrite(FF,[-7,8],'int32');
        bytesPerSample_ = 8;
    elseif isa(X,'int32')
        fwrite(FF,[-5,4],'int32');
        bytesPerSample_ = 4;
    elseif isa(X,'int16')
        fwrite(FF,[-4,2],'int32');
        bytesPerSample_ = 2;
    elseif isa(X,'uint16')
        fwrite(FF,[-6,2],'int32');
        bytesPerSample_ = 2;
    elseif isa(X,'uint32')
        fwrite(FF,[-8,4],'int32');
        bytesPerSample_ = 4;
    else
        error('Unknown dtype %s', class(X));
    end
    factor_ = strcmpi(dim_type_str, 'int32')*2-1;
    fwrite(FF, factor_ * ndims(X), 'int32');
    fwrite(FF, size(X), dim_type_str);
    dimm_ = size(X);
end

fwrite(FF, X, class(X));
end
