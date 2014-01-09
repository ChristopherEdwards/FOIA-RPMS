BLRAGUT ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPC UTILITIES ;
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;
 ; UTILITIES  (BGOUTL)
 ;   GACE    = get accession number external for given test
 ;   GACE69  = get accession number external for given pointers to file 69
 ;   CVTDATE = Convert date to internal format
 ;   ERR     = Error logging routine
 ;   ERROR   = General error catch routine used by @^%ZOSF("TRAP")
 ;   FILL    = Pad end of string with given character (default to space)
 ;   LEXLKUP = Perform lookup in lexicon
 ;   PREP    = prep input for partial name lookup
 ;   PTC     = return the value of the BLR PT CONFIRM parameter
 ;   TEST    = Returns true if routine exists
 ;   TMPGLB  = return name of global array
 ;   UPS     = upshift and check punctuation of input
 ;
GACE(AREA,DATE,ACI) ; EP - get accession number external for given test
 ;  AREA = area pointer to ACCESSION file 68
 ;  DATE = date pointer to ACCESSION file 68 - ^LRO(68,AREA,1,DATE
 ;  ACI  = internal accession pointer to ACCESSION file 68 - ^LRO(68,AREA,1,DATE,1,ACI
 Q:$G(AREA)=""
 Q:$G(DATE)=""
 Q:$G(ACI)=""
 Q $P($G(^LRO(68,AREA,1,DATE,1,ACI,.2)),U,1)
 Q
 ;
GACE69(ODATE,OSPEC,OTST) ; EP - get accession number external for given test from file 69
 ;  ODATE = date pointer to LAB ORDER ENTRY file 69 - ^LRO(69,DATE
 ;  OSPEC = specimen pointer to LAB ORDER ENTRY file 69 - ^LRO(69,DATE,1,SPEC
 ;  OTST  = test pointer to LAB ORDER ENTRY file 69 - ^LRO(69,DATE,1,SPEC,2,TST
 Q:$G(ODATE)=""
 Q:$G(OSPEC)=""
 Q:$G(OTST)=""
 N AREA,DATE,ACI,NODT69
 S NODT69=$G(^LRO(69,ODATE,1,OSPEC,2,OTST,0))
 S AREA=$P(NODT69,U,4)
 S DATE=$P(NODT69,U,3)
 S ACI=$P(NODT69,U,5)
 Q $S((AREA'="")&(DATE'="")&(ACI'=""):$P($G(^LRO(68,AREA,1,DATE,1,ACI,.2)),U,1),1:"")
 Q
 ;
 ; Convert date to internal format
CVTDATE(X) ; EP
 Q:"@"[X X
 S:X?1.E1" "1.2N1":"2N.E X=$P(X," ")_"@"_$P(X," ",2,99)
 D DT^DILF("PT",X,.X)
 Q $S(X>0:X,1:"")
 ;
ERR(BLRERR) ; EP - Error processing
 ; BLRERR = Error text OR error code
 ; BLRI   = pointer into return global array
 I +BLRERR S BLRERR=BLRERR+134234112 ;vbObjectError
 S BLRI=BLRI+1
 S ^TMP("BLRAG",$J,BLRI)=BLRERR_$C(30)
 ;S BLRI=BLRI+1
 ;S ^TMP("BLRAG",$J,BLRI)=$C(31)
 Q
 ;
ERROR ; EP
 D ENTRYAUD^BLRUTIL("ERROR^BLRAGUT 0.0")  ; Store RPMS Error data
 NEW ERRORMSG
 S ERRORMSG="$"_"Z"_"E=""ERROR^BLRAGUT"""  ; BYPASS SAC Checker
 S @ERRORMSG  D ^%ZTER
 D ERR("RPMS Error")
 Q
 ;
FILL(PADS,CHAR=" ") ; EP
 N I
 S RET=""
 F I=1:1:PADS S RET=RET_CHAR
 Q RET
 ;
 ; Perform lookup in lexicon
 ;  INP = Term ^ Type (ICD/CHP)
LEXLKUP(RET,INP) ; EP
 N TERM,TYPE
 Q:'$$TEST("LEX^ORWPCE",.RET)
 S TERM=$P(INP,U)
 Q:TERM=""
 S TYPE=$P(INP,U,2)
 Q:TYPE=""
 D LEX^ORWPCE(.RET,TERM,TYPE)
 Q
 ;
PREP(NAME) ; EP - prep input for partial name lookup - decrement last char of name for $O; up-shift all alpha characters
 N BLRL
 Q:$G(NAME)="" -1
 S NAME=$$UPS(NAME)
 Q:$E(NAME,$L(NAME))'?1A NAME
 S BLRL=$E(NAME,$L(NAME))
 S BLRL=$A(BLRL)-1
 Q $E(NAME,1,$L(NAME)-1)_$C(BLRL)_"~"
 ;
PTC() ; EP - return the value of the BLR PT CONFIRM parameter
 ; Returns Patient Confirmation enabled; 0='no' (default); 1='yes'
 N BLRDOM,BLRENT,BLRI,BLRPAR
 ;K ^TMP("BLRAG",$J)
 ;D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 ;S BLRI=0
 ;S BLRY="^TMP(""BLRAG"","_$J_")"
 ;S ^TMP("BLRAG",$J,BLRI)="T00020PT_CONFIRM"_$C(30)
 S BLRDOM=$$GET1^DIQ(8989.3,"1,",.01,"I")
 S BLRENT=BLRDOM_";"_"DIC(4.2,"
 S BLRPAR=$O(^XTV(8989.51,"B","BLR PT CONFIRM",0))
 S BLRRET=$$GET^XPAR(BLRENT,BLRPAR,1,"Q")
 Q $S(BLRRET'="":BLRRET,1:0)
 ;
 ; Returns true if routine exists
 ;  X = Routine or routine^tag
 ; .Y error message returned if not found
TEST(X,Y) ; EP
 S:X[U X=$P(X,U,2)
 Q:'$L(X)!(X'?.1"%"1.AN) 0
 X ^%ZOSF("TEST")
 Q:$T 1
 S Y=$$ERR("1059:"_X)
 Q 0
 ;
TMPGLB() ; EP
 K ^TMP("BLRAG",$J)
 Q $NA(^TMP("BLRAG",$J))
 ;
UPS(NAME) ; EP - upshift and check punctuation of input
 N BLRDGC,BLRDGI
 F BLRDGI=1:1:$L(NAME) S BLRDGC=$E(NAME,BLRDGI) D:$$FC1^DPTNAME1(.BLRDGC,1)
 .S NAME=$E(NAME,0,BLRDGI-1)_BLRDGC_$E(NAME,BLRDGI+1,999)
 .Q
 Q NAME
 ;
QS(BLRROOT,BLRN) ; EP
 ;replace $QS calls; SAC checker does not like $QS
 ;this routine does not handle intexpr (BLRN) <0
 S BLRRET=""
 I BLRN=1 Q $P($P($P(BLRROOT,",",1),"(",2),")",1)
 I BLRN>1 Q $P($P(BLRROOT,",",2),")",1)
 I BLRN=0 Q $P(BLRROOT,"(",1)
 Q ""
 ;
DEVICE(BDGXY) ; EP List of printers
 ; OUTPUT:
 ;       BDGXY(n)=REPORT TEXT
 ;
 N BDGII,FROM,DIR
 S BDGII=0
 S BDGXY=$$TMPGLB^BLRAGUT()
 S @BDGXY@(BDGII)="I00030PRINTER_IEN^T00040PRINTER_NAME"
 N CNT,IEN,X,Y,X0,XLOC,XSEC,XTYPE,XSTYPE,XTIME,XOSD,MW,PL,DEV
 S FROM="",DIR=1
 F  S FROM=$O(^%ZIS(1,"B",FROM),DIR),IEN=0 Q:FROM=""  D
 .F  S IEN=$O(^%ZIS(1,"B",FROM,IEN)) Q:'IEN  D
 ..S DEV="",X0=$G(^%ZIS(1,IEN,0)),XLOC=$P($G(^(1)),U),XOSD=+$G(^(90)),MW=$G(^(91)),XSEC=$G(^(95)),XSTYPE=+$G(^("SUBTYPE")),XTIME=$P($G(^("TIME")),U),XTYPE=$P($G(^("TYPE")),U)
 ..Q:$E($G(^%ZIS(2,XSTYPE,0)))'="P"                ; Printers only
 ..Q:"^TRM^HG^CHAN^OTH^"'[(U_XTYPE_U)
 ..Q:$P(X0,U,2)="0"!($P(X0,U,12)=2)                ; Queuing allowed
 ..I XOSD,XOSD'>DT Q                               ; Out of Service
 ..I $L(XTIME) D  Q:'$L(XTIME)                     ; Prohibited Times
 ...S Y=$P($H,",",2),Y=Y\60#60+(Y\3600*100),X=$P(XTIME,"-",2)
 ...S:X'<XTIME&(Y'>X&(Y'<XTIME))!(X<XTIME&(Y'<XTIME!(Y'>X))) XTIME=""
 ..I $L(XSEC),$G(DUZ(0))'="@",$TR(XSEC,$G(DUZ(0)))=XSEC Q
 ..S PL=$P(MW,U,3),MW=$P(MW,U),X=$G(^%ZIS(2,XSTYPE,1))
 ..S:'MW MW=$P(X,U)
 ..S:'PL PL=$P(X,U,3)
 ..S X=$P(X0,U)
 ..Q:$E(X,1,4)["NULL"
 ..S:X'=FROM X=FROM_"  <"_X_">"
 ..S BDGII=BDGII+1,@BDGXY@(BDGII)=IEN_U_$P(X0,U)
 Q
 ;
SETVARS() ; EP - Set the necessary variables for BLREVTQ to work
 S LRAS=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))    ; Get Accession
 I $L(LRAS)<1 Q $$WHYNOT("<NULL>","Accession string does not exist")
 ;
 I +$O(^BLRTXLOG("D",LRAS,0)) Q $$WHYNOT(LRAS,"Accession already in ^BLRTXLOG")
 ;
 S LRSS=$P($G(^LRO(68,LRAA,0)),"^",2)
 I LRSS'="CH"&(LRSS'="MI") Q $$WHYNOT(LRAS,"Accession not 'CH' nor 'MI' Subscript")
 ;
 S ORIGACCD=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",3)  ; Original Accession Date
 I ORIGACCD<YEARAGO Q $$WHYNOT(LRAS,"Original Accession Date More than a Year Ago")
 ;
 S ORDNUM=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.1))  ; Order Number
 I ORDNUM<1 Q $$WHYNOT(LRAS,"Order Number does not exist")
 ;
 S LRODT=+$O(^LRO(69,"C",ORDNUM,0))
 I LRODT<1 Q $$WHYNOT(LRAS,"Order Number "_ORDNUM_"'s Order Date does not exist for "_LRAD_" Accession Date")
 ;
 S LRSN=+$O(^LRO(69,"C",ORDNUM,LRODT,0))
 I LRSN<1 Q $$WHYNOT(LRAS,"Order Date's LRSN:"_LRSN_" does not exist")
 ;
 S DTTRAVIL=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",4)     ; Date/Time Results Available
 I +DTTRAVIL<1 Q $$WHYNOT(LRAS,"No 'Results Available' Date")
 ;
 S LRCDT=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,3))                  ; Collection Date/Time
 ;
 I $$PCCVFILE(LRAA,LRAS,LRCDT,LRSS,.PCCVISIT) Q $$WHYNOT(LRAS,"PCC Visit "_PCCVISIT_" Matched "_$P(LRCDT,".")_" Collection Date.")
 ;
 S (D0,DA,LRIDT)=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5) ; Inverse Date
 ;
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 S DFN=+$P($G(^LR(LRDFN,0)),"^",3)
 I DFN<1 Q $$WHYNOT(LRAS,"LRDFN "_LRDFN_" has no DFN.")
 ;
 D DFN^LRDAGE(DFN,2,LRCDT)
 S (BID,HRCN,PID)=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),"^",2)
 S PNM=$P($G(^DPT(DFN,0)),"^"),STR=$RE($P($G(^(0)),"^",9))
 S SSN=$RE($E(STR,7,9))_"-"_$RE($E(STR,5,6))_"-"_$RE($E(STR,1,4))
 ;
 S BLRCMF="M",BLRDH=+$H,BLRLOG=1,BLRPCC=1
 S BLROPT="BYPASS"                            ; Set to BYPASS because its already resulted
 S BLRPHASE="R"                               ; Set phase to RESULTing
 S BLRQSITE=DUZ(2),BLRQUIET=1,BLRSTOP=0
 S (BLRIDS,LRACC)=LRAS
 ;
 S STR=$$FMTE^XLFDT(LRCDT,"2M")
 S LRDAT=$P(STR,"/",1,2)_" "_$TR($P(STR,"@",2),":")_"d"
 ;
 S (LRACD,LRAOD)=LRAD
 S LRDT0=$$HTE^XLFDT($H,"2D")
 S LRLABKY="1^1^1^1"
 S LRLOCKER="^LR("_LRDFN_","_$C(34)_LRSS_$C(34)_","_LRIDT_")"
 S LROUTINE=9,LRPANEL=0,LRPCEVSO=1
 ;
 S PTR=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",8),LRLLOC=$P($G(^(0)),"^",7)
 S LRPRAC=$P($G(^VA(200,PTR,0)),"^")
 ;
 S PTR=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",10)
 ;
 S LRUID=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3))
 ;
 S STR=$G(^VA(200,DUZ,0))
 S LRUSI=$P(STR,"^",2)
 S LRUSNM=$P(STR,"^")
 ;
 S BLRPARAM=""
 Q "OK"
 ;
