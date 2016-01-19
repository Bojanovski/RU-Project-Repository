
function retColor = DrawFaceRectangle(color, depth)
    
    FDetect = vision.CascadeObjectDetector;
    
    %Returns Bounding Box values based on number of objects
    BB = step(FDetect,color);
    widthHeightRectangle = 32;
    workspaceWithSVM = load('esviem4.mat');
    svm = getfield(workspaceWithSVM, 'esviem4');
    retColor = color;
    
    for i=1:size(BB,1)
        %fill positives
        imCrop = imcrop(depth, [round(BB(i,1) - 0.2*BB(i,3)) round(BB(i,2) - 0.2*BB(i,4)) BB(i,3) BB(i,4)]); %%PAZI NA OVAJ 0.2 ispravak
        frameDCroped = imresize(imCrop, [widthHeightRectangle widthHeightRectangle]);

        red = double(frameDCroped(:,:,1));
        green = double(frameDCroped(:,:,2));
        sum = red*255 + green;
        features = reshape(sum, 1, []); %plavi kanal je sve u 0 tako da ga ne citamo

        result = svmclassify(svm, features);
        
        if (result == 1)
            retColor = insertShape(retColor, 'rectangle', BB(i,:), 'color', 'green');
            %retColor = insertShape(color, 'rectangle', BB, 'LineWidth', 5);
        else
            retColor = insertShape(retColor, 'rectangle', BB(i,:), 'color', 'red');
        end
    end
