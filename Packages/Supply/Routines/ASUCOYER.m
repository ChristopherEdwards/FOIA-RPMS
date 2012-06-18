ASUCOYER ; IHS/ITSC/LMH -YEARLY CLOSEOUT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine controls a Yearly closeout (first day of new FY) update
 ;run
 S ASUV("RPQ")="",ASUP("TYP")=2
 D CLS^ASUUHDG,^ASUCOSTS
 W !?20,"Yearly Closeout Process Running",!
 D SETCTRL^ASUCOSTS
 D ^ASUCORUN  Q:'ASUP("OK")  G:ASUP("RE*") UPDT
 D SETRUN^ASUUDATE
 I ASUP("LSTY")=1,$E(ASUP("LSMO"),2)=9 D
 .D CKOK
 E  D  G:ASUP("HLT") KILL
 .I ASUP("LSTY")=1 D  Q
 ..W *7,!?25,"**** ERROR ****",!
 ..;beginnig Y2K fix 
 ..;S Y=2_$E(ASUP("LSMO"),3,4)_$E(ASUP("LSMO"),1,2) X ^DD("DD")
 ..D START^ASUUY2K(ASUP("LSMO"),1,U,"N") X ^DD("DD")   ;Y2000
 ..;end Y2K fix block
 ..W !,"The last monthly closeout was for the month of ",Y
 ..S DIR(0)="E",DIR("A")="Yearly runs must be done after the September monthly closeout" D ^DIR
 ..S ASUP("HLT")=1
 .I ASUP("LSTY")=1,$E(ASUP("LSMO"),2)=8 D  Q
 ..W *7,!!?25,"**** ERROR ****",!!
 ..W !,"The month of September is not closed out (Monthly closeout not completed)",!
 ..W !,"A monthly closeout must be completed for September."
 ..S DIR(0)="E",DIR("A")="After it has been completed, redo the yearly closeout" D ^DIR
 ..K DIR S ASUP("HLT")=1
 .I ASUP("LSTY")'=1,$E(ASUP("LSMO"),2)=9 D  Q:ASUP("HLT")
 ..W *7,!!?25,"**** WARNING ****",!!
 ..W !,"September has been closed out, but last update was not the monthly closeout.",!,"If you close out the fiscal year, data processed since the September closeout",!,"may be lost in some of your reports and files.",!
 ..S DIR(0)="Y",DIR("A")="Are you sure you want to close out the fiscal year" D ^DIR
 ..K DIR
 ..Q:$D(DTOUT)  Q:$D(DUOUT)
 ..I Y D
 ...D CKOK
 ..E  S ASUP("HLT")=1
 .I ASUP("TYP")=2 D
 ..W *7,!!?25,"**** ERROR ****",!!
 ..W !,"The last update was a yearly closeout which has successfully completed",!!
 ..K DIR S DIR(0)="E",DIR("A")="**** Contact your supervisor if you wish to re-run it ****" D ^DIR
 .E  D
 ..W *7,!!?25,"**** ERROR ****",!!
 ..W !,"The last update was other than a monthly closeout, and the last monthly was not",!,"for either September or August.",!!
 ..K DIR S DIR(0)="E",DIR("A")="**** Contact your supervisor to resolve the problem ****" D ^DIR
 .S ASUP("HLT")=1
 G:$D(DTOUT) KILL
 G UPDT
UPDT ;
 I 'ASUP("RE*") S ASUP("LSYR")=ASUP("MOYR") D SETLM^ASUCOSTS
 ;D YEARCLR^ASUMCUPD
 S ASUP("RE*")=+$G(ASUP("RE*"))
 S ASUP("CKP")=$G(ASUP("CKP"))
 S (ASUP("STP"),ASUP("IVS"),ASUP("SRP"))="N"
 D SETTY^ASUCOSTS
 S ASUP("CKP")=7
 D CLYR^ASUMKBPS
 I ASUP("CKY")'=5 S ASUP("HLT")=1
 ;D ^ASUCOHKP Q:ASUP("HLT")
 ;S ASUP("CKP")=5 D SETSTAT^ASUCOSTS
 S ASUP("CKY")=0,ASUP("CKP")=0 D SETSTAT^ASUCOSTS
 G:$G(ASUP("HLT"))=1 KILL
 D STAT^ASUCOKIL
 Q
KILL ;
 D SETSTAT^ASUCOSTS
 D ^ASUCOKIL
 K ASUP("LST"),ASUF
 Q:ASUP("HLT")
 S ASUP("CKY")=0 D SETSY^ASUCOSTS S ASUP("CKP")=2 D SETSP^ASUCOSTS
 S ASUP("CKP")=0 D SETSTAT^ASUCOSTS ;Set Status to run sucessfully completed
 D ^ASUCOKIL,STAT^ASUCOKIL ;Kill all normal variables
 K ASUP Q
END ;
 K ASUP,ASUF,DTOUT,DUOUT
 Q
CKOK ;
 S ASUP("MOYR")=10_ASUK("DT","CFY")
 I ASUP("MOYR")=ASUP("LSYR") D
 .W !,"The yearly closeout for ",ASUP("MOYR")," has already successfully completed"
 .K DIR S DIR(0)="E",DIR("A")="**** Contact your supervisor if you wish to re-run it ****" D ^DIR
 .S ASUP("HLT")=1
 E  D
 .D DT^DILF("E",1000_ASUK("DT","CFY"),.X)
 .W !,"Year end closeout run will be first processing of Month and FISCAL year ",!?30,X(0)
 .K DIR S DIR(0)="Y",DIR("B")="Y",DIR("A")="Is that correct" D ^DIR
 .I 'Y S ASUP("HLT")=1,DUOUT=1
 Q
