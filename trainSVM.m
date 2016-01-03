function svm = trainSVM(positive, negative)
%funkcija kao parametre prima mapu sa pozitivnim i negativnim primjerima.
%Za racunanje znacanjki se koristi funkcija findFeatures. Na kraju se
%trenira SVM klasifikator koji se vraca kao rezultat funkcije.
pos = dir(positive);
neg = dir(negative);
data = [];
label = [];
%racunaj znacajke kod pozitivnih primjera
for i = 1 : length(pos)
    if (strcmp(pos(i).name, '.') == 0) && (strcmp(pos(i).name, '..') == 0)
        data = [data ; findFeatures(strcat(positive, '\\', pos(i).name))];
        label = [label ; 1];
    end
end
%racunaj znacajke kod negativnih primjera
for i = 1 : length(neg)
    if (strcmp(neg(i).name, '.') == 0) && (strcmp(neg(i).name, '..') == 0)
        data = [data ; findFeatures(strcat(negative, '\\', neg(i).name))];
        label = [label ; -1];
    end
end
%sada bi jos trebalo samo trenirati SVM!
svm = svmtrain(data, label); %treba prouciti koje sve parametre ima funkcija