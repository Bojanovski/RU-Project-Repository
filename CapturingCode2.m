    %------------------------------------------------
    %------------------------------------------------
    %Code to record kinect colour and sensor data
    %using code supplied on http://www.mathworks.co.uk/help/imaq/examples/using-the-                kinect-r-for-windows-r-from-image-acquisition-toolbox-tm.html
    %and http://www.mathworks.co.uk/help/imaq/examples/logging-data-to-disk.html
    %------------------------------------------------
    %------------------------------------------------

    dbstop if error

    imaqreset %deletes any image acquisition objects that exsist in memory and uploads         all adaptors loaded by the toolbox. As a result, image acquisition hardware is reset

    %------------------------------------------------
    %setting up video streams
    %------------------------------------------------
    disp('Setting up video streams');

    %Call up dicertory containing utility functions
    utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', 'html', 'KinectForWindows');
    addpath(utilpath);

    %Create the videoinput objects for the colour and depth streams
    colourVid = videoinput('kinect', 1, 'RGB_640x480');
    %preview(colourVid);
    depthVid = videoinput('kinect', 2, 'Depth_640x480');

    %set backlight compensation with centre priority
    %set(colourVid, 'BacklightCompensation', 'CentrePriority');

    %Set camera angle to 0
    %set(colourVid, 'CameraElevationAngle', 0);

    disp('Video stream set-up complete');

    %------------------------------------------------
    %setting up record
    %------------------------------------------------

    % set the data streams to logging mode and to disk
    set(colourVid, 'LoggingMode', 'Disk&Memory');
    set(depthVid, 'LoggingMode', 'Disk&Memory');    
    
    %Creat a VideoReader object
    colourLogfile = VideoWriter('colourTrial5.mj2', 'Motion JPEG 2000');
    depthLogfile = VideoWriter('depthTrial5.mj2', 'Motion JPEG 2000');

    %configure the video input object to use the VideoWriter object
    colourVid.DiskLogger = colourLogfile;
    depthVid.DiskLogger = depthLogfile;

    %set the triggering mode to 'manual'
    triggerconfig([colourVid depthVid], 'manual');

    %set the FramePerTrigger property of the VIDEOINPUT objects to 'numOfFrames' to
    %acquire 'numOfFrames' frames per trigger.
    numOfFrames = 10;
    set([colourVid depthVid], 'FramesPerTrigger', numOfFrames);

    disp('Video record set-up complete');

    %------------------------------------------------
    %Initiating the aquisition
    %------------------------------------------------
    disp('Starting Stream');

    %Start the colour and depth device. This begins acquisition, but does not
    %start logging of acquired data
    start([colourVid depthVid]);
    
    countdownSeconds = 3;
    for k = 1:countdownSeconds
        disp(num2str(countdownSeconds + 1 - k));
        pause(1);
    end
    disp('GO!');

    %Trigger the devices to start logging of data.
    trigger([colourVid depthVid]);
    
    %Wait until all frames are available
    lastAvailable = 0;
    while get(colourVid,'FramesAvailable') < numOfFrames
        ncv = get(colourVid,'FramesAvailable');
        if (lastAvailable < ncv)
            lastAvailable = ncv;
            disp(strcat('Color frames available ', num2str(ncv,'%u')));
        end
    end
    lastAvailable = 0;
    while get(depthVid,'FramesAvailable') < numOfFrames
        ndv = get(depthVid,'FramesAvailable');
        if (lastAvailable < ndv)
            lastAvailable = ndv;
            disp(strcat('Depth frames available ', num2str(ndv,'%u')));
        end
    end

    %Retrieve the acquired data
    [colourFrameData, colourTimeData, colourMetaData] = getdata(colourVid);
    [depthFrameData, depthTimeData, depthMetaData] = getdata(depthVid);

    stop([colourVid depthVid]) 
    
    disp('Recording Complete')
    clear ncv;
    clear ndv;
    clear lastAvailable;
    clear countdownSeconds;

    %------------------------------------------------
    %Play back recordings
    %------------------------------------------------
    disp('Construct playback objects')

    colourPlayback = VideoReader('colourTrial5.mj2');
    depthPlayback = VideoReader('depthTrial5.mj2');

    %Set colour(c) playback parameters
    cFrames = colourPlayback.NumberOfFrames;
    cHeight = colourPlayback.Height;
    cWidth = colourPlayback.Width;

    %Preallocate movie structure
    colourMov(1:cFrames)=struct('cdata', zeros(cHeight,cWidth,3,'uint8'),'colormap',[]);

    disp('Reading colour frames one by one')
    
    outputVideoColor = VideoWriter(fullfile('.', 'color_out.avi'), 'Uncompressed AVI');
    outputVideoColor.FrameRate = colourPlayback.FrameRate;
    open(outputVideoColor);
    
    %read one frame at a time
    for k = 1:cFrames
        colourMov(k).cdata = read(colourPlayback,k);
        img = colourMov(k).cdata;
        writeVideo(outputVideoColor, img)
    end
    close(outputVideoColor)
    

    disp('Sizing figure for colour playback')

    %Size a figure based on the video's width and height
    hf1=figure;
    set(hf1,'position',[150 150 cWidth cHeight])

    disp('Playing Colour recording')

    %play back the movie once at the video's frame rate
    movie(hf1,colourMov,1,colourPlayback.FrameRate);

    %Set depth(d) playback parameters
    dFrames = depthPlayback.NumberOfFrames;
    dHeight = depthPlayback.Height;
    dWidth = depthPlayback.Width;

    %Preallocate movie structure
    depthMov(1:dFrames)=struct('cdata', zeros(dHeight,dWidth,3,'uint8'),'colormap',gray(256));

    disp('Reading depth frames one by one')
    
    %read one frame at a time
    for k = 1:dFrames
        depthMov(k).cdata=uint8(read(depthPlayback,k));
        %depthMov(k)=imrotate(depthMov(k),180); %tried this to no effect
    end

    disp('Sizing figure for depth playback')

    %Size a figure based on the video's width and height
    hf2=figure;
    set(hf2,'position',[150 150 dWidth dHeight])

    disp('Playing Depth recording')

    %play back the movie once at the video's frame rate
    movie(hf2,depthMov,1,depthPlayback.FrameRate);

    %clear videos from workspace
    delete([colourVid depthVid])
    clear [colourVid depthVid]