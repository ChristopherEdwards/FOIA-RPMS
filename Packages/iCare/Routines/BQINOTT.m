BQINOTT ;GDIT/HS/ALA-Note Trigger ; 21 Mar 2013  4:36 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;;
 ;
NOT(DATA,BQINOTT) ; EP - BQI TRIGGER NOTIFICATION
 NEW UID,II,VALUE,SOURCE,HELP,ABLE,REQ,CLEAR,TYPE,ABR,CLFLAG
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQINOTT",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQINOTT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 I BQINOTT="L"!(BQINOTT="P") D
 . S SOURCE="BTPWTDOC",VALUE="",HELP="",ABLE="Y",REQ="R",CLEAR="",CLFLAG="",TYPE="T" D REC
 . S SOURCE="BTPWTTMP",VALUE="",HELP="",ABLE="Y",REQ="R",CLEAR="",CLFLAG="",TYPE="T" D REC
 . S SOURCE="BTPWSIGN",VALUE="",HELP="",ABLE="Y",REQ="R",CLEAR="",CLFLAG="",TYPE="P" D REC
 . S SOURCE="BTPWLNK",VALUE="",HELP="",ABLE="Y",REQ="R",CLEAR="",CLFLAG="",TYPE="X" D REC
 E  D
 . S SOURCE="BTPWTDOC",VALUE="",HELP="",ABLE="N",REQ="R",CLEAR="BTPWTDOC",CLFLAG="",TYPE="T" D REC
 . S SOURCE="BTPWTTMP",VALUE="",HELP="",ABLE="N",REQ="R",CLEAR="BTPWTTMP",CLFLAG="",TYPE="T" D REC
 . S SOURCE="BTPWSIGN",VALUE="",HELP="",ABLE="N",REQ="R",CLEAR="BTPWSIGN",CLFLAG="",TYPE="P" D REC
 . S SOURCE="BTPWLNK",VALUE="",HELP="",ABLE="N",REQ="R",CLEAR="BTPWLNK",CLFLAG="",TYPE="X" D REC
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ; Header
 S @DATA@(II)="T00008SOURCE^T00001CODE_TYPE^T01024PARMS^T00030PROP_VALUE^T00001ABLE_FLAG^T00001REQ_OPT^T00200HELP_TEXT^T01024CLEAR_FIELDS^T00001CLEAR_FLAG"_$C(30)
 Q
 ;
REC ; Record
 S II=II+1,@DATA@(II)=$G(SOURCE)_U_$G(TYPE)_U_$G(VALUE)_U_U_$G(ABLE)_U_$G(REQ)_U_$G(HELP)_U_$G(CLEAR)_U_$G(CLFLAG)_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
INIT(DATA,FAKE) ;EP - BQI NOTIFICATION INITIAL
 NEW UID,II,VALUE,SOURCE,IEN,TYPE,IIEN,BTPWPFND,BTPWFNTR,FNDING,ABLE,FNDING
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQINOTI",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWBTTR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00008SOURCE^T00001CODE_TYPE^T00001ABLE_FLAG^T01024PARMS"_$C(30)
 S IEN="",VALUE="",ABLE="Y"
 S SOURCE="BQINOTT",TYPE="C",VALUE="P" D UP
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
UP ; Update
 S II=II+1,@DATA@(II)=SOURCE_U_TYPE_U_$G(ABLE)_U_VALUE_$C(30)
 Q