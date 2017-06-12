BEHORXF3 ;MSC/IND/PLS - Support for Lab Test lookup when ordering meds;13-Feb-2014 12:09;PLS
 ;;1.1;BEH COMPONENTS;**009012**;Sep 18, 2007;Build 3
 ;=================================================================
 ; RPC: BEHORXF3 LABTESTS
 ; Returns test results for lab tests associated with a pharmacy orderable item
 ; Input: DFN - Patient
 ;        OI  - Orderable Item
LABTESTS(DATA,DFN,OI) ;EP-
 N POI,TSTS,LP,STR,CNT,ARY,ARYC,SEQN
 S CNT=0,ARYC=0
 S POI=+$P($G(^ORD(101.43,+OI,0)),U,2)
 K TSTS,DATA
 D GETWP^XPAR(.TSTS,"SYS","BEHORX LAB TESTS",POI)
 I $L($G(TSTS)) D
 .S LP=0 F  S LP=$O(TSTS(LP)) Q:'LP  D
 ..S STR=$G(TSTS(LP,0))
 ..Q:STR=""
 ..S SEQN=$P(STR,U,5)
 ..I SEQN D
 ...S ARY(SEQN,0)=STR
 ..E  D
 ...S ARYC=ARYC+1
 ...S ARY("X"_ARYC,0)=STR
 .S LP=0 F  S LP=$O(ARY(LP)) Q:LP=""  D
 ..S STR=$G(ARY(LP,0))
 ..Q:STR=""
 ..D LABRSLT(DFN,+STR,$P(STR,U,3),+$P(STR,U,4))
 E  S DATA(0)=CNT  ;No tests associated with Pharmacy Orderable Item
 Q
 ; Call Lab Package for test results
LABRSLT(DFN,TST,DAYS,SPEC) ;EP-
 N IDT,SUB
 K ^TMP("LRRR",$J)
 D RR^LR7OR1(DFN,,$S($G(DAYS):$$FMADD^XLFDT(DT,-DAYS),1:365),DT,,TST,,1,$G(SPEC))
 I $D(^TMP("LRRR",$J,DFN,"CH")) D
 .S IDT=0 F  S IDT=$O(^TMP("LRRR",$J,DFN,"CH",IDT)) Q:'IDT  D
 ..S SUB=0 F  S SUB=$O(^TMP("LRRR",$J,DFN,"CH",IDT,SUB)) Q:'SUB  D
 ...D ADDRES(^TMP("LRRR",$J,DFN,"CH",IDT,SUB))
 E  D
 .D ADD($P($G(^LAB(60,TST,0)),U))
 .D ADD("  No results available in last "_DAYS_" days.")  ; for "_$P($G(^LAB(60,TST,0)),U))
 .D ADD("")
 Q
 ; Add result to output
ADDRES(VAL) ;EP-
 N TSTN,TRNG,TRES,TUNIT,TDT
 S TRES=$P(VAL,U,2)
 S TSTN=$P(VAL,U,10) S:TSTN="" TSTN=$P(VAL,U,15)
 S TRNG=$P(VAL,U,5)
 S TUNIT=$P(VAL,U,4)
 S TDT=9999999-IDT
 S CNT=CNT+1
 D ADD(TSTN)
 D ADD("  Most recent value was "_TRES_" "_TUNIT_" on "_$P($TR($$FMTE^XLFDT(TDT,"5Z"),"@"," "),":",1,2))
 D ADD("    Reference Range: "_TRNG_" "_TUNIT)
 D ADD("")
 Q
 ; Add to return array
ADD(VAL) ;EP-
 S CNT=CNT+1
 S DATA(CNT)=VAL
 Q
 ; Return boolean flag indicate status of tests associated with orderable item
TSTASSOC(DATA,OI) ;EP-
 N POI,TSTS
 S POI=+$P($G(^ORD(101.43,+OI,0)),U,2)
 K TSTS
 D GETWP^XPAR(.TSTS,"SYS","BEHORX LAB TESTS",POI)
 S DATA=$L($G(TSTS))>0
 Q
 ;
LTEN ;-- main entry point for BEHORX LAB TESTS
 N POI
 S POI=$$LOOKUP^BEHUTIL(50.7,"Pharmacy Orderable Item")
 Q:'POI
 D EN^VALM("BEHORX LAB TESTS")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Manage Pharmacy Orderable Test Mappings"
 S VALMHDR(2)="Rx Orderable: "_$P($G(^PS(50.7,+POI,0)),U)
 Q
 ;
