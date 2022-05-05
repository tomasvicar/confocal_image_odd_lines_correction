clc;clear all;close all;


data_path = '..\data_27_04_22_filtered';

% names = subdir([data_path '/*_norm.png']);
% names = {names(:).name};
% for name = names
% 
%     delete(name{1})
% end


names = subdir([data_path '/*shift*.tif']);
names = {names(:).name};

name_parts = {};
for name_num = 1:length(names)
    name = names{name_num};
    tmp = split(name,'_');
    name_part = join(tmp(1:end-2),'_');
    name_parts = [name_parts,name_part];
end


u = unique(name_parts);




for u_num = 1:length(u)
    disp([num2str(u_num) ' / ' num2str(length(u))])

    uu = u{u_num};


    tmp = cellfun(@(x) contains(x,[uu '_DeepRed_']), names,'UniformOutput',1);
    if sum(tmp) ~= 1
        error('dfsdsdf')
    end
    name_tmp = names{tmp};
    DeepRed = imread(name_tmp);
   
    tmp = cellfun(@(x) contains(x,[uu '_RFP_']), names,'UniformOutput',1);
    if sum(tmp) ~= 1
        error('dfsdsdf')
    end
    name_tmp = names{tmp};
    RFP = imread(name_tmp);
   

    tmp = cellfun(@(x) contains(x,[uu '_GFP_']), names,'UniformOutput',1);
    if sum(tmp) ~= 1
        error('dfsdsdf')
    end
    name_tmp = names{tmp};
    GFP = imread(name_tmp);
   


    save_name_tif = [uu '_RFP-GFP.tif'];
    save_name_png = [uu '_RFP-GFP.png'];

    RFP_GFP = zeros(size(RFP,1),size(RFP,2),3);

    RFP_GFP(:,:,1) = mat2gray(RFP,[460,2000]);
    RFP_GFP(:,:,2) = mat2gray(GFP,[460,4000]);

    imwrite(RFP_GFP,save_name_tif)
    imwrite(uint8(RFP_GFP * 255),save_name_png)

%     figure()
%     imshow(RFP_GFP)

    save_name_tif = [uu '_RFP-DeepRed.tif'];
    save_name_png = [uu '_RFP-DeepRed.png'];

    RFP_DeepRed = zeros(size(RFP,1),size(RFP,2),3);

    RFP_DeepRed(:,:,1) = mat2gray(RFP,[460,2000]);
    RFP_DeepRed(:,:,2) = mat2gray(DeepRed,[140,8000]);
    RFP_DeepRed(:,:,3) = mat2gray(DeepRed,[140,8000]);
   
%     figure()
%     imshow(RFP_DeepRed)

    imwrite(RFP_DeepRed,save_name_tif)
    imwrite(uint8(RFP_DeepRed * 255),save_name_png)



%     save_name_tif = [uu '_RFP_norm.tif'];
%     save_name_png = [uu '_RFP_norm.png'];
%     RFP_norm = mat2gray(double(RFP),[460,2000]);
%     
%     imwrite(RFP_norm,save_name_tif)
%     imwrite(uint8(RFP_norm * 255),save_name_png)
%     
%     figure()
%     imshow(RFP_norm)
% 
% 
%     save_name_tif = [uu '_GFP_norm.tif'];
%     save_name_png = [uu '_GFP_norm.png'];
%     GFP_norm = mat2gray(double(GFP),[460,4000]);
%     
%     imwrite(GFP_norm,save_name_tif)
%     imwrite(uint8(GFP_norm * 255),save_name_png)
% 
%     figure()
%     imshow(GFP_norm)
% 
% 
%     save_name_tif = [uu '_DeepRed_norm.tif'];
%     save_name_png = [uu '_DeepRed_norm.png'];
%     DeepRed_norm = mat2gray(double(DeepRed),[140,8000]);
%     
%     imwrite(DeepRed_norm,save_name_tif)
%     imwrite(uint8(DeepRed_norm * 255),save_name_png)
% 
%     figure()
%     imshow(DeepRed_norm)


end




