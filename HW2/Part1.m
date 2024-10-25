clear;
clc;
% Brown-Conrady Model
%Inputs
left_image = imread('left.jpg');
right_image = imread('right.jpg');

k1 = 0.2; k2 = -0.02; k3 = -0.0001;
p1 = 0.001; p2 = -0.002;

% Image values
[height, width, channels] = size(left_image);
center = [width / 2, height / 2];

distorted_image_left = applyDistortion(left_image, k1, k2, k3, p1, p2);
distorted_image_right = applyDistortion(right_image, k1, k2, k3, p1, p2);

% Plot images
figure;
subplot(1, 2, 1);
imshow(distorted_image_left);
title(["Distorted Left Image with parameters:",;
        'p1:', num2str(p1);
        'p2:', num2str(p2);
        'k1:', num2str(k1);
        'k2:', num2str(k2);
        'k3:', num2str(k3)]);
subplot(1, 2, 2);
imshow(distorted_image_right);
title(["Distorted Right Image with parameters:",;
        'p1:', num2str(p1);
        'p2:', num2str(p2);
        'k1:', num2str(k1);
        'k2:', num2str(k2);
        'k3:', num2str(k3)]);

        function distorted_image = applyDistortion(left_image, k1, k2, k3, p1, p2)
            [height, width, channels] = size(left_image);
            center = [width / 2, height / 2];

            distorted_image = zeros(height, width, channels, 'uint8');

            % Iterate over all pixels
            for y = 1:height
                for x = 1:width
                    x_norm = (x - center(1)) / center(1);
                    y_norm = (y - center(2)) / center(2);
                    % Radial distortion
                    r2 = x_norm^2 + y_norm^2;
                    radial_distortion = 1 + k1 * r2 + k2 * r2^2 + k3 * r2^3;
                    % Tangential distortion
                    x_tangential = 2 * p1 * x_norm * y_norm + p2 * (r2 + 2 * x_norm^2);
                    y_tangential = p1 * (r2 + 2 * y_norm^2) + 2 * p2 * x_norm * y_norm;
                    % Sum distortions
                    x_distorted = x_norm * radial_distortion + x_tangential;
                    y_distorted = y_norm * radial_distortion + y_tangential;
                    % Map back to original coordinates
                    x_orig = round(x_distorted * center(1) + center(1));
                    y_orig = round(y_distorted * center(2) + center(2));
                    % Debug over or undersize
                    if x_orig >= 1 && x_orig <= width && y_orig >= 1 && y_orig <= height
                        distorted_image(y, x, :) = left_image(y_orig, x_orig, :);
                    end
                end
            end
        end
        