AZAXCADU ;IHS/PHXAO/AEF - CAD/STATIN STUDY DATA EXTRACT UTILITY SUBROUTINES
 ;;1.0;ANNE'S SPECIAL ROUTINES;;MAR 23, 2004
 ;
DESC ;---- PROGRAM DESCRIPTION
 ;;
 ;;      This routine contains utility subroutines used by the
 ;;      AZAXCAD CAD/STATIN STUDY DATA EXTRACT routine.
 ;; 
 ;;$$END
 ;
 Q
 ;
AGE(X) ;
 ;----- RETURN PATIENT'S AGE
 ;
 ;      X  =  PATIENT IEN
 ;
 N X1,X2,Y
 S Y=""
 I $G(X) D
 . S X2=$P($G(^DPT(X,0)),U,3)
 . I X2 D
 . . S X1=DT
 . . D ^%DTC
 . . S Y=X\365.25
 Q Y
 ;
DRUG(X) ;
 ;----- RETURN DRUG NAME
 ;
 ;      X  =  DRUG IEN
 ;    
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^PSDRUG(X,0)),U)
 Q Y
 ;
FNAME(X) ;
 ;----- RETURN FILE NAME
 ;
 ;      X  =  DATA TYPE, I.E., DRUGS OR ICDS
 ;
 N Y
 S Y=""
 I $G(X)]"" D
 . S Y="AZAX"_X_$$SITE_".TXT"    
 Q Y
FORMAT(X) ;
 ;----- FORMAT "^" DELIMITED DATA STRING INTO COMMA DELIMITED STRING
 ;
 ;      INPUT:
 ;      X  =  DATA STRING IN "^" DELIMITED FIELD FORMAT,
 ;            I.E., FIELD1^FIELD2^FIELD3^FIELD4
 ;            
 ;      OUTPUT:
 ;      Y  =  DATA STRING IN QUOTED DATA/COMMA DELIMITED FORMAT,
 ;            I.E., "FIELD1","FIELD2","FIELD3","FIELD4" 
 ;             
 N I,Y,Z
 S Y=""
 I $G(X)]"" D
 . F I=1:1:$L(X,U) D
 . . S Z=$P(X,U,I)
 . . S Y=Y_""""_Z_""""_","
 . S Y=$E(Y,1,$L(Y)-1)
 Q Y
 ;
HFS(AZAXPATH,AZAXFILE,%FILE,AZAXOUT) ;
 ;----- CREATE AND OPEN DATA FILE
 ;
 ;      INPUT:
 ;      AZAXFILE  =  THE FILENAME TO CREATE AND OPEN
 ;      AZAXPATH  =  THE UNIX OR WINDOWS DIRECTORY PATH NAME TO PUT THE FILE
 ;
 ;      OUTPUT:
 ;      %FILE     =  DEVICE NUMBER OF THE FILE
 ;      AZAXOUT   =  QUIT INDICATOR
 ;      
 N POP,X,Y,ZISH1,ZISH2,ZISH3,ZISH4
 ;
 S %FILE=""
 S AZAXOUT=0
 S ZISH1="FILE"
 S ZISH2=AZAXPATH
 S ZISH3=AZAXFILE
 S ZISH4="W"
 ;
 D OPEN^%ZISH(ZISH1,ZISH2,ZISH3,ZISH4)
 ;
 I POP D  Q
 . W "CANNOT OPEN FILE "_ZISH2_ZISH3
 . S AZAXOUT=1
 S %FILE=IO
 Q
ICD(X) ;
 ;----- RESOLVE ICD DX CODE POINTER
 ;
 ;      X  =  INTERNAL ICD DIAGNOSIS CODE
 ;
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^ICD9(X,0)),U)
 Q Y
 ;
LOC(X) ;
 ;----- RETURN LOCATION OF ENCOUNTER FROM VISIT FILE
 ;
 ;      X  =  VISIT IEN
 ;
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^AUPNVSIT(X,0)),U,6)
 Q Y
 ;
