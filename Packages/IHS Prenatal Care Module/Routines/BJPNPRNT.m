BJPNPRNT ;GDIT/HS/BEE-Prenatal Care Module Print Handling Calls ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
GDFLT(DATA,LOC) ;BJPN GET DEF PRNT
 ;
 ;Returns current default printer for user
 ;
 S LOC=+$G(LOC)
 ;
 NEW UID,II,RET
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRNT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRNT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S II=II+1,@DATA@(II)="T00050IEN_NAME"_$C(30)
 ;
 ;Call CIAV API
 D PRTGETDF^CIAVUTIO(.RET,LOC)
 ;
 S II=II+1,@DATA@(II)=$G(RET)_$C(30)
 ;
XGDF S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SDFLT(DATA,DEV) ;BJPN SET DEF PRNT
 ;
 ;Sets the current default printer for user
 ;
 S DEV=$G(DEV)
 ;
 NEW UID,II,RET
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRNT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRNT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S II=II+1,@DATA@(II)="T00050RESULT"_$C(30)
 ;
 ;Call CIAV API
 S RET=1 I $G(DEV)]"" D PRTSETDF^CIAVUTIO(.RET,DEV)
 ;
 S II=II+1,@DATA@(II)=+$G(RET)_$C(30)
 ;
XSDF S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEVICE(DATA,FAKE) ;BJPN GET PRINTER LIST
 ;
 ;Returns the device list
 ;
 NEW UID,II,RET,TMP
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRNT",UID))
 S TMP=$NA(^TMP("BJPNPRT",UID))
 K @DATA,@TMP
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRNT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S II=II+1,@DATA@(II)="T00050IEN_NAME^T00100DISPLAY_NAME^T00050LOCATION^I00099RIGHT_MARGIN^I00099PAGE_LENGTH"_$C(30)
 ;
 ;Call CIAV API - Retrieve up to 2000 printers
 D DEVICE^CIAVUTIO(.RET,"",1,2000)
 ;
 ;Copy to return global
 S RET="" F  S RET=$O(RET(RET)) Q:RET=""  S II=II+1,@DATA@(II)=RET(RET)_$C(30)
 ;
XDEV K @TMP
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DETPRT(DATA,PIPIEN,DEVICE,CP,RM,PL) ;BJPN PRINT DETAIL
 ;
 ;Prints the specific problem detail to the selected device
 ;
 ;Input:
 ; PIPIEN - Pointer to PIP problem
 ; DEVICE - Device to print on (IEN_NAME value)
 ; CP - Number of Copies
 ;   RM - Right Margin
 ;   PL - Page Length
 ;
 NEW UID,II,RET,HDR,FTR,SPACE,PNAME,AGE,DOB,PAD,DFN,H2,%,NOW,PNOW,CTMAX
 NEW COPY,DIEN,HRN,REPT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRNT",UID))
 S REPT=$NA(^TMP("BJPNPBDT",UID))
 K @DATA,@REPT
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRNT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S II=II+1,@DATA@(II)="T00001RESULT^T00080ERROR_MESSAGE"_$C(30)
 ;
 D NOW^%DTC S NOW=%,PNOW=$P($$FMTE^BJPNPRL(NOW),":",1,2)
 ;
 ;Data Validation
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^INVALID PIPIEN"_$C(30) G XPRT
 I $G(DEVICE)="" S II=II+1,@DATA@(II)="-1^INVALID DEVICE"_$C(30) G XPRT
 S DIEN=$P(DEVICE,";")
 S CP=$G(CP) S:'CP CP=1
 S:$G(RM)="" RM=$$GET1^DIQ(3.5,DIEN_",",9,"E") S:RM="" RM=80
 S:$G(PL)="" PL=$$GET1^DIQ(3.5,DIEN_",",11,"E") S:PL="" PL=65
 S CTMAX=PL-3
 ;
 ;Retrieve Patient Info
 S DFN=$$GET1^DIQ(90680.01,PIPIEN_",",".02","I")
 S PNAME=$$GET1^DIQ(2,DFN_",",".01","E")
 S DOB=$$FMTE^BJPNPRL($$GET1^DIQ(2,DFN_",",.03,"I"))
 S AGE=$$AGE^AUPNPAT(DFN,,1),H2=DOB_" ("_AGE_")"
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2),"")
 ;
 ;Retrieve Detail
 D DET^BJPNPBDT("",PIPIEN)
 ;
 ;Define Report Header
 S SPACE=" ",$P(SPACE," ",RM)=" ",LINE="_",$P(LINE,"_",RM)="_"
 S PAD=(RM-$L("Prenatal Problem Detail"))\2
 S HDR(1)=$E(SPACE,1,PAD)_"Prenatal Problem Detail"
 S HDR(2)=PNAME_"  "_HRN,PAD=RM-$L(HDR(2))-$L(H2),HDR(2)=HDR(2)_$E(SPACE,1,PAD)_H2
 S HDR(3)=LINE
 S HDR(4)="*** WORK COPY ONLY ***",PAD=RM-$L(HDR(4))-$L(PNOW)-9,HDR(4)=HDR(4)_$E(SPACE,1,PAD)_"Printed: "_PNOW
 ;
 ;Define Report Footer
 S FTR(1)=LINE
 S FTR(2)="Page "
 S FTR(3)=HDR(4)
 ;
 ;Print each copy
 F COPY=1:1:CP D PRINT(.HDR,.FTR,RM,CTMAX)
 ;
 ;Record success
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
 Q
 ;
