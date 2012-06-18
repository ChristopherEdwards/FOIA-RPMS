APSPSITE ;IHS/CIA/PLS - IHS Site Parameter Setup;29-Jun-2010 15:35;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1003,1008,1009**;Sep 23, 2004
 ; Modified - IHS/CIA/PLS - 04/05/05 - SIGLBL API
 ;            IHS/MSC/PLS - 03/17/09 - PDEDWM commented out
 ;                                   - Added PMIS printer default
 ;                          06/29/10 - Added default label device support
EP ; EP
 ; APSQSGLB - Holds the selected signature label device when using laser labels.
 I $D(^APSPCTRL(PSOSITE,0)) S %APSITE=^(0)
 S %APSITE3=$G(^APSPCTRL(PSOSITE,3)),APSQTYPE=$P($G(^(3)),"^",1)  ; Patient Info Language
 I $P($G(%APSITE),U,36)]"" S $P(%APSITE,U,20)=$P(%APSITE,U,36)  ; Summary Label Copies
 S $P(%APSITE,U,15)="",$P(%APSITE,U,36)=""
 S APSPMAN=$P($G(^APSPCTRL(PSOSITE,1)),U)   ; Manufacturer
 ;USED IN FILLING RX AND REFILLS TO LIMIT FIELDS SEEN
 S PSOAWP=+$P(%APSITE3,"^",9)
 S PSOCOST=+$P(%APSITE3,"^",10)
 S PSONDC=$P(%APSITE3,"^",8)
 S PSOPATST=$P(%APSITE3,"^",2)
 S PSOBILST=$P(%APSITE3,"^",4) S:PSOBILST="" PSOBILST=0
 S PSOBILRX=$P(%APSITE3,"^",5)
 S APSQDNDC=$P(%APSITE3,"^",11)  ; Display NDC on label
 S PSOTRIP=$P(%APSITE3,"^",12)   ;Triplicate number
 S APSPCMP=+$P(%APSITE3,U,13)      ;Chronic Med Prompt
 S APSPDOL=$P($G(^APSPCTRL(PSOSITE,1)),U,2)  ; Default other location set
 I $D(^AUTTSITE(1,0)),$P(^(0),U,8)="Y",'$D(^APCCCTRL(DUZ(2),0))#2 W !,*7,"ENTRY MUST BE MADE IN THE PCC MASTER CONTROL FILE FOR THIS LOCATION",!,"PLEASE NOTIFY YOUR SITE MANAGER ... NO LINKAGE TO PCC IS OCCURRING !"
 S PHARMACY("PKGE DFN")=$O(^DIC(9.4,"B","OUTPATIENT PHARMACY",""))
 I $P(%APSITE,U,36)]"",'$D(^APCCCTRL(DUZ(2),11,PHARMACY("PKGE DFN"),0))#2 W !,*7,"ENTRY MUST BE MADE IN THE PCC MASTER CONTROL FILE FOR THIS PACKAGE !",!,"PLEASE NOTIFY YOUR SITE MANAGER ... NO LINKAGE TO PCC IS OCCURRING !"
 I $D(^AUTTSITE(1,0)),$P(^(0),U,8)="Y",$D(^APCCCTRL(DUZ(2),0))#2,$D(^APCCCTRL(DUZ(2),11,PHARMACY("PKGE DFN"),0))#2,$P(^(0),U,2) S $P(%APSITE,U,15)="Y",$P(%APSITE,U,36)=$P(^APCCCTRL(DUZ(2),0),U,2)
 S APSPLAP=$$GET1^DIQ(9009033,PSOSITE,401)
 K PHARMACY("PKGE DFN")
 ;-----------------------------------------------------------------
PDEDWM ; Patient Drug Education Database expiration warning message
 ;IHS/MSC/PLS - 03/17/09 - VA PMI data is now used.
 ;S X="APSEWMSG" X ^%ZOSF("TEST") I $T D EP^APSEWMSG
 ;
 ;-----------------------------------------------------------------
CPARM ; Chronic Med Parameter Default Days
 S PSOZZCP("DAYS")=""
 K PSOZP("FLG"),DIRUT,DTOUT
 S DIR(0)="NO^1:999:0"
 S DIR("B")=90,DIR("A")="Number of Days For Chronic Med Profile"
 D ^DIR
 I $D(DIRUT)!($D(DTOUT)) S PSOZCP("FLG")="" G CPARMX
 S PSOZZCP("DAYS")=$S(+Y>0:+Y,1:90)
CPARMX ;-----------------------------------------------------------------
 S PSODIV=$S(($P(PSOSYS,"^",2))&('$P(PSOSYS,"^",3)):0,1:1)
 S PSOINST=000 I $D(^DD("SITE",1)) S PSOINST=^DD("SITE",1)
 I $D(DUZ),$D(^VA(200,+DUZ,0)) S PSOCLC=DUZ
 I $D(PSOREO) G EXIT  ;No printer questions for OREO
 ;-----------------------------------------------------------------
ZCM ; Chronic Med Queue
 W !,"Pre-Select PMI/Chronic Med Profile Device? (Y/N) "
 S %=2 D YN^DICN
 W:%Y["?" !,"Answer 'Yes' if you want the Chronic Med Profiles to automa tically print with new Rx's"
 G:%Y["?" ZCM
 S APSPCP=%
CPLBL ; Chronic Med Device
 I APSPCP=1 D
 .S %ZIS="MNQ",%ZIS("A")="Select PMI/Chronic Med Profile PRINTER: "
 .S:$L($$GET1^DIQ(59.7,1,13)) %ZIS("B")=$$GET1^DIQ(59.7,1,13)
 .D ^%ZIS K %ZIS,IO("Q"),IOP
 .Q:POP
 .S APSPCPP=ION D ^%ZISC
 ; Signature Label Device
SIGLBL S APSQSGLB=""
 ; IHS/CIA/PLS - 04/05/05 - Logic changed to always prompt for signature label per PSG
 ;I $$GET1^DIQ(9009033,PSOSITE,316,"I") D
 ;.N APSPSIG,POP,%ZIS,ION
 ;.S APSPSIG=$$GET1^DIQ(9009033,PSOSITE,306,"I")
 ;.Q:'$L(APSPSIG)!(APSPSIG["N")
 ;.S %ZIS="MNQ",%ZIS("A")="Select Signature Label Printer: //"
 ;.S %ZIS("B")=""
 ;.S %ZIS("S")="I $P(^(0),U,2)'=0,$E($G(^%ZIS(2,+$G(^(""SUBTYPE"")),0)),1)=""P"""
 ;.D ^%ZIS K IO("Q") Q:POP  S APSQSGLB=ION_U_$G(IO("S")) D ^%ZISC
 N APSPSIG,POP,%ZIS,ION
 S APSPSIG=$$GET1^DIQ(9009033,PSOSITE,306,"I")
 Q:'$L(APSPSIG)!(APSPSIG["N")
 S %ZIS="MNQ",%ZIS("A")="Select Signature Label Printer: //"
 S %ZIS("B")=""
 S %ZIS("S")="I $P(^(0),U,2)'=0,$E($G(^%ZIS(2,+$G(^(""SUBTYPE"")),0)),1)=""P"""
 D ^%ZIS K IO("Q") Q:POP  S APSQSGLB=ION_U_$G(IO("S")) D ^%ZISC
EXIT Q
