#get monthly data for tmin,tmax,and precip for previous year

rm(list = ls())
gc()
#library to work with ncdg
library(ncdf)
library(raster)

#observaiton location
data.dir<-"E:/Daisy Englert/Work MQ/Current Projects/ENSO/Raw Data/"
#path to AWAP data
pt.dir <- "C:/Users/Visitor/Documents/FWPT/unpacked/"
#observations and background data
obs<-read.csv(paste(data.dir,"butterfly_observation_biovars_Dec_March.csv",sep=""),header=TRUE)
obs_sub<-obs[,1:10]
bgd<-read.csv(paste(data.dir,"butterfly_background_biovars_Dec_March.csv",sep=""),header=TRUE)
bgd_sub<-bgd[,1:10]

#make empty dataframe
obs2<-NULL

#loop through observations
for(i in 1:nrow(obs_sub)){
  #single row of data
  observation<-obs_sub[i,]
  y<-observation$year
  y2<-y+1
  
  #get the year data needed and read rasters for dec-march
  r1<-raster(paste0(pt.dir,y,"0101_",y,"1231.FWPT.run26h.flt/AWAP/Run26h/FWPT/mth_FWPT_",y,"1231.flt"), crs=sCrs)
  r2<-raster(paste0(pt.dir,y2,"0101_",y2,"1231.FWPT.run26h.flt/AWAP/Run26h/FWPT/mth_FWPT_",y2,"0131.flt"), crs=sCrs)
  f_r3<-list.files(path=paste0(pt.dir,y2,"0101_",y2,"1231.FWPT.run26h.flt/AWAP/Run26h/FWPT/"),pattern=paste0("^mth_FWPT_",y2,"02.+[.]flt$"), full.names = T)
  r3<-raster(f_r3, crs=sCrs)
  r4<-raster(paste0(pt.dir,y2,"0101_",y2,"1231.FWPT.run26h.flt/AWAP/Run26h/FWPT/mth_FWPT_",y2,"0331.flt"), crs=sCrs)
  
  #get lat and long
  xy<-subset(observation,select=c("X","Y"))
  
  #get the value at the cell location
  
  observation$FWPT_1<-extract(r1,xy)
  observation$FWPT_2<-extract(r2,xy)
  observation$FWPT_3<-extract(r3,xy)
  observation$FWPT_4<-extract(r4,xy)
  
  #add it to the list
  
  obs2[[i]]<-observation
  
}

#add to obs dataframe

obs3<-do.call("rbind",obs2)
obs4<-merge(obs)
  