ABSPOS32 ; IHS/FCS/DRS - survey insurances ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
MAIN ;EP - option ABSP INSURER SURVEY
 W !!,"Survey insurances from recent prescriptions to see which",!
 W "additional formats we might like to have.",!
 ; default to starting 60 days ago
 N X1,X2,X,%H S X1=DT,X2=-60 D C^%DTC ; X = result
 N START,END
 S START=$$DATE^ABSPOSU1("Start date: ",X,1,2970000,4000000,"E",300)
 Q:'START  S END=DT
 N POP D ^%ZIS Q:$G(POP)
 U $P W !,"...thinking...",!
 I START D MAIN1(START)
 D ^%ZISC
 Q
HEADING ;
 W @IOF
 W "Survey of Insurers (","ABSPOS32",")   ",$$NOWEXT^ABSPOSU1,!
 W "For " N Y S Y=START X ^DD("DD") W Y
 I START'=END S Y=END X ^DD("DD") W "-",Y,!
 W ?3,"Count",?10,"Name",?50,"Now sending format",!
 Q
MAIN1(START)       ; START = fileman date.time to start search
 ; Build ^TMP("ABSPOS32",$J,INSIEN)=count
 ;       ^TMP("ABSPOS32",$J,"B",count)=INSIEN
 DO SURVEY(START)
 I '$D(^TMP("ABSPOS32",$J)) W !,"No prescriptions found?!",! Q
 U IO D HEADING
 N COUNT,INS,NUMBERS,X
 S COUNT="" F  S COUNT=$O(^TMP("ABSPOS32",$J,"B",COUNT),-1) Q:'COUNT  D
 . S INS=0 F  S INS=$O(^TMP("ABSPOS32",$J,"B",COUNT,INS)) Q:'INS  D
 . . S X=^TMP("ABSPOS32",$J,INS)
 . . W $J(COUNT,7),?10,$E($P(X,U,2)_"(`"_INS_")",1,40)
 . . I $P(X,U,3)]"" W ?51,$P(X,U,3)
 . . W !
 . . I $$EOPQ^ABSPOSU8(2,,"D HEADING^"_$T(+0)) S INS=999999999,COUNT=1
 D ENDRPT^ABSPOSU5()
 Q
SURVEY(START)      ; START = fileman date.time
 N RXI,RXR,DOC,TIME S TIME=START K ^TMP("ABSPOS32",$J)
 F  D  S TIME=$O(^PSRX("AL",TIME)) Q:'TIME
 . S RXI="" F  S RXI=$O(^PSRX("AL",TIME,RXI)) Q:'RXI  D
 . . S RXR="" F  S RXR=$O(^PSRX("AL",TIME,RXI,RXR)) Q:RXR=""  D
 . . . D SURVEY1
 ; Now index it by count
 S DOC=""
 F  S DOC=$O(^TMP("ABSPOS32",$J,DOC)) Q:"B"[DOC  D
 . N X S X=^TMP("ABSPOS32",$J,DOC) N COUNT S COUNT=$P(X,U)
 . S ^TMP("ABSPOS32",$J,"B",COUNT,DOC)=""
 Q
SURVEY1 ; given RXI, RXR
 N ABSBRXI,ABSBRXR,ABSBVMED,ABSBVISI,ABSBPATI
 S ABSBRXI=RXI,ABSBRXR=RXR
 I ABSBRXR S ABSBVMED=$P($G(^PSRX(ABSBRXI,1,ABSBRXR,999999911)),U)
 E  S ABSBVMED=$P($G(^PSRX(ABSBRXI,999999911)),U)
 I 'ABSBVMED D:0  Q
 . W "No PCC link for ",ABSBRXI,",",ABSBRXR,! Q
 I '$D(^AUPNVMED(ABSBVMED,0)) D:0  Q
 . W "PCC link but '$D() on ABSBVMED=" W ABSBVMED W ! Q
 S ABSBVISI=$P(^AUPNVMED(ABSBVMED,0),U,3)
 S ABSBPATI=$P(^PSRX(ABSBRXI,0),U,2)
 N ARRAY D INSURER^ABSPOS25(.ARRAY)
 N INS S INS=+$G(ARRAY(1))
 N X S X=$G(^TMP("ABSPOS32",$J,INS))
 I X="" D
 . I INS D
 . . S X=$P($G(^AUTNINS(INS,0)),U)
 . . I X="" S X="(Missing AUTNINS("_INS_")??"
 . E  S X="(No insurance)"
 . S X=U_X
 . N FMT S FMT=$P($G(^ABSPEI(INS,100)),U)
 . I FMT D
 . . N FMTNAME S FMTNAME=$P($G(^ABSPF(9002313.92,FMT,0)),U)
 . . I FMTNAME="" S FMTNAME="(?format `"_FMT_")"
 . . S $P(X,U,3)=FMTNAME
 S $P(X,U)=$P(X,U)+1
 S ^TMP("ABSPOS32",$J,INS)=X
 Q
