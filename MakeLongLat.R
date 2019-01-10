MakeLongLat <- function(x){
  if(!is.matrix(x)) stop("x must be a matrix")
  latlength <- length(x[1,])
  longlength <- length(x[,1])
  latworld <- seq(-90,90,length=latlength)
  longworld <- seq(-180,180,length=(longlength+1))
  longworld <- longworld[1:longlength]
  return(list(longworld,latworld,x))
}
