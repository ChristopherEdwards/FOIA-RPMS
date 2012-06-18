BDWA ;IHS/CMI/LAB - dw export reg data - old version;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
 NEW BDWALDAT,BDWAFDAT,BDWATXST,BDWAIN01,BDWAIN03,BDWAIN06
 S BDWAIN01=$$NOW^XLFDT,BDWATXST=$P(^AUTTSITE(1,0),U),(BDWA("TOT"),BDWAROUT,BDWAIN03,BDWAIN06)=0
 D HOME^%ZIS
HDR ;;^Export Registration Data for ALL Patients
 W @IOF,!
 F I=1:1:(IOM-2) W "*"
 W !,"*",?(IOM\2-($L($P($T(HDR),U,2))\2)),$P($T(HDR),U,2),?(IOM-3),"*",!
 F I=1:1:(IOM-2) W "*"
 W !!?10,"Exporting all Registration info for ",$P(^DIC(4,BDWATXST,0),U)
 W !?10,"** Merge'd or Deleted Pts are not exported."
 W !?10,"** Data checks are -not- performed, as in the Reg export."
 W !!?10,"NOW PROCESSING ALL PATIENTS...",!
 KILL ^BDWRDATA ; Kill of unsubscripted TEMPORARY work globals.
 S ^BDWRDATA(0)="",%=$$NOJOURN^ZIBGCHAR("BDWRDATA")
 I % W !,"The 'NOJOURN^ZIBGCHAR() for ^BDWRDATA didn't work...",!
 D ^BDWA1
 W !?10,"NUMBER OF PATIENTS PROCESSED      = ",$J(BDWAIN03,5)
 W !?10,"NUMBER OF PATIENT RECORDS TO SEND = ",$J(BDWA("TOT"),5)
 S ^BDWRDATA(0)=$P(^AUTTLOC(BDWATXST,0),U,10)_U_$P(^DIC(4,BDWATXST,0),U)_U_(DT+17000000)_U_(BDWAFDAT+17000000)_U_(BDWALDAT+17000000)_"^^"_BDWA("TOT")_U
 S BDWAIN06=BDWAIN06+$L(^BDWRDATA(0))+12
 W !!?17,"DW EXPORT GLOBAL HAS BEEN GENERATED."
 KILL DA,DIC,DR,DX,DY,X,XX,Y,Z
 W !?28,"***  0th Node Info  ***",!!,"Number : ",$P(^BDWRDATA(0),U),!,"  Name : ",$P(^BDWRDATA(0),U,2),!?9,$P(^BDWRDATA(0),U,7)," records",!?9,$$FMTE^XLFDT($P(^BDWRDATA(0),U,4)-17000000)," to ",$$FMTE^XLFDT($P(^BDWRDATA(0),U,5)-17000000),!
 D EN^XBVK("XB")
 S XBGL="BDWRDATA",XBNAR="DW Registration Export Global",XBMED="F"
 S XBQ="N" ; XBQTO="???"
 D ^XBGSAVE
 I XBFLG W *7,!!?22,"ABNORMAL END OF DW REG DATA GLOBAL SAVE." W:$D(XBFLG(1)) !!,XBFLG(1),!! I $$DIR^XBDIR("E","Press ENTER")
 D EN^XBVK("XB")
 NEW DIC,DA,DR,DLAYGO
 S DLAYGO=90029,DIC(0)="L",DIC="^BDWAINFO(",X=BDWAIN01,DIC("DR")=".02///"_$$NOW^XLFDT_";.03///"_BDWAIN03_";.04////"_DUZ_";.05///"_BDWA("TOT")_";.06///"_BDWAIN06
 KILL DD,DO D FILE^DICN
 D EN^XBVK("BDWA"),^XBFMK
 Q
 ;
