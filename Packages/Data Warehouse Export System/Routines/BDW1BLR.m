BDW1BLR ; IHS/CMI/LAB - DW EXPORT REG DATA BACKLOAD VIA HL7 ;
 ;;1.0;IHS DATA WAREHOUSE;**2**;JAN 23, 2006
 ;
 ;IHS/SD/lwj 4/21/04 added call to Patient Reg audit file rtn
 ;
 S X=$O(^INRHD("B","HL IHS DW1 IE",0))
 I $D(^BDWTMP(X)) W !!,"previous DW export not written to host file" S DIR(0)="EO",DIR("A")="Press return to continue" KILL DA D ^DIR KILL DIR Q
 N AGPEXF   ;IHS/SD/lwj 4/21/04 patient audit flag
 D EXIT
 S BDWAIN01=$$NOW^XLFDT,BDWATXST=$P(^AUTTSITE(1,0),U),(BDWA("TOT"),BDWAROUT,BDWAIN03,BDWAIN06)=0
 D HOME^%ZIS
HDR ;;^Export Data for ALL Registration Records to Data Warehouse via HL7
 W @IOF,!
 F I=1:1:(IOM-2) W "*"
 W !,"*",?(IOM\2-($L($P($T(HDR),U,2))\2)),$P($T(HDR),U,2),?(IOM-3),"*",!
 F I=1:1:(IOM-2) W "*"
 W !!?10,"Exporting all Registration info for ",$P(^DIC(4,BDWATXST,0),U)
 W !?10,"** Merge'd or Deleted Pts are not exported."
 W !?10,"** Data checks are -not- performed, as in the Reg export."
CONT ;do you want to continue?
 W !!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 ;
 S BDWUSER=DUZ
 ;IHS/SD/lwj 04/21/04  run the patient export audit/chk result
 S AGEXPF=$$FULLEP^BDWDWPX    ;Patient Reg audit file creation
 I AGEXPF'=0 D
 . W !!?10,"Creation of audit file unsuccessful.",!!
 . S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 . I $D(DIRUT) D EXIT Q
 . I 'Y D EXIT Q
 ;IHS/SD/lwj 04/21/04 end changes for patient audit
 ;
G D GIS
 W !!?10,"NOW PROCESSING ALL REGISTRATION RECORDS...",!
 ;create log entry
 K DD,DA,DO,D0,DLAYGO,DIADD
 S DLAYGO=90215,DIADD=1,DIC(0)="L",DIC="^BDWRBLOG(",X=$$NOW^XLFDT,DIC("DR")=".04////"_DUZ_";.06////"_BDWATXST_";8801////"_DUZ_";.23///RBL" D FILE^DICN
 I Y=-1 W !!,"Creating log entry failed....notify programmer." D EXIT Q
 K DIC,DA,DO,D0,DD,DIADD,DLAYGO
 S BDWIEN=+Y
 ;get header message number
 S X=""
 S X=$$DW1HDR^BHLEVENT(90215,BDWIEN)
 S ^BDWTMP(BDWIEDST,X)=""
 S DA=BDWIEN,DIE="^BDWRBLOG(",DR=".07////"_X D ^DIE K DA,DIE,DR
 D ^XBFMK
 ;loop through AUPNPAT and generate all messages
 ;
 D LOOP
 W !?10,"NUMBER OF PATIENT ENTRIES PROCESSED      = ",$J(BDWA("TOT"),5)
 W !?10,"NUMBER OF REGISTRATION RECORDS (HL7 MESSAGES) TO SEND = ",$J(BDWAIN03,6)
 ;do trailer
 S X=""
 S X=$$DW1TRLR^BHLEVENT(90215,BDWIEN)
 S ^BDWTMP(BDWIEDST,X)=""
 ;update log with trailer message number, etc
 S DA=BDWIEN,DIE="^BDWRBLOG(",DR=".03///"_BDWA("TOT")_";.05///"_BDWAIN03_";.08////"_X D ^DIE K DA,DIE,DR
 D ^XBFMK
 S DA=1,DR=".04////"_DT,DIE="^BDWSITE(" D ^DIE
 D ^XBFMK
 W !!?17,"DW EXPORT HAS BEEN COMPLETED."
 S DIR(0)="EO",DIR("A")="Press return to continue" KILL DA D ^DIR KILL DIR
