#####need grid system for latitudes and longitudes with equal distance
##longworld= longitudes from -180 to 180
###latworld= latitude from-90 to 90
library(maps)
library(mapproj)
######let this run so amke fucntion that rturn mor than one value
list <- structure(NA,class="result")
"[<-.result" <- function(x,...,value) {
  args <- as.list(match.call())
  args <- args[-c(1:2,length(args))]
  length(value) <- length(args)
  for(i in seq(along=args)) {
    a <- args[[i]]
    if(!missing(a)) eval.parent(substitute(a <- v,list(a=a,v=value[[i]])))
  }
  x
}
#############################################
## give in any arry m with the data , you want to plot 
# but make sure the data is otganized in 
# an array fom -180,180 long and -90,90 latitude in function MakeLongLat(m)
#### exp.: m <- array(1:5,c(5,9))
########list[longworld,latworld] <- MakeLongLat(m)
source('MakeLongLat.R')
list[longworld,latworld,thearray] <- MakeLongLat(INSERTYOURARRAY)# insert the wished array
spacing=longworld[2]-longworld[1]
spacing2= latworld[2]-latworld[1] 

#####create polygon for grid
###for longitudes poly x:
plyx <- array(1,c(length(longworld),4))
for(i in 1:length(longworld)){
  plyx[i,]<- c(longworld[i]-spacing/2,longworld[i]+spacing/2,longworld[i]+spacing/2,longworld[i]-spacing/2)
}
###for latitudes poly y
plyy <- array(1,c(length(latworld),4))
for(i in 1:length(latworld)){
  plyy[i,] <- c(latworld[i]+spacing2/2,latworld[i]+spacing2/2,latworld[i]-spacing2/2,latworld[i]-spacing2/2)
}

###now plot worldmap with perspective
source('val2col.R')
source("image.scale.R")

###color
pal=colorRampPalette(c("blue","lightblue" ,"white","pink", "red","darkred")) ##change colors if you want
ncol=50
res=200

colorvalues <- val2col(thearray, col=pal(ncol)) #color levels for the polygons

# val2cal gives value vector of length(m*n) of matrix(m,n)
##### therfore value of matrix(i,j) is in vector= (j-1)*m+i
##set parameter

####figure settings:
heights=c(4)
widths=c(4,1)
PAR=3 ###how round the Earth seems to stick out to you (play around and watch grid)
orientation <- c(0,162.,0) ### view on globe

project <- "perspective"####look for different map projection @ http://wiki.tcl.tk/19833
XLIM <- c(-180,180)  # can change to different map detail 
YLIM <- c(-90,90)

#######now the actuall plot
png(filename="map_round.png", width = sum(widths), height = sum(heights), units="in", res=res)
par(omi=c(0.1, 0.1, 0.1, 0.1), ps=12)
layout(matrix(c(1,2),nrow=1,ncol=2,byrow=TRUE), widths = widths, heights = heights, respect=TRUE)
layout.show(2)

##plot of map
par(mai=c(0.2, 0.2, 0.2, 0.2))
map("world", proj=project,par=PAR,orientation=orientation, xlim=XLIM, ylim= YLIM, interior=FALSE, lwd=1)
for(i in 1:length(longworld)){
  for(j in 1:length(latworld)){
    pos <-((j-1)*length(longworld)+i)
    polygon(mapproject(x=plyx[i,], y=plyy[j,],proj=""), col=colorvalues[pos], border=colorvalues[pos])
  }
}



map("world",pro="", fill=FALSE,orientation=orientation, add=TRUE, col="black", ylim=YLIM, xlim=XLIM)
map.grid(c(-180, 180, -90, 90), nx=18, ny=18, labels=FALSE, col="darkgrey",lty=1, lwd=0.5)

#legend( inset=c(-0.09,-1),v, col=rangecol,bty="n")
legendlength=0.25 # for legend not over total height is, distance to figure bottom
par(mai=c(0.2,0,  0.2, 0.6),plt=c(0,0.1,legendlength,1-legendlength))
image.scale(thearray, col=pal(ncol), horiz=FALSE, yaxt="n")
# 
axis(4,cex.axis=0.8)
mtext("trend lin. reg.", side=4, line=2.5, cex=0.8)
box()

par(mai=c(0.2,0,  0.2, 0.6),plt=c(0,0.1,0.0,legendlength-0.02))### this is just a whit box added beacues if legendlength is bigger than 0 a 1 occcurs in the plot
rect(0.2,-2 , 0.8, 0.1,col="white", border="white")## if legendlength is zero, comment these two lines out

dev.off()

