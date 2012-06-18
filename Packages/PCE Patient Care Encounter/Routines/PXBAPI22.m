PXBAPI22 ;ISL/DCM - API for Classification check out ;8/30/96
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**1,26**;Aug 12, 1996
ONE(TYPI,DATA,ENCOWNTR,SQUIT) ;Process One Classification
 ; Input  -- TYPI    Outpatient Classification Type IEN
 ;           DATA    Null or 409.42 IEN^Internal Value^1=n/a^1=unedt
 ;           ENCOWNTR     Outpatient Encounter file IEN (optional)
 ; Output -- SQUIT User entered '^' or timeout
 N SDCT0,SDVAL
 S SDCT0=$G(^SD(409.41,TYPI,0)) I SDCT0']"" S PXBDATA("ERR",TYPI)=1 Q  ;Bad entry
 I $P(DATA,"^",3) D:DATA  S PXBDATA("ERR",TYPI)=2 Q  ;Not applicable
 .W !,$C(7),">>> "_$P(SDCT0,"^",6)_" is no longer applicable..."
 .S DA=+DATA,DIK="^SDD(409.42," D ^DIK W "deleted."
 I DATA,$P(DATA,"^",4) D  S PXBDATA("ERR",TYPI)=3 Q  ;Uneditable data
 . W !,$P(SDCT0,"^",6)_": "_$$VAL^SDCODD(TYPI,$P(DATA,"^",2))_"  <Uneditable>"
 S SDVAL=$$VAL(TYPI,SDCT0,DATA) ;Get field value
 I SDVAL="^" S SQUIT="",PXBDATA("ERR",TYPI)=4 Q  ;user ^ out
 D STORE(+DATA,SDVAL,TYPI)
 Q
VAL(TYPI,SDCT0,DATA) ;Get Outpatient Classification
 N DIR,DA,Y
 I TYPI=1,$P($G(^DPT(DFN,.321)),"^",2)'="Y" G VALQ
 I TYPI=2,$P($G(^DPT(DFN,.321)),"^",3)'="Y" G VALQ
 I TYPI=4,$P($G(^DPT(DFN,.322)),"^",13)'="Y",'$$EC^SDCO22(DFN,ENCOWNTR) G VALQ
 I TYPI=3,$P($G(^SCE(+$G(ENCOWNTR),0)),"^",10)=2 S Y=1 G VALQ ;Change SC to 'yes'
REASK S DIR("A")=$S($P(SDCT0,"^",2)]"":$P(SDCT0,"^",2),1:$P(SDCT0,"^"))
 I $P(DATA,"^",2)]""!($P(SDCT0,"^",4)]"") S DIR("B")=$S($P(DATA,"^",2)]"":$$VAL^SDCODD(TYPI,$P(DATA,"^",2)),1:$P(SDCT0,"^",4))
 S DIR(0)=$P(SDCT0,"^",3)_"O"
 I $D(^SD(409.41,TYPI,2)) S DIR(0)=DIR(0)_"^"_^(2)
 I TYPI=3 S DIR("?")="^D SC^SDCO23(DFN)"
 D ^DIR
 I $P(SDCT0,"^",5),'$D(DTOUT),$P(DATA,"^",2)="",Y=""!(Y["^"&('$P($G(^DG(43,1,"SCLR")),"^",24))) D  G REASK
 .W !,$C(7),"This is a required response." W:Y["^" "  An '^' is not allowed."
 .K DIRUT,DUOUT
 I $D(DIRUT) S Y="^"
VALQ K DIRUT,DTOUT,DUOUT
 Q $G(Y)
 ;
STORE(SDCNI,SDCNV,TYPI) ;File Outpatient Classification
 ; Input  -- SDCNI    Outpatient Classification IEN
 ;           SDCNV    Outpatient Classification Value
 ;           TYPI    Classification type 1 - Agent Orange
 ;                                        2 - Ionizing Radiation
 ;                                        3 - Service Connected
 ;                                        4 - Environmental Contaminants
 ; Output -- PXBDATA array
 ; Error codes -- PXBDATA("ERR",TYPI)=1 - Bad ptr to 409.41 in TYPI
 ;                                  2 - DATA entry not applicable
 ;                                  3 - DATA entry uneditable
 ;                                  4 - User ^ out of prompt
 S PXBDATA(TYPI)=SDCNI_"^"_SDCNV
 Q
