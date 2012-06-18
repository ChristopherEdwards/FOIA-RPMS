BTPWPBTH ;VNGT/HS/ALA-Batch Process TIU Letters ; 27 Aug 2009  3:05 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 Q
 ;
EN(NDATA,BTPWDFN,BTPWVIEN,BTPWTIT,SUBJ,SIGN,TEXT) ; EP - BTPW BATCH NOTES
 ; Input
 ;   BTPWDFN  = Patient IEN
 ;   BTPWVIEN = Visit IEN
 ;   BTPWTIT  = Document Title IEN
 ;   SUBJ     = Subject header
 ;   SIGN     = Electronic Signature
 ;   TEXT     = Note text
 ;
 ; Create chart review visit
 ;   BTPWVIEN = Visit IEN
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPBTH D UNWIND^%ZTER" ; SAC 2006 2.2.3
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S NDATA=$NA(^TMP("BTPWPBTH",UID)),TEMP=$NA(^TMP("BTPWNOTE",UID))
 K @NDATA,@TEMP
 ;
 I $D(TEXT)>1 D
 . S BN="",LINE="",CT=0
 . F  S BN=$O(TEXT(BN)) Q:BN=""  D
 .. S NBN=$O(TEXT(BN))
 .. S LINE=LINE_TEXT(BN) I NBN'="" S LINE=LINE_TEXT(NBN)
 .. I NBN'="" D
 ... F BQ=1:1:$L(LINE,$C(10))-1 S CT=CT+1,@TEMP@(CT)=$P(LINE,$C(10),BQ)
 ... S LINE=$P(LINE,$C(10),BQ+1,$L(LINE,$C(10)))
 ... S BN=NBN
 .. I NBN="" D
 ... F BQ=1:1:$L(LINE,$C(10)) S CT=CT+1,@TEMP@(CT)=$P(LINE,$C(10),BQ)
 I $D(TEXT)=1 D
 . S LINE=TEXT,CT=0
 . F BQ=1:1:$L(LINE,$C(10)) S CT=CT+1,@TEMP@(CT)=$P(LINE,$C(10),BQ)
 ;
 ; Create Chart Review
 I $G(BTPWVIEN)="" D
 . S BTPWVIEN=$$EN^BTPWPCHT(1,BTPWDFN,1)
 I BTPWVIEN=-1 D  Q
 . S @NDATA@(II)="I00010RESULT^T00080MESSAGE^I00010VISIT_IEN"_$C(30)
 . S II=II+1,@NDATA@(II)="-1^Unable to create Chart Review Record^"_$C(30)
 . S II=II+1,@NDATA@(II)=$C(31)
 ; Get visit data
 NEW TIUDA,N,BTPWVIS,TIUX,RESULT
 S DATA="BTPWVIS"
 D LOAD^BEHOENP1(.DATA,BTPWDFN,BTPWVIEN)
 ;
 I $G(SUBJ)="" S SUBJ="CMET Batch Notification"
 ;
 S N=0
 F  S N=$O(BTPWVIS(N)) Q:N=""  D
 . I $P(BTPWVIS(N),U,1)="VST",$P(BTPWVIS(N),U,2)="HL" S TIUX(1205)=$P(BTPWVIS(4),U,3) Q
 . I $P(BTPWVIS(N),U,1)="HDR" S VSTR=$P(BTPWVIS(N),U,4)
 S TIUX(1202)=DUZ
 S TIUX(1301)=$$NOW^XLFDT()
 ; Subject (may need to be passed)
 S TIUX(1701)=SUBJ
 S TIUX("VISIT")=BTPWVIEN
 ;
 ; Create TIU record
 D MAKE^TIUSRVP(.RESULT,BTPWDFN,BTPWTIT,"","",BTPWVIEN,.TIUX,"",1,"")
 S TIUDA=RESULT
 ; Save document RPC - TIU SET DOCUMENT TEXT
 ;                TIUX("HDR")=<# of Current Page>^<Total # of Pages>
 ;                TIUX("TEXT",1,0)=<Line 1 of document body>
 ;                TIUX("TEXT",2,0)=<Line 2 of document body>
 ;                TIUX("TEXT",3,0)=<Line 3 of document body>
 ; Update the text for the patient
 ;K TIUX
 ;S I=0 F  S I=$O(@TIUY@(I)) Q:I=""  S TIUX(I,0)=@TIUY@(I)
 ;  Replace boilerplate with data
 K TIUX
 S BN=0 F  S BN=$O(@TEMP@(BN)) Q:BN=""  S TIUX(BN,0)=@TEMP@(BN)
 K ^TMP("TIUBOIL",$J)
 ; Variable needs to be set for the "{FLD:} values to stay in the text
 S XWBOS=1
 D GETTEXT^TIUSRVT(.TIUY,BTPWDFN,VSTR,.TIUX)
 K XWBOS
 K TIUZ
 M TIUZ=@TIUY
 K TIUX
 S TIUX("HDR")="1^1"
 S BN=0 F  S BN=$O(TIUZ(BN)) Q:BN=""  S TIUX("TEXT",BN,0)=TIUZ(BN,0)
 D SETTEXT^TIUSRVPT(.TIUY,TIUDA,.TIUX,1)
 ;
 ; Set the Chart Review with provider, dx and note
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 S APCDALVR("APCDTPS")="PRIMARY",APCDALVR("APCDTPRO")=DUZ
 S RESULT=$$ADD^BTPWPCHT(BTPWDFN,BTPWVIEN,.APCDALVR)
 ;
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]"
 S APCDALVR("APCDTPOV")="V68.9",APCDALVR("APCDTNQ")="CMET CHART REVIEW"
 S APCDALVR("APCDTPS")="PRIMARY"
 ;
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.28 (ADD)]"
 S APCDALVR("APCDTDOC")=TIUDA
 S RESULT=$$ADD^BTPWPCHT(BTPWDFN,BTPWVIEN,.APCDALVR)
 ;
 K @TEMP
 S @NDATA@(II)="T00001RESULT^T01024MSG^I00010BTPWVIEN^I00010TIUDA"_$C(30)
 S II=II+1,@NDATA@(II)=1_U_U_BTPWVIEN_U_TIUDA_$C(30)
 S II=II+1,@NDATA@(II)=$C(31)
 Q
 ;
ERR ;
 ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@NDATA@(II)=$C(31)
 Q
