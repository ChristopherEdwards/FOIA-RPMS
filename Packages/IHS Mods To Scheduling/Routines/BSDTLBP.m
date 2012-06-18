BSDTLBP ;ihs/cmi/maw - BSD Track Letters By Patient 5/3/2011 1:23:57 PM
 ;;5.3;PIMS;**1013**;APR 26, 2002
 ;
 ;
MAIN ;-- this is the main routine driver
 N PAT
 S PAT=$$PAT
 Q:'$G(PAT)
 D ZIS^DGUTQ
 D LET(PAT)
 U IO
 D HDR(PAT)
 D PRT
 D XIT
 Q
 ;
PAT() ;-- get the patient
 S DIC(0)="AEMQZ",DIC="^AUPNPAT(",DIC("A")="Select Patient: "
 D ^DIC
 Q +Y
 ;
LET(P) ;-- get the letter to print
 N BDA,CDA,CNT,DLP
 S BDA=0 F  S BDA=$O(^VA(407.5,"BTRK",P,BDA)) Q:'BDA  D
 . S CNT=0
 . S:'$D(LET(P)) LET(P)=0
 . S CDA=0 F  S CDA=$O(^VA(407.5,"BTRK",P,BDA,CDA)) Q:'CDA  D
 .. S CNT=CNT+1
 .. S DLP=$P($G(^VA(407.5,BDA,"PIHS",CDA,0)),U,2)
 .. S LET(BDA)=DLP_U_CNT
 Q
 ;
PRT ;-- lets print the report
 N LETE,DDA,DLPE,NT
 S DDA=0 F  S DDA=$O(LET(DDA)) Q:'DDA  D
 . S LETE=$P($G(^VA(407.5,DDA,0)),U)
 . Q:$G(LETE)=""
 . S DLPE=$$FMTE^XLFDT($P($G(LET(DDA)),U))
 . S NT=$P($G(LET(DDA)),U,2)
 . W !,LETE,?30,DLPE,?60,NT
 Q
 ;
HDR(P) ;-- Get the header
 W !,"Patient Letter Tracking for: "_$P($G(^DPT(P,0)),U),?55,"Date Printed: "_DT
 W !!,"Letter",?30,"Last Date Printed",?60,"Number of times",!
 F I=1:1:80 W "-"
 Q
 ;
XIT ;-- exit and quit
 D ^%ZISC
 K LET
 Q
 ;
