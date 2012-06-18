ABSPOS31 ; IHS/FCS/DRS - survey prescribers' ID #s ; 
 ;;1.0;PHARMACY POINT OF SALE;**15,20**;JUN 21, 2001
 ;
 ;IHS/SD/RLT - 1/12/06 - Fix header - Patch 15
 ;
 ;IHS/SD/RLT - 3/26/07 - Patch 20
 ;             Add NPI
 ;
 Q
 ; Need to fix up ABSPOS31,32, etc. for screen output
 ; $$TOSCREEN^ABSPOSU5 is available now.
MAIN ;EP - option ABSP PROVIDER #S SURVEY
 W !!,"Survey prescribers from recent prescriptions and see if we have",!
 W "DEA #s, Medicaid #s, etc. on file for them.",!
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
 W "Survey of Prescribers (",$T(+0),")   ",RPTDATE,!
 W "For " N Y S Y=START X ^DD("DD") W Y
 I START'=END S Y=END X ^DD("DD") W "-",Y,!
 ;RLT - 1/12/06 - Fix header - Patch 15
 ;W ?0,"Count",?8,"Name",?30,"DEA #",?42,"CAID",?54,"UPIN",?66,"CARE",!
 ;W ?0,"Count",?8,"Name",?30,"DEA #",?42,"CAID",?54,"CARE",?66,"UPIN",!
 ;RLT - 3/26/07 - Patch 20
 W ?0,"Count",?8,"Name",?30,"NPI #",?42,"DEA#",?54,"CAID",?66,"CARE",!
 Q
MAIN1(START)       ; START = fileman date.time to start search
 N RPTDATE S RPTDATE=$$NOWEXT^ABSPOSU1
 DO SURVEY(START)
 I '$D(^TMP("ABSPOS31",$J)) W !,"No prescriptions found?!",! Q
 U IO D HEADING
 N COUNT,DOC,NUMBERS,X
 S COUNT="" F  S COUNT=$O(^TMP("ABSPOS31",$J,"B",COUNT),-1) Q:'COUNT  D
 . S DOC=0 F  S DOC=$O(^TMP("ABSPOS31",$J,"B",COUNT,DOC)) Q:'DOC  D
 . . S X=^TMP("ABSPOS31",$J,DOC)
 . . W $J(COUNT,4),?5,$E($P(X,U,2),1,24) ;_"(`"_DOC_")",1,24)
 . . N I F I=3:1:6 W ?I-3*12+30,$P(X,U,I)
 . . W !
 . . I $$EOPQ^ABSPOSU8(2,,"D HEADING^"_$T(+0)) S DOC=99999999,COUNT=1
 I +$H=58399 D ZWRITE^ABSPOS("IOST","ZTQUEUED","IOT","IO")
 D ENDRPT^ABSPOSU5()
 Q
SURVEY(START)      ; START = fileman date.time
 ; Build ^TMP($T(+0),$J,physician)=count^name^dea^caid^care^upin
 ;       ^TMP($T(+0),$J,"B",count,physician)=""
 N RXI,RXR,DOC,TIME,NAME
 S TIME=START K ^TMP("ABSPOS31",$J)
 F  D  S TIME=$O(^PSRX("AL",TIME)) Q:'TIME
 . S RXI="" F  S RXI=$O(^PSRX("AL",TIME,RXI)) Q:'RXI  D
 . . S RXR="" F  S RXR=$O(^PSRX("AL",TIME,RXI,RXR)) Q:RXR=""  D
 . . . I RXR S DOC=$P($G(^PSRX(RXI,1,RXR,0)),U,17)
 . . . E  S DOC=$P($G(^PSRX(RXI,0)),U,4)
 . . . I DOC S NAME=$P($G(^VA(200,DOC,0)),U) S:NAME="" NAME="???"
 . . . E  S DOC=0,NAME="(missing prescriber)"
 . . . I $D(^TMP("ABSPOS31",$J,DOC)) S X=^(DOC)
 . . . E  D
 . . . . N NPI,DEA,CAID,UPIN,CARE
 . . . . S NPI=$P($$NPI^XUSNPI("Individual_ID",DOC),U)    ;RLT - 3/26/07 - Patch 20
 . . . . S:NPI'>0 NPI=""
 . . . . S DEA=$P($G(^VA(200,DOC,"PS")),U,2)
 . . . . S CAID=$P($G(^VA(200,DOC,9999999)),U,7)
 . . . . S CARE=$P($G(^VA(200,DOC,9999999)),U,6)
 . . . . S UPIN=$P($G(^VA(200,DOC,9999999)),U,8)
 . . . . ;S X=U_NAME_U_DEA_U_CAID_U_CARE_U_UPIN
 . . . . S X=U_NAME_U_NPI_U_DEA_U_CAID_U_CARE             ;RLT - 3/26/07 - Patch 20
 . . . S $P(X,U)=$P(X,U)+1
 . . . S ^TMP("ABSPOS31",$J,DOC)=X
 ; Now index it by count
 S DOC=""
 F  S DOC=$O(^TMP("ABSPOS31",$J,DOC)) Q:"B"[DOC  D
 . N X S X=^TMP("ABSPOS31",$J,DOC) N COUNT S COUNT=$P(X,U)
 . S ^TMP("ABSPOS31",$J,"B",COUNT,DOC)=""
 Q
