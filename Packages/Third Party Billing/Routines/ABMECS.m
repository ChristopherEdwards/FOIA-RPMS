ABMECS ; IHS/ASDST/DMJ - ELECTRONIC CLAIMS SUBMISSION ;   
 ;;2.6;IHS Third Party Billing System;**2,6**;NOV 12, 2009
 ;Original;DMJ;01/02/96 4:18 PM
 ;
 ; This routine is called from the EMC Create a Batch Menu option.
 ; It will show you a summary of bills ready to export grouped by
 ; bill type and export type. The user is asked to select one 
 ; group. An entry is then made in 3P TX STATUS file and a file
 ; is created in unix as specified by the user.
 ;
 ; IHS/ASDS/DMJ - 03/01/01 - V2.4 Patch 9 - NOIS HQW-0301-100010 - Modified to accommodate new Envoy electronic format
 ; IHS/ASDS/DMJ - 01/03/02 - V2.4 Patch 10 - NOIS NDA-1201-180141 - Modified code to calculate submission number differently as
 ;    Medicare saves the numbers for up to a year.
 ; IHS/ASDS/SDR - 01/16/02 - V2.4 Patch 10 - NOIS XAA-0800-200136 - Modified so as not to combine different export modes
 ;   into one file
 ; IHS/SD/SDR - v2.5 p8 - IM13650 - Set ABMAPOK so the trigger on Bill Status field gets executed
 ;    to update A/R.
 ; IHS/SD/SDR - abm*2.6*2 - 5PMS10005 - Populate EXPORT NUMBER RE-EXPORT mult
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added clearinghouse code
 ; ********************************************************************
START ;
 K ABME,ABMER
 ; Display summary of bills ready to export and ask user to select 
 ; one group. The ABMER array and ABMSEQ are undefined going into
 ; EMCREAT^ABMECDSP but are needed upon return.
 D EMCREAT^ABMECDSP(.ABMER,.ABMSEQ)
 Q:'+$G(ABMSEQ)     ; Quit if no group selected.
 ;start old code abm*2.6*6 5010
 ;S DIR(0)="Y"
 ;S DIR("A")="Proceed"
 ;S DIR("B")="YES"
 ;D ^DIR
 ;K DIR
 ;I Y'=1 K ABME Q
 ;end old code 5010
 K ABMGCN  ;abm*2.6*6 5010
 I $D(^TMP($J,"S-CH",ABMSEQ)) D CHFILE Q  ;abm*2.6*6 5010
 D FILE         ; Make entry in 3P TX STATUS and create a file
 S DIR(0)="E"
 D ^DIR
 K DIR
 K ABMER,ABMP,ABMSEQ
 Q
 ;
 ;start new code abm*2.6*6 5010
CHFILE ;
 S ABMER("CNT")=0,ABMER("LAST")=0
 S ABMCH=$P(ABMER(ABMSEQ),U)
 S ABMINS("IEN")=0
 F  S ABMINS("IEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABMCH,ABMINS("IEN"))) Q:'(ABMINS("IEN"))  S ABMER("LAST")=+$G(ABMER("LAST"))+1
 S ABMINS("IEN")=0
 F  S ABMINS("IEN")=$O(^TMP($J,"S-CH",ABMSEQ,ABMCH,ABMINS("IEN"))) Q:'(ABMINS("IEN"))  D
 .S ABMITYP=$P(^AUTNINS(ABMINS("IEN"),2),U) ; Insurance type
 .S ABMVTYPE=$P(ABMER(ABMSEQ),U,2)          ; Visit type
 .S ABMEXP=$P(ABMER(ABMSEQ),U,3)            ; export type
 .; Loop through locations in TMP global created by EMCREAT^ABMECDSP
 .S ABMLOC=""
 .F  S ABMLOC=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC)) Q:ABMLOC=""  D
 ..Q:$D(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE))<2
 ..S ABMER("CNT")=+$G(ABMER("CNT"))+1
 ..D NEWB    ; Create a new batch in 3P TX STATUS
 ..I $G(Y)<0 D MSG^ABMERUTL("Could not enter batch in 3P TX STATUS file.") Q
 ..; Add bill to detail in 3P TX STATUS for this batch
 ..S ^ABMDTXST(DUZ(2),DA(1),2,0)="^9002274.61P^^"
 ..S ABMAPOK=1
 ..S ABMDA=0
 ..F  S ABMDA=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,ABMDA)) Q:'+ABMDA  D
 ...S X=ABMDA
 ...S DIC="^ABMDTXST(DUZ(2),DA(1),2,"
 ...S DIC(0)="LXNE"
 ...S DINUM=X
 ...K DD,DO D FILE^DICN
 ...Q:+Y<0
 ...S DA=+Y
 ...S DIE="^ABMDTXST(DUZ(2),DA(1),2,"
 ...S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMDA,41,"C","A",0))
 ...S:ABMAPRV ABMAPRV=$P(^ABMDBILL(DUZ(2),ABMDA,41,ABMAPRV,0),U)
 ...I ABMAPRV D
 ....S DR=".02///`"_ABMAPRV
 ....D ^DIE
 ....K ABMAPRV
 ...S ABMSBR=$$SBR^ABMUTLP(ABMDA)
 ...S DR=".03///"_ABMSBR
 ...D ^DIE
 ...K ABMSBR
 ...S DIE="^ABMDBILL(DUZ(2),"
 ...S DA=ABMDA
 ...S DR=".04////B;.16////A"_$S($P($G(^ABMDBILL(DUZ(2),ABMDA,1)),U,7)="":";.17////"_ABMP("XMIT"),1:"")
 ...S ABMREX("BDFN")=ABMDA
 ...D ^DIE
 ..K ABMAPOK
 ..; Write record  (Create EMC unix file)
 ..D @("^ABMEF"_$P(ABMER(ABMSEQ),U,3))
 ..I $G(POP) D
 ...S DIE="^ABMDTXST(DUZ(2),"
 ...S DA=ABMP("XMIT")
 ...S DR=".14///NOPEN"
 ...D ^DIE
 S DIR(0)="E"
 D ^DIR
 K DIR
 K ABMER,ABMP,ABMSEQ
 Q
 ;end new code 5010
