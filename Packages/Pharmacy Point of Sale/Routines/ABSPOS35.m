ABSPOS35 ; IHS/FCS/DRS - survey pharmacy volume ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
MAIN ;EP - option: ABSP VOLUME SURVEY
 W !,"Survey of pharmacy volume",!
 N RANGE S RANGE=$$DTR^ABSPOSU1 Q:RANGE<1
 D ^%ZIS
 D VOLUME($P(RANGE,U),$P(RANGE,U,2))
 D ^%ZISC
 Q
VOLTEST N X1,X2,X,%H S X1=DT,X2=-90 D C^%DTC D VOLUME(X,DT) Q
VOLUME(STARTDT,THRUDT)    ;EP - survey daily volume (via AL and AJ indexes)
 ; Build ^TMP($J,index,date)=how many
 ;       ^TMP($J,index)=total
 K ^TMP($J)
 N INDEX,RXI,RXR,WEEKDAY,I,X,DATE,NDAYS,COUNT,WKTOTAL
 N RPTDATE S RPTDATE=$$NOWEXT^ABSPOSU1
 I '$D(THRUDT) S THRUDT=DT
 N YEAR S YEAR=$$YEAR(STARTDT) D HEADING
 S DATE=STARTDT,WKTOTAL=0,NDAYS=0
 F  D  Q:DATE>THRUDT
 . F INDEX="AL","AJ" D
 . . S COUNT=$$COUNT(DATE,INDEX)
 . . S ^TMP($J,INDEX,DATE)=COUNT
 . . S ^TMP($J,INDEX)=$G(^TMP($J,INDEX))+COUNT
 . . S WKTOTAL=WKTOTAL+COUNT
 . . I INDEX="AL" D
 . . . I $$WKDAY(DATE)=0 W $$MMMDD(DATE)
 . . . W ?$$WKDAY(DATE)+1*8,$J(COUNT,5)
 . . . I $$WKDAY(DATE)=6 W ?70,$J(WKTOTAL,6),! S WKTOTAL=0
 . . . I $$EOPQ^ABSPOSU8(2,,"D HEADING^"_$T(+0)) S DATE=9999999
 . S NDAYS=NDAYS+1
 . S DATE=$$NEXTDAY(DATE) Q:DATE>THRUDT
 . I $$YEAR(DATE)'=YEAR D
 . . S YEAR=$$YEAR(DATE)
 . . D HEADING
 W:$X>0 !
 D EOPQ^ABSPOSU8(4,,"D HEADING^"_$T(+0))
 W "INDEX",?10,"Total",?20,"Average",!
 F INDEX="AL","AJ" D
 . W INDEX,?10,^TMP($J,INDEX)
 . W ?20,$J(^TMP($J,INDEX)/NDAYS,6,1),!
 D ENDRPT^ABSPOSU5()
 Q
HEADING ;
 W @IOF
 W "Survey of Pharmacy Volume  (",$T(+0),")",?60,RPTDATE,!
 W "For " D  W !
 . N Y S Y=$P(RANGE,U) X ^DD("DD") W Y
 . W " through "
 . S Y=$P(RANGE,U,2) X ^DD("DD") W Y
 . W !
 W !,YEAR
 F I=0:1:6 W ?I+1*8,"  ",$P("MON,TUE,WED,THU,FRI,SAT,SUN",",",I+1)
 W ?70,"WK. TOTAL",!
 Q
COUNT(DATE,INDEX)  ;
 N C,D,RXI,RXR S C=0
 S D=DATE F  D  S D=$O(^PSRX(INDEX,D)) Q:D=""  Q:D\1'=DATE
 . S RXI="" F  S RXI=$O(^PSRX(INDEX,D,RXI)) Q:RXI=""  D
 . . S RXR="" F  S RXR=$O(^PSRX(INDEX,D,RXI,RXR)) Q:RXR=""  D
 . . . S C=C+1
 Q C
WKDAY(X)          ; given X = Fileman date return 0 = Monday, 1 = Tuesday, etc.
 Q $$DOLLARH(X)+3#7
DOLLARH(X)         ; given X = Fileman date, return $H date
 N %H,%T,%Y D H^%DTC Q %H
NEXTDAY(X1)         ; given X = Fileman date, return next day's Fileman date
 N X2 S X2=1 N X,%H D C^%DTC Q X
YEAR(Y) X ^DD("DD") Q $P($P(Y,"@"),",",2)
MMMDD(Y) X ^DD("DD") Q $P(Y,",")
