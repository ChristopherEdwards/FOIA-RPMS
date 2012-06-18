DPTDZPRE ; IHS/TUCSON/JCM - PRE-MERGE INIT FOR PATIENT MERGE ; [ 09/10/2001  11:01 AM ]
 ;;1.0;PATIENT MERGE;;FEB 02, 1994
 ;IHS/ANMC/LJF 9/10/2001 made temp fix so HS and FS prints for TO pt
 ;
 ; The purpose of this routine is to do any pre-merge processing that
 ; needs to occur prior to the actual merging.  At the present time
 ; the only thing that is occuring is the printing of the health
 ; summary and the face sheet.
 ;
 ; Input variables: XDRMRG("FR"),XDRMRG("TO")
 ;
 ; Calls: START^AGFACE,EN^APCHS
 ; Called by: XDRMRG
 ;--------------------------------------------------------------------
 ;
START ;   
 D CHECK
 Q:$D(XDRM("AUTO"))
 K DPTDZPRE
 S DPTDZPRE("QFLG")=0
 S DPTDZPRE("DFN")=$S($D(DFN):DFN,1:"")
 D ASK G:DPTDZPRE("QFLG") END
 S DPTDZPRE("FR")=XDRMRG("FR"),DPTDZPRE("TO")=XDRMRG("TO")
 D DEVICE G:DPTDZPRE("QFLG") END
 F DPTDZPRE=DPTDZPRE("FR"),DPTDZPRE("TO") S DPTDZPRE("PAT")=DPTDZPRE D:$D(DPTDZPRE("PCC")) HEALTH D FACE K AGOPT D:DPTDZPRE("PAT")'=DPTDZPRE("TO") DEVICE
END D EOJ
 Q
 ;
ASK ;
 K DIR
 S DIR(0)="YO",DIR("B")="Y",DIR("A")="Do you wish to print a face sheet"
 I $P(^AUTTSITE(1,0),U,8)="Y" S DIR("A")=DIR("A")_" and health summary" S DPTDZPRE("PCC")=""
 D ^DIR K DIR
 I $D(DUOUT)!($D(DTOUT)) S DPTDZPRE("QFLG")=1 G ASKX
 I 'Y S DPTDZPRE("QFLG")=1 G ASKX
 I $D(DPTDZPRE("PCC")) K DIC,Y S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQ" D
 .S X=$S($D(^APCHSCTL("B","PATIENT MERGE (COMPLETE)")):"PATIENT MERGE (COMPLETE)",1:"ADULT REGULAR"),DIC("B")=X D ^DIC S:Y>0 DPTDZPRE("TYPE")=+Y S:Y'>0 DPTDZPRE("QFLG")=1 K DIC
ASKX K Y
 Q
 ;
DEVICE ;
 ;S:$D(DPTDZPRE("DEVICE")) IOP=DPTDZPRE("DEVICE")  ;IHS/ANMC/LJF 9/10/2001
 S %ZIS(0)="MP" D ^%ZIS
 I POP S DPTDZPRE("QFLG")=1 G DEVICEX
 S DPTDZPRE("DEVICE")=$P(IO,";")_";"_IOST_";"_IOM_";"_IOSL
DEVICEX K %ZIS,POP
 Q
 ;
HEALTH ;
 I $D(^%ZOSF("XY"))#2 S (DX,DY)=0 X ^("XY") K DX,DY
 K APCHSPAT,APCHSTYP
 S APCHSPAT=DPTDZPRE("PAT"),APCHSTYP=DPTDZPRE("TYPE")
 D EN^APCHS
 Q
 ;
FACE ;
 I $D(^%ZOSF("XY"))#2 S (DX,DY)=0 X ^("XY") K DX,DY
 S DFN=DPTDZPRE("PAT")
 D START^AGFACE K AGOPT
 Q
 ;
CHECK ;
 I $P(^DPT(XDRMRG("FR"),0),U,19)]""!($E($P(^DPT(XDRMRG("FR"),0),U),1)="*")!($E(^DPT(XDRMRG("TO"),0),1)="*")!($P(^DPT(XDRMRG("TO"),0),U,19)]"") D
 .S XDRMRG("QFLG")=1
 .Q:$D(ZTQUEUED)
 .W !!,$C(7),"Either the FROM or the TO Patient has already been merged away!!  You cannot ",!,"continue with this pair of patients.  Jot down the following information and ",!,"give it to your supervisor and/or site manager.",!
 .W !?5,"FROM Patient:  ",$P(^DPT(XDRMRG("FR"),0),U,1),?40,"<DFN:  ",XDRMRG("FR"),">"
 .W !?5,"TO Patient:  ",$P(^DPT(XDRMRG("TO"),0),U,1),?40,"<DFN:  ",XDRMRG("TO"),">"
 .W !?5,"DUPLICATE RECORD IEN:  ",XDRMPDA,!
 .Q
 Q
EOJ ;
 K:'DPTDZPRE("DFN") DFN S:DPTDZPRE("DFN") DFN=DPTDZPRE("DFN")
 K DPTDZPRE
 Q
