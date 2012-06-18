AQAOPU1 ; IHS/ORDC/LJF - INDICATOR SELECTION ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an extrinsic function called by various reports
 ;to select facility-defined report format.  These formats contain a
 ;defined set of grouped indicators.
 ;
FACR(AQAOSUB) ;ENTRY POINT EXTR FUNC - select facility specific report to run
 K ^TMP(AQAOSUB,$J) ;PATCH 1
 S AQAOTYP=Y ;set report type
 ;
 ; >> user gets choice of facilities if user has access >1 site
 S AQAOFAC=DUZ(2),X=$O(^VA(200,DUZ,2,0)) I X]"" D
 .S X=$O(^VA(200,DUZ,2,X)) I X]"" D
 ..W !! K DIC S DIC="^AQAGP(",DIC(0)="AEMZQ"
 ..S DIC("A")="Select FACILITY first:  " D ^DIC
 ..I Y<1 S AQAOTYP=U
 ..E  S AQAOFAC=+Y
 I AQAOTYP=U Q AQAOTYP
 ;
 ; >> user selects report format
 I '$D(^AQAGP(AQAOFAC,"FACRPT",0)) S ^(0)="^9002166.41"
 W !! K DIC,DA S DIC="^AQAGP("_AQAOFAC_",""FACRPT"",",DIC(0)="AEMZQ"
 S DIC("S")="I '$O(^AQAGP(AQAOFAC,""FACRPT"",Y,""RES"",0))!$D(^AQAGP(AQAOFAC,""FACRPT"",Y,""RES"",""B"",DUZ))" ;PATCH 1
 S DA(1)=AQAOFAC D ^DIC I Y<1 S AQAOTYP=U Q AQAOTYP
 S AQAORPT=Y ;report name & number
 S AQAORPTT=$P(^AQAGP(AQAOFAC,"FACRPT",+AQAORPT,0),U,2) ;report title
 ;
 ; >> find contents of report selected
 F AQAOI="MSF","HW","KF","IND","DIM" D
 .S AQAOX=0 ;for each heading, find indicators
 .F  S AQAOX=$O(^AQAGP(AQAOFAC,"FACRPT",+AQAORPT,AQAOI,AQAOX)) Q:AQAOX'=+AQAOX  D
 ..Q:'$D(^AQAGP(AQAOFAC,"FACRPT",+AQAORPT,AQAOI,AQAOX,0))  S AQAOS=+^(0)
 ..I (AQAOI="HW")!(AQAOI="IND") S Y=AQAOS D INDCHK^AQAOPU,SET Q
 ..;
 ..I AQAOI="DIM" D DIMCHK Q
 ..S AQAOC=$S(AQAOI="MSF":"AD",1:"AB") ;xref in qi ind file
 ..S Y=0 F  S Y=$O(^AQAO(2,AQAOC,AQAOS,Y)) Q:Y=""  D INDCHK^AQAOPU,SET
 ;
 ; >> display indicators included in report
 D DISPLAY
 ;
 Q AQAOTYP
 ;
 ;
SET ; >> SUBRTN to set indicator array
 I (AQAOI="MSF")!(AQAOI="KF") Q:$G(AQAOCHK("OK"))="I"  ;inactive ind
 I AQAOI="HW" S AQAOF="FACILITY WIDE INDICATORS" ;PATCH 2
 I AQAOI="IND" S AQAOF="OTHER INDICATORS"
 I AQAOI="KF" S AQAOF="KEY FUNCTION - "_$P(^AQAO(1,AQAOS,0),U)
 I AQAOI="MSF" D
 .S AQAOZ=Y,Y=AQAOS,C=$P(^DD(9002168.2,.13,0),U,2) D Y^DIQ
 .S AQAOF="MED STAFF FUNCTION - "_Y,Y=AQAOZ
 I AQAOI="DIM" S AQAOF="DIMENSION - "_$P($T(DIM+AQAOS),";;",2) ;ENH1
 I $D(AQAOCHK("OK")) S ^TMP(AQAOSUB,$J,1,AQAOF,Y)=""
 E  S ^TMP(AQAOSUB,$J,2,$P(^AQAO(2,Y,0),U))=""
 Q
 ;
 ;
DISPLAY ; >> SUBRTN to display indicators found for report
 S X="Facility Specific Report:  "_$P(AQAORPT,U,2) W @IOF,!!,X
 W !!,"Indicators To Be Included In This Report:"
 I '$D(^TMP(AQAOSUB,$J,1)) W !!,"NONE FOUND" S AQAOTYP=U G DSPLY9
 S X=0 F  S X=$O(^TMP(AQAOSUB,$J,1,X)) Q:X=""  Q:$G(AQAOSTOP)=U  D
 .W !!,"HEADING: ",X
 .S Y=0 F  S Y=$O(^TMP(AQAOSUB,$J,1,X,Y)) Q:Y=""  Q:$G(AQAOSTOP)=U  D
 ..W !?9,$P(^AQAO(2,Y,0),U),?20,$P(^(0),U,2)
 ..I $Y>(IOSL-4) S AQAOSTOP=$$EOP^AQAOPU Q:AQAOSTOP=U
 I $D(^TMP(AQAOSUB,$J,2)) D
 .W !!,"Indicators NOT To Be Included: (You do not have access to them)"
 .S X=0 F  S X=$O(^TMP(AQAOSUB,$J,2,X)) Q:X=""  D
 ..W !?5,X
 ..I $Y>(IOSL-4) S AQAOSTOP=$$EOP^AQAOPU Q:AQAOSTOP=U
DSPLY9 W !! K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
 Q
 ;
 ;
DIMCHK ; -- SUBRTN to find indicators tied to dimension
 NEW Y,X S Y=0
 F  S Y=$O(^AQAO(2,"ADIM",AQAOS,Y)) Q:Y=""  D INDCHK^AQAOPU,SET
 S X=0
 F  S X=$O(^AQAO1(6,"ADIM",AQAOS,X)) Q:X=""  D
 . S Y=0
 . F  S Y=$O(^AQAO1(6,X,"IND","B",Y)) Q:Y=""  D INDCHK^AQAOPU,SET
 Q
 ;
 ;
DIM ;;
 ;;EFFICACY
 ;;APPROPRIATENESS
 ;;AVAILABILITY
 ;;TIMELINESS
 ;;EFFECTIVENESS
 ;;CONTINUITY
 ;;SAFETY
 ;;EFFICIENCY
 ;;RESPECT & CARING
