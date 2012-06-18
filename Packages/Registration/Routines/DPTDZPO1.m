DPTDZPO1 ; IHS/TUCSON/JCM - PRE-MERGE INIT FOR PATIENT MERGE ; [ 09/10/2001  11:43 AM ]
 ;;1.0;PATIENT MERGE;;FEB 02, 1994
 ;IHS/ANMC/LJF 9/10/2001 made temp fix so HS/FS prints to TO pat
 ;
 ; This routine is part of the post merge action that occurs it is
 ; responsible for the printing of the health summary and the
 ; face sheet for the newly merged to patient.
 ;
 ; Input variables: XDRMRG("TO")
 ;
 ; Calls: START^AGFACE,EN^APCHS
 ; Called by: DPTDZPO
 ;--------------------------------------------------------------------
 ;
START ;   
 K DPTDZPO1
 S DPTDZPO1("QFLG")=0
 S DPTDZPO1("DFN")=$S($D(DFN):DFN,1:"")
 D ASK G:DPTDZPO1("QFLG") END
 S DPTDZPO1("PAT")=XDRMRG("TO")
 D DEVICE G:DPTDZPO1("QFLG") END
 D:$D(DPTDZPO1("PCC")) HEALTH
 D FACE K AGOPT
END D EOJ
 Q
 ;
ASK ;
 K DIR
 S DIR(0)="YO",DIR("B")="Y",DIR("A")="Do you wish to print a face sheet"
 I $P(^AUTTSITE(1,0),U,8)="Y" S DIR("A")=DIR("A")_" and health summary" S DPTDZPO1("PCC")=""
 D ^DIR K DIR
 I $D(DUOUT)!($D(DTOUT)) S DPTDZPO1("QFLG")=1 G ASKX
 I 'Y S DPTDZPO1("QFLG")=1 G ASKX
 I $D(DPTDZPO1("PCC")) K DIC,Y S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQ" D
 .;S XX=$S($D(^APCHSCTL("B","PATIENT MERGE (COMPLETE)")):"PATIENT MERGE (COMPLETE)",1:"ADULT REGULAR"),DIC("B")=X D ^DIC S:Y>0 DPTDZPO1("TYPE")=+Y S:Y'>0 DPTDZPO1("QFLG")=1 K DIC  ;IHS/ANMC/LJF 9/10/2001
 .S X=$S($D(^APCHSCTL("B","PATIENT MERGE (COMPLETE)")):"PATIENT MERGE (COMPLETE)",1:"ADULT REGULAR"),DIC("B")=X D ^DIC S:Y>0 DPTDZPO1("TYPE")=+Y S:Y'>0 DPTDZPO1("QFLG")=1 K DIC  ;IHS/ANMC/LJF 9/10/2001
ASKX K Y
 Q
 ;
DEVICE ;
 ;S:$D(DPTDZPO1("DEVICE")) IOP=DPTDZPO1("DEVICE")  ;IHS/ANMC/LJF 9/10/2001
 S %ZIS(0)="MP" D ^%ZIS
 I POP S DPTDZPO1("QFLG")=1 G DEVICEX
 S DPTDZPO1("DEVICE")=$P(IO,";")_";"_IOST_";"_IOM_";"_IOSL
DEVICEX K %ZIS,POP
 Q
 ;
HEALTH ;
 I $D(^%ZOSF("XY"))#2 S (DX,DY)=0 X ^("XY") K DX,DY
 K APCHSPAT,APCHSTYP
 S APCHSPAT=DPTDZPO1("PAT"),APCHSTYP=DPTDZPO1("TYPE")
 D EN^APCHS
 Q
 ;
FACE ;
 I $D(^%ZOSF("XY"))#2 S (DX,DY)=0 X ^("XY") K DX,DY
 S DFN=DPTDZPO1("PAT")
 D START^AGFACE K AGOPT
 Q
 ;
EOJ ;
 K:'DPTDZPO1("DFN") DFN S:DPTDZPO1("DFN") DFN=DPTDZPO1("DFN")
 K DPTDZPO1
 Q
