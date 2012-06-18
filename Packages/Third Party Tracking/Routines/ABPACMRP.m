ABPACMRP ;CLOSE THE MONTHLY REPORTING PERIOD; [ 07/04/91  7:43 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 K ABPA("HD") S ABPA("HD",1)=ABPATLE
 S ABPA("HD",2)="Close the Monthly Reporting Period" D ^ABPAHD
 S Y=$E(DT,1,3),X=$E(DT,4,5) I +X'=1 S X=X-1 S:X<10 X=0_X S Y=Y_X_"00"
 E  S Y=(Y-1)_1200
 S ABPA("DT")=Y X ^DD("DD")
 I $D(^ABPAFAC(DUZ(2),1,ABPA("DT"),0))=1 D  Q
 .K ABPAMESS
 .S ABPAMESS="The '"_Y_"' reporting period has already been closed."
 .S ABPAMESS(2)="... Press any key to continue ..." D PAUSE^ABPAMAIN
 K DIR S DIR(0)="YA",DIR("A",1)="CLOSE THE '"_Y_"' REPORTING PERIOD!"
 S DIR("A")="    ARE YOU SURE?  " W !!!,*7 D ^DIR
 I Y D
 .I $D(^ABPAFAC(DUZ(2),1,0))=0 D
 ..S ^ABPAFAC(DUZ(2),1,0)="^9002270.08D^^0"
 .K DIC S DIC="^ABPAFAC("_DUZ(2)_",1,",DA(1)=DUZ(2),DIC(0)="L"
 .S X=ABPA("DT") W ! D ^DIC W !!,"All done!"
 .K ABPAMESS D PAUSE^ABPAMAIN
 K X,Y,ABPA("DT"),DIC,DA
 Q
 ;
CHECK ;ENTRY POINT - CHECK FOR CLOSED REPORTING PERIOD
 K CLOSED S CLOSED=1
 S Y=$E(DT,1,3),X=$E(DT,4,5) I +X'=1 S Y=Y_0_(X-1)_"00"
 E  S Y=(Y-1)_1200
 S ABPA("DT")=Y X ^DD("DD")
 I $D(^ABPAFAC(DUZ(2),1,ABPA("DT"),0))=1 Q
 E  D  S CLOSED=0
 .K ABPAMESS S ABPAMESS="POSTING DENIED - The '" W *7
 .S ABPAMESS=ABPAMESS_Y_"' reporting period has not been closed."
 .S ABPAMESS(2)="... Press any key to continue ..." D PAUSE^ABPAMAIN
