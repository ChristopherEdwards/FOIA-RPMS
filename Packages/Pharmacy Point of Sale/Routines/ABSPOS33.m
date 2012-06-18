ABSPOS33 ; IHS/FCS/DRS - survey divisions ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
MAIN ;EP - option ABSP DIVISIONS SURVEY
 W !!,"Survey DIVISION from recent prescriptions",!
 N X1,X2,X,%H ;S X1=DT,X2=-60 D C^%DTC ; X = result
 S X=DT-10000 ; 1 year ago
 N START,END
 S START=$$DATE^ABSPOSU1("Start date: ",X,1,2970000,4000000,"E",300)
 Q:'START  S END=DT
 D ^%ZIS Q:$G(POP)
 U $P W !,"...thinking...",!
 I START D MAIN1(START)
 D ^%ZISC
 Q
HEADING ;
 W @IOF
 W "Survey of Divisions (","ABSPOS33",")   ",?60,RPTDATE,!
 W "For " N Y S Y=START X ^DD("DD") W Y
 I START'=END S Y=END X ^DD("DD") W "-",Y,!
 W ?3,"Count",?10,"Name",!
 Q
MAIN1(START)       ; START = fileman date.time to start search
 ; Build ^TMP("ABSPOS33",$J,ien)=count^name
 ;       ^TMP("ABSPOS33",$J,"B",count)=INSIEN
 N RPTDATE S RPTDATE=$$NOWEXT^ABSPOSU1
 DO SURVEY(START)
 I '$D(^TMP("ABSPOS33",$J)) W !,"No prescriptions found?!",! Q
 U IO D HEADING
 N COUNT,INS,NUMBERS,X
 S COUNT="" F  S COUNT=$O(^TMP("ABSPOS33",$J,"B",COUNT),-1) Q:'COUNT  D
 . S INS=0 F  S INS=$O(^TMP("ABSPOS33",$J,"B",COUNT,INS)) Q:'INS  D
 . . S X=^TMP("ABSPOS33",$J,INS)
 . . W $J(COUNT,7),?10,$E($P(X,U,2)_"(`"_INS_")",1,40)
 . . I $P(X,U,3)]"" W ?51,$P(X,U,3)
 . . W !
 . . I $$EOPQ^ABSPOSU8(2,,"D HEADING^"_$T(+0)) S INS=999999999,COUNT=1
 D ENDRPT^ABSPOSU8()
 Q
SURVEY(START)      ; START = fileman date.time
 N RXI,RXR,DOC,TIME S TIME=START K ^TMP("ABSPOS33",$J)
 F  D  S TIME=$O(^PSRX("AL",TIME)) Q:'TIME
 . S RXI="" F  S RXI=$O(^PSRX("AL",TIME,RXI)) Q:'RXI  D
 . . S RXR="" F  S RXR=$O(^PSRX("AL",TIME,RXI,RXR)) Q:RXR=""  D
 . . . D SURVEY1
 ; Now index it by count
 S DOC=""
 F  S DOC=$O(^TMP("ABSPOS33",$J,DOC)) Q:"B"[DOC  D
 . N X S X=^TMP("ABSPOS33",$J,DOC) N COUNT S COUNT=$P(X,U)
 . S ^TMP("ABSPOS33",$J,"B",COUNT,DOC)=""
 Q
SURVEY1 ; given RXI, RXR
 N DIV,NAME
 I RXR S DIV=$P($G(^PSRX(RXI,1,RXR,0)),U,9)
 E  S DIV=$P($G(^PSRX(RXI,2)),U,9)
 I DIV="" S (DIV,NAME)="null?" ; *1.26*3*
 E  D
 . S NAME=$P($G(^PS(59,DIV,0)),U)
 . I NAME="" S NAME="`"_DIV_"?"
 N X S X=$G(^TMP("ABSPOS33",$J,DIV))
 I X="" S $P(X,U,2)=NAME
 S $P(X,U)=$P(X,U)+1
 S ^TMP("ABSPOS33",$J,DIV)=X
 Q
