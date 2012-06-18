BTPWTIUN ;VNGT/HS/ALA-Create TIU Note for CMET ; 24 Aug 2009  6:50 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
EN(BTPWDFN,BTPWVIEN,BTPWTIT,BTPWTMP,SUBJ,SIGN,PARMS) ; EP - Create a TIU note
 ; Input
 ;   BTPWDFN  = Patient IEN
 ;   BTPWVIEN = Visit IEN
 ;   BTPWTIT  = Document Title IEN
 ;   BTPWTMP  = Template IEN
 ;   SUBJ     = Subject header
 ;   SIGN     = Electronic Signature
 ;   PARMS    = Parameters needed for the letter
 ;
 NEW TIUDA,N,BTPWVIS,TIUX,RESULT
 S DATA="BTPWVIS"
 D LOAD^BEHOENP1(.DATA,BTPWDFN,BTPWVIEN)
 ;
 S N=0
 F  S N=$O(BTPWVIS(N)) Q:N=""  D
 . I $P(BTPWVIS(N),U,1)="VST",$P(BTPWVIS(N),U,2)="HL" S TIUX(1205)=$P(BTPWVIS(4),U,3) Q
 . I $P(BTPWVIS(N),U,1)="HDR" S VSTR=$P(BTPWVIS(N),U,4)
 S TIUX(1202)=DUZ
 S TIUX(1301)=$$NOW^XLFDT()
 ; Subject (may need to be passed)
 I $G(SUBJ)="" S SUBJ="CMET Document"
 S TIUX(1701)=SUBJ
 S TIUX("VISIT")=BTPWVIEN
 ;  Create the document
 D MAKE^TIUSRVP(.RESULT,BTPWDFN,BTPWTIT,"","",BTPWVIEN,.TIUX,"",1,"")
 S TIUDA=RESULT
 ;  Lock the document
 D LOCK^TIUSRVP(.ERROR,TIUDA)
 I ERROR Q
 ;  Get the boilerplate
 D GETBOIL^TIUSRVT(.TIUY,BTPWTMP)
 K TIUX
 S I=0 F  S I=$O(@TIUY@(I)) Q:I=""  D
 . NEW VALUE
 . S VALUE=@TIUY@(I)
 . I VALUE["{FLD:" D
 .. NEW X,XLEN,VAR
 .. S X=VALUE,XLEN=$L(X)
 .. S X=$$DOLMLINE^TIUSRVF1(X)
 .. ; If the length of the updated line is NOT less than the original
 .. ; line length, then it should have translated okay
 .. I $L(X)'<XLEN S VALUE=X Q
 .. S X=VALUE
 .. S VAR=$P(X,"}",1),VAR=$P(VAR,":",2)
 .. I $D(PARMS(VAR)) D
 ... S NVAL=PARMS(VAR)
 ... S BL=$F(X,"{") S:BL=2 BL=1
 ... S BE=$F(X,"}")
 ... S NVALUE=""
 ... I BL=1 S NVALUE=NVAL_$E(X,BE,$L(X)) Q
 ... S NVALUE=$E(X,BL,BE)_NVAL_$E(X,BE,$L(X))
 .. S VALUE=NVALUE
 . S TIUX(I,0)=VALUE
 ;  Replace boilerplate with data
 K ^TMP("TIUBOIL",$J)
 D GETTEXT^TIUSRVT(.TIUY,BTPWDFN,VSTR,.TIUX)
 I $E(SIGN,1)'=" " S SIGN=" "_SIGN_" "
 ;  Check for valid signature
 D VALIDSIG^ORWU(.SIG,SIGN)
 S SUPRESS=0 I SIG S SUPRESS=1
 ;
 ;  Set the text into the document
 K TIUX
 S I=0 F  S I=$O(@TIUY@(I)) Q:I=""  S TIUX("TEXT",I,0)=@TIUY@(I,0)
 S TIUX("HDR")="1^1"
 D SETTEXT^TIUSRVPT(.TIUY,TIUDA,.TIUX,SUPRESS)
 ;  Set the signature into the document
 D SIGN^TIUSRVP(.ERROR,TIUDA,SIGN)
 ;  Unlock the document
 D UNLOCK^TIUSRVP(.ERROR,TIUDA)
 ;
 K TIUX,TMPN,VISIT,VSTR,X,TIUY,BTPWVIS,BE,BL,D,D0,DATA,DOCN,DG,DIC,DIW
 K N,NVAL,NVALUE,SIG,SIGN,SUPRESS,TIUPRM0,TIUPRM1
 Q TIUDA
 ;
ERR ;
 ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PTXT(NDATA,BTPWDFN,BTPWVIEN,BTPWTMP,SUBJ) ; EP - BTPW GET NOTE
 NEW II,UID,DATA,TEXT,VSTR
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWTINT D UNWIND^%ZTER" ; SAC 2006 2.2.3
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S NDATA=$NA(^TMP("BTPWTIUN",UID))
 K @NDATA
 ;
 ; Create Chart Review
 I $G(BTPWVIEN)="" D
 . S BTPWVIEN=$$EN^BTPWPCHT(1,BTPWDFN,1)
 ;
 I BTPWVIEN=-1 D  Q
 . S @NDATA@(II)="I00010RESULT^T00080MESSAGE^I00010VISIT_IEN"_$C(30)
 . S II=II+1,@NDATA@(II)="-1^Unable to create Chart Review Record^"_$C(30)
 . S II=II+1,@NDATA@(II)=$C(31)
 ;
 NEW TIUDA,N,BTPWVIS,TIUX,RESULT,TIUY,TT,XWBOS,TEXT
 S DATA="BTPWVIS"
 D LOAD^BEHOENP1(.DATA,BTPWDFN,BTPWVIEN)
 ;
 S N=0
 F  S N=$O(BTPWVIS(N)) Q:N=""  D
 . I $P(BTPWVIS(N),U,1)="VST",$P(BTPWVIS(N),U,2)="HL" S TIUX(1205)=$P(BTPWVIS(4),U,3) Q
 . I $P(BTPWVIS(N),U,1)="HDR" S VSTR=$P(BTPWVIS(N),U,4)
 S TIUX(1202)=DUZ
 S TIUX(1301)=$$NOW^XLFDT()
 ; Subject (may need to be passed)
 I $G(SUBJ)="" S SUBJ="CMET Document"
 S TIUX(1701)=SUBJ
 S TIUX("VISIT")=BTPWVIEN
 ;
 D GETBOIL^TIUSRVT(.TIUY,BTPWTMP)
 K TIUX
 S I=0 F  S I=$O(@TIUY@(I)) Q:I=""  S TIUX(I,0)=@TIUY@(I)
 ;  Replace boilerplate with data
 K ^TMP("TIUBOIL",$J)
 ; Variable needs to be set for the "{FLD:} values to stay in the text
 S XWBOS=1
 D GETTEXT^TIUSRVT(.TIUY,BTPWDFN,VSTR,.TIUX)
 K XWBOS
 S @NDATA@(II)="I00010BTPWVIEN^T32000NOTE_TEXT"_$C(30)
 S II=II+1,@NDATA@(II)=BTPWVIEN_U,TEXT=""
 S TT=0 F  S TT=$O(@TIUY@(TT)) Q:'TT  S TEXT=TEXT_@TIUY@(TT,0)_$C(10)
 S TEXT=$$TKO^BQIUL1(TEXT,$C(10))
 S @NDATA@(II)=@NDATA@(II)_TEXT_$C(30)
 S II=II+1,@NDATA@(II)=$C(31)
 K @TIUY
 Q
