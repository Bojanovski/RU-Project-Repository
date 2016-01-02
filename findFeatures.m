function features = findFeatures(path)
%funkcija kao argument prima putanju do slike koja predstavlja dubinu. Kao
%rezultat vraæa vektor redak sa znacajkama koje predstavljaju standardnu
%devijaciju pojedinih podrucja dubinske slike.
pic = imread(path); %ucitaj
r = pic(:, :, 1); % R komponeneta
g = pic(:, :, 2); % G komponenta
depth = int32(r) + int32(g) * 256; %pretvori u dubinsku mapu
dims = size(depth);
%odredi desno oko
r_eye_x = int32(0.215 * dims(2));
r_eye_y = int32(0.33 * dims(1));
r_eye_w = int32(0.23 * dims(2) - 1);
r_eye_h = int32(0.15 * dims(1) - 1);
r_eye = depth(r_eye_y : r_eye_y + r_eye_h, r_eye_x : r_eye_x + r_eye_w);
%figure();
%imshow(r_eye);
%odredi ljevo oko
l_eye_x = int32(0.555 * dims(2));
l_eye_y = int32(0.33 * dims(1));
l_eye_w = int32(0.23 * dims(2) - 1);
l_eye_h = int32(0.15 * dims(1) - 1);
l_eye = depth(l_eye_y : l_eye_y + l_eye_h, l_eye_x : l_eye_x + l_eye_w);
%figure();
%imshow(l_eye);
%odredi nos
nose_x = int32(0.4 * dims(2));
nose_y = int32(0.345 * dims(1));
nose_w = int32(0.26 * dims(2) - 1);
nose_h = int32(0.325 * dims(1) - 1);
nose = depth(nose_y : nose_y + nose_h, nose_x : nose_x + nose_w);
%figure();
%imshow(nose);
%odredi usta
mouth_x = int32(0.315 * dims(2));
mouth_y = int32(0.635 * dims(1));
mouth_w = int32(0.4 * dims(2) - 1);
mouth_h = int32(0.19 * dims(1) - 1);
mouth = depth(mouth_y : mouth_y + mouth_h, mouth_x : mouth_x + mouth_w);
%figure();
%imshow(mouth);
%vektor redak sa rezultatima
features = [std2(r_eye), std2(l_eye), std2(nose), std2(mouth)];