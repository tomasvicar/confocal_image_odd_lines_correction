clc;close all force;clear all;
addpath('bfmatlab')
addpath('plotSpread')


% shift_range = -3:0.05:3;
shift_range = -3:0.05:3;

%%%%% slozka stare se nepouzila
data_path = 'C:\Users\vicar\Desktop\honza_flourescence\data_27_04_22';


names = subdir([data_path '/*.czi']);
names = {names(:).name};


results = struct();

results.median_RFP = [];
results.median_GFP = [];
results.median_DeepRed = [];
results.median_RFP_plus_GFP = [];
results.median_RFP_div_GFP = [];
results.median_RFP_div_pix_GFP = [];
results.median_RFP_times_GFP = [];
results.median_RFP_times_pix_GFP = [];

results.mean_RFP = [];
results.mean_GFP = [];
results.mean_DeepRed = [];
results.mean_RFP_plus_GFP = [];
results.mean_RFP_div_GFP = [];
results.mean_RFP_div_pix_GFP = [];
results.mean_RFP_times_GFP = [];
results.mean_RFP_times_pix_GFP = [];

dyess = {};
names_tmp = {};
wlens = {};
for img_num = 1:length(names)

    name = names{img_num};
    if contains(name,'zstack')
        continue;
    end
    if contains(name,'HGFb CTRL 48h\40x_HGFb_CTRL_48h_BF_6.czi')
        continue;
    end
    if contains(name,'FADU BAF 24h\40x_FADU_BAF_24h_BF_10.czi')
        continue;
    end
    if contains(name,'FADU CBD 24h\40x_FADU_CBD_24h_BF_2.czi')
        continue;
    end
    if contains(name,'HGFb BLANK 12h\40x_HGFb_Blank_12h_BF_10.czi')
        continue;
    end
    
    names_tmp = [names_tmp,name];

    data = ReadImage6D(name);

    meta = data{2};
    data = data{1};
    data = squeeze(data);
    data = permute(data,[2,3,1]);

    dyes = meta.Dyes;
    wlen = meta.WLEx;
    wlen = cellfun(@num2str,wlen,'UniformOutput',false);

    tmp = strjoin(dyes,'  ');
    dyess = [dyess;tmp];


    tmp = strjoin(wlen,'    ');
    wlens = [wlens;tmp]; 


    ind = find(strcmp(wlen,'561'));
    if length(ind)~=1
        error('fdsfsdf')
    end
    RFP = data(:,:,ind);

    ind = find(strcmp(wlen,'na'));
    if length(ind)~=1
        error('fdsfsdf')
    end
    DIC = data(:,:,ind);


    ind = find(strcmp(wlen,'488'));
    if length(ind)~=1
        error('fdsfsdf')
    end
    GFP = data(:,:,ind);
    
    
    ind = find(strcmp(wlen,'633'));
    if length(ind)~=1
        error('fdsfsdf')
    end
    DeepRed = data(:,:,ind);


    data_all = {RFP, GFP, DeepRed};
    data_names_all = {'RFP', 'GFP', 'DeepRed'};

    
    for data_num = 1:3
        data = data_all{data_num};

        quality = zeros(length(shift_range),1);
        for shift_ind = 1:length(shift_range)
            shift = shift_range(shift_ind);

            data_shift = fraccircshift(data,[0,shift]);

            mix = data;
            mix(1:2:end,:) = data_shift(1:2:end,:);

            
%             figure
%             imshow(imresize(mix(250:400,100:250),6,'nearest'),[0,4000])
%             title(shift)
%             drawnow;


            
            dif = abs(diff(mix,1,1));
            quality(shift_ind) = -sum(dif(:));

%             figure()
%             imshow(dif,[]);
        
        end

        [~,ind] = max(quality);
        best_shift = shift_range(ind);



        data_shift = fraccircshift(data,[best_shift,0]);
        final = data;
        final(1:2:end,:) = data_shift(1:2:end,:);

        figure(1)
        plot(quality)
        figure(2);
        imshow(data,[0,4000])
        title('orig')
        figure(3);
        imshow(final,[0,4000])
        title(['shift' num2str(best_shift)])


        save_name_tif = [replace(name,'.czi','') '_' data_names_all{data_num} '_shift' num2str(best_shift) '.tif'];
        save_name_png = [replace(name,'.czi','') '_' data_names_all{data_num} '_shift' num2str(best_shift) 'kontrola.png'];

        imwrite_uint16(uint16(final),save_name_tif)

%         tmp = uint8(mat2gray(final,[0,prctile(final(:),99.7)]) * 255);

%         imwrite(tmp,save_name_png)



    end
end