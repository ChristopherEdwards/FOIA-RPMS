ABMDVST9 ; IHS/ASDST/DMJ - PCC VISIT STUFF IV PHARMACY ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;;Y2K/OK - IHS/ADC/JLG 12-18-97
 ;Original;TMD;03/26/96 10:50 AM
 ;
 ;IHS/DSD/JLG 05/21/98 -  NOIS NCA-0598-180077
 ;            Modified to set corresponding diagnosis if only one POV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ;
 Q:ABMIDONE
 Q:$D(ABMP("RXIVDONE"))
MED ;
 N ABMPPDU,ABMQTY
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",23,",DIC(0)="LE"
 S ABM=0 F  S ABM=$O(^PS(55,ABMP("PDFN"),"IV",ABM)) Q:'ABM  I $G(^(ABM,9)) S ABM(9)=^(9) D
 .I $D(ABMP("DDT")),$D(ABMP("ADMITDT")),+ABM(9)\1>ABMP("DDT")!((+ABM(9)\1)<ABMP("ADMITDT")) Q
 .I '$D(ABMP("DDT")),+ABM(9)\1'=ABMCHVDT Q
 .S ABM("TIME")=+ABMCHV0
 .N DOC,OK,DIC,DR,DIQ,DA
 .S OK=$D(ABMP("DDT"))
 .I 'OK D
 ..S DOC=$P(^PS(55,ABMP("PDFN"),"IV",ABM,0),U,6)
 ..S DIC="^DD(55.01,"
 ..S DR=.3
 ..S DIQ="ABMDFP"
 ..S DIQ(0)="I"
 ..S DA=.06
 ..D EN^DIQ1
 ..S DIC="^DD(9000010.06,"
 ..S DIQ="ABMDFV"
 ..S DA=.01
 ..D EN^DIQ1
 ..I ABMDFP(0,.06,.3,"I")'=ABMDFV(0,.01,.3,"I") D
 ...S DOC=$G(^DIC(16,DOC,"A3"))
 ..;It is assumed that if the files point to different files only the
 ..;pharmacy one needs to converted to a file 200 value
 ..S D1=0,OK=0
 ..F  S D1=$O(^AUPNVPRV("AD",ABMVDFN,D1)) Q:'D1  D  Q:OK
 ...I $P(^AUPNVPRV(D1,0),U,1)=DOC S OK=1
 .Q:'OK
 .K X
 .S ABM("FEE")=0
 .;This is the IV subfile of the Pharmacy Patient File.
 .S Y=^PS(55,ABMP("PDFN"),"IV",ABM,0)
 .S ABM("ORDER#")=$P(Y,U,1)
 .S ABM("TIME")=$P(Y,U,2)
 .S ABM("TYPE")=$P(Y,"^",4)
 .S ABM("TQTY")=$P(Y,"^",16)
 .;ABM("TQTY")=Cumulative doses - not used
 .S ABM("A")=0,ABM("T")="A" F  S ABM("A")=$O(^PS(55,ABMP("PDFN"),"IV",ABM,"AD",ABM("A"))) Q:'ABM("A")  S ABM(0)=^(ABM("A"),0) D
 ..;ABM(0) - Additive node
 ..;(#.01) ADDITIVE [1P] ^ (#.02) STRENGTH [2F] ^(#.03) BOTTLE [3F] ^
 ..;S ABM("QTY")=+$P(ABM(0),U,2)*$P(ABM(9),U,2)
 ..S ABMQTY=$S("PACSH"[ABM("TYPE"):+$P(ABM(0),U,2),1:1)*$P(ABM(9),U,3)
 ..;For piggybacks, admixtures, & chemo the strength is multiplied
 ..;times TOTAL IV'S ADMINISTERED to get ABMQTY.  For others we use
 ..;just TOTAL IV'S ADMINISTERED.
 ..;The above line has been modified further to measure the quantity
 ..;the same for all IV's.  It has been left in to make it easier
 ..;to modify.
 ..;ABM("QTY") - STRENGTH TIMES LAST QTY FILLED - not used
 ..I +ABM(0),$D(^PS(52.6,+ABM(0))) D
 ...S Y=^PS(52.6,+ABM(0),0)
 ...S ABMX=$P(Y,U,2)
 ...;The price per disp unit is obtained either from 3P fee table or
 ...;drug file.
 ...;S ABMPPDU=$S($D(^ABMDFEE(ABMP("FEE"),25,ABMX,0)):$P(^(0),U,2),1:$P($G(^PSDRUG(ABMX,660)),U,6))  ;abm*2.6*2 3PMS10003A
 ...S ABMPPDU=$S($D(^ABMDFEE(ABMP("FEE"),25,ABMX,0)):$P($$ONE^ABMFEAPI(ABMP("FEE"),25,ABMX,ABMP("VDT")),U),1:$P($G(^PSDRUG(ABMX,660)),U,6))  ;abm*2.6*2 3PMS10003A
 ...;Fee for each PPDU times ABMQTY (quantity) calculated above
 ...S ABM("FEE")=ABM("FEE")+(ABMPPDU*ABMQTY)
 ...;S ABM("FEE")=$G(ABM("FEE"))+($P(Y,U,7)*ABM("QTY"))
 ...I '$D(X),$D(^PSDRUG(ABMX,0)) S X=ABMX
 ..;ABMX - Generic Drug
 ..;7th Piece - average drug cost per unit
 .S ABMSRC="PSIV|"_ABM_"|RX-AD"
 .I $D(X),$D(^PSDRUG(X,0)) D MEDSET
 .K X
 .S ABM("FEE")=0
 .S ABM("A")=0,ABM("T")="S" F  S ABM("A")=$O(^PS(55,ABMP("PDFN"),"IV",ABM,"SOL",ABM("A"))) Q:'ABM("A")  S ABM(0)=^(ABM("A"),0) D
 ..;ABM(0) - solution node
 ..S ABM("QTY")=+$P(ABM(0),U,2)*$P(ABM(9),U,2)
 ..;ABM("QTY") - VOLUME TIMES LAST QTY FILLED
 ..;^PS(52.7 is the IV solutions file.
 ..I +ABM(0),$D(^PS(52.7,+ABM(0))) D
 ...S Y=^PS(52.7,+ABM(0),0)
 ...S ABMX=$P(Y,U,2)
 ...;S ABMPPDU=$S($D(^ABMDFEE(ABMP("FEE"),25,ABMX,0)):$P(^(0),U,2),1:$P($G(^PSDRUG(ABMX,660)),U,6))  ;abm*2.6*2 3PMS10003A
 ...S ABMPPDU=$S($D(^ABMDFEE(ABMP("FEE"),25,ABMX,0)):$P($$ONE^ABMFEAPI(ABMP("FEE"),25,ABMX,ABMP("VDT")),U),1:$P($G(^PSDRUG(ABMX,660)),U,6))  ;abm*2.6*2 3PMS10003A
 ...;For solutions same as additives.
 ...S ABM("FEE")=ABM("FEE")+(ABMPPDU*$P(ABM(9),U,3))
 ...;S ABM("FEE")=$G(ABM("FEE"))+($P(Y,U,7)*ABM("QTY"))
 ...I '$D(X),$D(^PSDRUG(ABMX,0)) S X=ABMX
 ..;X - Generic drug
 ..;7th piece - Average drug cost
 .S ABMSRC="PSIV|"_ABM_"|RX-SOL"
 .I $D(X),$D(^PSDRUG(X,0)) D MEDSET
 Q
 ;
MEDSET ;SET 3P CLAIM RX MULTIPLE
 S ABMP("RXIVDONE")=1
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",23,",DIC(0)="LE"
 S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),"ASRC",ABMSRC,0))
 I DA,'$D(@(DIC_DA_",0)")) S DA=""          ;For duplicates problem
 I 'DA D
 .S DIC("P")=$P(^DD(9002274.3,23,0),U,2)
 .; ENTER CORRECT DEFAULT REV CODE
 .S DIC("DR")=".02////260"    ;IHS/DSD/JLG 3/31/98
 .K DD,DO D FILE^DICN S DA=+Y
 .K DIC("DR")                 ;IHS/DSD/JLG 3/31/98
 Q:DA<1  S DIE=DIC
 D DFEE
 S DR=".03////1;.04////"_+ABM("FEE")_";.05////"_+ABM("DISPFEE")_";.06////"_ABM("ORDER#")   ;MODIFIED  IHS/DSD/JLG 3/31/98
 S DR=DR_";"_$S(ABM("T")="A":.07,1:.08)_"////"_(+ABM(0))_";.09///"_$P(ABM(0),U,2)
 ;Next line set correspond diagnosis if only 1 POV  
 I $D(ABMP("CORRSDIAG")) S DR=DR_";.13////1"
 S DR=DR_";.15////"_ABM("TYPE")_";.14////"_ABM("TIME")
 S DR=DR_";.17////"_ABMSRC
 D ^DIE
 K DR
 Q
DFEE ;DISPENSE FEE
 S ABM("DFPARM")=$G(^ABMDPARM(DUZ(2),1,4))
 S ABM("DISPFEE")=+$P(ABM("DFPARM"),"^",$F("APHSC",ABM("TYPE")))
 Q
