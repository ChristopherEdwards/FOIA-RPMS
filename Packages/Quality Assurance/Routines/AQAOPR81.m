AQAOPR81 ; IHS/ORDC/LJF - INDICATOR MATRIX CONINUED ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine prints a list of indicators grouped by the functions
 ;selected by the user and by dimensions of performance if also
 ;selected.
 ;Added for Enhancement #1
 ;
INIT ; -- initialize variables for report
 S AQAOTY="CLINICAL INDICATOR MATRIX" D INIT^AQAOUTIL
 S X=AQAOIOMX X ^%ZOSF("RM")
 D COVER,NEWPG^AQAOUTIL,HDG2
 ;
LOOP ; -- loop thru indicators by code number
 S AQAOC=0
 F  S AQAOC=$O(^AQAO(2,"B",AQAOC)) Q:AQAOC=""  Q:AQAOSTOP=U  D
 . S AQAON=0
 . F  S AQAON=$O(^AQAO(2,"B",AQAOC,AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 .. Q:'$D(^AQAO(2,AQAON,0))
 .. Q:$$VAL^XBDIQ1(9002168.2,AQAON,.06)="INACTIVE"
 .. S Y=AQAON D INDCHK^AQAOSEC I '$D(AQAOCHK("OK")) Q  ;chk access
 .. I AQAOSEL=1 Q:'$$FNCYES  ;not linked to functions selected
 .. I AQAOSEL=2 Q:'$$DIMYES  ;not linked to any dimensions
 .. I AQAOSEL=3,'$$FNCYES,'$$DIMYES Q  ;not linked to anything
 .. I $Y>(IOSL-3) D NEWPG Q:AQAOSTOP=U  D HDG2
 .. W !,AQAOC,?11
 .. I AQAOSEL'=2 D FUNCTION Q:AQAOSTOP=U
 .. I AQAOSEL'=1 D CRITERIA Q:AQAOSTOP=U
 .. D TEAMS Q:AQAOSTOP=U
 .. I AQAOCRT D CRITLIST
 ;
 ;
EXIT ; -- eoj
 S X=80 X ^%ZOSF("RM")
 I '$D(ZTQUEUED),(IOST["C-") D PRTOPT^AQAOVAR
 D ^%ZISC K AQAOFNC,AQAOSEL,AQAOCRT D KILL^AQAOUTIL
 Q
 ;
 ;
COVER ; -- SUBRTN to print cover page for report
 D NEWPG^AQAOUTIL
 S X="COVER PAGE" W ?AQAOIOMX-$L(X)\2,X,!,AQAOLINE,!
 ;
 I AQAOSEL'=2 W !!?3,"KEY FUNCTIONS SELECTED:",!
 S AQAOX=0
 F  S AQAOX=$O(AQAOFNC(AQAOX)) Q:AQAOX=""  D
 . I $Y>(IOSL-3) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  W !,AQAOLINE,!
 . W !?3,"F",$E("0"_AQAOX,$L(AQAOX),$L(AQAOX)+1)
 . W ?10,$P(AQAOFNC(AQAOX),U,2)
 ;
 Q:AQAOSEL=1
 W !!?3,"DIMENSIONS OF PERFORMANCE:",!
 F AQAOI=1:1:9 W !?3,"DP",AQAOI,?10,$P($T(DIM+AQAOI),";;",2)
 Q
 ;
 ;
FUNCTION ; -- SUBRTN to mark which functions indicator is linked to
 NEW AQAOX
 S AQAOX=0 F  S AQAOX=$O(AQAOFNC(AQAOX)) Q:AQAOX=""  D
 . W "  "
 . W $S($D(^AQAO(2,AQAON,"AOC","B",+AQAOFNC(AQAOX))):"X",1:" ")
 . W "  "
 Q
 ;
 ;
CRITERIA ; -- SUBRTN to mark which dimensions indicator is linked to
 NEW AQAOI,X,C
 F AQAOI=1:1:9 D
 . W "  "
 . S X=$S($D(^AQAO(2,AQAON,"DIM","B",AQAOI)):"X",1:" ")
 . I X="X" W X,"  " Q
 . S (X,C)=0
 . F  S C=$O(^AQAO1(6,"C",AQAON,C)) Q:C=""  Q:X=1  D
 .. W $S($D(^AQAO1(6,C,"DIM","B",AQAOI)):"X",1:" "),"  " S X=1
 Q
 ;
 ;
TEAMS ; -- SUBRTN to print teams linked to indicator
 NEW AQAOX,AQAO,AQAOCOL S AQAOCOL=$X+2
 D ENPM^XBDIQ1(9002168.25,AQAON_",0",.01,"AQAO(","I")
 S AQAOX=0
 F  S AQAOX=$O(AQAO(AQAOX)) Q:'AQAOX  Q:AQAOSTOP=U  D
 . W ?AQAOCOL,$$VALI^XBDIQ1(9002169.1,AQAO(AQAOX,.01,"I"),.02),!
 . I $Y>(IOSL-3) D NEWPG Q:AQAOSTOP=U  D HDG2
 Q
 ;
 ;
CRITLIST ; -- SUBRTN to print review criteria for each indicator
 NEW AQAOX,AQAOD
 S AQAOX=0
 F  S AQAOX=$O(^AQAO1(6,"C",AQAON,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 . W:$X>3 ! W "CR",AQAOX
 .; W $S(AQAOSEL=2:$$VAL^XBDIQ1(9002169.6,AQAOX,.01),1:"CR"_AQAOX)
 . W ?($$HIGHFNC*5+11) ;move to beginning of dimensions columns
 . F AQAOD=1:1:9 D
 .. W "  "
 .. W $S($D(^AQAO1(6,"ADIM",AQAOD,AQAOX)):"X",1:" "),"  "
 W !
 Q
 ;
 ;
NEWPG ; -- SUBRTN to call newpage code
 D NEWPG^AQAOUTIL Q
 ;
 ;
HDG2 ; -- SUBRTN to print 2nd half of heading
 NEW I
 W !,AQAOLIN2,!
 W "Indicators",?11
 I AQAOSEL'=2 F I=1:1:$$HIGHFNC W " F" S:$L(I)=1 I="0"_I W I," "
 I AQAOSEL'=1 F I=1:1:9 W " DP",I," "
 W "  QI TEAMS",!,AQAOLINE,!
 Q
 ;
 ;
FNCYES() ; -- SUBRTN to return whether indicator linked to selected funcs
 NEW X,Y S Y=0
 S X=0 F  S X=$O(AQAOFNC(X)) Q:X=""  Q:Y=1  D
 . I $D(^AQAO(2,AQAON,"AOC","B",+AQAOFNC(X))) S Y=1
 Q Y
 ;
 ;
DIMYES() ; -- SUBRTN to return whether indicator linked to any dimensions
 NEW X,Y S Y=0
 I $O(^AQAO(2,AQAON,"DIM",0)) S Y=1
 S X=0 F  S X=$O(^AQAO1(6,"C",AQAON,X)) Q:X=""  Q:Y=1  D
 . I $O(^AQAO1(6,X,"DIM",0)) S Y=1
 Q Y
 ;
 ;
HIGHFNC() ; -- SUBRTN to return # of functions selected
 NEW X,Y S (X,Y)=0 F  S X=$O(AQAOFNC(X)) Q:X=""  S Y=X
 Q Y
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