INIT ; -- init variables and list array
 D CLEAN^VALM10
 D BUILDLST
 Q
 ; Set line into array
SETARR(LINE,TEXT,IEN,DAYS,SPEC,SEQN) ;EP-
 S @VALMAR@(LINE,0)=TEXT
 S:$G(IEN) @VALMAR@("IDX",LINE,LINE)=""
 S @VALMAR@(LINE,"POIIEN")=LINE_U_IEN
 S @VALMAR@(LINE,"DATA")=LINE_U_IEN_U_DAYS_U_SPEC_U_SEQN
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K SAVE
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BUILDLST ;EP-
 N LST,LP,VAL
 S VALMCNT=0
 D GETWP^XPAR(.LST,"SYS","BEHORX LAB TESTS",POI)
 I $L($G(LST)) D
 .S LP=0 F  S LP=$O(LST(LP)) Q:'LP  D
 ..S VAL=LST(LP,0)
 ..D ADDITEM($P(VAL,U),$P(VAL,U,3),$P(VAL,U,4),$P(VAL,U,5))
 Q
 ; Add a single line item
ADDITEM(TST,DAYS,SPEC,SEQ) ;EP-
 N LINE
 S VALMCNT=VALMCNT+1
 S LINE=$$SETFLD^VALM1(VALMCNT,"","ITEM")
 S LINE=$$SETFLD^VALM1($P($G(^LAB(60,TST,0)),U),LINE,"TEST")
 S LINE=$$SETFLD^VALM1(DAYS,LINE,"DAYS")
 S LINE=$$SETFLD^VALM1(SEQ,LINE,"SEQ")
 S LINE=$$SETFLD^VALM1($P($G(^LAB(61,+SPEC,0)),U),LINE,"SPEC")
 D SETARR(VALMCNT,LINE,TST,DAYS,SPEC,SEQ)
 Q
 ; Update an existing line item
UPDITM(ITM,TST,DAYS,SPEC,SEQ) ;EP-
 N LINE
 S LINE=$$SETFLD^VALM1(VALMCNT,"","ITEM")
 S LINE=$$SETFLD^VALM1($P($G(^LAB(60,TST,0)),U),LINE,"TEST")
 S LINE=$$SETFLD^VALM1(DAYS,LINE,"DAYS")
 S LINE=$$SETFLD^VALM1(SEQ,LINE,"SEQ")
 S LINE=$$SETFLD^VALM1($P($G(^LAB(61,+SPEC,0)),U),LINE,"SPEC")
 D SETARR(ITM,LINE,TST,DAYS,SPEC,SEQ)
 Q
ADDTEST ;EP-
 D FULL^VALM1
 N DIR,DUOUT,DIRUT,Y,IEN,TSTIEN,DAYSNUM,SPECIEN,SEQN,BEHOPOP
 S BEHOPOP=0
 S TSTIEN=$$GETIEN1(60,"Laboratory Test: ",-1,,"I ""BO""[$P(^(0),U,3)")
 I $D(DIRUT)!$D(DUOUT)!BEHOPOP S VALMBCK="R" Q
 I $$CHKDUP(TSTIEN,2) S VALMSG="Selected test is already included in mapping!",VALMBCK="R" Q
 S DAYSNUM=$$DIR("NO^1:999999","Days Back (defaults to 365 if not specified): ",,.BEHOPOP)
ADDTEST2 S SEQN=$$DIR("N^1:99","Sequence Number: ",,,.BEHOPOP)
 I BEHOPOP S VALMBCK="R" Q
 I $$CHKDUP(SEQN,5) D  G ADDTEST2
 .W !,"Specified sequence number is already in use!",!
 S SPECIEN=$$GETIEN1(61,"Specimen type Defaults to 'ALL'): ",-1)
 I BEHOPOP<0 S VALMBCK="R" Q
 S:SPECIEN<0 SPECIEN=""
 D ADDITEM(TSTIEN,DAYSNUM,SPECIEN,SEQN)
 D SAVELST
 D INIT
 Q
 ;
