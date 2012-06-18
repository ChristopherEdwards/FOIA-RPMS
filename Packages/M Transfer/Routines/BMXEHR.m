BMXEHR ; IHS/OIT/GIS - ENCAPSULATE BMX CALLS FOR USE WITHIN THE EHR 14 Jan 2009 4:37 PM ; 04 Jun 2010  3:16 PM
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
 ;
CIARPCD(XOUT,IN,A,B,C) ; EP - RPC: CIABMX - EHR WRAPER FOR BMX
 ;
 S A=$G(A),B=$G(B),C=$G(C)
 ; D DEBUG^%Serenji("CIARPCD^BMXEHR(.XOUT,IN,A,B,C)")
 Q
CIARPC(XOUT,IN,A,B,C) ; EP - RPC: CIABMX - EHR WRAPER FOR BMX
 ; INPUT = CF QUAD OR AN ADO RECORD SET
 ; OUT = BMX DATA ARRAY IN "^TMP("BMX DATA",$J)
 S XOUT=$NA(^TMP("BMX DATA",$J)),@XOUT@(1)=""
 ; S BMXR=$NA(^TMP("BMX ADO",$J))
 I $G(A)'="" S IN=IN_"^"_A
 I $G(IN)'["{BMX}" Q
 N X,Y,Z,BMXTBUF,BMXHTYP,BMXTLEN,L,BMXDTIME,BMXPLEN,STG,BMXTIME,BMXPTYPE,BMXWRAP,BMXR,I,SECURE,CTXT,DTSG,NODE,L
 S CTXT="",BMXTBUF="",RESULT=""