FILE ;
 ; File bills to 3P TX STATUS FILE
 S ABMER("CNT")=1,ABMER("LAST")=1  ;abm*2.6*6 5010
 S ABMINS("IEN")=$P(ABMER(ABMSEQ),U)       ; Active Insurer IEN
 S ABMITYP=$P(^AUTNINS(ABMINS("IEN"),2),U) ; Insurance type
 S ABMVTYPE=$P(ABMER(ABMSEQ),U,2)          ; Visit type
 S ABMEXP=$P(ABMER(ABMSEQ),U,3)            ; export type
 ; Loop through locations in TMP global created by EMCREAT^ABMECDSP
 S ABMLOC=""
 F  S ABMLOC=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC)) Q:ABMLOC=""  D
 .Q:$D(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE))<2
 .K ABMGCN  ;abm*2.6*6
 .D NEWB    ; Create a new batch in 3P TX STATUS
 .I $G(Y)<0 D MSG^ABMERUTL("Could not enter batch in 3P TX STATUS file.") Q
 .; Add bill to detail in 3P TX STATUS for this batch
 .S ^ABMDTXST(DUZ(2),DA(1),2,0)="^9002274.61P^^"
 .S ABMAPOK=1
 .S ABMDA=0
 .F  S ABMDA=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMVTYPE,ABMEXP,ABMDA)) Q:'+ABMDA  D
 ..S X=ABMDA
 ..S DIC="^ABMDTXST(DUZ(2),DA(1),2,"
 ..S DIC(0)="LXNE"
 ..S DINUM=X
 ..K DD,DO D FILE^DICN
 ..Q:+Y<0
 ..S DA=+Y
 ..S DIE="^ABMDTXST(DUZ(2),DA(1),2,"
 ..S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMDA,41,"C","A",0))
 ..S:ABMAPRV ABMAPRV=$P(^ABMDBILL(DUZ(2),ABMDA,41,ABMAPRV,0),U)
 ..I ABMAPRV D
 ...S DR=".02///`"_ABMAPRV
 ...D ^DIE
 ...K ABMAPRV
 ..S ABMSBR=$$SBR^ABMUTLP(ABMDA)
 ..S DR=".03///"_ABMSBR
 ..D ^DIE
 ..K ABMSBR
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DA=ABMDA
 ..;S DR=".04////B;.16////A;.17////"_ABMP("XMIT")  ;abm*2.6*2 5PMS10005
 ..S DR=".04////B;.16////A"_$S($P($G(^ABMDBILL(DUZ(2),ABMDA,1)),U,7)="":";.17////"_ABMP("XMIT"),1:"")  ;abm*2.6*2 5PMS10005
 ..S ABMREX("BDFN")=ABMDA  ;abm*2.6*3
 ..D ^DIE
 ..;D BILLSTAT^ABMDREEX(DUZ(2),ABMDA,ABMP("XMIT"),"O",$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,6))  ;abm*2.6*2 5PMS10005
 .K ABMAPOK
 .; Write record  (Create EMC unix file)
 .D @("^ABMEF"_$P(ABMER(ABMSEQ),U,3))
 .I $G(POP) D
 ..S DIE="^ABMDTXST(DUZ(2),"
 ..S DA=ABMP("XMIT")
 ..S DR=".14///NOPEN"
 ..D ^DIE
 Q
 ;
NEWB ;
 ; Create a new batch  (Make entry in 3P TX STATUS)
 D NOW^%DTC
 S X=%
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="LX"
 S DLAYGO=9002274.6
 K DD,DO D FILE^DICN
 K DLAYGO
 Q:Y<0
 S ABMP("XMIT")=+Y
 S DIE=DIC
 S DA=+Y
 S DR=".02///"_$P(ABMER(ABMSEQ),U,3)_";.04///`"_ABMINS("IEN")_";.03///"_ABMITYP_";.05////"_DUZ_";.09///"_$P(ABMER(ABMSEQ),U,4)_";.11///"_$J($P(ABMER(ABMSEQ),U,5),1,2)
 S DR=DR_";.17////"_$$FMT^ABMERUTL(ABMER("CNT"),"4NR")  ;abm*2.6*6 5010
 D ^DIE
 ;S DR=".16///"_$$NSN^ABMERUTL D ^DIE  ;abm*2.6*3 5PMS10005#2
 D GCNMULT^ABMERUTL("O",$S(($G(ABMREX("BILLSELECT"))!($G(ABMREX("BATCHSELECT")))):"1",1:""))  ;abm*2.6*3 5PMS10005#2
 S DA(1)=DA
 W !,"ENTRY CREATED IN 3P TX STATUS FILE."
 W !,"LOCATION: ",ABMLOC
 ;W !,"VISIT TYPE: ",$P(^ABMDVTYP(ABMVTYPE,0),U),!  ;abm*2.6*2 5PMS10005
 W:$G(ABMVTYPE) !,"VISIT TYPE: ",$P(^ABMDVTYP(ABMVTYPE,0),U),!  ;abm*2.6*2 5PMS10005
 Q
