clc;clear all;close all force;
addpath('bfmatlab')
addpath('czireader')



input_folder = '../data';
output_folder = '../result';
shift_range = -5:0.25:5;  %% shift search values
save_all_shifts = 0; %% 1 to save all shifts - very slow - but allow manual selection of otput shifts....


file_names = dir(input_folder);
file_names = {file_names(3:end).name};


if save_all_shifts
    for file_num = 1:length(file_names)
        mkdir([output_folder '/' file_names{file_num}(1:end-4) ])
    end
end
mkdir([output_folder ])



quality = zeros(length(file_names),length(shift_range));
names = cell(length(file_names),length(shift_range));


for file_num = 1:length(file_names)
    file_num
    
    A = ReadImage6D([input_folder '/' file_names{file_num}] );

    A = A{1};
    A = permute(A,[5 6 3 4 1 2]);%%reorder to  x,y,z,c
    
    
    
    A0 = A;
    
    
    
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
        
        name = [output_folder '/' file_names{file_num}(1:end-4) '/' file_names{file_num}(1:end-4) '_shift' num2str(shift) '.tiff' ];
        
        names{file_num,shift_ind} = name;
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
    
    name = [output_folder '/'  file_names{file_num}(1:end-4) '_shift' num2str(shift) '.tiff' ];
    A = permute(A,[1 2 4 3 5 6]);
    bfsave(A, name, 'dimensionOrder', 'XYCZT', 'Compression', 'LZW')

    
end





