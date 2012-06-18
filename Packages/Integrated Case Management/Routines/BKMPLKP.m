BKMPLKP ;PRXM/HC/ALA - Patient Lookup ; 19 Jul 2005  12:32 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;** Program Description **
 ;  This program contains a registry patient lookup as well as
 ;  a standard patient lookup
 ;
 Q
 ;
RLK(SCREEN) ;  EP - Registry Lookup
 K DFN,BKMRIEN,PTNAME,SEX,SSN,DOB,AUPNDOB,AGE,AUPNDOD,AUPNPAT,AUPNDAYS,AUPNSEX
 ;  Input Variable
 ;    SCREEN - any DIC("S") screen value
 ;
 ;  Output variables returned if patient selected
 ;    BKMRIEN - Registry IEN
 ;    DFN - Patient IEN
 ;    PTNAME - Patient Name
 ;    SEX - Patient Sex
 ;    SSN - Patient SSN
 ;    DOB - Patient Date of Birth
 ;    AUPNDOB - Patient Date of Birth
 ;    AGE - Patient Age
 ;    AUPNDOD - Patient Date of Death
 ;    AUPNPAT - Patient IEN
 ;    AUPNDAYS - Patient Age in # of Days
 ;
 NEW Y,X,DIC
 I $G(SCREEN)'="" S DIC("S")=SCREEN
 S DIC("A")="Registry Patient Name (HRN, DOB, SSN): ",DIC(0)="AEMQZ",DIC="^BKM(90451," D ^DIC
 I Y=-1 K SCREEN Q
 ;S DFN=+Y,BKMRIEN=$O(^BKM(90451,"B",DFN,"")),PTNAME=$P(^DPT(DFN,0),U,1)
 S BKMRIEN=+Y,DFN=$P(^BKM(90451,BKMRIEN,0),U,1),PTNAME=$P(^DPT(DFN,0),U,1)
 K SCREEN
 I $G(AUPNSEX)="" S Y=DFN D ^AUPNPAT K Y
 Q
 ;
PLK ;  EP - Patient Lookup
 K DFN,PTNAME,SEX,SSN,DOB,AUPNDOB,AGE,AUPNDOD,AUPNPAT,AUPNDAYS
 ;
 ;  Output variables returned if patient selected
 ;    DFN - Patient IEN
 ;    SEX - Patient Sex
 ;    SSN - Patient SSN
 ;    DOB - Patient Date of Birth
 ;    AUPNDOB - Patient Date of Birth
 ;    AGE - Patient Age
 ;    AUPNDOD - Patient Date of Death
 ;    AUPNPAT - Patient IEN
 ;    AUPNSEX - Patient Sex
 ;    AUPNDAYS - Patient Age in # of Days
 ;    PTNAME - Patient name
 ;
 NEW Y,X,DIC,DO
 ; PRX/HMS/DLS 3/30/2006 Added prompt to include HRN,DOB,SSN.
 S DIC("A")="Select Patient Name (HRN, DOB, SSN):"
 S DIC="^AUPNPAT(",DIC(0)="AEMQZ" D ^DIC
 S PTNAME=$G(Y(0,0))
 Q
 ;
PLKN(NDFN) ;  Non-interactive Patient Lookup
 ;
 ;  Input Parameter
 ;    NDFN - Patient IEN
 ;
 ;  Output Parameters
 ;    See list in PLK
 ;
 I $G(NDFN)="" Q
 NEW Y,X,DIC,DO
 S DIC="^AUPNPAT(",DIC(0)="MNQZ",X=NDFN D ^DIC
 K NDFN
 Q
