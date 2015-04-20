nfeatures=34;

classfileid = fopen('classID.txt');
classcell = textscan(classfileid,'%s');
classunique=unique(classcell{1});

classes=size(classunique,1);
samples=size(classcell{1},1);


rnfileid = fopen('listaRN.txt');
rncell = textscan(rnfileid,'%d');



featureid = fopen('allfeatures.txt');
featuredata = textscan(featureid,['LIFECLEF2014_BIRDAMAZON_XC_WAV_RN%d',repmat('%f',[1,nfeatures])],'CollectOutput',1);


nsegments=size(featuredata{2},1);

% Solve a Pattern Recognition Problem with a Neural Network




dictionary=zeros(samples,classes);

for j=1:classes
	for i=1:samples
		if (strcmp(classunique{j},classcell{1}(i)))
			dictionary(i,j)=1;
		end
	end
end





rnlist=featuredata{1};
inputs=featuredata{2};
targets=zeros(nsegments,classes);
for i=1:nsegments
	for j=1:samples
		if (rnlist(i)==rncell{1}(j))
			targets(i,:)=dictionary(j,:);
		end
	end
end





% Create a Pattern Recognition Network
hiddenLayerSize = [80 160 160];
net = patternnet(hiddenLayerSize);


% Set up Division of Data for Training, Validation, Testing

net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% View the Network
%view(net)
save net

confmat=confusionmat(inputs,outputs);
save('confmat.txt','confmat','-ascii')
type('confmat.txt')

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)
