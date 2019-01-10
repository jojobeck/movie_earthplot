########insert you array
ARRAY<- INSERTYOURARRAY
library(maps)
library(mapproj)

steps <- seq(0,360,1.8) ### my stepsize on degree for turrning the Earth

###figure settings
heights=c(4)
widths=c(4,1)
PAR=3 ###how round the Earth seems to stick out to you (play around and watch grid)


project <- "perspective"####look for different map projection @ http://wiki.tcl.tk/19833
XLIM <- c(-180,180)  # can change to different map detail 
YLIM <- c(-90,90)

  for(i in 1:200){

  step <-steps[i]
  orientation <- c(0,step,0)  #view on Earth (long,lat,rot)
  png(filename=paste("./movie/mapround",i,".png",sep="_"), width = sum(widths), height = sum(heights), units="in", res=res)
  par(omi=c(0.1, 0.1, 0.1, 0.1), ps=12)
  layout(matrix(c(1,2),nrow=1,ncol=2,byrow=TRUE), widths = widths, heights = heights, respect=TRUE)


##plot of map
  par(mai=c(0.2, 0.2, 0.2, 0.2))
  map("world", proj=project,par=PAR,mai=c(0.2, 0.2, 0.2, 0.2),orientation=orientation, xlim=XLIM, ylim= YLIM, interior=FALSE, lwd=1)
  for(i in 1:length(longminus)){
    for(j in 1:length(latworld)){
      pos <-((j-1)*length(longminus)+i)
      polygon(mapproject(x=plyx[i,], y=plyy[j,],proj=""), col=colorvalues[pos], border=colorvalues[pos])
    }
  }


map("world",pro="", fill=FALSE,orientation=orientation, add=TRUE, col="black", ylim=YLIM, xlim=XLIM)
  
  map.grid(c(-180, 180, -90, 90), nx=18, ny=18, labels=FALSE, col="darkgrey",lty=1, lwd=0.5)
  

  
  legendlength=0.25 # for legend not over the full page height = distance to figure bottom
  par(mai=c(0.2,0,  0.2, 0.6),plt=c(0,0.1,legendlength,1-legendlength))
  image.scale(ARRAY, col=pal(ncol), horiz=FALSE, yaxt="n")
  # 
  axis(4,cex.axis=0.8)
  mtext("trend lin. reg.", side=4, line=2.5, cex=0.8)
  box()
  par(mai=c(0.2,0,  0.2, 0.6),plt=c(0,0.1,0.0,legendlength-0.02))### this is just a whit box added beacues if legendlength is bigger than 0 a 1 occcurs in the plot
  rect(0.2,-2 , 0.8, 0.1,col="white", border="white")## if legendlength is zero, comment these two lines out
  dev.off(dev.cur())

}