LOCN(X) ;
 ;----- RETURN LOCATION NAME
 ;
 ;      X  =  LOCATION IEN
 ;
 N Y
 S Y=""
 I $G(X) D 
 . S Y=$P($G(^AUTTLOC(X,0)),U)
 . I Y S Y=$P($G(^DIC(4,Y,0)),U)      
 Q Y
 ;
LOCP(X) ;
 ;----- RETURN LOCATION OF ENCOUNTER FROM INSIDE PRESCRIPTION FILE
 ;
 ;      X  =  PRESCRIPTION IEN
 ;      
 N Y,Z
 S Y=""
 I $G(X) D
 . S Z=$P($G(^PSRX(X,999999911)),U)
 . I Z S Y=$$LOCVM(Z)
 Q Y
 ;
LOCR(D0,D1) ;
 ;----- RETURN LOCATION OF ENCOUNTER FROM INSIDE REFILL SUBFILE OF 
 ;      PRESCRIPTION FILE
 ;      
 ;      D0  =  PRESCRIPTION IEN
 ;      D1  =  REFILL IEN
 ;  
 N Y
 S Y=""
 I $G(D0),$G(D1) D
 . S Z=$P($G(^PSRX(D0,1,D1,999999911)),U)
 . I Z S Y=$$LOCVM(Z)
 Q Y
 ;
LOCVM(X) ;
 ;----- RETURN LOCATION OF ENCOUNTER FROM INSIDE V MEDICATION FILE
 ;
 ;      X  =  V MEDICATION IEN
 ;      
 N Y,Z
 S Y=""
 I $G(X) D
 . S Z=$P($G(^AUPNVMED(X,0)),U,3)
 . I Z S Y=$P($G(^AUPNVSIT(Z,0)),U,6)
 Q Y
 ;
NDC(X) ;
 ;----- RETURN NDC CODE
 ;
 ;      X  =  DRUG IEN
 ;  
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^PSDRUG(X,2)),U,4)    
 Q Y
PATH(X) ;
 ;
 ;      X  =  RPMS SITE IEN
 ;
 N Y
 S Y=""
 ;
 I $G(X) D
 . ;I X=2906 S Y="C:\inetpub\ftproot\pub\"  ;PARKER ON phxed
 . I X=3018 S Y="E:\pub\"                  ;WHITERIVER
 . I X=2898 S Y="c:\inetpub\ftproot\pub\"  ;ELKO
 . I X=2869 S Y="c:\inetpub\ftproot\pub\"  ;FT DUCHESNE
 . I X=3050 S Y="d:\pub\"                  ;FT YUMA
 . I X=2872 S Y="/usr/spool/uucppublic/"   ;HOPI
 . I X=7150 S Y="d:\pub\"                  ;OWYHEE
 . I X=2906 S Y="/usr/spool/uucppublic/"   ;PARKER
 . I X=2955 S Y="/usr/spool/uucppublic/"   ;SACATON (IHS)
 . I X=6283 S Y="/usr/spool/uucppublic/"   ;SACATON (638)
 . I X=2967 S Y="d:\pub\"                  ;SAN CARLOS (IHS)
 . I X=6622 S Y="d:\pub\"                  ;SAN CARLOS (638)
 . I X=3000 S Y="/usr/spool/uucppublic/"   ;SCHURZ
 . I X=5621 S Y="/usr/spool/uucppublic/"   ;SCHURZ (WALKER RIVER)
 . I X=3018 S Y="e:\pub\"                  ;WHITERIVER
 . I X=6600 S Y="c:\inetpub\ftproot\pub\"  ;CEDAR CITY (FT DUCHESNE)
 . I X=3245 S Y="/usr/spool/uucppublic/"   ;WASHOE (SCHURZ)
 . I X=3246 S Y="/usr/spool/uucppublic/"   ;RENO/SPARKS (SCHURZ)
 . I X=3008 S Y="/usr/spool/uucppublic/"   ;FALLON (SCHURZ)
 . I X=2917 S Y="d:\pub\"                  ;PIMC
 ;
 Q Y
 ;
PICD(X) ;
 ;----- RESOLVE ICD PROCEDURE CODE POINTER
 ;
 ;      X  =  INTERNAL ICD PROCEDURE CODE
 ;    
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^ICD0(X,0)),U)
 Q Y
 ;
