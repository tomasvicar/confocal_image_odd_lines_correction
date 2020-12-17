clc;clear all;close all force;
addpath('bfmatlab')
addpath('czireader')
addpath('../Fiji.app/scripts')
% ImageJ



input_folder = '../data';
output_folder = '../result';
sift_range = -4:4;



file_names = dir(input_folder);
file_names = {file_names(3:end).name};
file_names = file_names(1:3);

for file_num = 1:length(file_names)
    mkdir([output_folder '/' file_names{file_num}(1:end-4) ])
end
mkdir([output_folder '/shift_best'])



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
        
        
        bfsave(A, name, 'dimensionOrder', 'XYTZC', 'Compression', 'LZW')
%         B = bfopen_fix(name);
        
%         imp = copytoImagePlus(A,'YXZC');
%         name = [output_folder '/sift' num2str(sift) '/' replace(file_names{file_num},'.czi','.tiff')];
%         names{file_num,sift_ind} = name;
%         ij.IJ.saveAsTiff(imp,name);
       
%         imp = ij.IJ.openImage(name);
%         imp.show()
%         IJM.getDatasetAs('B');

%         drawnow;
        
    end
    
    
    
    
    
end

[~,ind] = max(quality);
for k = 1:length(ind)
    name = names{k,ind(k)};
    [f,n,e] = fileparts(filename);
    
    copyfile(name,[output_folder '/sift_best/' n e])

end





