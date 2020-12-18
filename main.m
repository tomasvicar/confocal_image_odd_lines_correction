clc;clear all;close all force;
addpath('bfmatlab')
addpath('czireader')



input_folder = '../data';
output_folder = '../result';
sift_range = -5:0.25:5;  %% shift search values
save_all_shifts = 0; %% 1 to save all shifts - very slow - but allow manual selection of otput shifts....


file_names = dir(input_folder);
file_names = {file_names(3:end).name};


if save_all_shifts
    for file_num = 1:length(file_names)
        mkdir([output_folder '/' file_names{file_num}(1:end-4) ])
    end
end
mkdir([output_folder ])



quality = zeros(length(file_names),length(sift_range));
names = cell(length(file_names),length(sift_range));


for file_num = 1:length(file_names)
    file_num
    
    A = ReadImage6D([input_folder '/' file_names{file_num}] );

    A = A{1};
    A = squeeze(A);
    A = permute(A,[3 4 1 2]);%%reorder to  x,y,z,c
    
    
    
    A0 = A;
    
    
    
    sift_ind = 0;
    for sift = sift_range
        sift_ind = sift_ind +1;
    
        A = A0;

        for row = 1:2:size(A,1)

            tmp = A(row,:,:,:);
            tmp = fraccircshift(tmp,[0 sift 0 0]);
            A(row,:,:,:) = tmp;

        end

        dif = abs(diff(A,1,1));
        quality(file_num,sift_ind) = -sum(dif(:));
        
        name = [output_folder '/' file_names{file_num}(1:end-4) '/' file_names{file_num}(1:end-4) '_sift' num2str(sift) '.tiff' ];
        
        names{file_num,sift_ind} = name;
        if save_all_shifts
            bfsave(A, name, 'dimensionOrder', 'XYTZC', 'Compression', 'LZW')
        end
%         B = bfopen_fix(name);
        

        
    end
    
    
    [~,ind] = max(quality(file_num,:));
    
    sift = sift_range(ind);
    
     A = A0;

    for row = 1:2:size(A,1)

        tmp = A(row,:,:,:);
        tmp = fraccircshift(tmp,[0 sift 0 0]);
        A(row,:,:,:) = tmp;

    end
    
    name = [output_folder '/'  file_names{file_num}(1:end-4) '_sift' num2str(sift) '.tiff' ];
    bfsave(A, name, 'dimensionOrder', 'XYTZC', 'Compression', 'LZW')

    
end





