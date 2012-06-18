ACDVIMP1 ;IHS/ADC/EDE/KML - BUILD CDMIS ENTRIES FROM IMPORTED GLOBAL; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;******************************************************************
 ;Build CDMIS data files on area/HQ machine from the ^ACDVTMP global
 ;that has just been imported to the area/HQ machine
 ;****************************************************************
EN ;EP
 ;//^ACDVIMP
 ;Check for existence of data
 I '$D(^ACDVTMP) W !,"No data to import..." Q
 ;
 ;Validate incomming ASUFAC's are in the area location file
 ;ACDUSER is in the form 'DUZ(2)^PROGRAM ASSOCIATED WITH VISIT'
 ;Phoenix may have several programs in their database because they
 ;will have outlying facilities dialing in to use CDMIS.
 ;
 W !! K ACDQUIT S ACDUSER="" F  S ACDUSER=$O(^ACDVTMP(ACDUSER)) Q:ACDUSER=""  W !,"Checking for the existence of ASUFAC: ",$P(ACDUSER,"*",2)," in your location file." I '$O(^AUTTLOC("C",$P(ACDUSER,"*",2),0)) S ACDQUIT=1 W *7," Missing.",!
 I $D(ACDQUIT) W !!,"Aborted...Contact your site manager immediately.." S ^ACDV1TMP=1 Q
 E  W !!,"All facility codes exist. Proceeding with rebuild...",!
 ;
 S ACDUSER="" F  S ACDUSER=$O(^ACDVTMP(ACDUSER)) Q:ACDUSER=""  F ACDV=0:0 S ACDV=$O(^ACDVTMP(ACDUSER,ACDV)) Q:'ACDV  D:$D(^(ACDV,"P")) L I $D(^ACDVTMP(ACDUSER,ACDV,"V")) S ACD("V")=^("V") D FILEV,L W "."
 I $D(^ACDV1TMP) W !!,"Since this import is finished, now killing the ^ACDV1TMP global flag." K ^ACDV1TMP ;       kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
 Q
L ;Get data from link files
 I $D(^ACDVTMP(ACDUSER,ACDV,"P")) D P Q
 I $D(^ACDVTMP(ACDUSER,ACDV,"IIF")) D IIF Q
 I $D(^ACDVTMP(ACDUSER,ACDV,"TDC")) D TDC Q
 I $D(^ACDVTMP(ACDUSER,ACDV,"CS")) D CS Q
 Q
IIF ;Get entry to file into ^ACDIIF
 F ACDDA=0:0 S ACDDA=$O(^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA)) Q:'ACDDA  S ACD("IIF")=^(ACDDA) D FILEIIF
 Q
TDC ;Get entry to file into ^ACDTDC
 F ACDDA=0:0 S ACDDA=$O(^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA)) Q:'ACDDA  S ACD("TDC")=^(ACDDA) D FILETDC
 Q
CS ;Get entry to file into ^ACDCS
 F ACDDA=0:0 S ACDDA=$O(^ACDVTMP(ACDUSER,ACDV,"CS",ACDDA)) Q:'ACDDA  S ACD("CS")=^(ACDDA) D FILECS
 Q
P ;Get entry to file into ^ACDPD
 S ACD("P")=^ACDVTMP(ACDUSER,ACDV,"P") D FILEP
 Q
FILEIIF ;File entry into ^ACDIIF
 S DIC="^ACDIIF(",X=$P(ACD("IIF"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDIIF(+Y,0)=ACD("IIF"),^("BWP")=ACDBWP
 S ACDIIF=+Y
 F ACDMULT=2,3 F ACDMLEV=0:0 S ACDMLEV=$O(^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA,$S(ACDMULT=2:"DRUG",1:"SECPROB"),ACDMLEV)) Q:'ACDMLEV  D
 .S DA(1)=ACDIIF,DIC="^ACDIIF("_DA(1)_","_ACDMULT_",",DIC(0)="L",X=ACDMLEV S:'$D(@(DIC_"0)")) @(DIC_"0)")="^9002170."_$S(ACDMULT=2:"05",1:"01")_"PA" D FILE^ACDFMC
 .K ^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA,$S(ACDMULT=2:"DRUG",1:"SECPROB"),ACDMLEV)
 S DA=ACDIIF,DIK="^ACDIIF(" D IX1^DIK
 K ^ACDVTMP(ACDUSER,ACDV,"IIF",ACDDA)
 Q
