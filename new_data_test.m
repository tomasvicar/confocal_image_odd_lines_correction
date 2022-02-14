clc;clear all;close all force;
addpath('bfmatlab')
addpath('czireader')



input_folder = 'D:\20-07-13 - Pc3 pc3-50 22rv1 22rv1400 mitogreen';
output_folder = 'D:\20-07-13 - Pc3 pc3-50 22rv1 22rv1400 mitogreen\corrected';
shift_range = -1:0.02:1;  %% shift search values
save_all_shifts = 0; %% 1 to save all shifts - very slow - but allow manual selection of otput shifts....


file_names = subdir([input_folder '/*.tif']);
file_names = {file_names(:).name};





quality = zeros(length(file_names),length(shift_range));
names = cell(length(file_names),length(shift_range));


for file_num = 1:length(file_names)
    
    file_num
    
    
    
    file_name = file_names{file_num};
    
    [~,tmp,~] = fileparts(file_name);
    if strcmp(tmp,'MaxProjs')
        continue;
    end
    
    
    file_name_save = replace(file_name,input_folder,output_folder);
    
    A = ReadImage6D(file_name );

    A = A{1};
    A = permute(A,[5 6 3 4 1 2]);%%reorder to  x,y,z,c      
    
    
    A0 = A;
    
    mkdir(fileparts(file_name_save));
    if save_all_shifts
        mkdir([replace(file_name_save,'.tif','') '_all']);
    end
    
    proj = [];
    
    for shift_ind = 1:length(shift_range)
        shift = shift_range(shift_ind);
        
        A = A0;

        for row = 1:2:size(A,1)
            
            if length(size(A))==2
                tmp = A(row,:);
            elseif length(size(A))==3
                tmp = A(row,:,:);
            elseif length(size(A))==4
                tmp = A(row,:,:,:);
            elseif length(size(A))==5
                tmp = A(row,:,:,:,:);
            else
                error('dims error')
            end
            
            tmp_shift = zeros(1,length(size(A)));
            tmp_shift(2) = shift;
            tmp = fraccircshift(tmp,tmp_shift);
            
            if length(size(A))==2
                A(row,:) = tmp;
            elseif length(size(A))==3
                A(row,:,:) = tmp;
            elseif length(size(A))==4
                A(row,:,:,:) = tmp;
            elseif length(size(A))==5
                A(row,:,:,:,:) = tmp;
            else
                error('dims error')
            end

        end

        dif = abs(diff(A,1,1));
        quality(file_num,shift_ind) = -sum(dif(:));
        
        name = [replace(file_name_save,'.tif','') '_all/shift' num2str(shift) '.tif' ];
        
        names{file_num,shift_ind} = name;
        
        proj = cat(3,proj,max(A,[],3));
        
        if save_all_shifts
            
            A = permute(A,[1 2 4 3 5 6]);
            bfsave(A, name, 'dimensionOrder', 'XYCZT', 'Compression', 'LZW')
            
        end
%         B = bfopen_fix(name);
        

        
    end
    
    
    [~,ind] = max(quality(file_num,:));
    
    shift = shift_range(ind);
    
     A = A0;

    for row = 1:2:size(A,1)
            
        if length(size(A))==2
            tmp = A(row,:);
        elseif length(size(A))==3
            tmp = A(row,:,:);
        elseif length(size(A))==4
            tmp = A(row,:,:,:);
        elseif length(size(A))==5
            tmp = A(row,:,:,:,:);
        else
            error('dims error')
        end

        tmp_shift = zeros(1,length(size(A)));
        tmp_shift(2) = shift;
        tmp = fraccircshift(tmp,tmp_shift);
        
        if length(size(A))==2
                A(row,:) = tmp;
            elseif length(size(A))==3
                A(row,:,:) = tmp;
            elseif length(size(A))==4
                A(row,:,:,:) = tmp;
            elseif length(size(A))==5
                A(row,:,:,:,:) = tmp;
            else
                error('dims error')
            end

    end
    
%     imshow4(proj(300:600,300:600,:))
    
    name = [replace(file_name_save,'.tif','') '_shift' num2str(shift) '.tiff' ];
    A = permute(A,[1 2 4 3 5 6]);
    bfsave(A, name, 'dimensionOrder', 'XYCZT', 'Compression', 'LZW')
    
    if (shift == -1) || (shift == 1)
        error('out_of_range')
        
        
        
    end
    
end