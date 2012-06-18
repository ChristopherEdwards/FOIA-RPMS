ABSPOS34 ; IHS/FCS/DRS - survey elig. status ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
MAIN ;EP - option: ABSP BEN/ELIG SURVEY
 W !!,"Survey BENEFICIARY/ELIGIBILITY status from recent prescriptions",!
 N X1,X2,X,%H ;S X1=DT,X2=-60 D C^%DTC ; X = result
 S X=DT-10000 ; 1 year ago
 N START,END
 S START=$$DATE^ABSPOSU1("Start date: ",X,1,2970000,4000000,"E",300)
 Q:'START  S END=DT
 N POP D ^%ZIS Q:$G(POP)
 U $P W !,"...thinking...",!
 D MAIN1(START)
 D ^%ZISC
 Q
HEADING ;
 W @IOF
 W "Survey of Beneficiary/Eligibility Status (","ABSPOS34",")",?60,RPTDATE,!
 W "For " N Y S Y=START X ^DD("DD") W Y
 I START'=END S Y=END X ^DD("DD") W "-",Y,!
 W ?3,"Count",?10,"Status",!
 Q
MAIN1(START)       ; START = fileman date.time to start search
 ; Build ^TMP("ABSPOS34",$J,ien)=count^name
 ;       ^TMP("ABSPOS34",$J,"B",count)=INSIEN
 N RPTDATE S RPTDATE=$$NOWEXT^ABSPOSU1
 DO SURVEY(START)
 I '$D(^TMP("ABSPOS34",$J)) W !,"No prescriptions found?!",! Q
 U IO D HEADING
 N COUNT,INS,NUMBERS,X
 S COUNT="" F  S COUNT=$O(^TMP("ABSPOS34",$J,"B",COUNT),-1) Q:'COUNT  D
 . S INS=0 F  S INS=$O(^TMP("ABSPOS34",$J,"B",COUNT,INS)) Q:INS=""  D
 . . S X=^TMP("ABSPOS34",$J,INS)
 . . W $J(COUNT,7),?10,$E($P(X,U,2),1,40)
 . . I $P(X,U,3)]"" W ?51,$P(X,U,3)
 . . W !
 . . I $$EOPQ^ABSPOSU8(2,,"D HEADING^"_$T(+0)) S INS=99999999,COUNT=1
 D ENDRPT^ABSPOSU5()
 Q
SURVEY(START)      ; START = fileman date.time
 N RXI,RXR,DOC,TIME S TIME=START K ^TMP("ABSPOS34",$J)
 F  D  S TIME=$O(^PSRX("AL",TIME)) Q:'TIME
 . S RXI="" F  S RXI=$O(^PSRX("AL",TIME,RXI)) Q:'RXI  D
 . . S RXR="" F  S RXR=$O(^PSRX("AL",TIME,RXI,RXR)) Q:RXR=""  D
 . . . D SURVEY1
 ; Now index it by count
 S DOC=""
 F  S DOC=$O(^TMP("ABSPOS34",$J,DOC)) Q:DOC=""  I "B"'[DOC D
 . N X S X=^TMP("ABSPOS34",$J,DOC) N COUNT S COUNT=$P(X,U)
 . S ^TMP("ABSPOS34",$J,"B",COUNT,DOC)=""
 Q
SURVEY1 ; given RXI, RXR
 N NAME,P1112,PAT
 S PAT=$P($G(^PSRX(RXI,0)),U,2)
 I PAT D
 . S P1112=$P($G(^AUPNPAT(PAT,11)),U,11,12)
 . I P1112?."^" S (NAME,P1112)="???"
 . E  D
 . . N BEN,ELG S BEN=$P(P1112,U),ELG=$P(P1112,U,2)
 . . I BEN="" S BEN="??"
 . . E  S BEN=$P($G(^AUTTBEN(BEN,0)),U) I BEN="" S BEN="??"
 . . N X S X=$P(^DD(9000001,1112,0),U,3)
 . . N I,Y
 . . F I=1:1:$L(X,";") S Y=$P(X,";",I) I ELG=$P(Y,":") S ELG=$P(Y,":",2)
 . . I ELG="" S ELG="??"
 . . S NAME=BEN_","_ELG
 E  S (NAME,P1112)="??"
 S X=$G(^TMP("ABSPOS34",$J,NAME))
 I X="" S $P(X,U,2)=NAME
 S $P(X,U)=$P(X,U)+1
 S ^TMP("ABSPOS34",$J,NAME)=X
 Q
