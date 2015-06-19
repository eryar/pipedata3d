### pipedata3d - piping component data and dimension in 3d.

Shing Liu(eryar@163.com)

##Introduction

pipedata3d is based on OpenCASCADE Draw Test Harness,
so it supports the Tcl commands to modeling, visualization.

You can download pipedata3d from the following address freely: <br>
http://yun.baidu.com/pcloud/album/file?album_id=6625679120668624981&uk=3808749571&fsid=1084553234738540

After download, you can run pipedata3d by *pipedata3d.bat*:
![pipedata3d GUI] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/wps_clip_image-25799_thumb.png "pipedata3d GUI")<br>
Figure 1. A Welding Neck Flange in pipedata3d

##View Options
The view options is the same with OpenCASCADE Draw Test Harness, i.e.:
* ![Zoom] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/wps_clip_image-15691_thumb.png "Zoom") : Drag with left button down and Ctrl to zoom;
* ![Rotate] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/wps_clip_image-20741_2.png "Rotate") : Drag with right button down and Ctrl to rotate; 
* ![Pan] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/wps_clip_image-2452_thumb.png "Pan") : Draw with middle button down and Ctrl to pan;

<br>
![3d view of pipedata3d] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/wps_clip_image-19538_2.png "3d view of pipedata3d")<br>
Figure 2. 3D view of pipedata3d

There are also some hotkeys for the view operations:
* F: fit all for the view;
* D: reset the view;
* W: switch to wireframe mode;
* S: switch to shadeing mode;
* T: view from top;
* B: view from bottom;
* R: view from right:
* L: view from left;

##Customisation Issues
You can build your standard piping components by Tcl scripts, put these Tcl script file to the *stdlib* folder, <br>
![Standard Library Data] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/wps_clip_image-19873_2.png "Standard Library Data") <br>
Figure 3. Standard Library Data

You can download the Tcl scripts from github and put them in to the *stdlib* folder: <br>
https://github.com/eryar/pipedata3d

## Piping Component
![Long Radius Returns Elbow] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_thumb.png "Long Radius Returns Elbow") <br>
Figure 4. Long Radius Returns Elbow

![Long Radius Elbow 45 Degree] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_4.png "Long Radius Elbow 45 Degree") <br>
Figure 5. Long Radius Elbow 45 Degree

![Long Radius Elbow 90 Degree] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_6.png "Long Radius Elbow 90 Degree") <br>
Figur 6. Long Radius Elbow 90 Degree

![Concentric Reducer] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_8.png "Concentric Reducer") <br>
Figure 7. Concentric Reducer

![Eccentric Reducer] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_10.png "Eccentric Reducer") <br>
Figure 8. Eccentric Reducer

![Straight Tee] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_12.png "Straight Tee") <br>
Figure 9. Straight Tee

![ANSI B16.10 Globe Valve] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/pipedata3d-GlobeValve_2.png "ANSI B16.10 Globe Valve") <br>
Figure 10. ANSI B16.10 Globe Valve

![ASME B16.5-2013 Welding Neck Flange] (http://www.cppblog.com/images/cppblog_com/eryar/Windows-Live-Writer/pipedata3d-User-Guide_12B8C/image_thumb_6.png "ASME B16.5-2013 Welding Neck Flange") <br>
Figure 11. ASME B16.5-2013 Welding Neck Flange


## Feedback and Support
Please send any bug report, suggestion, question and comment to the author at following address: <br>
Shing Liu(eryar@163.com)

## References
* OpenCASCADE Draw Test Harness User Guide;
* Tcl and the Tk Toolit;
* Practical Programming in Tcl and Tk;
* Tcl/Tk Developer's Guide;
* http://www.tcl.tk
