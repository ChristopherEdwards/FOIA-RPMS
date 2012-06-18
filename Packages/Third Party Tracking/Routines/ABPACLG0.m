ABPACLG0 ;CHECK LOGGING UTILITY; [ 07/09/91  4:28 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 Q  ;;NOT AN ENTRY POINT
 ;---------------------------------------------------------------------
CLEAR ;PROCEDURE TO KILL ALL TEMPORARY LOCAL VARIABLES
 K X,Y,ABPA("HD"),DIC,DIE,DA,DR,ABPADFN,ABPAC,NOINS,NOCHECK,ABPAINS
 K NOACCT,LDT,LLDT,ABPAM,ABPAL,ABPAJ,ABPAK,ABPACAP
 Q
 ;---------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 K ABPA("HD") S ABPA("HD",1)=ABPATLE
 S ABPA("HD",2)="LOG third party CHECKS - "_+$E(LOGDT,4,5)_"/"
 S ABPA("HD",2)=ABPA("HD",2)_+$E(LOGDT,6,7)_"/"_+$E(LOGDT,2,3)
 D ^ABPAHD
 Q
 ;--------------------------------------------------------------------
GETCHK ;PROCEDURE TO GET CHECK DATA
 F ABPAK=0:0 S NOACCT=0,LOGDT=DT D  I NOACCT Q
 .K DIC,DA,ABPADFN,ABPAINS,ACCTPT
 .W ! S DX=0,DY=8 X XY D EOP^ABPAMAIN
 .S DIC="^ABPACHKS(",DIC(0)="AQZ"
 .S DIC("A")="Select ACCOUNTING POINT: " W !! D ^DIC
 .I +Y<1 S NOACCT=1 Q
 .S ABPADFN(1)=+Y,ACCTPT="ACCOUNTING POINT = "_Y(0,0)
 .W ! S DX=0,DY=8 X XY D EOP^ABPAMAIN W !?(40-($L(ACCTPT)/2)),ACCTPT
 .I $D(^ABPACHKS(ABPADFN(1),"I",0))'=1 D
 ..S ^ABPACHKS(ABPADFN(1),"I",0)="^9002270.31PA^^"
 .;------------------------------------------------------------------
 .;PROCEDURE TO VERIFY PRINTING OF 'FINAL' COPIES OF TRANSMITTALS
 .S LLDT=$O(^ABPACHKS("TR",""))
 .I +LLDT>0,+LLDT<+DT,$D(^ABPACHKS("TR",LLDT,"N",ABPADFN(1)))'=0 D
 ..S DX=0,DY=21 X XY W !,*7
 ..W @(ABPARON),"*** WARNING ***  SWITCHING TO THE ACTIVE LOG DATED "
 ..W +$E(LLDT,4,5),"/",+$E(LLDT,6,7),"/",+$E(LLDT,2,3),@(ABPAROFF)
 ..K DIR S DIR(0)="EA",DIR("A")="Press [RETURN] to continue "
 ..D ^DIR S LOGDT=LLDT D HEAD
 ..W ! S DX=0,DY=8 X XY D EOP^ABPAMAIN W !?(40-($L(ACCTPT)/2)),ACCTPT
 .;------------------------------------------------------------------
 .;PROCEDURE TO CHECK FOR EXISTING PAYMENT BATCH
 .I $D(^ABPAPBAT(LOGDT,0))=1 W !!!?7 D  Q
 ..W *7,"<<< PAYMENT BATCH '",+$E(LOGDT,4,5)_"/"_+$E(LOGDT,6,7)_"/"
 ..W +$E(LOGDT,2,3),"' ALREADY EXIST - SESSION ABORTED >>>" H 3
 .;------------------------------------------------------------------
 .F ABPAL=0:0 S NOINS=0 D  I NOINS S LOGDT=DT D HEAD Q
 ..S DX=0,DY=10 X XY D EOP^ABPAMAIN
 ..K DIC,DA S DA(1)=ABPADFN(1),DIC="^ABPACHKS("_DA(1)_",""I"","
 ..S DIC(0)="AELQZ" I LOGDT'=DT S DIC(0)="AEQZ"
 ..S DIC("A")="Select THIRD PARTY PAYOR: " W !! D ^DIC
 ..I +Y<1 S NOINS=1 Q
 ..S ABPADFN(2)=+Y,ABPAINS="*** "_Y(0,0)_" ***" I $Y<58 D
 ...D HEAD W ! S DX=0,DY=8 X XY D EOP^ABPAMAIN
 ...W !?(40-($L(ACCTPT)/2)),ACCTPT
 ..S DX=0,DY=10 X XY D EOP^ABPAMAIN W !?(40-($L(ABPAINS)/2)),ABPAINS
 ..I $D(^ABPACHKS(ABPADFN(1),"I",ABPADFN(2),"C",0))'=1 D
 ...S ^ABPACHKS(ABPADFN(1),"I",ABPADFN(2),"C",0)="^9002270.311AI^^"
 ..S ABPACAP=ACCTPT
 ..F ABPAM=0:0 D  I 'GOTCHECK I ABPACHK="" S ACCTPT=ABPACAP Q
 ...S DX=0,DY=12 X XY D EOP^ABPAMAIN
 ...S RESTRICT=1,ABPASCR="I RR'=ABPADFN(2) S QFLG=""""",ABPA("LOG")=1
 ...D MAIN^ABPACKLK I 'GOTCHECK I ABPACHK="" Q
 ...I $A($E(X,1))=34!($A($E(X,$L(X)))=34) D  Q
 ....S ABPAMESS="'FORCING' DUPLICATE ENTRIES NOT ALLOWED"
 ....S ABPAMESS(2)="... Press any key to continue ..."
 ....W *7 D PAUSE^ABPAMAIN
 ...I 'GOTCHECK I LOGDT'=DT D  Q
 ....S ABPAMESS="YOU CANNOT ADD NEW ENTRIES TO AN OLD LOG "
 ....S ABPAMESS(2)="... Press any key to continue ..."
 ....W *7 D PAUSE^ABPAMAIN
 ...I 'GOTCHECK Q:Y']""  I $D(Y(0))=1 Q:Y(0)="NO"
 ...K DIC,DA S DA(2)=ABPADFN(1),DA(1)=ABPADFN(2)
 ...S DIC="^ABPACHKS("_DA(2)_",""I"","_DA(1)_",""C"",",DIC("DR")=3
 ...S DIC(0)="LZ" I LOGDT'=DT S DIC(0)="Z"
 ...I GOTCHECK S X=ABPACHK("NUM")
 ...W ! D ^DIC Q:+Y<1  S GOTCHECK=+Y
 ...I +$P(Y,"^",3)'=1 D  W ! Q
 ....;-------------------------------------------------------------
 ....;PROCEDURE TO EDIT A EXISTING LOG ENTRY
 ....K DIC,DIE,DA,DR
 ....S ABPADFN(3)=+Y,DA(2)=ABPADFN(1),DA(1)=ABPADFN(2)
 ....S DA=ABPADFN(3)
 ....S LDT=$P($P(^ABPACHKS(DA(2),"I",DA(1),"C",DA,0),"^",2),".")
 ....I $D(^ABPACHKS("TR",LDT,"N",DA(2),DA(1),DA))'=1 D  Q
 .....W *7,!?5,"<<< NO EDITING ALLOWED >>>" H 2
 ....S DIE="^ABPACHKS("_DA(2)_",""I"","_DA(1)_",""C"","
 ....S DR=".01;3;" I $D(ABPAOPT(1))=11 I ABPAOPT(1)="Y" S DR=DR_"14;"
 ....S DR=DR_"6///N;7///0" W ! D ^DIE I $D(DA)=0 D  Q
 .....K ^ABPACHKS("RB",ABPADFN(1),ABPADFN(2),ABPADFN(3))
 ....S RBAL=$P(^ABPACHKS(DA(2),"I",DA(1),"C",DA,0),"^",4)
 ....S DR="4///"_DUZ_";5///NOW;8///"_+RBAL_";11///N" D ^DIE
 ....;-------------------------------------------------------------
 ...K DIC,DIE,DR,DA
 ...S ABPADFN(3)=+Y,DA(2)=ABPADFN(1),DA(1)=ABPADFN(2),DA=ABPADFN(3)
 ...S DIE="^ABPACHKS("_DA(2)_",""I"","_DA(1)_",""C"",",DIE("NO^")=""
 ...S DR=".01;3;" I $D(ABPAOPT(1))=11 I ABPAOPT(1)="Y" S DR=DR_"14;"
 ...S DR=DR_"1///NOW;2///"_DUZ_";6///N;7///0" W ! D ^DIE
 ...Q:$D(DA)=0  S RBAL=$P(^ABPACHKS(DA(2),"I",DA(1),"C",DA,0),"^",4)
 ...S RBAL=RBAL-$P(^ABPACHKS(DA(2),"I",DA(1),"C",DA,0),"^",8)
 ...S DR="4///"_DUZ_";5///NOW;8///"_+RBAL_";11///N" D ^DIE
 Q
 ;--------------------------------------------------------------------
MAIN ;MAIN ROUTINE DRIVER PROCEDURE
 F ABPAJ=0:0 D CLEAR S LOGDT=DT D HEAD S NOACCT=0 D GETCHK I NOACCT Q
 D CLEAR K I
 Q
