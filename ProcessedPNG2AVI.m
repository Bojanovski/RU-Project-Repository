
function ProcessedPNG2AVI(frameRate, videoName)
workingDir = videoName;

imageNames = dir(fullfile(workingDir,'images','P_RGB_*.png'));
imageNames = {imageNames.name};

outputVideo = VideoWriter(fullfile(workingDir,'P_color_out.avi'), 'Uncompressed AVI');
outputVideo.FrameRate = frameRate;

open(outputVideo)
for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'images', imageNames{ii}));
   writeVideo(outputVideo, img)
end
close(outputVideo)