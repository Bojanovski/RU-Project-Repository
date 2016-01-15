
function retColor = DrawFaceRectangle(color, depth)
    
    FDetect = vision.CascadeObjectDetector;
    
    %Returns Bounding Box values based on number of objects
    BB = step(FDetect,color);
    %disp(BB);
    %BB = int32([4, 4, 8, 8]);
    
    
    retColor = insertShape(color, 'rectangle', BB);
    %retColor = insertShape(color, 'rectangle', BB, 'LineWidth', 5);

