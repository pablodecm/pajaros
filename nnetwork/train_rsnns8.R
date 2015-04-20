library(RSNNS)

tabla_tot <- read.table('allfeatures2.txt',
                      sep="",stringsAsFactors =F,header=F)


as.numeric(gsub("LIFECLEF2014_BIRDAMAZON_XC_WAV_RN", "", tabla_tot[1]))

tienenNA<-which(!complete.cases(tabla_tot))
tabla_tot <- tabla_tot[-tienenNA,]

tabla_clases <- read.table('classID.txt',sep="",stringsAsFactors =F,header=F)
tabla_rn <- read.table('listaRN.txt',sep="",stringsAsFactors =F,header=F)


nsegments=length(tabla_tot[,1])
nrecords=length(tabla_rn[,1])
nfeatures=34
tabla_clases[,2]=tabla_rn
for (i in 1:nrecords){
      tabla_tot[tabla_tot[,1]==tabla_clases[i,2],36]<-tabla_clases[i,1]
      #print(i)
}
head(tabla_tot)


tabla_prueba <- tabla_tot[(tabla_tot[,36]==tabla_tot[1,36])
                          | (tabla_tot[,36]==tabla_tot[20,36])
                          | (tabla_tot[,36]==tabla_tot[40,36])
                          | (tabla_tot[,36]==tabla_tot[60,36])
                          | (tabla_tot[,36]==tabla_tot[80,36])
                          | (tabla_tot[,36]==tabla_tot[100,36])
                          | (tabla_tot[,36]==tabla_tot[120,36])
                          | (tabla_tot[,36]==tabla_tot[160,36])
                          | (tabla_tot[,36]==tabla_tot[180,36])
                          | (tabla_tot[,36]==tabla_tot[220,36])
                          | (tabla_tot[,36]==tabla_tot[240,36])
                          | (tabla_tot[,36]==tabla_tot[260,36])
                          | (tabla_tot[,36]==tabla_tot[280,36])
                          | (tabla_tot[,36]==tabla_tot[300,36])
                          | (tabla_tot[,36]==tabla_tot[320,36])
                          | (tabla_tot[,36]==tabla_tot[340,36])
                          | (tabla_tot[,36]==tabla_tot[360,36])
                          | (tabla_tot[,36]==tabla_tot[380,36])
                          | (tabla_tot[,36]==tabla_tot[400,36])
                          | (tabla_tot[,36]==tabla_tot[420,36])
                          | (tabla_tot[,36]==tabla_tot[440,36])
                          | (tabla_tot[,36]==tabla_tot[460,36])
                          | (tabla_tot[,36]==tabla_tot[480,36])
                          | (tabla_tot[,36]==tabla_tot[490,36])
                          | (tabla_tot[,36]==tabla_tot[520,36])
                          | (tabla_tot[,36]==tabla_tot[540,36])
                          | (tabla_tot[,36]==tabla_tot[560,36])
                          | (tabla_tot[,36]==tabla_tot[580,36])
                          | (tabla_tot[,36]==tabla_tot[600,36])
                          | (tabla_tot[,36]==tabla_tot[720,36])
                          | (tabla_tot[,36]==tabla_tot[740,36])
                          | (tabla_tot[,36]==tabla_tot[760,36])
                          | (tabla_tot[,36]==tabla_tot[780,36])
                          | (tabla_tot[,36]==tabla_tot[800,36])
                          | (tabla_tot[,36]==tabla_tot[820,36])
                          | (tabla_tot[,36]==tabla_tot[840,36])
                          | (tabla_tot[,36]==tabla_tot[860,36])
                          | (tabla_tot[,36]==tabla_tot[880,36])
                          | (tabla_tot[,36]==tabla_tot[900,36])
                          | (tabla_tot[,36]==tabla_tot[925,36])
                          | (tabla_tot[,36]==tabla_tot[940,36])
                          | (tabla_tot[,36]==tabla_tot[960,36])
                          | (tabla_tot[,36]==tabla_tot[983,36])
                          | (tabla_tot[,36]==tabla_tot[1000,36])
                          | (tabla_tot[,36]==tabla_tot[1015,36])
                          | (tabla_tot[,36]==tabla_tot[1040,36])
                          | (tabla_tot[,36]==tabla_tot[1060,36])
                          | (tabla_tot[,36]==tabla_tot[1080,36])
                          | (tabla_tot[,36]==tabla_tot[1100,36])
                          | (tabla_tot[,36]==tabla_tot[200,36]), ]

#tabla_tot_shuffle <- tabla_tot[sample(1:nrow(tabla_tot)),]
tabla_tot_shuffle <- tabla_prueba[sample(1:nrow(tabla_prueba)),]

features<-tabla_tot_shuffle[,4:35]
targets<-decodeClassLabels(tabla_tot_shuffle[,36])

data <- splitForTrainingAndTest(features,targets,ratio=0.2)



redneuronal <- mlp(data$inputsTrain,data$targetsTrain,
                   size=c(100,200),maxit=10000,
                   inputsTest=data$inputsTest,targetsTest=data$targetsTest)

confmat_test <- confusionMatrix(data$targetsTest,redneuronal$fittedTestValues)
confmat_train <- confusionMatrix(data$targetsTrain,redneuronal$fitted.values)

save(redneuronal,file="redneuronal8.rda")
write.table(confmat_train,file="confmat_train8.txt")
write.table(confmat_test,file="confmat_test8.txt")
# library(doParallel)
# registerDoParallel(cores=8)
# 
# foreach(i=1:nsegments) %dopar% {
#   for (j in 1:nclases){
#     if ( tabla_tot[i,1]==tabla_clases[j,2] ){
#       tabla_tot[i,36]<-tabla_clases[j,1]
#     }
#   }
# }
