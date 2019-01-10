#reguires install.packages("animation")
library(animation)

oopt = ani.options(interval = 0.05)# fastness of the roation

thenames <- c(1:200)
for(i in 1:200){
  thenames[i] <- paste("./movie/mapround",i,".png",sep="_")
}
im.convert(thenames, output = "bm-animation1-fast.gif")