AQAOPU ; IHS/ORDC/LJF - INIDICATOR SELECTION ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains 2 extrinsic functions called by various reports
 ;to select a single indicator or all indicators for a key function.
 ;
IND(AQAOSUB) ;EP >> EXTR FUNC - select indicator and set array
 S AQAOTYP=Y
 W !! K DIC S DIC=9002168.2,DIC(0)="AEMZQ"
 S DIC("S")="D INDCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 D ^DIC K DIC I Y=-1 S AQAOTYP=U
 E  S ^TMP(AQAOSUB,$J,1,"SINGLE INDICATOR",+Y)=""
 Q AQAOTYP
 ;
 ;
KF(AQAOSUB) ;EP >> EXTR FUNC - select key func & all indicators under it
 S AQAOTYP=Y ;set type of report
 W !! K DIC S DIC=9002168.1,DIC(0)="AEMZQ" D ^DIC
 I Y>0 D
 .S AQAOF="KEY FUNCTION - "_$P(Y,U,2) ;if funct, find ind linked to it
 .S AQAOFN=+Y
 .S Y=0 F  S Y=$O(^AQAO(2,"AB",AQAOFN,Y)) Q:Y=""  D
 ..D INDCHK ;is indicator active and does user have access to it?
 ..I $G(AQAOCHK("OK"))="I" Q  ;screen out inactives from display
 ..I $D(AQAOCHK("OK")) S ^TMP(AQAOSUB,$J,1,AQAOF,Y)=""
 ..E  S ^TMP(AQAOSUB,$J,2,$P(^AQAO(2,Y,0),U))=""
 .;
 .D DISPLAY ;display indicators included in report
 E  S AQAOTYP=U
 Q AQAOTYP
 ;
 ;
EOP() ;ENTRY POINT - EXTR VAR to handle end of screen code
 N X,DIR,AQAOSTOP
 S DIR("A")="Press RETURN to continue OR ""^"" to quit display."
 S DIR(0)="E" D ^DIR S AQAOSTOP=$S(Y=1:"",1:U)  I AQAOSTOP="" W @IOF,!
 Q AQAOSTOP
 ;
 ;
INDCHK ;ENTRY POINT >> SUBRTN to check indicator screens
 K AQAOCHK("OK")
 Q:$G(Y)<1  ;Y must be set to indicator ifn
 X ^DD(9002168.2,0,"SCR") I '$T S AQAOCHK("OK")="I" Q
 D INDCHK^AQAOSEC
 Q
 ;
 ;
DISPLAY ; >> SUBRTN to display indicators found for report
 D INIT^AQAOUTIL W @IOF,!!?AQAOIOMX-$L(AQAOF)/2,AQAOF
 W !!,"Indicators To Be Included In This Report:"
 I '$D(^TMP(AQAOSUB,$J,1)) W !!,"NONE FOUND" S AQAOTYP=U Q
 S X=0 F  S X=$O(^TMP(AQAOSUB,$J,1,AQAOF,X)) Q:X=""  Q:$G(AQAOSTOP)=U  D
 .W !?5,$P(^AQAO(2,X,0),U),?20,$P(^(0),U,2)
 .I $Y>(IOSL-4) S AQAOSTOP=$$EOP Q:AQAOSTOP=U
 I $D(^TMP(AQAOSUB,$J,2)) D
 .W !!,"Indicators NOT To Be Included: (You do not have access to them)"
 .S X=0 F  S X=$O(^TMP(AQAOSUB,$J,2,X)) Q:X=""  D
 ..W !?5,X
 ..I $Y>(IOSL-4) S AQAOSTOP=$$EOP Q:AQAOSTOP=U
 Q
 ;
 ;
