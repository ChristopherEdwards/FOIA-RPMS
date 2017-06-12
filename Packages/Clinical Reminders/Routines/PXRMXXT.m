PXRMXXT ; SLC/DLT - Formatting for extract print templates ;29-Feb-2012 09:27;DU
 ;;2.0;CLINICAL REMINDERS;**1001**;Feb 04, 2005;Build 21
 ;IHS/CIA/MGH Patch 1001 Modified to use health record number
 ;
 ;======================================================================
FORMATB ;Format body of report that prints the findings
 ; Variables that need to be deleted from the template logic follow
 ;     PXRME,PXRMB,PXRMSEX,PXRMFD
 D DELVAR^PXRMXXT
 N DFN,VADM,VA
 S PXRME=^PXRMXT(810.3,D0,1,D1,0)
 S DFN=+$P(PXRME,"^",1)
 D DEM^VADPT
 S PXRMB=$$FMTE^XLFDT(+VADM(3),"2D")
 I '$L(PXRMB) S PXRMB="Missing DOB"
 ;IHS/CIA/MGH Modified to use health record number
 S PXRMHRCN=$$HRCN^PXRMXXT(DFN,+$G(DUZ(2)))
 S PXRMSSN=$P(VADM(2),"^",2)
 S PXRMSEX=$P(VADM(5),"^",1)
 S PXRMFD=$$FMTE^XLFDT($P(PXRME,"^",6),"2D")
 S PXRMENCT=$S($P(PXRME,"^",8)="I":"Inpatient ",1:"Outpatient")
 Q
 ;
PDEM ;Print SSN with dashes
 ;IHS/MSC/MGH Patch 1001Modified to use health record number
 ;W PXRMSSN
 W PXRMHRCN
 Q
HRCN(DFN,SITE) ;EP
 ; IHS/MSC/MGH Patch 1001 Return chart number for patient at this site
 N TEST,TEST1
 Q $P($G(^AUPNPAT(DFN,41,SITE,0)),U,2)
 ;
PFIND ;Print findings data from the template
 W " "_PXRMENCT_" "_$E(PXRMFD,1,8)
 Q
 ;
DELVAR ;Delete variables used in the processing
 K PXRME,PXRMB,PXRMSEX,PXRMFD,PXRMSSN,PXRMFD,PXRMENCT
 Q
 ;
