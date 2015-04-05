%import library for mfcc calculations
addpath('/Users/yael/Desktop/pajaros/rastamat')

%directorios en los que están los wav y los csv de cada segmento

clear
wavfiles = dir('/Users/yael/Desktop/pajaros/data/raw_wav_files/*.wav'); %directory wavefiles
csv = dir('/Users/yael/Desktop/pajaros/data/segment_results/*.csv'); % directory segment csv

for i = 1:length(wavfiles)
    
    wavfiles(i).name
    csv(i).name
    
    % leo el wav: valores y smaple rate
    [d,sr]=wavread(['/Users/yael/Desktop/pajaros/data/raw_wav_files/',wavfiles(i).name]);
    
    nombre_sin_csv = regexprep(csv(i).name,'.csv','');
    RN_csv = load (['/Users/yael/Desktop/pajaros/data/segment_results/',csv(i).name]); %leo el csv
    num_segmentos = length(RN_csv(:,1)); %numero de segmentos = numero de filas del csv
    
    
    
    nombre_fichero = strcat('features_',nombre_sin_csv,'.csv'); %nombre del fichero

    fileID = fopen(['/Users/yael/Desktop/pajaros/data/features/',nombre_fichero],'w'); %abro el fichero en el que escribo
    
    for n = 1:num_segmentos %recorro cada semento
        
        inicio = RN_csv(n,1); %tiempo inicio
        fin = RN_csv(n,2); %tiempo fin
        
        elemento_inicio = inicio * sr; %elemento del array del wav de incio segemento
        elemento_fin = fin * sr; %elemento del array del wav de fin segemento
        
        selected_segment = d(elemento_inicio:elemento_fin); %segmento del wav
        [cepstra]=melfcc(selected_segment, sr); %aplico melfcc al segmetno
        
        %calculo medias
        media_cepstra = mean(cepstra'); %13 elementos uno por cada mfcc
        var_cepstra = var(cepstra'); %13 elementos uno por cada mfcc
        
        %media_cepstra_final(n,:) = media_cepstra;
        %var_cepstra_final(n,:) = var_cepstra;
       
        fprintf(fileID,'%s %s %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %5d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d \n',nombre_sin_csv, inicio, fin, media_cepstra, var_cepstra)
        
    end   
   
    fclose(fileID); %cierro el fichero

end

