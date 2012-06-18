BARDYSCL ; IHS/SD/TPF - DAYS IN A/R REPORT MAIN DRIVER ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**16**;OCT 22,2008
 ;
 Q
START ;
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL         ; Setup basic A/R variables
 S BARP("RTN")="BARDYSCL"           ; Routine used to get data
 S BAR("PRIVACY")=1                ; Privacy act applies
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 S BARMENU="Days in AR"
SEL ;
 K DTOUT,DIRUT,DUOUT
 D ^BARRSEL                        ; Select exclusion parameters
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) Q
 I $D(BARY("RTYP")) S BAR("HD",0)=BARY("RTYP","NM")_" "_BARMENU
 E  S BAR("HD",0)=BARMENU
 S BARY("STCR")=5                   ;allow all allowance categories
 D ^BARRHD                         ; Report header
 S BARQ("RC")="COMPUTE^BARDYSCL"    ; Compute routine
 S BARQ("RP")="PRINT^BARDYSCL"
 ;I XQY0["Days to Bill by Visit Range of Approved Bills" D
 ;.S BARQ("RP")="PRINTAPP^BARDYSPR"      ; Print routine
 ;E  S BARQ("RP")="PRINTVIS^BARDYSPR"
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 ;D ^BARDBQUE                       ; Double queuing
 S %ZIS="QM"
 D ^%ZIS Q:POP
 I $D(IO("Q")) D  Q
 .S ZTRTN="COMPUTE^BARDYSCL",ZTDESC=XQY0
 .S ZTSAVE("BAR*")=""
 .D ^%ZTLOAD
 .I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 .E  W !!?5,"Report queued to run on ",ZTSK," #"
 .D HOME^%ZIS
 .K IO("Q")
 D COMPUTE
 Q
PRINT ;
 Q
COMPUTE ;
 U IO
 ;search by visit date range
 I BARY("DT")="V" D BYVISIT^BARDYSVS(BARY("DT",1),BARY("DT",2)) Q
 ;SEARCH BY APPROVAL DATE RANGE
 I BARY("DT")="A" D BYAPPDT^BARDYSAP(BARY("DT",1),BARY("DT",2)) Q
 ;SEARCH BY EXPORT NUMBER FIELD .17 DATE RANGE ?
 ;I BARY("DT")="X" S TOTVSIT=$$EXPRANG(BARY("DT",1),BARY("DT",2)) Q
 Q
