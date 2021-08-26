% 画像のサイズを変更して保存します

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_folder_path = 'shintakabashi_sfm_results/shintakebashi_img';
path = 'shintakabashi_sfm_results/cameras_v2.txt';
repath = 'shintakabashi_sfm_results/re_img/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

camera_params = read_vsfm(path);

for a = 0:camera_params.Count - 1
    if a - 9 < 1
        image_path = [image_folder_path '/0000000' int2str(a) '.jpg'];
    else
        image_path = [image_folder_path '/000000' int2str(a) '.jpg'];
    end
    
    I = imread(image_path);
    re_I = imresize(I,0.5);
    filename = [repath 're_' int2str(a) '.jpg'];
    imwrite(re_I,filename)
end



