BMXMBRK ; IHS/OIT/HMW - BMXNet MONITOR ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
PRSP(P) ;EP -Parse Protocol
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
 N ERR,C,M,R,X
 S R=0,C=";",ERR=0,M=512 ;Maximum buffer input
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
PRSM(P) ;EP - Parse message
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
 N C,ERR,M,R,X,U
 S U="^",R=1,C=";",ERR=0,M=512 ;Max buffer
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
 S U="^",R=2,C=";",ERR=0,M=512 ;Max buffer
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
 N A,ERR,F,FL,I,K,L,M,P1,P2,P3,P4,P5,MAXP,R
 S R=3,MAXP=+$E(P,1,5)
 S P1=$E(P,6,MAXP+5) ;only param string
 S ERR=0,F=3,M=512
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
 . . S BMXZ(R,"P",I)=$S(P3'=1:$E(P1,1,L),1:$$GETV($E(P1,1,L)))
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
 . F  D  Q:+L=0
 . . S L=$$BREAD(3) Q:+L=0  S P3=$$BREAD(L)
 . . S L=$$BREAD(3) IF +L'=0 S P4=$$BREAD(L)
 . . IF +L=0 Q
 . . IF P3=0,P4=0 S L=0 Q
 . . IF FL=1 D LINST(A,P3,P4)
 . . IF FL=2 D GINST
 IF ERR Q P1
 S P1=""
 D  Q P1
 . F I=0:1:K D
 . . IF FL,$E(BMXZ(R,"P",I),1,5)=".BMXS" D  Q  ;XWB*1.1*2
 . . . S P1=P1_"."_$E(BMXZ(R,"P",I),2,$L(BMXZ(R,"P",I)))
 . . . IF I'=K S P1=P1_","
 . . S P1=P1_"BMXZ("_R_",""P"","_I_")"
 . . IF I'=K S P1=P1_","
 IF '+ERR Q P1
 Q ERR
 ;
BREAD(L) ;read tcp buffer, L is length
 N E,X,DONE
 S (E,DONE)=0
 R X#L:BMXDTIME(1) ;IHS/OIT/HMW SAC Exemption Applied For
 S E=X
 IF $L(E)<L F  D  Q:'DONE
 . IF $L(E)=L S DONE=1 Q
 . R X#(L-$L(E)):BMXDTIME(1) ;IHS/OIT/HMW SAC Exemption Applied For
 . S E=E_X
 Q E
 ;
CALLP(BMXP,P,DEBUG) ;EP - make API call using Protocol string
 N ERR,S
 S ERR=0
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
 E  D CLRBUF ;p10
 IF 'DEBUG K BMXZ
 IF $D(BMXARY) K @BMXARY,BMXARY
 Q
 ;
LINST(A,X,BMXY) ;instantiate local array
 IF BMXY=$C(1) S BMXY=""
 S X=A_"("_X_")"
 S @X=BMXY
 Q
GINST ;instantiate global
 N DONE,N,T,T1
 S (DONE,I)=0
 ;find piece with global ref - recover $C(44)
 S REF=$TR(REF,$C(23),$C(44))
 F  D  Q:DONE
 . S N=$NA(^TMP("BMXZ",$J,$P($H,",",2)))
 . S BMXZ("FRM")=REF
 . S BMXZ("TO")=N
 . IF '$D(@N) S DONE=1 Q
 ;loop through all and instantiate
 S DONE=0
 F  D  Q:DONE
 . S T=$E(@REF@(I),4,M)
 . IF T="" S DONE=1 Q
 . S @N@("BMXZ")="" ;set naked indicator
 . S @T
 . S I=I+1
 K @N@("BMXZ")
 Q
 ;
GETV(V) ;get value of V - reference parameter
 N X
 S X=V
 IF $E(X,1,2)="$$" Q ""
 IF $C(34,36)[$E(V) X "S V="_$$VCHK(V)
 E  S V=@V
 Q V
 ;
VCHK(S) ;Parse string for first argument
 N C,I,P
 F I=1:1 S C=$E(S,I) D VCHKP:C="(",VCHKQ:C=$C(34) Q:" ,"[C
 Q $E(S,1,I-1)
VCHKP S P=1 ;Find closing paren
 F I=I+1:1 S C=$E(S,I) Q:P=0!(C="")  I "()"""[C D VCHKQ:C=$C(34) S P=P+$S("("[C:1,")"[C:-1,1:0)
 Q
VCHKQ ;Find closing quote
 F I=I+1:1 S C=$E(S,I) Q:C=""!(C=$C(34))
 Q
CLRBUF ;p10  Empties Input buffer
 N %
 F  R %#1:BMXDTIME(1) Q:%=""  ;IHS/OIT/HMW SAC Exemption Applied For
 Q