FILETDC ;File entry into ^ACDTDC
 S DIC="^ACDTDC(",X=$P(ACD("TDC"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDTDC(+Y,0)=ACD("TDC"),^("BWP")=ACDBWP
 S ACDTDC=+Y
 F ACDMULT=2,3 F ACDMLEV=0:0 S ACDMLEV=$O(^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA,$S(ACDMULT=2:"DRUG",1:"SECPROB"),ACDMLEV)) Q:'ACDMLEV  D
 .S DA(1)=ACDTDC,DIC="^ACDTDC("_DA(1)_","_ACDMULT_",",DIC(0)="L",X=ACDMLEV S:'$D(@(DIC_"0)")) @(DIC_"0)")="^9002171."_$S(ACDMULT=2:"02",1:"0102")_"PA" D FILE^ACDFMC
 .K ^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA,$S(ACDMULT=2:"DRUG",1:"SECPROB"),ACDMLEV)
 S DA=ACDTDC,DIK="^ACDTDC(" D IX1^DIK
 K ^ACDVTMP(ACDUSER,ACDV,"TDC",ACDDA)
 Q
FILECS ;File entry into ^ACDCS
 S DIC="^ACDCS(",X=$P(ACD("CS"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDCS(+Y,0)=ACD("CS"),^("BWP")=ACDBWP
 S ACDCS=+Y
 K ^ACDVTMP(ACDUSER,ACDV,"CS",ACDDA)
 S DA=ACDCS,DIK="^ACDCS(" D IX1^DIK
 Q
FILEV ;File visit into ^ACDVIS
 S DIC="^ACDVIS(",X=$P(ACD("V"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDVIS(+Y,0)=ACD("V")
 S ACDBWP=+Y
 S ACDPG=$O(^AUTTLOC("C",$P(ACDUSER,"*",2),0))
 I '$D(^ACDF5PI(ACDPG,0)) S DIC="^ACDF5PI(",DIC(0)="L",X=ACDPG,DINUM=X D FILE^ACDFMC
 S DIE="^ACDVIS(",DA=ACDBWP,DR="99.99///^S X=ACDPG" D DIE^ACDFMC
 S DA=ACDBWP,DIK="^ACDVIS(" D IX1^DIK
 K ^ACDVTMP(ACDUSER,ACDV,"V")
 Q
FILEP ;File entry into ^ACDPD
 S DIC="^ACDPD(",X=$P(ACD("P"),U),DIC(0)="L" D FILE^ACDFMC
 S ^ACDPD(+Y,0)=ACD("P")
 S ACDP=+Y
 S ACDPG=$O(^AUTTLOC("C",$P(ACDUSER,"*",2),0))
 I '$D(^ACDF5PI(ACDPG,0)) S DIC="^ACDF5PI(",DIC(0)="L",X=ACDPG,DINUM=X D FILE^ACDFMC
 S DIE="^ACDPD(",DA=ACDP,DR="3///^S X=ACDPG" D DIE^ACDFMC
 F ACDAY=0:0 S ACDAY=$O(^ACDVTMP(ACDUSER,ACDV,"P","DAY",ACDAY)) Q:'ACDAY  S ACD("P")=^(ACDAY) D
 .S DA(1)=ACDP,DIC="^ACDPD("_DA(1)_",1,",DIC(0)="L",X=ACDAY S:'$D(@(DIC_"0)")) @(DIC_"0)")="^9002170.75A" D FILE^ACDFMC S ^ACDPD(ACDP,1,+Y,0)=ACD("P")
 .K ^ACDVTMP(ACDUSER,ACDV,"P","DAY",ACDAY)
 S DA=ACDP,DIK="^ACDPD(" D IX1^DIK
 K ^ACDVTMP(ACDUSER,ACDV,"P")
 Q
