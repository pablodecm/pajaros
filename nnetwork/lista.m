nfeatures=


classfileid = fopen('classID.txt');
classcell = textscan(classfileid,'%s');
classunique=unique(classcell{1});

rnfileid = fopen('listaRN.txt');
rncell = textscan(rnfileid,'%d');



classes=size(classunique,1);
samples=size(classcell{1},1);


dictionary=zeros(unique,samples);

for j=1:samples
	for i=1:classes
		if (strcmp(classunique{i},classcell{1}{j}))
			dictionary(i,j)=1;
		end if
	end for
end for



featuredata = textscan(featureid,['LIFECLEF2014_BIRDAMAZON_XC_WAV_RN%d',repmat('%f',[1,nfeatures])],'CollectOutput',1)
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
