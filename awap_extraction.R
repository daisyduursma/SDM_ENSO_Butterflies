library(raster)
library(ncdf)
sCrs<-"+proj=longlat +datum=WGS84"
FWE.path="C:/AWAP-SPATIAL/26h/unpacked/FWE/"
FWPT.path="C:/AWAP-SPATIAL/26h/unpacked/FWPT/"
k=2000
for (k in 2000:2011){
  sPat<-glob2rx(paste("mth_*_",k,"*.flt",sep=""))
  FWE.Files<-list.files(path = FWE.path, 
                      pattern = sPat , 
                      all.files = T, 
                      full.names = T, 
                      recursive = F)
  FWPT.Files<-list.files(path = FWPT.path, 
                        pattern = sPat , 
                        all.files = T, 
                        full.names = T, 
                        recursive = F)
  i=1
  for (i in 1:12){
    r.FWE<-raster(FWE.Files[i], crs=sCrs)
    r.FWPT<-raster(FWPT.Files[i], crs=sCrs)
    r.alpha=r.FWE/r.FWPT
    writeRaster(r.alpha, paste("C:/AWAP-SPATIAL/26h/alpha-ncdf/",k,"_",i,"_alpha.nc", sep=""), crs=sCrs, type="CDF")
  }
}
