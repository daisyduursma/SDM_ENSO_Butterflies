
#make sure workspace is clean
	rm(list = ls())
#load library 


#.libPaths("/data1/dduursma/R/x86_64-redhat-linux-gnu-library/")
#install.packages("dismo")


	library(dismo)
#get directories where data located
	work.dir<-"C:\\Daisy\\Current_Projects\\exotic_plants\\enso"
	out.dir<-paste(work.dir,"outputs\\",sep="")
  dir.create(out.dir)
  options(java.parameters = "-Xmx1g" )
  #read in observation SWD file
	sp_dat<- read.table(paste(work.dir,"data/", "observations_05_11_12_8km_grid_all_worldclimvar_sub_eur_usa.csv", sep=""),header=TRUE, sep=",")
  all_background<-read.table(paste(work.dir,"data/","RK_background_10000_05_11_12_8km_grid.csv", sep=""),header=TRUE, sep=",")
 #make list of species
species <-as.vector(unique(sp_dat$species))
#for each species
for (i in 176:200){
	#get occurance points for one speci<-ies
		remove_dat<-sp_dat$species==species[i]
		occurence<-sp_dat[remove_dat,]
		occurence$p<-rep(1,nrow(occurence))
	#background points
		remove_dat<-all_background$species==species[i]
		background<-all_background[remove_dat,]
		background$p<-rep(0,nrow(background))
# 		background<-background[sample(nrow(background), 10000), ]
	#bind the dat so it is in form needed by maxent
		env_dat<-rbind(background,occurence)
	#list of environmental variables
		ev<-env_dat[,c("bioclim_01","bioclim_05","bioclim_06","bioclim_12","bioclim_15","clay_5min2")]
		#list of 0 and 1 values to show if species is present or absent at location
		pres<-as.vector(env_dat[,"p"])
	#SEND TO MAXENT	
	#path to write out files
		new.out.dir<-(paste(out.dir,species[i],"_final2",sep=""))
	#maxent runs
	 maxent(x=ev,p=pres,path=paste(new.out.dir),args=c("-d","-x","-r","betamultiplier=1","nohinge","nothreshold","replicates=10","randomseed","projectionlayers=C://Daisy//Raw Data//van_der_Wal_data//current,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_ccsr-miroc32med_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_ccsr-miroc32med_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_csiro-mk30_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_csiro-mk30_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_gfdl-cm20_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_gfdl-cm20_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_mpi-echam5_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_mpi-echam5_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_ukmo-hadcm3_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_ukmo-hadcm3_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_ukmo-hadgem1_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_ukmo-hadgem1_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_ccsr-miroc32med_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_ccsr-miroc32med_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_csiro-mk30_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_csiro-mk30_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_gfdl-cm20_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_gfdl-cm20_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_mpi-echam5_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_mpi-echam5_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_ukmo-hadcm3_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_ukmo-hadcm3_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_ukmo-hadgem1_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_ukmo-hadgem1_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_mri-cgcm232a_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP85_mri-cgcm232a_2065,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_mri-cgcm232a_2035,C://Daisy//Raw Data//van_der_Wal_data_future//RCP45_mri-cgcm232a_2065"))
    
    
    
		min_files<-list.files(paste(new.out.dir),pattern="_min.asc",full.names = TRUE)
		max_files<-list.files(paste(new.out.dir),pattern="_max.asc",full.names = TRUE)
		med_files<-list.files(paste(new.out.dir),pattern="_median.asc",full.names = TRUE)
		st_files<-list.files(paste(new.out.dir),pattern="_stddev.asc",full.names = TRUE)
		zz2<-list.files(paste(new.out.dir),pattern="_stdev.csv",full.names = TRUE)
		zz3<-list.files(paste(new.out.dir),pattern="_max.csv",full.names = TRUE)
		zz4<-list.files(paste(new.out.dir),pattern="_median.csv",full.names = TRUE)
		zz5<-list.files(paste(new.out.dir),pattern="_min.csv",full.names = TRUE)
		file.remove(zz2)
		file.remove(zz3)
		file.remove(zz4)
		file.remove(zz5)
		file.remove(st_files)
		file.remove(min_files)
		file.remove(max_files)
		file.remove(med_files)
    
    
message(i)
    
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
#   
#   
#   
#   
# 
#   #threshold maps
#   asc_names<-c("current",paste(list.files("/data2/home/dduursma/exotic_plants/data/future_climate")))
#   
#   for(i in 1:length(asc_names)){}
#   
# 	species_RCP45_ncar-ccsm30_2035.asc
#   
#    		avg_r<-paste(new.out.dir,"species_",asc_names,".asc",sep="")
# 	#get file with maxent results(
#     dat1<-read.csv(paste(new.out.dir,"/maxentResults.csv",sep=""),row.names=1)
# 		sp_avg<-raster(paste(avg_r))
#     
#                         thresh5<-dat1["species (average)","Fixed.cumulative.value.5.logistic.threshold"]   
#                     		fun <- function(x) { x[x<thresh5] <- 0; return(x) }
#                     		rc2 <- calc(sp_avg, fun)
#                     		fun <- function(x) { x[x>=thresh5] <- 1; return(x) }
#                     		rc3 <- calc(rc2, fun)
#                     		writeRaster(rc3,filename=paste(new.out.dir,species[i],"_current_threshold_sub_Europe_cumulative_5.asc",sep=""),overwrite=TRUE,NAflag=-9999)
#   
#   
# 	for(i in 99:150){
# 	  new.out.dir<-(paste(out.dir,species[i],"_final",sep=""))
# 		min_files<-list.files(paste(new.out.dir),pattern="_min.asc",full.names = TRUE)
# 		max_files<-list.files(paste(new.out.dir),pattern="_max.asc",full.names = TRUE)
# 		med_files<-list.files(paste(new.out.dir),pattern="_median.asc",full.names = TRUE)
# 		zz1<-list.files(paste(new.out.dir),pattern="_avg.csv",full.names = TRUE)
# 		zz2<-list.files(paste(new.out.dir),pattern="_stdev.csv",full.names = TRUE)
# 		zz3<-list.files(paste(new.out.dir),pattern="_max.csv",full.names = TRUE)
# 		zz4<-list.files(paste(new.out.dir),pattern="_median.csv",full.names = TRUE)
# 		zz5<-list.files(paste(new.out.dir),pattern="_min.csv",full.names = TRUE)
# 		file.remove(zz5)
# 	
# 		file.remove(min_files)
# 		file.remove(max_files)
# 		file.remove(med_files)
# 	file.remove(zz1)
# file.remove(zz2)
# 	file.remove(zz3)
# file.remove(zz4)
# 		
# 	message(i)	
# 		
# 		}
# 		
# 		
	







