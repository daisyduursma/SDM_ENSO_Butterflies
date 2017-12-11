
rm(list = ls())
gc()

#library to make biovlim variables
library(dismo)
#location of data
data.dir<-"D:\\Current_Projects\\ENSO\\Raw Data\\"

#make loop of files
sp_name<-c("butterfly_observation","butterfly_background")

for (i in 1:length(sp_name)){

	#read in observation file
	obs<-read.csv(paste(data.dir,sp_name[i],"_NETCDF_extraction.csv",sep=""))
		
	#make empty dataframe
	dat2<-NULL

		#start loop to calculate biovars for each row
	for(ii in 1:nrow(obs)){
		
		dat<-obs[ii,]
		#get the measurments for a single row
		prec<-as.numeric(dat[,c("pre_1","pre_2","pre_3","pre_4")])
		tmin<-as.numeric(dat[,c("tmin_1","tmin_2","tmin_3","tmin_4")])
		tmax<-as.numeric(dat[,c("tmax_1","tmax_2","tmax_3","tmax_4")])
		#run the biovars function
		bv<-biovars(prec, tmin, tmax)
		#add rows to the observation data for the biovars
		dat_bv<-cbind(dat,bv)
		#merge the rows to make a dataframe
		dat2<-rbind(dat2,dat_bv)
	}
  
write.csv(dat2,paste(data.dir,sp_name[i],"_biovars_Dec_March.csv",sep=""))
}
  