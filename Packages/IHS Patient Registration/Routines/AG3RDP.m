AG3RDP ;IHS/ASDS/SDH - COUNT 3RD PARTY RESOURCE PATIENTS ;  
 ;;7.1;IHS PATIENT REGISTRATION;**2,4**;JAN 31, 2007
 ;
INTRO ;
 ;;
 ;;3RD PARTY ELIGIBLITY COUNT PROCESS!
 ;;-----------------------------------
 ;;This report counts the number of patients that have 3rd Party
 ;;insurance on a selected date.
 ;; 
 ;;###
 W @IOF
 F AG=1:1 W $$CJ^XLFSTR($P($T(INTRO+AG),";",3),IOM) Q:$P($T(INTRO+AG+1),";",3)="###"
 ;
DATE ; Input date to check for eligibility.
 S AGDT=$$DIR^XBDIR("D","Date for the point in Time you want eligibility for")
 I $D(DIRUT) D EOJ Q
VSTCK ; Input check-active flag.
 S AGVCK=$$DIR^XBDIR("Y","Want to check if patient is active")
 I $D(DIRUT) D EOJ Q
DEV ; Select Device.
 W !!
 KILL IOP
 S %ZIS="PQ"
 KILL IO("Q")
 D ^%ZIS
 I POP D EOJ Q
 I $D(IO("Q")) D TASK,EOJ Q
START ;EP - From TaskMan.
 ;AG*7.1*2 ALPHA ISSUE ADD DATE/TIME STAMP TO AID IN BEFORE/AFTER COMPARISONS FOR CMS DOWNLOAD
 N AGNOW
 D NOW^%DTC
 S Y=% X ^DD("DD")
 S AGNOW=Y
 ;AG*7.1*2 END
 KILL ^TMP("AG3RDP",$J)
 D MCR,MCD,PI,RPT,EOJ
 Q
 ;
