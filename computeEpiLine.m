%  この関数では、エピポーラ線を求めます
%  pointsは基準画像における画素値の行列です（[x,y]の順で）
%  visual sfm用の関数です。それ以外の手法に適応したいときはcomputeEpiline_photogrammetryを使う
%  出力値のepiLinesはy=Ax+BのAとBをそれぞれ格納しています

function [epiLines,min_points_xy,max_points_xy] = computeEpiLine(points, camera_params, base_image_id, refer_image_ids, refer_image)

%　カメラパラメータを読み込みます
camera_position1 = camera_params(base_image_id).camera_position;
% camera_position2 = camera_params(refer_image_id).camera_position;

rotation_matrix1 = camera_params(base_image_id).rotation_matrix;

translation_vector1 = camera_params(base_image_id).translation_vector;

principal_point1 = camera_params(base_image_id).principal_point;
% principal_point2 = camera_params(refer_image_id).principal_point;

focal_length1 = camera_params(base_image_id).focal_length;

% inMatrix1 = camera_params(base_image_id).inMatrix;



%  世界座標系へ画像座標値を無理やり変換します
pts_size = size(points);
f_mat = zeros(pts_size(1),1);
f_mat(:) = focal_length1;
cam_co_pts = [points(:,1)-principal_point1(1) (points(:,2)-principal_point1(2)) f_mat];
world_co_pts = (rotation_matrix1\(cam_co_pts - translation_vector1')')';

%  カメラ位置と画像座標を通る直線を計算します
vectors = world_co_pts - camera_position1';


for i = 1:size(refer_image_ids,1)
    
    %  画像平面へ直線を投影するためのパラメータの整理をします
    rotation_matrix2 = camera_params(refer_image_ids(i)).rotation_matrix;
    translation_vector2 = camera_params(refer_image_ids(i)).translation_vector;
    inMatrix2 = camera_params(refer_image_ids(i)).inMatrix;
    
    rotation_translation = [rotation_matrix2 translation_vector2];
    camMatrix = inMatrix2*rotation_translation;
    
    %  画像平面へ直線を投影します
    one_mat = ones(pts_size(1),1);
    edit_vectors = [vectors one_mat]';
    
    edit_vectors = (camMatrix*edit_vectors)';
    edit_camposition = camMatrix*[camera_position1' 1]'; % ここまでで、直線のベクトルと通る点を画像平面へ投影したことに。あとは媒介変数ｔを代入して実際に画像平面へ
    
    %  媒介変数tのminとmaxを求める
    %  xの取りうる範囲は0から画像の端だから、その条件を用いて算出する
    x_min = 0;
    x_max = size(refer_image,2);
    
    t_min = (x_min*edit_camposition(3)-edit_camposition(1))./(edit_vectors(:,1)-(x_min.*edit_vectors(:,3)));
    t_max = (x_max*edit_camposition(3)-edit_camposition(1))./(edit_vectors(:,1)-(x_max.*edit_vectors(:,3)));
    
    %  エピポーラ線の端点を求めます
    % w_min_points = vectors.*t_min+camera_position1';
    % i_min_points = camMatrix*[w_min_points ones(pts_size(1),1)]';
    % i_min_points_xy = [i_min_points(1)./i_min_points(3) i_min_points(2)./i_min_points(3)];
    
    min_points = edit_vectors.*t_min+edit_camposition';
    min_point_xy = [min_points(:,1)./min_points(:,3) min_points(:,2)./min_points(:,3)];
    
    % w_max_points = vectors.*t_max+camera_position1';
    % i_max_points = camMatrix*[w_max_points ones(pts_size(1),1)]';
    % i_max_points_xy = [i_max_points(1)./i_max_points(3) i_max_points(2)./i_max_points(3)];
    
    max_points = edit_vectors.*t_max+edit_camposition';
    max_point_xy = [max_points(:,1)./max_points(:,3) max_points(:,2)./max_points(:,3)];
    
    %  エピポーラ線の計算を行います（y = Ax + B の形にします）
    gradients = (max_point_xy(:,2)-min_point_xy(:,2))./(max_point_xy(:,1)-min_point_xy(:,1));
    intercepts = -min_point_xy(:,1).*gradients+min_point_xy(:,2);
    epiLine = [gradients intercepts];
    
    varname = sprintf('refer%d', i);
    epiLines.(varname) = epiLine;
    max_points_xy.(varname) = max_point_xy;
    min_points_xy.(varname) = min_point_xy;
    
end
    
end