EXIT ;
 K DIADD,DLAYGO
 D EN^XBVK("BDWA"),^XBFMK
 Q
 ;
GIS ;-- check background jobs for gis
 S BDWIEDST=$O(^INRHD("B","HL IHS DW1 IE",0))
 W !!,"Checking GIS Background Jobs..."
 N BDWGISI
 F BDWGISI="FORMAT CONTROLLER" D
 . N BDWGISS
 . S BDWGISS=$$CHK^BHLBCK(BDWGISI,0)
 Q
 ;
LOOP ;LOOP PATS
 NEW DFN,BDWADONE,BDWAP3,DX,DY,BDWASITE,BDWAN11,BDWADPT0,BDWAPAT0,T
 S (BDWALDAT,DFN)=0,BDWAFDAT=9999999,BDWAP3=$P(^AUPNPAT(0),U,3)
 S DX=$X,DY=$Y+1
 S X=0 F  S X=$O(^AUPNPAT(X)) Q:X'=+X  I $D(^AUPNPAT(X,4)) F Y=1:1:5 S $P(^AUPNPAT(X,4),U,Y)="" I X>10000 W:'(X\10000) "."
 W !,"resetting DW AUDIT file"
 S BDWDA=0 F  S BDWDA=$O(^AUPNDWAF(BDWDA)) Q:BDWDA'=+BDWDA  S DA=BDWDA,DIK="^AUPNDWAF(" D ^DIK
 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D  I '(DFN#100),'$D(ZTQUEUED) X IOXY W "On IEN ",DFN," of ",BDWAP3," in ^AUPNPAT(..."
 . Q:'$D(^DPT(DFN))
 . Q:$P(^DPT(DFN,0),U,19)  ; merged pt
 . S BDWA("TOT")=BDWA("TOT")+1
 . Q:'$$ORF(DFN)  ;quit if no ORF charts per Lisa P 4-30-04
 . S (BDWADONE,BDWASITE)=0
 . F  S BDWASITE=$O(^AUPNPAT(DFN,41,BDWASITE)) Q:'BDWASITE  D  Q:BDWADONE
 .. I $L($P(^AUPNPAT(DFN,41,BDWASITE,0),U,5)) Q:"M"[$P(^(0),U,5)  ; deleted or merged patient
 .. ;Q:"T"=$E($P(^AUPNPAT(DFN,41,BDWASITE,0),U,2))  ; Temp HRN
 .. KILL T
 .. S BDWADPT0=$G(^DPT(DFN,0)),BDWAPAT0=$G(^AUPNPAT(DFN,0)),BDWAN11=$G(^AUPNPAT(DFN,11))
 .. S X=""
 .. S X=$$DW1REG^BHLEVENT(DFN,1)
 .. S ^BDWTMP(BDWIEDST,X)=""
 .. S BDWADONE=1 ; pt is done, one and only one time
 .. S BDWAIN03=BDWAIN03+1
 .. S DA=DFN,DIE="^AUPNPAT(",DR=".41////"_DT_";.42////"_DT_";.44////"_DT
 .. I $O(^DPT(DFN,.01,0)) S DR=DR_";.43////"_DT
 .. I $D(^AUPNMCR(DFN))!($D(^AUPNPRVT(DFN)))!($O(^AUPNMCD("B",DFN,0))) S DR=DR_";.45////"_DT
 .. D ^DIE K DIE,DA,DR,DIU,DIV,DIW,DIX
 .. Q
 . Q
 Q
 ;
ORF(P) ;patient has ORF?
 I '$G(P) Q 0
 NEW FLAG,D
 S FLAG=0
 ;
 S D=0
 F  S D=$O(^AUPNPAT(P,41,D)) Q:+D=0  D
 . Q:$P($G(^AGFAC(D,0)),"^",21)'="Y"   ;only want ORFs
 . S FLAG=1  ;found one
 . Q
 Q FLAG
