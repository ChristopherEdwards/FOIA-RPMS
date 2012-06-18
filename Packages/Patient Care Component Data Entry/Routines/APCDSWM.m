APCDSWM ; IHS/CMI/LAB - SWITCH TO V FILE ;
 ;;2.0;IHS PCC SUITE;**4,5**;MAY 14, 2009
 ;
 ; APCDSWD=DICTIONARY NUMBER
 ; APCDSWCR=LINKING CROSS REFERENCE
 ; APCDSWV=VISIT DFN
 ;
EPLKW ;EP
 NEW APCDSWMT
 S APCDSWMT="LKW"
 D EP
 K APCDSWMV
 Q
EP ;EP
 D EN^XBNEW("EN^APCDSWM","APCDVSIT;APCDMNE;APCDSWMV;APCDSWMT")
 Q
EN ;
 NEW APCDSWDA,APCDSWMV,APCDVM01,APCDVM04,APCDSWCT,APCDSWA,APCDSWAN,APCDSWX,APCDSWT,APCDSWI
 NEW X,Y,DIR
EN0 ;
 W !!,"Please Note:  You are NOT permitted to modify or delete a measurement."
 W !,"A measurement must be marked as 'entered in error' and then re-entered "
 W !,"through Add or Append mode of PCC data entry."
 ;
 S APCDSWCT=0
 K APCDSWA
 ;S APCDSWMV=$P($G(^APCDTKW(APCDMNE,0)),U,5),APCDSWMV=$TR(APCDSWMV,"""","")
 S APCDSWDA=0 F  S APCDSWDA=$O(^AUPNVMSR("AD",APCDVSIT,APCDSWDA)) Q:APCDSWDA'=+APCDSWDA  D
 .Q:$P($G(^AUPNVMSR(APCDSWDA,2)),U,1)  ;don't display those entered in error
 .S APCDVM01=$$VAL^XBDIQ1(9000010.01,APCDSWDA,.01)
 .;S APCDVM04=$$VAL^XBDIQ1(9000010.04,APCDSWDA,.04)
 .I $G(APCDSWMT)]"",APCDVM01'=APCDSWMT Q
 .S APCDSWCT=APCDSWCT+1
 .S APCDSWA(APCDSWCT)=APCDSWDA
 I '$D(APCDSWA) W !!,"There are no ",$S($G(APCDSWMV)]"":APCDSWMV_" ",1:""),"measurements on this visit." Q
 D SELECTM
 Q
 ;
SELECTM ;
 ;select the measurement to edit or delete
 W !,"Please choose which measurement you would like to mark 'Entered in Error',"
 W !,"if you do not wish to mark any in error, simply press 'enter' to bypass."
 S APCDSWX=0,APCDSWT=0 F  S APCDSWX=$O(APCDSWA(APCDSWX)) Q:APCDSWX'=+APCDSWX  D
 .S APCDSWDA=APCDSWA(APCDSWX),APCDSWT=APCDSWX
 .S APCDVM01=$$VAL^XBDIQ1(9000010.01,APCDSWDA,.01)
 .S APCDVM04=$$VAL^XBDIQ1(9000010.01,APCDSWDA,.04)
 .W !?2,APCDSWX,")",?7,APCDVM01,?14,APCDVM04
 K DIR
 S DIR(0)="NO^1:"_APCDSWT_":0",DIR("A")="Which Measurement",DIR("?")="Enter a number from the list above (1-"_APCDSWT_" or 'N' to exit." KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I X="" Q
 I Y="" Q
 I '$D(APCDSWA(X)) W !,"Invalid response.  Please enter a number from 1 to ",APCDSWT," or N." G SELECTM
 S APCDSWI=Y
 S APCDSWDA=APCDSWA(X)
 K DIR
 W !,"You have selected: ",$$VAL^XBDIQ1(9000010.01,APCDSWDA,.01),"   Value: ",$$VAL^XBDIQ1(9000010.01,APCDSWDA,.04)
 S DIR(0)="Y",DIR("A")="Are you sure you want to mark this measurement entered in error",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 Q:'Y
 Q:$D(DIRUT)
 D ENTINERR(APCDSWDA)
 Q
ENTINERR(APCDSWDA) ;EP
 I '$D(APCDSWDA) Q
 I '$D(^AUPNVMSR(APCDSWDA,0)) W !!,"invalid v measurement...." Q
 W !,"Please enter the reason the measurement was entered in error.  Choices are:"
 W !?10,"1    INCORRECT DATE/TIME"
 W !?10,"2    INCORRECT READING"
 W !?10,"3    INCORRECT PATIENT"
 W !?10,"4    INVALID RECORD"
 S DA=APCDSWDA,DIE("NO^")=1,DIE="^AUPNVMSR(",DR="[APCD MEAS ENTERED IN ERROR]" D ^DIE K DA,DR,DIE
 Q
MODQUAL ;
 I '$D(APCDSWDA) Q
 I '$D(^AUPNVMSR(APCDSWDA,0)) W !!,"invalid v measurement...." Q
 S DA=APCDSWDA,DIE="^AUPNVMSR(",DR=5 D ^DIE K DA,DR,DIE
 Q
