function OUT = DrawBorder(IN, BB, LineWidth, Color)
RGB = IN;
for i = 1:LineWidth
    RGB = insertShape(RGB, 'rectangle', BB-i*[1,1,-2,-2], 'Color', Color);
end

OUT = RGB;
end