LONG D PARSE(IN,.CTXT,.BMXTBUF) I $L(BMXTBUF),$L(CTXT) G CALLPNOW ; INPUT STRING IS IN LONG FORMAT
SHORT D PARSE1 I '$L(BMXTBUF)!('$L(CTXT)) Q  ; LONG PARSE FAILED, SO INPUT STRING MUST BE IN SHORT FORMAT
CALLPNOW D CRCONTXT^XWBSEC(.SECURE,CTXT) I 'SECURE Q  ; CONFIRM THAT THE USER HAS CONTEXT SECURITY
 D CALLP(.BMXR,BMXTBUF,.BMXSTR) ; RUN THE RPC
 I BMXSTR="",$L($G(BMXR)) S BMXSTR=BMXR
 S BMXPTYPE=$S('$D(BMXPTYPE):1,BMXPTYPE<1:1,BMXPTYPE>6:1,1:BMXPTYPE)
 IF BMXPTYPE'=1,BMXPTYPE'=5,$L($G(BMXSEC))'>0
 E  S @XOUT@(1)=$G(BMXSTR) Q  ; -- SIMPLE STRING
ARR  ; -- word processing or global array, or global instance
 I $G(BMXR)="" S BMXR="BMXR"
 I '$O(@BMXR@(0)) Q
 S I="",NODE=1,L=0
 F  S I=$O(@BMXR@(I)) Q:I=""  D
 . S DSTG=@BMXR@(I)
 . I '$L(DSTG) Q
 . S %=$L(DSTG)+L I %<32000 S @XOUT@(NODE)=@XOUT@(NODE)_DSTG,L=% Q
 . S NODE=NODE+1,L=$L(DSTG)
 . S @XOUT@(NODE)=DSTG
 . Q
CLEANUP K @BMXR
 Q
 ; 
PARSE(IN,CTXT,STG1) ; EP - PARSE INPUT STRING, LONG FORMAT
 S CTXT="",STG1=""
 I $L($G(IN))
 E  Q
 N A,B,C,X,Y,Z,%,L1,L2,L3,L4
 S A=$E(IN,1,5) I A'="{BMX}" Q
 S L1=+$E(IN,16,18) I 'L1 Q
 S B=+$E(IN,18+L1+6) I B'=1 Q
 S L2=+$E(IN,6,10) I 'L2 Q
 S C=$E(IN,16,L2),D=$E(IN,L2+1,9999)
 S L3=+$E(D,11,15)
 S CTXT=$E(D,16,L3+15)
 S E=$E(D,L3+16,9999)
 S STG1=C_E
 Q
 ;
PARSE1 ; PARSE INPUT STRING, SHORT FORMAT
 S STG=IN,BMXTIME=$G(BMXTIME,60)
 S BMXTBUF=$E(STG,1,11),STG=$E(STG,12,999)
 S BMXHTYP=5
 S BMXTLEN=$E(BMXTBUF,6,10)-15,L=$E(BMXTBUF,11,11)
 S BMXTBUF=$E(STG,1,4),STG=$E(STG,5,999)
 S BMXTBUF=L_BMXTBUF
 S BMXPLEN=BMXTBUF
 S BMXTBUF=$E(STG,1,BMXPLEN),STG=$E(STG,(BMXPLEN+1),999)
 K BMXR,BMXARY
 S BMXDTIME=9999,BMXDTIME(1)=0.5
 I $L(IN,"{BMX}")>2 S CTXT=$E(IN,31+BMXPLEN,9999)
 Q
 ; 
PRSP(PARG) ;EP -Parse Protocol
 ;M Extrinsic Function
 ;
 ;Inputs
 ;P        Protocol string with the form
 ;         Protocol := Protocol Header^Message where
 ;         Protocol Header := LLLWKID;WINH;PRCH;WISH;MESG
 ;           LLL  := length of protocol header (3 numeric)
 ;           WKID := Workstation ID (ALPHA)
 ;           WINH := Window handle (ALPHA)
 ;           PRCH := Process handle (ALPHA)
 ;           WISH := Window server handle (ALPHA)
 ;           MESG := Unparsed message
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 ;
 N ERR,C,M,R,X,P
 S P=PARG
 S R=0,C=";",ERR=0,M=99999 ;Maximum buffer input
 IF $E(P,1,5)="{BMX}" S P=$E(P,6,$L(P)) ;drop out prefix
 IF '+$G(P) S ERR="-1^Required input reference is NULL"
 IF +ERR=0 D
 . S BMXZ(R,"LENG")=+$E(P,1,3)
 . S X=$E(P,4,BMXZ(R,"LENG")+3)
 . S BMXZ(R,"MESG")=$E(P,BMXZ(R,"LENG")+4,M)
 . S BMXZ(R,"WKID")=$P(X,C)
 . S BMXZ(R,"WINH")=$P(X,C,2)
 . S BMXZ(R,"PRCH")=$P(X,C,3)
 . S BMXZ(R,"WISH")=$P(X,C,4)
 Q ERR
 ;
PRSM(PARG) ;EP - Parse message
 ;M Extrinsic Function
 ;
 ;Inputs
 ;P        Message string with the form
 ;         Message := Header^Content
 ;           Header  := LLL;FLAG
 ;             LLL     := length of entire message (3 numeric)
 ;             FLAG    := 1 indicates variables follow
 ;           Content := Contains API call information
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 N C,ERR,M,R,X,U,P
 S P=PARG
 S U="^",R=1,C=";",ERR=0,M=99999 ;Max buffer
 IF '+$G(P) S ERR="-1^Required input reference is NULL"
 IF +ERR=0 D
 . S BMXZ(R,"LENG")=+$E(P,1,5)
 . S BMXZ(R,"FLAG")=$E(P,6,6)
 . S BMXZ(R,"TEXT")=$E(P,7,M)
 Q ERR
 ;
PRSA(P) ;EP - Parse API information, get calling info
 ;M Extrinsic Function
 ;Inputs
 ;P        Content := API Name^Param string
 ;           API     := .01 field of API file
 ;           Param   := Parameter information
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 ;
 N C,DR,ERR,M,R,T,X,U
 S U="^",R=2,C=";",ERR=0,M=99999 ;Max buffer
 IF '+$L(P) S ERR="-1^Required input reference is NULL"
 IF +ERR=0 D
 . S BMXZ(R,"CAPI")=$P(P,U)
 . S BMXZ(R,"PARM")=$E(P,$F(P,U),M)
 . S T=$O(^XWB(8994,"B",BMXZ(R,"CAPI"),0))
 . I '+T S ERR="-1^Remote Procedure '"_BMXZ(R,"CAPI")_"' doesn't exist on the server." Q  ;P10 - dpc
 . S T(0)=$G(^XWB(8994,T,0))
 . I $P(T(0),U,6)=1!($P(T(0),U,6)=2) S ERR="-1^Remote Procedure '"_BMXZ(R,"CAPI")_"' cannot be run at this time." Q  ;P10. Check INACTIVE field. - dpc.
 . S BMXZ(R,"NAME")=$P(T(0),"^")
 . S BMXZ(R,"RTAG")=$P(T(0),"^",2)
 . S BMXZ(R,"RNAM")=$P(T(0),"^",3)
 . S BMXPTYPE=$P(T(0),"^",4)
 . S BMXWRAP=+$P(T(0),"^",8)
 Q ERR
 ;information
PRSB(P) ;EP - Parse Parameter
 ;M Extrinsic Function
 ;Inputs
 ;P        Param   := M parameter list
 ;           Param   := LLL,Name,Value
 ;             LLL     := length of variable name and value
 ;             Name    := name of M variable
 ;             Value   := a string
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 ;
 ;
 N A,ERR,F,FL,I,K,L,M,P1,P2,P3,P4,P5,MAXP,R,Z
 S R=3,MAXP=+$E(P,1,5)
 S P1=$E(P,6,MAXP+5) ;only param string
 S ERR=0,F=3,M=99999
 IF '+$D(P) S ERR="-1^Required input reference is NULL"
 S FL=+$G(BMXZ(1,"FLAG"))
 S I=0
 IF '+ERR D
 . IF 'FL,+MAXP=0 S P1="",ERR=1 Q
 . F  D  Q:P1=""
 . . Q:P1=""
 . . S L=+$E(P1,1,3)-1
 . . S P3=+$E(P1,4,4)
 . . S P1=$E(P1,5,MAXP)
 . . S BMXZ(R,"P",I)=$S(P3'=1:$E(P1,1,L),1:$$GETV^BMXMBRK($E(P1,1,L)))
 . . IF FL=1,P3=2 D  ;XWB*1.1*2
 . . . S A=$$OARY^BMXMBRK2,BMXARY=A
 . . . S BMXZ(R,"P",I)=$$CREF^BMXMBRK2(A,BMXZ(R,"P",I))
 . . S P1=$E(P1,L+1,MAXP)
 . . S K=I,I=I+1
 . IF 'FL Q
 . S P3=P
 . S L=+$E(P3,1,5)
 . S P1=$E(P3,F+3,L+F)
 . S P2=$E(P3,L+F+3,M)
 . ;instantiate array
 . ;0011400
 . S Z=$P(P,".x",2,99)
 . F  D  Q:+L=0
 .  . S L=+$E(Z,1,3)
 .  . S P3=+$E(Z,4,3+L)
 .  . S L1=+$E(Z,L+4,L+6)
 .  . S P4=$E(Z,L+7,L+6+L1)
 . . ; S L=$$BREAD(3) Q:+L=0  S P3=$$BREAD(L)
 . . ; S L=$$BREAD(3) IF +L'=0 S P4=$$BREAD(L)
 . . IF +L=0 Q
 . . IF P3=0,P4=0 S L=0 Q
 . . IF FL=1 D LINST^BMXMBRK(A,P3,P4)
 . . S Z=$E(Z,L+7+L1,99999)
 IF ERR Q P1
 S P1=""
 F I=0:1:K D
 . IF FL,$E(BMXZ(R,"P",I),1,5)=".BMXS" D  Q  ;XWB*1.1*2
 .. S P1=P1_"."_$E(BMXZ(R,"P",I),2,$L(BMXZ(R,"P",I)))
 .. IF I'=K S P1=P1_","
 .. Q
 . S P1=P1_"BMXZ("_R_",""P"","_I_")"
 . IF I'=K S P1=P1_","
 . Q
 IF '+ERR Q P1
 Q ERR
 ;
CALLP(BMXP,P,BMXSTR,DEBUG) ;EP - make API call using Protocol string
 N ERR,S
 S ERR=0,BMXSTR=""
 K BMXSEC
 IF '$D(DEBUG) S DEBUG=0
 S ERR=$$PRSP(P)
 IF '+ERR S ERR=$$PRSM(BMXZ(0,"MESG"))
 IF '+ERR S ERR=$$PRSA(BMXZ(1,"TEXT")) ;I $G(BMXZ(2,"CAPI"))="XUS SET SHARED" S XWBSHARE=1 Q
 I +ERR S BMXSEC=$P(ERR,U,2) ;P10 -- dpc
 IF '+ERR S S=$$PRSB(BMXZ(2,"PARM"))
 ;IF (+S=0)!(+S>0) D
 I '+ERR D CHKPRMIT^BMXMSEC(BMXZ(2,"CAPI")) ;checks if RPC allowed to run
 S:$L($G(BMXSEC)) ERR="-1^"_BMXSEC
 ;IF 'DEBUG S:$D(XRT0) XRTN="RPC BROKER READ/PARSE" D:$D(XRT0) T1^%ZOSV ;stop RTL
 IF '+ERR,(+S=0)!(+S>0) D
 . D CAPI^BMXMBRK2(.BMXP,BMXZ(2,"RTAG"),BMXZ(2,"RNAM"),S)
 IF 'DEBUG K BMXZ
 IF $D(BMXARY) K @BMXARY,BMXARY
 Q
 ; 
TEST(OUT,STG,RPT,DELAY) ; 
 I $L($G(STG))
 E  Q
 S OUT=$NA(^TMP("BMX DATA",$J)),@OUT@(1)=""
 S RPT=+$G(RPT)
 I RPT F I=1:1:RPT S STG=STG_STG
 H +$G(DELAY)
 S OUT=STG
 Q
 ; 