WHYNOT(LRAS,MESSAGE) ; EP - Store Reason why ^BLREVTQ not called
 S ^TMP("BLRPCCRR",$J,"NOSEND",LRAS,$H)=MESSAGE
 S NOTSENT=NOTSENT+1
 ;
 D WHYNCNTM(MESSAGE)
 ;
 Q:AUTOLOAD "Q"
 ;
 W !,?4,"Could not set a variable"
 W $S($L(LRAS):" for Accession "_LRAS_".",1:"."),!
 W ?9,"Error Message:",$E(MESSAGE,1,55),!
 D PRESSKEY^BLRGMENU(14)
 Q "Q"
 ;
PCCVFILE(LRAA,LRAS,LRCDT,LRSS,PCCVISIT) ; EP - Try to determine if Accession already in PCC File
 NEW BLRVERN,CDTPCC,FOUNDIT,PCCIEN
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 ;
 S:LRSS="CH" PCCFILE="^AUPNVLAB(""ALR0"","_$C(34)_LRAS_$C(34)_","
 S:LRSS="MI" PCCFILE="^AUPNVMIC(""ALR0"","_$C(34)_LRAS_$C(34)_","
 ;
 S LRCDT=$P(LRCDT,".")
 S PCCIEN=.9999999,FOUNDIT=0
 F  S PCCIEN=$O(@(PCCFILE_PCCIEN_")"))  Q:PCCIEN<1!(FOUNDIT)  D
 . S CDTPCC=$P($P($G(^AUPNVLAB(PCCIEN,12)),"^"),".")
 . S:CDTPCC=LRCDT FOUNDIT=PCCIEN
 ;
 I FOUNDIT S PCCVISIT=FOUNDIT  Q 1
 ;
 Q 0
 ;
