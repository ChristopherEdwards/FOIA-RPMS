BARRASM2 ; IHS/SD/LSL - Age Summary Report by Fiscal Year ; 09/15/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;MAR 27,2007
 ;New routine MRS:BAR*1.8*7 TO131 REQ_2
 Q
 ; *********************************************************************
EN ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R Variables
 N BARA
 S BARA=$$GETFY
 Q:BARA=0                            ; Returns string
 S BARP("UAGE")=BARA                 ; Save FY range
 D EN^BARRASM
 Q
 ; *********************************************************************
GETFY() ;EXTRINSIC FUNCTION TO FIND FISCAL YEAR FOR REPORT
 N BARA,BARFY,BARBEG,BAREND,BARZ
 S BARA=$$FISCAL^XBDT()              ;GET CURRENT FISCAL YEAR
 S BARFY=$P(BARA,U)
 D ^XBFMK                            ;KILL FM VARIABLES
 S DIR(0)="FOU^4:4^K:$$UPC^BARUTL(X)'?1""BULK""&($$UPC^BARUTL(X)'?1""FY""2N) X"
 ;S DIR("S")="I $$UPC^BARUTL(X)?1""BULK""!($$UPC^BARUTL(X)?1""FY""2N)"
 ;S DIR("?",1)="BULK is limited to Billed Dates before 10/1/2008 and"
 ;S DIR("?",2)="corresponds to the BULK Invoices in UFMS"
 ;S DIR("?",3)="FY## allows you to enter a specific Fiscal Year"
 ;S DIR("?",4)="Type in FY followed by the two digit year"
 S DIR("A")="Enter FISCAL YEAR for the Report"
 S DIR("A",1)="Enter BULK for Billed Date prior to 10/1/2008"
 S DIR("A",2)="Enter FYnn for specific Fiscal Year e.g. FY"_$E(BARFY,3,4)
 S DIR("A",3)=""
 S DIR("B")="BULK"
 W !!
 D ^DIR
 I $D(DIRUT)!$D(DUOUT)!$D(DTOUT)!(Y="") Q 0
 S BARZ=$$UPC^BARUTL(Y)
 I BARZ="BULK" D  Q BARA
 .S BARA=BARZ_"^2571001^3081001"           ;Everything prior to Go Live date
 S BARZ=$E(BARZ,3,4)
 I BARZ=$E(BARFY,3,4) Q BARA                ;Current Fiscal Year
 S BARFY=$S(BARZ<40:(20_BARZ),1:(19_BARZ))  ;Change to 4 digits
 S BARA=BARFY_U_(BARFY-1700-1)_"1001"_U_(BARFY-1700)_"0930"  ;Build DT-type string
 Q BARA
 ;
UAGE(BAR) ;EP; EXTRINSIC FUNCTION
 ; Enters with BAR=DA of A/R Bill fille
 ;             BARP("UAGE")=Fiscal year string
 I 'BAR Q 0
 N BARBEG,BAREND,BAR0
 S BARBEG=$P(BARP("UAGE"),U,2)
 S BAREND=$P(BARP("UAGE"),U,3)
 S BAR0=$P($G(^BARBL(DUZ(2),BAR,0)),U,7)
 I BAR0="" Q 0                    ;No bill
 I BAR0<BARBEG!(BAR0>BAREND) Q 0  ;Not within Fiscal Year range
 Q 1
