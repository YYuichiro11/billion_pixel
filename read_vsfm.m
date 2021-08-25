%%%%% This function read camera parameters from VisualSfM results %%%%%
% PATH = text file
% image_folder_path = /---.nvm.cmvs/00/visualize

function camera_params = read_vsfm(path)

% Open text file
fid = fopen(path);

% Skip explanation in the text file
for i = 1:16
    tline = fgetl(fid);
end

% The nubmer of cameras in this reconstruction
camera_counts = str2double(fgetl(fid));
% Skip
tline = fgetl(fid);

% Define Camera params container
camera_params = containers.Map('KeyType', 'int64', 'ValueType', 'any');

for a = 1:camera_counts
    
    % cam_param is defined as struct
    cam_param = struct;
    
    cam_param.count = camera_counts;
    
    cam_param.image_id = a;
    
    cam_param.filename = fgetl(fid);
    
    cam_param.original_filename = fgetl(fid);
    
    cam_param.focal_length = str2double(fgetl(fid));
    
    elems = strsplit(fgetl(fid));
    cam_param.principal_point = [str2double(elems(1)),str2double(elems(2))];
    
    cam_param.inMatrix = [cam_param.focal_length 0 cam_param.principal_point(1);0 cam_param.focal_length cam_param.principal_point(2);0 0 1];
    
    elems = strsplit(fgetl(fid));
    cam_param.translation_vector = [str2double(elems(1));str2double(elems(2));str2double(elems(3))];
    
    elems = strsplit(fgetl(fid));
    cam_param.camera_position = [str2double(elems(1));str2double(elems(2));str2double(elems(3))];
    
    elems = strsplit(fgetl(fid));
    cam_param.axis_angle = [str2double(elems(1));str2double(elems(2));str2double(elems(3))];
    
    elems = strsplit(fgetl(fid));
    cam_param.quaternion = [str2double(elems(1));str2double(elems(2));str2double(elems(3));str2double(elems(4))];
    
    elems = strsplit(fgetl(fid));
    elems2 = strsplit(fgetl(fid));
    elems3 = strsplit(fgetl(fid));
    cam_param.rotation_matrix = [str2double(elems(1)),str2double(elems(2)),str2double(elems(3));str2double(elems2(1)),str2double(elems2(2)),str2double(elems2(3));str2double(elems3(1)),str2double(elems3(2)),str2double(elems3(3))];
    
    cam_param.normalized_radial_distortion = str2double(fgetl(fid));
    
    elems = strsplit(fgetl(fid));
    cam_param.Lat_Lng_Alt = [str2double(elems(1));str2double(elems(2));str2double(elems(3))];
    % Skip
    tline = fgetl(fid);
    
    camera_params(cam_param.image_id) = cam_param;
    
end
    
    

fclose(fid);
