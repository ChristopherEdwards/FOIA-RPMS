ABMECS2 ; IHS/ASDST/DMJ - ELECTRONIC CLAIMS SUBMISSION ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;01/02/96 4:18 PM
 ;
 ; IHS/ASDS/DMJ - 03/01/01 - V2.4 P5 - NOIS HQW-0301-100010
 ;    Modified to accommodate new Envoy electronic format
 ;
 ; This routine is called from the EMC Create a Batch Menu option.
 ; It will show you a summary of bills ready to export grouped by
 ; bill type and export type. The user is asked to select one 
 ; group. An entry is then made in 3P TX STATUS file and a file
 ; is created in unix as specified by the user.
 ;
START ;
 K ABME,ABMER
 ; Display summary of bills ready to export and ask user to select 
 ; one group. The ABMER array and ABMSEQ are undefined going into
 ; EMCREAT^ABMECDSP but are needed upon return.
 D EMCREAT^ABMECDSP(.ABMER,.ABMSEQ)
 Q:'+ABMSEQ     ; Quit if no group selected.
 S DIR(0)="Y"
 S DIR("A")="Proceed"
 S DIR("B")="YES"
 D ^DIR
 K DIR
 I Y'=1 K ABME Q
 D FILE         ; Make entry in 3P TX STATUS and create a file
 S DIR(0)="E"
 D ^DIR
 K DIR
 K ABMER,ABMP,ABMSEQ
 Q
 ;
FILE ;
 ; File bills to 3P TX STATUS FILE
 S ABMINS("IEN")=$P(ABMER(ABMSEQ),U)       ; Active Insurer IEN
 S ABMITYP=$P(^AUTNINS(ABMINS("IEN"),2),U) ; Insurance type
 S ABMBTYPE=$P(ABMER(ABMSEQ),U,2)          ; Bill type
 ; Loop through locations in TMP global created by EMCREAT^ABMECDSP
 S ABMLOC=""
 F  S ABMLOC=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC)) Q:ABMLOC=""  D
 .Q:$D(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMBTYPE))<2
 .D NEWB    ; Create a new batch in 3P TX STATUS
 .I $G(Y)<0 D MSG^ABMERUTL("Could not enter batch in 3P TX STATUS file.") Q
 .; Add bill to detail in 3P TX STATUS for this batch
 .S ^ABMDTXST(DUZ(2),DA(1),2,0)="^9002274.61P^^"
 .S DIC="^ABMDTXST(DUZ(2),DA(1),2,"
 .S DIC(0)="LXNE"
 .S ABMDA=0
 .F  S ABMDA=$O(^TMP($J,"D",ABMINS("IEN"),ABMLOC,ABMBTYPE,ABMEXP,ABMDA)) Q:'+ABMDA  D
 ..S X=ABMDA
 ..K DD,DO D FILE^DICN
 ..Q:+Y<0
 ..S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMDA,41,"C","A",0))
 ..Q:'ABMAPRV
 ..S ABMAPRV=$P(^ABMDBILL(DUZ(2),ABMDA,41,ABMAPRV,0),U)
 ..S DA=+Y
 ..S DIE=DIC
 ..S DR=".02///`"_ABMAPRV
 ..D ^DIE
 .; Write record  (Create EMC unix file)
 .D @("^ABMEF"_$P(ABMER(ABMSEQ),U,3))
 Q
 ;
NEWB ;
 ; Create a new batch  (Make entry in 3P TX STATUS)
 H 1
 D NOW^%DTC
 S X=%
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="LX"
 D ^DIC
 Q:Y<0
 S ABMP("XMIT")=+Y
 S DIE=DIC
 S DA=+Y
 S DR=".02///"_$P(ABMER(ABMSEQ),U,3)_";.04///`"_ABMINS("IEN")_";.03///"_ABMITYP_";.05////"_DUZ_";.09///"_$P(ABMER(ABMSEQ),U,4)_";.11///"_$J($P(ABMER(ABMSEQ),U,5),1,2)
 D ^DIE
 S DA(1)=DA
 W !,"ENTRY CREATED IN 3P TX STATUS FILE."
 W !,"LOCATION: ",ABMLOC
 W !,"BILL TYPE: ",ABMBTYPE,!
 Q
