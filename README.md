# visualServoing

This project consists of three matlab files:
- Sorting.m
    Corresponds each observed point with its corresponding goal point, depending on their respective (x,y) values.
- FuncLx.m
    Converts (x,y,Z) input values to an interaction matrix.
- Main.m
    Contains the main script which captures frames from a video stream, performs image processing, and provides feedback to the user.

Short description of functionality:
1. Camera intrinsic properties and other variables are defined.
2. Camera video stream is started
3. A frame is captured every 0.3 seconds (Start of loop)
4. Processing is performed on the frame, in order, cropped -> greyscaled -> edge detection (canny) -> filled -> eroded
5. Corner features are extracted using harris corner technique
6. Cropped and eroded image are displayed for the user
7. If there are exactly 4 corners detected
8.   Corner points are plotted on cropped image, and sorted to their corresponding goal points using Sorting.m
9.   Transforming of coordinates to image coordinates
10.   Loop through each data point and compute the interaction matrix Lx for each
11.   Compute the error and derivated of the error between observed and desired coordinates
12.   Display the velocity commands in text
13. (End of loop), can be exited through key press 'q'

To execute the script, run Main.m on MATLAB, the other files are required for script execution.
UTS Sensors and Control submission
Individual code contributions: Kyle 50%, Bilguun 30%, Ben 20%
