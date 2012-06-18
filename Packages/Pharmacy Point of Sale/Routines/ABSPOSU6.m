ABSPOSU6 ; IHS/FCS/DRS - utilities, continued ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
COMMSLOG ;EP - ABSPOSC2 ; ABSP COMMS LOG VIEW option
 ; choose which dial out
 N DIC,X,DTIME,DLAYGO,DINUM,Y,DTOUT,DUOUT
 N DIR,DA,DIRUT
 N POP,DIALOUT ; DIALOUT points to 9002313.55
 N LOGFILEN ; points to piece in ^ABSP(9002313.55,DIALOUT,"LOG FILE")
 N LOGSLOT ; points to ^ABSPECX("LOG",
 S DIC=9002313.55,DIC(0)="AEM"
 S DIC("A")="DISPLAY log file for which Dial Out: "
 D
 . N X S X=$$DEF5599^ABSPOSA Q:'X
 . S DIC("B")=$P(^ABSP(9002313.55,X,0),U)
 D ^DIC W !
 Q:Y<0  S DIALOUT=+Y
 N LOGFILES S LOGFILES=$G(^ABSP(9002313.55,DIALOUT,"LOG FILE"))
 I LOGFILES?."^" D  Q
 . W !,"There are no log files available for this dial out.",!
 ; ask for device
 D ^%ZIS Q:$G(POP)
 S LOGFILEN=1
 ; display log file
C1 S LOGSLOT=$P(LOGFILES,U,LOGFILEN)
 U IO D PRINTLOG^ABSPOSL(LOGSLOT)
 ; ask if you want to see previous file
 U $P
 I $P(LOGFILES,U,LOGFILEN+1)="" G C2 ; no more log files, you're done
 S DIR(0)="YO",DIR("A")="Want to see the previous log file"
 D ^DIR W !
 I Y S LOGFILEN=LOGFILEN+1 G C1
C2 ;
 D ^%ZISC
 Q