XPRT S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PRINT(HDR,FTR,RM,CTMAX) ;EP - Print each copy
 ;
 NEW CTL,PAGE,RLINE,OUT,PGBK,TTL,INDT
 ;
 ;Select (and skip) first line - Quit if no line
 S RLINE=$O(@REPT@("")) I RLINE="" Q
 S PAGE=1
 ;
 F  D  I $O(@REPT@(RLINE))="" Q
 . ;
 . ;Assemble Header
 . NEW REP,CT
 . S REP(1)=HDR(1)
 . S REP(2)=HDR(2)
 . S REP(3)=HDR(3)
 . S REP(4)=HDR(4)
 . ;
 . ;Add Report Data Lines
 . S CT=4 F  D  Q:(CT=CTMAX)  Q:($O(@REPT@(RLINE))="")
 .. ;
 .. NEW VALUE,WRAP,CNTL
 .. ;
 .. ;Pull Next Line
 .. S RLINE=$O(@REPT@(RLINE)),VALUE=@REPT@(RLINE)
 .. F CNTL=13,10,30,31 S VALUE=$TR(VALUE,$C(CNTL))
 .. ;
 .. ;Wrap the Line
 .. D WRAP(.WRAP,VALUE,RM)
 .. ;
 .. ;Process each wrapped line
 .. S WRAP="" F  S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 ... S CT=CT+1,REP(CT)=WRAP(WRAP)
 . ;
 . ;Assemble Footer
 . S REP(CT+1)=FTR(1)
 . S REP(CT+2)=FTR(2)_PAGE
 . S REP(CT+3)=FTR(3)
 . ;I $O(@REPT@(RLINE))]"" S REP(CT+4)="**PAGE BREAK**"
 . ;
 . ;Define CTL
 . I PAGE=1 S CTL=0
 . ;
 . ;Final Parameters
 . S (TTL,DEV,PGBK,INDT)=""
 . I $O(@REPT@(RLINE))="" D
 .. S DEV=DEVICE
 .. S TTL="Prenatal Problem Detail"
 .. S PGBK=""
 .. S INDT=0
 . ;
 . ;Output Report
 . D PRINT^CIAVUTIO(.OUT,CTL,.REP,DEV,PGBK,INDT)
 . S CTL=+$G(OUT)
 . ;
 . ;Update Page
 . S PAGE=PAGE+1
 ;
 Q
 ;
WRAP(OUT,TEXT,RM,IND) ;EP - Wrap the text and insert in array
 ;
 NEW SP
 ;
 I $G(TEXT)="" S OUT(1)="" Q
 I $G(RM)="" Q
 I $G(IND)="" S IND=0
 S $P(SP," ",80)=" "
 ;
 ;Strip out $c(10)
 S TEXT=$TR(TEXT,$C(10))
 ;
 F  I $L(TEXT)>0 D  Q:$L(TEXT)=0
 . NEW PIECE,SPACE,LINE
 . S PIECE=$E(TEXT,1,RM)
 . ;
 . ;Handle Line feeds
 . I PIECE[$C(13) D  Q
 .. NEW LINE,I
 .. S LINE=$P(PIECE,$C(13)) S:LINE="" LINE=" "
 .. S OUT=$G(OUT)+1,OUT(OUT)=LINE
 .. F I=1:1:$L(PIECE) I $E(PIECE,I)=$C(13) Q
 .. S TEXT=$E(SP,1,IND)_$$STZ($E(TEXT,I+1,9999999999))
 . ;
 . ;Check if line is less than right margin
 . I $L(PIECE)<RM S OUT=$G(OUT)+1,OUT(OUT)=PIECE,TEXT="" Q
 . ;
 . ;Locate last space in line and handle if no space
 . F SPACE=$L(PIECE):-1:(IND+1) I $E(PIECE,SPACE)=" " Q
 . I (SPACE=(IND+1)) D  S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT Q
 .. S LINE=PIECE,OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,RM+1,999999999))
 . ;
 . ;Handle line with space
 . S LINE=$E(PIECE,1,SPACE-1),OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,SPACE+1,999999999))
 . S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT
 ;
 Q
 ;
STZ(TEXT) ;EP - Strip Leading Spaces
 NEW START
 F START=1:1:$L(TEXT) I $E(TEXT,START)'=" " Q
 Q $E(TEXT,START,9999999999)
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=$G(II)+1,@DATA@(II)="-1"_$C(31)
 Q
