APSPCAN ;IHS/OHPRD/JCM - SHOW PROFILE THEN CANCEL MEDICATIONS; [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;Input variables: PSDFN,DFN
 ;
 ;variables: PSRXS,AMC,AMC1,AMC2,AMC3,PS,PSFROM,PSII,PSD,X
 ;------------------PSOZCAN("EN")
 ;
 ;External Calls: ^PSODSPL,ENM^PSOCAN1 ;IHS/DSD/ENM 03/27/97
 ;
 ;---------------------------------------------------------------
START ;
 N X,PSOFROM,PSOOPT S APSPDFN=PSODFN ;IHS/DSD/ENM 03/27/97
 S BC="LL" ;IHS/DSD/ENM 03/27/97
 D INIT
 ;IHS/DSD/ENM 03/27/97 NEXT 4 LINES DISABLED
 ;D ^PSODSPL ;----->Displays profile
 ;D ASK ;---------->Asks which prescriptions to cancel
 ;G:'$T!(PSRXS="")!(PSRXS["^") EXIT
 ;D EN^PSOCAN ;---->Does the actual cancellation or reinstating of rxs
 D ENM^PSOCAN1 ;IHS/DSD/ENM 03/27/97 ---->Does the actual cancellation or reinstating of rxs
 S:$G(PSODFN)']"" PSODFN=APSPDFN ;IHS/DSD/ENM 03/31/97
EXIT ;---------------->End of routine
 ;
 K PSOZCAN,PS,PSD,PSII,PSRXS,X,PSFROM,BC ;IHS/DSD/ENM 03/27/97
 Q
 ;-----------------------------------------------------------------
 ;
INIT ;
 S PSOZCAN("EN")=""
 K PSD
 S PSFROM="R",PSII=0
 S PS="CANCEL"
 Q
 ;
ASK ;
 K X
 S DIR("A")="CHOOSE FROM ",DIR("?")="SELECT A NUMBER",DIR(0)="L^1:"_PSII D ^DIR S PSRXS=Y K DIR ;IHS/DSD/ENM 01/09/97
 ;W !,"CHOOSE 1 - ",PSII," > "
 G:'$T!(PSRXS="")!(PSRXS["^") ASKX
 I PSRXS'?1N.E D QUES G START
 I +PSRXS>PSII S X=PSRXS G ASKX
 F AMC=1:1 S AMC1=$P(PSRXS,",",AMC) Q:AMC1=""  S AMC3="" F AMC2=1:1:AMC1 S AMC3=$O(PSD(AMC3)) Q:'AMC3  I AMC2=AMC1 S X=$S($D(X):X_","_$P(^PSRX(+PSD(AMC3),0),U,1),1:$P(^PSRX(+PSD(AMC3),0),U,1)) ;IHS/DSD/ENM 11/15/96
ASKX ;Exit for ASK subroutine
 K AMC,AMC1,AMC2,AMC3
 Q
QUES ;
 W !?5,"Enter the item #(s) or RX #(s) you wish to cancel seperated by commas."
 W !?5,"For example: 1,2,5 or 123456,33254A,232323B."
 W !?5,"Do not enter the same number twice, duplicates are not allowed."
 Q