SAVELST ;EP-
 N ARY,ERR,LP,VAL
 S LP=0 F  S LP=$O(@VALMAR@(LP)) Q:'LP  D
 .S VAL=$G(@VALMAR@(LP,"DATA"))
 .S ARY(LP,0)=$P(VAL,U,2)_U_$P($G(^LAB(60,+$P(VAL,U,2),0)),U)_U_$P(VAL,U,3,5)
 I $D(ARY)>1 D
 .S ARY="LAB INFO"
 .D DEL^XPAR("SYS","BEHORX LAB TESTS","`"_POI,.ERR)
 .D EN^XPAR("SYS","BEHORX LAB TESTS","`"_POI,.ARY,.ERR)
 .S VALMSG="Mappings have been saved."
 E  D UNMAP
 ;D RE^VALM4
 S VALMBCK="R"
 Q
 ;
DELITEM ;EP-
 N DA,DUOUT,Y,VAL,ITM,DTOUT,DIRUT,DIE,DR,LST
 S LST=""
 S DIR("A")="Select Items",DIR(0)="LO^1:"_VALMCNT D ^DIR
 I $D(DUOUT) S VALMBCK="R" Q
 I +Y D FULL^VALM1 S LST=Y
 F ITM=1:1:$L(LST,",") Q:$P(LST,",",ITM)']""  S VAL=$P(LST,",",ITM) D
 .K @VALMAR@(VAL)
 .K @VALMAR@("IDX",VAL)
 D SAVELST
 D INIT
 Q
 ;
UNMAP ;EP-
 N ARY
 S ARY="LAB INFO"
 D DEL^XPAR("SYS","BEHORX LAB TESTS","`"_POI,.ERR)
 D INIT
 S VALMBCK="R"
 Q
 ; Change POI
CHGPOI ;EP-
 S POI=$$LOOKUP^BEHUTIL(50.7,"Pharmacy Orderable Item")
 D INIT
 S VALMBCK="R"
 Q
 ;
EDTITEM ;EP-
 N DA,DUOUT,Y,VAL,ITM,DTOUT,DIRUT,DIE,DR,LST
 S LST=""
 S DIR("A")="Select Items",DIR(0)="LO^1:"_VALMCNT D ^DIR
 I $D(DUOUT) S VALMBCK="R" Q
 I +Y D FULL^VALM1 S LST=Y
 F ITM=1:1:$L(LST,",") Q:$P(LST,",",ITM)']""  S VAL=$P(LST,",",ITM) D
 .D EDTITEM1(VAL)
 D SAVELST
 D INIT
 S VALMBCK="R"
 Q
 ;EP-
EDTITEM1(IDX) ;
 N VAL,TSTIEN,SPECIEN,DAYS,SEQN,SEQNT,BEHOPOP
 S VAL=@VALMAR@(IDX,"DATA")
 S TSTIEN=$P(VAL,U,2)
 S DAYS=$P(VAL,U,3)
 S SPECIEN=$P(VAL,U,4)
 S SEQN=$P(VAL,U,5)
 S BEHOPOP=0
 ;S TSTIEN=$$GETIEN1(60,"Laboratory Test: ",-1,,"I ""BO""[$P(^(0),U,3)",$P($G(^LAB(60,+TSTIEN,0)),U))
 ;Q:BEHOPOP
 S TSTIEN=$$DIR("PO^60:EM","Laboratory Test: ",$P($G(^LAB(60,+TSTIEN,0)),U),,.BEHOPOP,"I ""BO""[$P(^(0),U,3)")
 I BEHOPOP D  Q:BEHOPOP
 .I $P(BEHOPOP,U,2) D
 ..K @VALMAR@(IDX)
 ..K @VALMAR@("IDX",IDX)
 E  S TSTIEN=+TSTIEN
 I $$CHKDUP(TSTIEN,2,IDX) S VALMSG="Selected test is already included in mapping!",VALMBCK="R" Q
 S DAYSNUM=$$DIR("NO^1:999999","Days Back (defaults to 365 if not specified): ",DAYS,,.BEHOPOP)
 I BEHOPOP D  Q:BEHOPOP
 .I $P(BEHOPOP,U,2) S DAYSNUM="",BEHOPOP=0
