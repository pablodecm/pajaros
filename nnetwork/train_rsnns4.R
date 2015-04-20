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


# tabla_prueba <- tabla_tot[(tabla_tot[,36]==tabla_tot[1,36])
#                           | (tabla_tot[,36]==tabla_tot[20,36])
#                           | (tabla_tot[,36]==tabla_tot[40,36])
#                           | (tabla_tot[,36]==tabla_tot[60,36])
#                           | (tabla_tot[,36]==tabla_tot[80,36])
#                           | (tabla_tot[,36]==tabla_tot[100,36])
#                           | (tabla_tot[,36]==tabla_tot[120,36])
#                           | (tabla_tot[,36]==tabla_tot[160,36])
#                           | (tabla_tot[,36]==tabla_tot[180,36])
#                           | (tabla_tot[,36]==tabla_tot[200,36]), ]

tabla_tot_shuffle <- tabla_tot[sample(1:nrow(tabla_tot)),]
#tabla_tot_shuffle <- tabla_prueba[sample(1:nrow(tabla_prueba)),]

features<-tabla_tot_shuffle[,2:35]
targets<-decodeClassLabels(tabla_tot_shuffle[,36])

data <- splitForTrainingAndTest(features,targets,ratio=0.2)



redneuronal <- mlp(data$inputsTrain,data$targetsTrain,
                   size=c(200,400),maxit=50000,
                   inputsTest=data$inputsTest,targetsTest=data$targetsTest)

confmat_test <- confusionMatrix(data$targetsTest,redneuronal$fittedTestValues)
confmat_train <- confusionMatrix(data$targetsTrain,redneuronal$fitted.values)

save(redneuronal,file="redneuronal4.rda")
write.table(confmat_train,file="confmat_train4.txt")
write.table(confmat_test,file="confmat_test4.txt")
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
