ABMDECLN ; IHS/ASDST/DMJ - Clean line itms claim file ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;IHS/SD/SDR - v2.5 p8 - task 6
 ;   Added code to rebuild new ambulance page 8K
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19901
 ;   Modified to make it leave completed insurers
 ;   instead of rebuilding them, making them active again
 ;
 ;Ask user for claim number
 N ABMCLM,ABMVDFN
 W !
 W !,"WARNING this option deletes the data from selected pages (subfiles) of the"
 W !,"claim file.  Then it looks to see if the data can be rebuilt from PCC."
 W !,"For some pages there is no data in PCC.  For some the data may be missing."
 W !,"The data will only be rebuilt if the information exists in PCC.",!
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="AEMNQ"
 D ^DIC
 Q:Y=-1
 S ABMCLM=+Y
 K ABM,DTOUT,DUOUT,DIRUT,DIROUT
 S Y=$P($G(^ABMDPARM(DUZ(2),1,0)),U,16)
 I Y D  Q:'Y
 .S X1=DT
 .S X2=-Y*30.417
 .D C^%DTC
 .Q:X<$P(^ABMDCLM(DUZ(2),ABMCLM,0),U,2)
 .W !,"The date of this claim is prior to the backbilling limit.  As a result items"
 .W !,"will not be rebuilt from PCC.  If you continue, you can only delete items.",!
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to continue"
 .S DIR("B")="No"
 .D ^DIR
 K ABM,DTOUT,DUOUT,DIRUT,DIROUT
 I '$D(^ABMDCLM(DUZ(2),ABMCLM,11,+$O(^ABMDCLM(DUZ(2),ABMCLM,11,0)),0)) D  Q:'Y
 .W !,"There are no PCC visits corresponding to this claim.  As a result there is no"
 .W !,"PCC data to rebuild from.  If you continue, you can only delete items.",!
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to continue"
 .S DIR("B")="No"
 .D ^DIR
 E  D  Q:$D(DIRUT)
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to view PCC visit information before continuing"
 .S DIR("B")="No"
 .D ^DIR
 .Q:'Y
 .S ABMI=0
 .F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMCLM,11,ABMI)) Q:'ABMI  D
 ..S APCDVDSP=ABMI
 ..D ^APCDVDSP
 .K ABMI,DIR
 ;Get list of subfiles and display to user.
 S DIC="^DD(9002274.3,"
 S DR=".01;.2;.4"
 S DIQ="ABM"             ;DIQ1 puts value into ABM array
 S DIQ(0)="I"
 F DA=13:2:47 D EN^DIQ1
 N PG
 F I=0:1:14 D
 .S Y=$T(PAGE+I)
 .S PG($P(Y,U,2))=$P($P(Y,U),";",3)
 W !!
 S I=0
 F  S I=$O(ABM(0,I)) Q:'I  D
 .Q:ABM(0,I,.2,"I")'["P"
 .I $X>35 W !
 .E  W ?40
 .W I,"  ",ABM(0,I,.01,"I") W:$D(PG(I)) "  (P-",PG(I),")"
 ;Ask user for list of subfiles to clean out
 W !
 K DIR
 S DIR("A")="Enter subfile number or list of subfiles to clean out"
 S DIR(0)="LC^13:47:0^K:'$D(ABM(0,+X)) X"
 S DIR("?")="Enter one number from the above list or a list or a range."
 S DIR("??")="^D HELP^ABMDECLN"
 D ^DIR
 I $D(DIRUT) G Q
 ;Clean out the list of selected subfiles
 S ABMY=Y
 S DA(1)=ABMCLM
 F  D  Q:'ABMY
 .S X=$P(ABMY,",",1)
 .S ABMY=$P(ABMY,",",2,45)
 .I X["-" D
 ..S ABM1=+X
 ..S ABM2=$P(X,"-",2)
 ..F ABM=ABM1:2:ABM2 D:$D(ABM(0,ABM)) CLEANIT(ABM,1)
 .E  D:$D(ABM(0,X)) CLEANIT(X,1)
 S DA=0
 F  S DA=$O(^ABMDCLM(DUZ(2),DA(1),11,DA)) Q:'DA  D
 .S ABMVDFN=+^ABMDCLM(DUZ(2),DA(1),11,DA,0)
 .S ^AUPNVSIT("ABILL",$P(^AUPNVSIT(ABMVDFN,0),U,2),ABMVDFN)=""
 S Y=+^ABMDCLM(DUZ(2),DA(1),0)
 I Y D QUEUE^ABMDVPAT
Q ;KILL OFF VARS
 K DIR,DIRUT,DTOUT,DUOUT,DIQ,DIC,DA,ABM,ABMY,ABM1,ABM2,DR
 Q
 ;
CLEAN(CLM,SECT,DFN)    ;EP to allow cleaning all items from multiple
 ;CLM  = Claim #
 ;SECT = The multiple to clean out
 ;Y    = Patient DFN
 N DA
 S DA(1)=CLM
 D CLEANIT(SECT,1)
 I $G(DFN)>0 S Y=DFN D QUEUE^ABMDVPAT
 Q
 ;
HELP ;EP
 W !,"Enter the subfile to clean out for claim # ",ABMCLM,"."
 W !,"You may enter a list of subfiles like this: 17,19,23."
 W !,"Or a range like this: 23-33, or a combination like this:"
 W !,"13,19,23-33.  To delete all line items from all mutiples enter"
 W !,"13-47"
 Q
CLEANIT(ABMSUB,ABMALL) ;EP - Clean out old values from ABMSUB node
 N ABMJ,ABMFDA,FILE,IENS
 S ABMALL=$G(ABMALL)
 S:'$D(DA) DA(1)=ABMP("CDFN")
 I $G(ABMCHV0)=$G(ABMP("V0")),$D(^ABMDCLM(DUZ(2),DA(1),ABMSUB))>1 D
 .S ABMJ=0
 .F  S ABMJ=$O(^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ)) Q:'ABMJ  D
 ..Q:'$D(^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ,0))
 ..S Y=^ABMDCLM(DUZ(2),DA(1),ABMSUB,ABMJ,0)
 ..I 'ABMALL,($P(Y,U,17)="M") Q
 ..I ABMSUB=13,$P(Y,U,3)="C" Q  ;quit if complete insurer
 ..S IENS=ABMJ_","_DA(1)_","
 ..S FILE=9002274.30+(ABMSUB/10000)
 ..S ABMFDA(FILE,IENS,.01)="@"
 ..D FILE^DIE("KE","ABMFDA")
 ..K ABMFDA(FILE)
 ..Q:'ABMALL
 ..S ABMSRC=""
 ..F  S ABMSRC=$O(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC)) Q:ABMSRC=""  D
 ...Q:'$D(^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,ABMJ))
 ...K ^ABMDCLM(DUZ(2),DA(1),"ASRC",ABMSRC,ABMJ,ABMSUB)
 Q
 ;
PAGE ;;2^13
 ;;4^41
 ;;5A^17
 ;;5B^19
 ;;6^33
 ;;8A^27
 ;;8B^21
 ;;8C^25
 ;;8D^23
 ;;8E^37
 ;;8F^35
 ;;8G^39
 ;;8H^43
 ;;8J^45
 ;;8K^47