MCR ; Process MediCare file.  Record the counts
 I '$D(ZTQUEUED),$E(IOST)="C" U IO(0) W !,"Processing Medicare......"
 S DFN=0
 F  S DFN=$O(^AUPNMCR(DFN)) Q:+DFN=0  D
 . I $P($G(^DPT(DFN,.35)),U)'="",($P($G(^DPT(DFN,.35)),U)'>AGDT) Q
 . S AGM=0
 . F  S AGM=$O(^AUPNMCR(DFN,11,AGM)) Q:+AGM=0  D
 .. S AGST=$P($G(^AUPNMCR(DFN,11,AGM,0)),U)
 .. S AGEND=$P($G(^AUPNMCR(DFN,11,AGM,0)),U,2)
 .. S AGTY=$P($G(^AUPNMCR(DFN,11,AGM,0)),U,3)
 .. S AG("MCR")="N"
 .. I (AGDT'<AGST),(AGEND="") S AG("MCR")="Y"
 .. E  I (AGDT'<AGST),(AGDT'>AGEND) S AG("MCR")="Y"
 .. ;I AG("MCR")="Y" S $P(^TMP("AG3RDP",$J,DFN),U,$S(AGTY="B":4,1:3))=1
 .. I AG("MCR")="Y" S $P(^TMP("AG3RDP",$J,DFN),U,$S(AGTY="B":4,AGTY="A":3,1:5))=1  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 8 PG 11
 ..Q
 .Q
 Q
 ;
MCD ; Process MediCaid file.  Record the counts
 I '$D(ZTQUEUED),$E(IOST)="C" U IO(0) W !!,"Processing Medicaid...."
 S AG=0
 F  S AG=$O(^AUPNMCD(AG)) Q:+AG=0  D
 . S DFN=$P($G(^AUPNMCD(AG,0)),U)
 . I 'DFN W !,DFN
 . Q:'DFN
 . I $P($G(^DPT(DFN,.35)),U)'="",($P($G(^DPT(DFN,.35)),U)'>AGDT) Q
 . S AGM=0,AG("MCD")="N"
 . F  S AGM=$O(^AUPNMCD(AG,11,AGM)) Q:+AGM=0  D  Q:AG("MCD")="Y"
 .. S AGST=$P($G(^AUPNMCD(AG,11,AGM,0)),U)
 .. S AGEND=$P($G(^AUPNMCD(AG,11,AGM,0)),U,2)
 .. I $E(AGEND,6,7)="00" S AGEND=AGEND+31
 .. I (AGDT'<AGST),(AGEND="") S AG("MCD")="Y"
 .. E  I (AGDT'<AGST),(AGDT'>AGEND) S AG("MCD")="Y"
 .. I AG("MCD")="Y" S $P(^TMP("AG3RDP",$J,DFN),U,1)=1
 ..Q
 .Q
 Q
 ;
PI ; Process Private Insurance file.  Record the counts
 I '$D(ZTQUEUED),$E(IOST)="C" U IO(0) W !!,"Processing Private Ins......."
 S DFN=0
 F  S DFN=$O(^AUPNPRVT(DFN)) Q:+DFN=0  I $$PI^AUPNPAT(DFN,AGDT) S $P(^TMP("AG3RDP",$J,DFN),U,2)=1
 Q
 ;
RPT ;
 K AGST,AGEND,AG,AGM,DIR
 U IO
 D EN
 Q
 ;
EOJ ;
 D ^%ZISC
 K AGDT,AGST,AGTY,AGVCK,DIR,DFN
 K ^TMP("AG3RDP",$J)
 Q
 ;
TASK ;
 K ZTSAVE
 S ZTSAVE("AGDT")="",ZTSAVE("AGVCK")="",ZTIO=ION,ZTRTN="START^AG3RDP",ZTDTH="",ZTDESC="3RD PARTY ELIGIBILITY REPORT"
 D ^%ZTLOAD
 Q
 ;
EN ;
 S (AG,AGMCD,AGPI,AGMCR,AGMCRB,AGMMPI,AGMM,AGMDPI,AGMRPI,AGMCRAB)=0
 S AGMCRD=0  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 8 PAGE 11
 S AG("BDT")=9999999-(AGDT-30001),AG("EDT")=9999999-(AGDT-1)
 S DFN=0
 F  S DFN=$O(^TMP("AG3RDP",$J,DFN)) Q:+DFN=0  D
 .I $G(AGVCK)=1 D VCHK Q:AG("V")="N"
 .S AG=$G(^TMP("AG3RDP",$J,DFN))
 .;F %=1:1:4 S @("AG"_%)=+$P(AG,U,%)
 .F %=1:1:5 S @("AG"_%)=+$P(AG,U,%)  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 8 PAGE 11
 .;I AG1=0,AG2=0,AG3=0,AG4=0,AG5=1 S AGMCRD=AGMCRD+1 Q
 .I AG5=1 S AGMCRD=AGMCRD+1 Q  ;AG*7.1*2 ITEM 8 PAGE 11 SPECS CHANGED PER BPD MEETING OF 8/18/2006
 .I AG1=1,AG2=0,AG3=0,AG4=0 S AGMCD=AGMCD+1 Q
 .I AG1=0,AG2=1,AG3=0,AG4=0 S AGPI=AGPI+1 Q
 .I AG1=0,AG2=0,AG3=1,AG4=0 S AGMCR=AGMCR+1 Q
 .I AG1=0,AG2=0,AG3=0,AG4=1 S AGMCRB=AGMCRB+1 Q
 .I AG1=0,AG2=0,AG3=1,AG4=1 S AGMCRAB=AGMCRAB+1 Q
 .I AG1=1,AG2=1,((AG3=1)!(AG4=1)) S AGMMPI=AGMMPI+1 Q
 .I AG1=1,((AG3=1)!(AG4=1)) S AGMM=AGMM+1 Q
 .I AG1=1,AG2=1 S AGMDPI=AGMDPI+1 Q
 .I AG1=0,AG2=1,((AG3=1)!(AG4=1)) S AGMRPI=AGMRPI+1 Q
 .Q
REPORT ;
 U IO
 W !!?10,"3rd Party eligibility Stats"
 W !?10,"For Patients with Eligibility: ",$$FMTE^XLFDT(AGDT)
 W:$G(AGVCK)=1 !?10,"and having a visit in the past 3 years."
 W !?10,"Report Date/Time: ",$G(AGNOW)  ;AG*7.1*2 ALPHA ISSUE ADD DATE/TIME STAMP TO AID IN BEFORE/AFTER COMPARISONS FOR CMS DOWNLOAD 
 W !!?16,"UNDUPLICATED PATIENT COUNTS"
 W !!?10,"Medicaid Only: ",?40,$J(AGMCD,6)
 W !!?10,"Private Insurance Only: ",?40,$J(AGPI,6)
 W !!?10,"Medicare A Only: ",?40,$J(AGMCR,6)
 W !!?10,"Medicare B Only: ",?40,$J(AGMCRB,6)
 W !!?10,"Medicare Part A & B Only: ",?40,$J(AGMCRAB,6)
 W !!?10,"Medicare Part D: ",?40,$J(AGMCRD,6)  ;IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 8 PAGE 11
 W !!?10,"Medicaid & Medicare: ",?40,$J(AGMM,6)
 W !!?10,"Medicaid & Private Ins.: ",?40,$J(AGMDPI,6)
 W !!?10,"Medicare & Private Ins.: ",?40,$J(AGMRPI,6)
 W !!?10,"Medicaid, Medicare, & PI: ",?40,$J(AGMMPI,6)
 ;S AGTOT=AGMCD+AGPI+AGMCR+AGMCRB+AGMCRAB+AGMM+AGMDPI+AGMRPI+AGMMPI
 S AGTOT=AGMCD+AGPI+AGMCR+AGMCRB+AGMCRAB+AGMM+AGMDPI+AGMRPI+AGMMPI+AGMCRD  ;AG*7.1*4 IM26255
 W !?40,"------",!!?20,"TOTAL",?40,$J(AGTOT,6)
 I '$D(ZTQUEUED),$E(IOST)="C",$$DIR^XBDIR("E","Enter RETURN to continue")
 W @IOF
 D ^%ZISC
 K DFN,AG1,AG2,AG3,AG4,AG,AGTOT,AGMCD,AGPI,AGMCR,AGMCRB,AGMMPI,AGMM,AGMDPI,AGMRPI,AGMCRAB,AGDT
 Q
 ;
VCHK ;
 S AG("V")="N",AGST=0
 F  S AGST=$O(^AUPNVSIT("AA",DFN,AGST)) Q:AGST=""  I (AGST<AG("BDT")),(AGST>AG("EDT")) S AG("V")="Y" Q
 Q