SCAT(X) ;
 ;----- RETURN EXTERNAL SERVICE CATEGORY
 ;
 ;      X  =  INTERNAL SERVICE CATETORY
 ;      
 N Y,Z
 S Y=""
 I $G(X)]"" D
 . S Z=$P($G(^DD(9000010,.07,0)),U,3)
 . S Z=$P(Z,X_":",2)
 . S Z=$P(Z,";")
 . S Y=Z
 Q Y
 ;
SCATP(X) ;
 ;----- RETURN EXTERNAL SERVICE CATEGORY FROM INSIDE PRESCRIPTION FILE
 ;
 ;      X  =  PRESCRIPTION IEN
 ;
 N Y,Z
 S Y=""
 I $G(X) D
 . S Z=$P($G(^PSRX(X,999999911)),U)
 . I Z S Y=$$SCATVM(Z)
 Q Y
 ;
SCATR(D0,D1) ;
 ;----- RETURN EXERNAL SERVICE CATEGORY FROM INSIDE REFILL SUBFILE OF 
 ;      PRESCRIPTION FILE
 ;      
 ;      D0  =  PRESCRIPTION IEN
 ;      D1  =  REFILL IEN
 ;      
 N Y,Z
 S Y=""
 I $G(D0),$G(D1) D
 . S Z=$P($G(^PSRX(D0,1,D1,999999911)),U)
 . I Z S Y=$$SCATVM(Z)        
 Q Y
 ; 
SCATV(X) ;
 ;----- RETURN SERVICE CATEGORY FROM INSIDE VISIT FILE
 ;
 ;      X  =  VISIT IEN
 ;      
 S Y=""
 I $G(X) S Y=$P($G(^AUPNVSIT(X,0)),U,7)
 Q Y
 ;    
SCATVM(X) ;
 ;----- RETURN EXTERNAL SERVICE CATEGORY FROM INSIDE V MEDICATION FILE
 ;
 ;      X  =  V MEDICATION FILE IEN
 ;
 N Y,Z
 S Y=""
 I $G(X) D
 . S Z=$P($G(^AUPNVMED(X,0)),U,3)
 . I Z S Z=$P($G(^AUPNVSIT(Z,0)),U,7)
 . I Z]"" S Z=$$SCAT(Z)
 . I Z]"" S Y=Z
 Q Z
 ;
SEX(X) ;
 ;----- RETURN PATIENT'S SEX
 ;
 ;      X  =  PATIENT IEN
 ;
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^DPT(X,0)),U,2)
 Q Y
 ;
SITE() ;
 ;----- RETURNS LOCATION IEN
 ;
 Q $P($G(^AUTTSITE(1,0)),U)
 ;
SLDATE(X) ;
 ;----- RETURNS DATE IN MM/DD/YYYY FORMAT
 ;
 ;      X  =  INTERNAL FILEMANAGER DATE IN YYYMMDD FORMAT
 ;
 N Y
 S Y=""
 I $G(X) D
 . Q:$L(X)'=7
 . S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 Q Y
 ;   
UID(X) ;
 ;----- CALCULATE UNIQUE PATIENT ID USING LOCATION IEN AND DFN
 ;      Returns a 13 digit unique patient ID where:
 ;      1st digit   = 1 (so that number never starts with zero)
 ;      2-5 digits  = 4 character location IEN (padded with zeros)
 ;      6-13 digits = 8 character DFN (padded with zeros)
 ;
 ;      INPUT:
 ;      X  =  DFN (PATIENT IEN)
 ;
 N S,Y
 S Y=""
 I $G(X) D
 . S X=$E("00000000",1,8-$L(X))_X
 . S S=$$SITE
 . S S=$E("0000",1,4-$L(S))_S
 . S Y=1_S_X
 Q Y
 ;
VISDT(X) ;
 ;----- RETURN VISIT DATE
 ;
 ;      X  =  VISIT IEN
 ;
 N Y
 S Y=""
 I $G(X) S Y=$P($G(^AUPNVSIT(X,0)),U)
 Q Y
