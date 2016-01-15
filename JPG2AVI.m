
function JPG2AVI(frameRate, videoName)
workingDir = videoName;

imageNamesColor = dir(fullfile(workingDir,'images','img_*.jpg'));
imageNamesColor = {imageNamesColor.name};

outputVideoColor = VideoWriter(fullfile(workingDir,'video_out.avi'), 'AVI');
outputVideoColor.FrameRate = frameRate;

open(outputVideoColor)
for ii = 1:length(imageNamesColor)
   img = imread(fullfile(workingDir,'images',imageNamesColor{ii}));
   writeVideo(outputVideoColor, img)
end
close(outputVideoColor)
