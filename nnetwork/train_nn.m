nfeatures=32

classfileid = fopen('classID.txt');
classcell = textscan(classfileid,'%s');
classunique=unique(classcell{1});

classes=size(classunique,1);
samples=size(classcell{1},1);


rnfileid = fopen('listaRN.txt');
rncell = textscan(rnfileid,'%d');



featureid = fopen("allfeatures.csv");
featuredata = textscan(featureid,['LIFECLEF2014_BIRDAMAZON_XC_WAV_RN%d',repmat('%f',[1,nfeatures])],'CollectOutput',1)


nsegments=size(featuredata{2},1);

% Solve a Pattern Recognition Problem with a Neural Network













dictionary=zeros(unique,samples);

for j=1:samples
	for i=1:classes
		if (strcmp(classunique{i},classcell{1}{j}))
			dictionary(i,j)=1;
		end if
	end for
end for




rnlist=featuredata{1};
features=featuredata{2};
targets=zeros(unique,nsegments);
for i=1:nsegments
	for j=1:samples
		if (featuredata{1}{i}==rncell{1}{j})
			targets(:,i)=dictionary(:,j);
		end if
	end for
end for














% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);


% Set up Division of Data for Training, Validation, Testing.divide
traininds=randperm();


net.divideFcn='divideind';
net.divideParam.trainInd = 1:;
net.divideParam.valInd = :;
net.divideParam.testInd = :n_seg_total;


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)
