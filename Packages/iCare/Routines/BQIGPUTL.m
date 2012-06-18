BQIGPUTL ;PRXM/HC/ALA - GPRA Utilities ; 10 Feb 2006  5:11 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
SUM(BQIGYR,BQIND) ;EP -- Is indicator a summary indicator?
 ;
 ;Input
 ;  BQIGYR = GPRA Year
 ;  BQIND = Internal entry number of GPRA individual indicator
 ;  Only valid for CRS versions less than 8.0
 ;
 NEW BQIH,BQIY
 S BQIH=$$SPM() I BQIH=-1 Q 0
 S BQIY=$$LKP(BQIGYR) I BQIY=-1 Q 0
 I '$D(^BQI(90508,BQIH,20,BQIY,20,"B",BQIND)) Q 0
 Q 1
 ;
SPM() ;EP -- Get site parameter entry
 NEW DIC,X,Y,BGPHOME,BHM
 I $G(U)="" D DT^DICRW
 S BGPHOME=$$HME()
 ;
 S X=$$GET1^DIQ(4,BGPHOME,.01,"E"),DIC(0)="XZ",DIC="^BQI(90508,"
 D ^DIC
 I Y=-1 S ^BQI(90508,1,0)=BGPHOME,^BQI(90508,"B",BGPHOME,1)="",Y=1
 Q +Y
 ;
LKP(BQIGYR) ;EP -- Lookup CRS year in the parameter file
 NEW X,DA,DIC,Y
 ;
 ; Check to see if BQIH has already been defined, if not, define it
 I $G(BQIH)="" S BQIH=$$SPM()
 S X=BQIGYR,DA(1)=BQIH,DIC(0)="XZ",DIC="^BQI(90508,"_DA(1)_",20,"
 D ^DIC
 Q +Y
 ;
GFN(BQIHH,BQIYY) ;EP - Get GPRA global reference
 ;
 ;Input
 ;  BQIHH - Site parameter internal entry number
 ;  BQIYY - GPRA Year
 ;Output
 ;  BQIINDF  - FileMan file number for Indicators
 ;  BQIMEASF - FileMan file number of Individual Indicators
 ;
 NEW DA,IENS
 S DA(1)=BQIHH,DA=BQIYY
 S IENS=$$IENS^DILF(.DA)
 S BQIINDF=$$GET1^DIQ(90508.01,IENS,.02,"E")
 S BQIMEASF=$$GET1^DIQ(90508.01,IENS,.03,"E")
 Q
 ;
HME() ;EP - Get Home Site
 NEW BHM,BHOME
 I $G(U)="" D DT^DICRW
 S BHM=$O(^BQI(90508,0))
 I BHM'="" S BHOME=$P($G(^BQI(90508,BHM,0)),U,1)
 I $G(BHOME)="" S BHOME=$P($G(^XTV(8989.3,1,"XUS")),U,17)
 ;S BHM=$O(^BGPSITE(0)) I BHM'="" S BHOME=$P($G(^BGPSITE(BHM,0)),U,1)
 Q $G(BHOME)