EDTITEM2 S SEQNT=$$DIR("N^1:99","Sequence Number: ",SEQN,,,.BEHOPOP)
 ;I BEHOPOP S VALMBCK="R" Q
 Q:BEHOPOP
 I $$CHKDUP(SEQNT,5,IDX) D  G EDTITEM2
 .W !,"Specified sequence number is already in use!",!
 S SEQN=SEQNT
 ;S SPECIEN=$$GETIEN1(61,"Specimen type (Defaults to 'ALL'): ",-1,,,$P($G(^LAB(61,+SPECIEN,0)),U))
 S SPECIEN=$$DIR("PO^61","Specimen type (Defaults to 'ALL'): ",$P($G(^LAB(61,+SPECIEN,0)),U),,.BEHOPOP)
 I BEHOPOP<0 D  Q:BEHOPOP
 .I $P(BEHOPOP,U,2) S SPECIEN="",BEHOPOP=0
 S:SPECIEN<0 SPECIEN=""
 D UPDITM(IDX,TSTIEN,DAYSNUM,+SPECIEN,SEQN)
 Q
 ; Return boolean flag indicating presence of VALue at POSition
CHKDUP(VAL,POS,EDT) ;EP-
 N LP
 S EDT=$G(EDT,0)
 S RES=0
 S LP=0 F  S LP=$O(@VALMAR@(LP)) Q:'LP!RES  D
 .Q:LP=EDT
 .S STR=@VALMAR@(LP,"DATA")
 .S:$P(STR,U,POS)=VAL RES=1
 Q RES
 ;FileMan Utilities
 ; Paramerized DIR call
DIR(BEHODTP,BEHOPMT,BEHODFL,BEHOHLP,BEHOPOP,BEHOSCN) ; EP
 N DIR,DTOUT,DUOUT,Y
 S DIR(0)=BEHODTP,DIR("B")=$G(BEHODFL)
 I '$G(BEHOPMT) M DIR("A")=BEHOPMT
 E  D GETTEXT(BEHOPMT,$NA(DIR("A")))
 I '$G(BEHOHLP) M DIR("?")=BEHOHLP
 E  D GETTEXT(BEHOHLP,$NA(DIR("?")))
 S:$L($G(BEHOSCN)) DIR("S")=BEHOSCN
 D ^DIR
 I $D(DUOUT)!$D(DTOUT)!(X="@") S BEHOPOP=1,$P(BEHOPOP,U,2)=X="@"
 Q Y
 ; Prompt for entry from file
 ; BEHOFILE = File #
 ; BEHOPMPT = Prompt
 ; BEHODFLD = Field whose value is to be used for default value
 ;          Set to -1 for no default value
 ; D - x-ref (C^D)
 ; BEHOSCRN = DIC("S") SCREEN LOGIC
 ; BEHODFLT = Default value set in DIC("B") - not used if BEHODFLD is >0
GETIEN1(BEHOFILE,BEHOPMPT,BEHODFLD,D,BEHOSCRN,BEHODFLT) ; EP
 N DIC,BEHOD,Y
 S D=$G(D,"B")
 S:'$L(D) D="B"
 S BEHODFLD=$G(BEHODFLD,.01)
 S BEHOD=""
 S DIC("S")=$G(BEHOSCRN)
 S:BEHODFLD>0 BEHOD=$$GET1^DIQ(BEHOFILE,$$FIND1^DIC(BEHOFILE,,," ",.D,DIC("S")),BEHODFLD)
 I BEHODFLD<0,$L($G(BEHODFLT)) S BEHOD=BEHODFLT
 S DIC=BEHOFILE,DIC(0)="AE",DIC("A")=$G(BEHOPMPT),DIC("B")=BEHOD
 I $L(D,U)>1,DIC(0)'["M" S DIC(0)=DIC(0)_"M"
 D MIX^DIC1
 I $D(DUOUT)!($D(DTOUT)) S BEHOPOP=-1
 E  I Y'>0 S BEHOPOP=1,$P(BEHOPOP,U,2)=X="@"
 ;I Y'>0 D
 ;.S BEHOPOP=1,$P(BEHOPOP,U,2)=X="@"
 ;E  I $D(DUOUT)!($D(DTOUT)) S BEHOPOP=-1
 ;S:Y'>0 BEHOPOP=1,$P(BEHOPOP,U,2)=X="@"
 Q +Y
 ; Load dialog text into array
 ; BEHODG = Dialog index^optional parameters
 ; BEHOAR = Array to receive text
GETTEXT(BEHODG,BEHOAR) ;
 N BEHOPM
 K @BEHOAR
 F X=2:1:$L(BEHODG,U) S BEHOPM(X-1)=$P(BEHODG,U,X)
 S BEHODG=$S(BEHODG<0:-BEHODG,1:+BEHODG)
 D BLD^DIALOG(BEHODG/1000+59000,.BEHOPM,,BEHOAR)
 Q
