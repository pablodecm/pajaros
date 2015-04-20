train8 <- as.matrix(read.table("confmat_train8.txt"))
test8 <- as.matrix(read.table("confmat_test8.txt"))

train7 <- as.matrix(read.table("confmat_train7.txt"))
test7 <- as.matrix(read.table("confmat_test7.txt"))

train9 <- as.matrix(read.table("confmat_train9.txt"))
test9 <- as.matrix(read.table("confmat_test9.txt"))

train10 <- as.matrix(read.table("confmat_train10.txt"))
test10 <- as.matrix(read.table("confmat_test10.txt"))

sum(diag(train9))/sum(train9)*100
sum(diag(test9))/sum(test9)*100

sum(diag(train10))/sum(train10)*100
sum(diag(test10))/sum(test10)*100

sum(diag(train7))/sum(train7)*100
sum(diag(test7))/sum(test7)*100

sum(diag(train8))/sum(train8)*100
sum(diag(test8))/sum(test8)*100

load("redneuronal9.rda")
plot(redneuronal)
library(nnet)
library(devtools)
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')
plot.nnet(redneuronal)