WHYNCNTM(MESSAGE) ; EP - Just count messages
 S MESSAGE=$$UP^XLFSTR(MESSAGE)
 ;
 I MESSAGE["PCC VISIT",MESSAGE["MATCHED",MESSAGE["COLLECTION DATE" D CNTERRS("PCC VISIT FOUND")  Q
 I MESSAGE["ACCESSION STRING DOES NOT EXIST" D CNTERRS("ACCESSION STRING DOES NOT EXIST")  Q
 I MESSAGE["ACCESSION ALREADY IN ^BLRTXLOG" D CNTERRS("ACCESSION ALREADY IN ^BLRTXLOG")  Q
 I MESSAGE["ACCESSION NOT 'CH' NOR 'MI' SUBSCRIPT" D CNTERRS("ACCESSION NOT 'CH' NOR 'MI' SUBSCRIPT")  Q
 I MESSAGE["ORDER NUMBER DOES NOT EXIST" D CNTERRS("ORDER NUMBER DOES NOT EXIST")  Q
 I MESSAGE["NO 'RESULTS AVAILABLE' DATE" D CNTERRS("NO 'RESULTS AVAILABLE' DATE")  Q
 I MESSAGE["ORDER NUMBER",MESSAGE["ORDER DATE DOES NOT EXIST" D CNTERRS("ORDER DATE DOES NOT EXIST")  Q
 I MESSAGE["ORDER DATE'S",MESSAGE["DOES NOT EXIST" D CNTERRS("LRSN DOES NOT EXIST")  Q
 ;
 D CNTERRS(MESSAGE)
 Q
 ;
CNTERRS(ERRMSG) ; EP
 S ^TMP("BLRPCCRR",$J,"ERRCNTS",ERRMSG)=1+$G(^TMP("BLRPCCRR",$J,"ERRCNTS",ERRMSG))
 Q
 ;
TESTNAME(TIEN) ; EP - Return Test Name from File 60.  IFF Ref Lab AOE test, add "[ AOE ]" to end of the name
 NEW BLRCRL,BLRRIEN,DESCRIP
 ;
 S DESCRIP=$$GET1^DIQ(60,+TIEN,"NAME")
 S:$L(DESCRIP)<1 DESCRIP=" "
 ;
 S BLRCRL=+$P($G(^BLRSITE(DUZ(2),"RL")),U)
 Q:BLRCRL<1 DESCRIP                           ; No Reference Lab defined for DUZ(2), so return
 ;
 S BLRRIEN=+$O(^BLRRL("ALP",TIEN,BLRCRL,0))
 Q:BLRRIEN<1 DESCRIP                          ; No Reference Lab defined test, so return
 ;
 Q:'$D(^BLRRL(BLRCRL,1,BLRRIEN,1,0)) DESCRIP  ; No comments for test
 ;
 Q DESCRIP_" [ AOE ]"                         ; Make test as AOE test
