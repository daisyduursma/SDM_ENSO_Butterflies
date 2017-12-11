#get monthly data for tmin,tmax,and precip for previous year

rm(list = ls())
gc()
#library to work with ncdg
library(ncdf)
# this library is just to plot the result
library(fields)
#library to make biovlim variables
library(dismo)
#library to work with rasters
library(raster)
#library used to rename columns
library(reshape)


data.dir<-"D:\\Current_Projects\\ENSO\\Raw Data\\"
# Write the path to the netcdf file
netcdf.dir <- paste(data.dir)
#variables in netcdf names
clim<-c("pre","tmin","tmax")
#make a dataframe showing years and the netcdf files associated,}
#file_name for 1950 is also _0000.nc since we want previous uears data,
##this is the same for 2000
year_id <- data.frame(year=rep(1900:2010,each=12),month=rep(1:12,111),
nc_layer=c(rep(1:600,2),1:132),file_name=c(rep("_0000.nc",50*12),rep("_0600.nc",50*12),rep("_1200.nc",11*12)),year_id=1:1332)
#make unique identifier
year_id$mo_yr<-paste(year_id$month,year_id$year)
#data

obs<-read.csv(paste(data.dir,"XY_butterfly_obs.csv",sep=""),header=TRUE)
bgd<-read.csv(paste(data.dir,"XY_butterfly_background.csv",sep=""),header=TRUE)


############for obs to turn into loop
#remove data from 1911
dat<-subset(bgd,ob_year>1911)
dat<-subset(bgd,ob_year<2011)

#add in details for start data so always starts in December

dat$mo_yr<-paste(12,dat$Data_from)
obs_detail<-merge(dat,year_id, by.y ="mo_yr" ,all.x =TRUE)

#make empty dataframe
obs2<-NULL
for(i in 1:nrow(obs_detail)){
#single row of data
observation<-obs_detail[i,]
y_id<-observation$year_id

#f_name<-obs$file_name
#layer in nc file for that month/year
#nc_layer<-obs$nc_layer
#layers for monthly data 1 year previous, not including the month of observation

#get the details fro the netcdfs 

#in output file tmin_1 would be the min temp from 13 months prior to the observations and tmin_12 would the the min temp the month before the observations
start_layer<-y_id
end_layer<-y_id+3
sub_year_id<-year_id[start_layer:end_layer,]

o_lat<-observation$Y
o_long<-observation$X



for (sid in 1:nrow(sub_year_id)){
needed_layer<-as.vector(sub_year_id$nc_layer)
for(ii in 1:length(clim)){

f_name<-sub_year_id[sid,]$file_name

nc = open.ncdf(paste(netcdf.dir,clim[ii],f_name,sep=""),readunlim=FALSE)


lat<-(nc$dim[[2]])[7]$vals
maxlat<-max(lat)
minlat<-min(lat)
long<-(nc$dim[[3]])[7]$vals
maxlong<-max(long)
minlong<-min(long)


#write out raster of m1_b

#for (nl in 1:length(needed_layers)){

#get the layer from the netcdf
m1<- get.var.ncdf( nc, clim[ii], start=c(1,1,needed_layer[sid]),count=c(813,670,1) )
#rotate the layer 90 degrees counter clockwise
m1_b<-apply(t(m1),2,rev)

#write out raster of m1_b
m1_c<-raster(m1_b, xmn=minlong-.025, xmx=maxlong+.025,ymn=minlat-0.025, ymx=maxlat+0.025, crs="+proj=longlat +datum=WGS84")
#writeRaster(m1_c,filename=paste(data.dir,"test.data\\",clim[ii],"_",f_name,"_",needed_layers[nl],".asc",sep=""),overwrite=TRUE)

#xy location
xy<-subset(observation,select=c("X","Y"))


#get the value at the cell location

v1<-extract(m1_c,xy)
#write the value to the obs file
observation$temp_name<-v1
#replace temp_name with real name
observation<-rename(observation,c(temp_name=paste(clim[ii],"_",sid,sep="")))
close.ncdf(nc)

}

}

obs2<-rbind(obs2,observation)
}

write.csv(obs2,paste(data.dir,"butterfly_background_NETCDF_extraction.csv",sep=""))
