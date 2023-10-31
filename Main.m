clear all
clf
close all

% Camera intrinsic parameters
f = 946;
p = 357;

% Other Parameters
Z = 150; % depth, unsure what units
l = 0.5; % lambda

% Target
Target = [200, 200; 200, 350; 350, 200; 350, 350];

% Create a video input object
imaqmex('feature', '-limitPhysicalMemoryUsage', false);
vid = videoinput('winvideo', 1, 'MJPG_640x480');

% Set the video input parameters (adjust as needed)
set(vid, 'FramesPerTrigger', inf);
set(vid, 'ReturnedColorspace', 'rgb');

src = getselectedsource(vid);
src.FrameRate = '10.0000'; % Adjust the frame rate as needed

% Start the video stream
start(vid);

% Create a figure to display the video and information
hFig = figure('Position', [100, 100, 1600, 800]);

% Create a subplot for video display
hAxes1 = subplot(1, 2, 1);
set(hAxes1, 'Position', [0.05, 0.05, 0.45, 0.9]); % Adjust position and size
title(hAxes1, 'Video Feed');

% Create a panel for information display
hPanel = uipanel('Title', 'Information', 'Position', [0.65, 0.375, 0.2, 0.3]);
infoText = uicontrol('Style', 'text', 'Position', [20, 20, 300, 150], 'Parent', hPanel, 'FontSize', 12);

while ishandle(hFig)
    % Capture a frame
    frame = getsnapshot(vid);

    % Mirror frame (for the sake of the webcam)
    flipframe = flip(frame, 2);
    croppedImage = imcrop(flipframe, [80, 1, 479, 479]);

    grayframe = rgb2gray(croppedImage);

    edgeframe = edge(grayframe, 'Canny', 0.3);
    filledImage = imfill(edgeframe, 'holes');

    % Create a disk-shaped structuring element
    se = strel('disk', 5);
    % Apply erosion to remove small regions
    erodedImage = imerode(filledImage, se);

    % Use Harris Features to detect corners
    cornerPoints = detectHarrisFeatures(erodedImage, 'MinQuality', 0.65);

    % Display the flipped and eroded image frame
    imshowpair(croppedImage, erodedImage, 'Montage', 'Parent', hAxes1);

    if length(cornerPoints.Location) == 4
        
        hold(hAxes1, 'on');
        plot(hAxes1, cornerPoints.Location(:, 1), cornerPoints.Location(:, 2), 'r*');
        plot(hAxes1, Target(:, 1), Target(:, 2), 'ro', 'MarkerSize', 2);
        hold(hAxes1, 'off');

        % Convert to observed matrix (for clarity)        
        Obs = cornerPoints.Location;
        sorted_Obs = Sorting(Obs);
        % Define the transformation equations for visual servoing
        xy = (Target - p) / f;      % Compute the desired image coordinates
        
        % Transform observed coordinates to desired image coordinates
        Obsxy = (sorted_Obs - p) / f;
        
        % Get the number of data points
        n = length(Target(:, 1));
        
        % Initialize an empty array for storing the interaction matrix Lx
        Lx = [];
        
        % Loop through each data point and compute the interaction matrix Lx for each
        for i = 1:n
            Lxi = FuncLx(xy(i, 1), xy(i, 2), Z);
            Lx = [Lx; Lxi];
        end
        
        % Compute the error between observed and desired coordinates
        e2 = Obsxy - xy;
        e = reshape(e2', [], 1);
        
        % Compute the derivative of the error
        de = -e * l;
        
        % Calculate the pseudo-inverse of the interaction matrix Lx
        Lx2 = inv(Lx' * Lx) * Lx';
        
        % Compute the control vector Vc
        Vc = -l * Lx2 * e;
        
        % Extract the individual components of the control vector
        Vx = Vc(1, 1);
        Vy = Vc(2, 1);
        Vz = Vc(3, 1);
        Wx = Vc(4, 1);
        Wy = Vc(5, 1);
        Wz = Vc(6, 1);

        % Display simple set of directions
        infoStr = sprintf('Move Right: %.2f\nMove Up: %.2f\nMove Forward: %.2f\nPitch Up: %.2f\nYaw Right: %.2f\nRoll Right: %.2f', Vx, Vy, Vz, Wx, Wy, Wz);
        set(infoText, 'String', infoStr);
    end

    % Cleanly stop camera through key input
    key = get(gcf, 'CurrentCharacter');
    if key == 'q'
        break; % Exit the loop when 'q' is pressed
    end
end

% Stop the video stream when done
stop(vid);

% Clean up
delete(vid);
clear vid;
