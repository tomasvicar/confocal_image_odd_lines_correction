clc;clear all;close all;


data_path = '..\data_27_04_22';
data_path_saved = '..\data_27_04_22_filtered';


names = subdir([data_path '/*.tif']);
names = {names(:).name};

parfor name_num = 1:length(names)
   
    
    name = names{name_num};
    name_save = [data_path_saved replace(name,data_path,'')];
    disp([num2str(name_num) ' / ' num2str(length(names))])
     disp(name)

    img = imread(name);


%     figure();
%     imshow(img,[])

    if contains(name,'_DeepRed_') || contains(name,'_RFP_')

            filt_1_5 = zeros(5);
            filt_1_5(2:end-1,2:end-1) = 1;
            filt_1_5(1,3) = 1;
            filt_1_5(3,1) = 1;
            filt_1_5(5,3) = 1;
            filt_1_5(3,5) = 1;
            
        	img_out = ordfilt2(img,7,filt_1_5,'symmetric');
            

    elseif contains(name,'_GFP_')

            filt_2_5 = zeros(7);
            filt_2_5(2:end-1,2:end-1) = 1;
            filt_2_5(1,4) = 1;
            filt_2_5(4,1) = 1;
            filt_2_5(7,4) = 1;
            filt_2_5(4,7) = 1;
            
        	img_out = ordfilt2(img,15,filt_2_5,'symmetric');
            img_out = imgaussfilt(img_out,0.5);

        
    else
        error('fsdfsdfsf')

    end

    
    mkdir(fileparts(name_save))
    imwrite_uint16(uint16(img_out),name_save)


%     figure()
%     imshow(img_out,[])
%     drawnow;

%     drawnow;

        
end




