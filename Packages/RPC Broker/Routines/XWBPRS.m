XWBPRS ;ISF/STAFF - VISTA BROKER MSG PARSER ;11/15/11  12:39
 ;;1.1;RPC BROKER;**35,43,46,57,1018**;Mar 28, 1997;Build 7
 ;XWB holds info from the message used by the RPC
CALLP(XWBP,XWBDEBUG) ;make API call using Protocol string
 N ERR,S,XWBARY K XWB
 S ERR=0
 S ERR=$$PRSP("[XWB]") ;Read the rest of the protocol header
 I '+ERR S ERR=$$PRSM ;Read and parse message
 I $G(XWB(2,"RPC"))="XUS SET SHARED" S XWBSHARE=1 Q
 I '+ERR S ERR=$$RPC ;Check the RPC
 I +ERR S XWBSEC=$P(ERR,U,2) ;P10 -- dpc
 I '+ERR D CHKPRMIT^XWBSEC($G(XWB(2,"RPC"))) ;checks if RPC allowed to run
 S:$L($G(XWBSEC)) ERR="-1^"_XWBSEC
 I '+ERR D
 . D CAPI(.XWBP,XWB("PARAM"))
 E  I ($G(XWBTCMD)'="#BYE#") D LOG^XWBTCPM("Bad Msg"_ERR),CLRBUF
 I 'XWBDEBUG K XWB
 I $D(XWBARY) K @XWBARY,XWBARY
 Q
 ;
PRSP(P) ;ef, Parse Protocol
 ;M Extrinsic Function
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 ;
 N ERR,C,M,R,X
 S R=0,C=";",ERR=0
 S P=$$BREAD^XWBRW(4)
 IF $L(P)'=4 S ERR="-1^Short Header info"
 IF +ERR=0 D
 . S XWB(R,"VER")=+$E(P,1)
 . S XWB(R,"TYPE")=+$E(P,2)
 . S (XWBENVL,XWB(R,"LENV"))=+$E(P,3)
 . S (XWBPRT,XWB(R,"RT"))=+$E(P,4)
 I XWBENVL<1 S (XWBENVL,XWB(R,"LENV"))=3
 Q ERR
 ;
PRSM() ;ef, Parse message
 ;M Extrinsic Function
 ;See document on msg format
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 N C,EX1,ERR,R,X,CNK
 S R=1,C=";",CNK=0,EX1=0 ;Max buffer
 S ERR="-1^Invalid Chunk"
 F  S CNK=$$BREAD^XWBRW(1) Q:("12345"'[CNK)  D  Q:EX1
 . S EX1=(CNK=5),@("ERR=$$PRS"_CNK)
 Q ERR
 ;
PRS1() ;Parse the HEADER chunk
 N %,L,R
 S R=1
 S XWB(R,"VER")=$$SREAD
 S XWB(R,"RETURN")=$$SREAD
 Q 0
 ;
PRS2() ;Parse the RPC chunk
 N L,R
 S R=2
 S (XWBAPVER,XWB(R,"VER"))=$$SREAD ;RPC version
 S XWB(R,"RPC")=$$SREAD
 I $G(XWBDEBUG)>1 D LOG^XWBTCPM("RPC: "_XWB(R,"RPC"))
 Q 0
PRS3() ;Parse the Security chunk
 N L,R
 S R=3
 Q 0
PRS4() ;Parse the Command chunk
 N R
 S R=4,XWBTCMD=$$SREAD,XWB(R,"CMD")=XWBTCMD
 I $G(XWBDEBUG)>1 D LOG^XWBTCPM("CMD: "_XWBTCMD)
 Q ("TCPConnect^#BYE#"[XWBTCMD)
 ;
PRS5() ;Parse Data Parameter chunk
 ;M Extrinsic Function
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 ;
 N CONT,DONE,ERR,F,FL,IX,K,L,P1,P2,P3,P4,P5,MAXP,R,TY,VA
 S R=5,ERR=0,F=3,IX=0,DONE=0,CONT="f",XWB("PARAM")=""
 F  S:CONT="f" TY=$$BREAD^XWBRW(1) D  Q:DONE  S CONT=$$BREAD^XWBRW(1) S:CONT'="t" IX=IX+1
 . K VA,P1
 . IF TY=$C(4) S DONE=1 Q  ;EOT
 . IF TY=0 D  Q  ;literal
 . . D LREAD("VA")
 . . S XWB(R,"P",IX)=VA(1) D PARAM($NA(XWB(R,"P",IX)))
 . . Q
 . IF TY=1 D  Q  ;reference
 . . D LREAD("VA")
 . . S XWB(R,"P",IX)=$$GETV(VA(1)) D PARAM($NA(XWB(R,"P",IX)))
 . . Q
 . IF TY=2 D  Q  ;list
 . . I CONT'="t" D
 . . . S XWBARY=$$OARY,XWB(R,"P",IX)="."_XWBARY
 . . . D PARAM(XWB(R,"P",IX))
 . . D LREAD("P1") Q:P1(1)=""  D LREAD("VA")
 . . D LINST(XWBARY,P1(1),VA(1))
 . . Q
 . IF TY=3 D  Q  ;global
 . . I CONT'="t" D
 . . . S XWBARY=$NA(^TMP("XWBA",$J,IX)),XWB(R,"P",IX)=XWBARY
 . . . K @XWBARY S @XWBARY=""
 . . . D PARAM(XWBARY)
 . . D LREAD("P1") Q:P1(1)=""  D LREAD("VA")
 . . D GINST(XWBARY,P1(1),VA(1))
 . . Q
 . IF TY=4 D  Q  ;empty - ,,
 . . S XWB(R,"XWB",IX)=""
 . . Q
 . IF TY=5 D  Q
 . . ;stream still to be done
 . Q  ;End of loop
 Q ERR
PARAM(NA) ;Add a new parameter to the list
 N A
 S A=$G(XWB("PARAM")) S:'$L(NA) NA="""""" ;Empty
 S A=A_$S($L(A):",",1:"")_$S(TY=3:"$NA(",1:"")_NA_$S(TY=3:")",1:"")
 S XWB("PARAM")=A
 Q
 ;
RPC() ;Check the rpc information.
 ;M Extrinsic Function
 ;Outputs
 ;ERR      0 for success, "-1^Text" if error
 ;
 N C,DR,ERR,M,R,RPC,T,X
 S R=2,C=";",ERR=0,M=512 ;Max buffer
 S RPC=$G(XWB(R,"RPC")) I '$L(RPC) Q "-1^No RPC sent"
 S T=$O(^XWB(8994,"B",RPC,0))
 I '+T Q "-1^Remote Procedure '"_RPC_"' doesn't exist on the server."
 S T(0)=$G(^XWB(8994,T,0))
 I $P(T(0),U,6)=1!($P(T(0),U,6)=2) Q "-1^Remote Procedure '"_RPC_"' cannot be run at this time."  ;P10. Check INACTIVE field. - dpc.
 S XWB(R,"RTAG")=$P(T(0),"^",2)
 S XWB(R,"RNAM")=$P(T(0),"^",3)
 S XWBPTYPE=$P(T(0),"^",4)
 S XWBWRAP=+$P(T(0),"^",8)
 Q ERR
 ;
SREAD() ;Read a S_PACK
 N L,V7
 S L=$$BREAD^XWBRW(1),L=$A(L)
 S V7=$$BREAD^XWBRW(L)
 Q V7
 ;
LREAD(ROOT) ;Read a L_PACK
 N L,V7,I ;p45 Remove limit on length of string.
 S I=1,@ROOT@(I)=""
 S L=$$BREAD^XWBRW(XWBENVL),L=+L
 I L>0 S V7=$$BREAD^XWBRW(L),@ROOT@(I)=V7,I=I+1
 Q
 ;
 ;X can be something like '"TEXT",1,0'.
LINST(A,X,XWBY) ;instantiate local array
 IF XWBY=$C(1) S XWBY=""
 S X=A_"("_X_")"
 S @X=XWBY
 Q
 ;
 ;S can be something like '"TEXT",1,0'.
GINST(R,S,V) ;instantiate global
 N N
 I V=$C(1) S V=""
 S N=$P(R,")")_","_S_")"
 S @N=V
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
CLRBUF ;Empties Input buffer
 N %
 F  R *%:2 Q:'$T!(%=4)  ;!(%=-1)
 Q
ZZZ(X) ;Convert
 N I,J
 F  S I=$F(X,"$C(") Q:'I  S J=$F(X,")",I),X=$E(X,1,I-4)_$C($E(X,I,J-2))_$E(X,J,999)
 Q X
 ;
CAPI(XWBY,PAR) ;make API call
 N XWBCALL,T,DX,DY
 ; ZEXCEPT: XWBFGTIM - created here, will be killed in STRTCVR2 or ONECOVER
 ; ZEXCEPT: XWBCSRPC - created here, will be killed in ONECOVER
 ; JLI 110606 next line checks for start call to Coversheet Timing
 I XWB(2,"RTAG")="START",XWB(2,"RNAM")="ORWCV" I +$G(^KMPTMP("KMPD-CPRS")) S XWBFGTIM=$H D STRTCVR1 I 1
 E  I $G(XWBCOVER),$D(^TMP("XWBFGP",$J,"TODO",XWB(2,"RPC"))) S XWBFGTIM=$H,XWBCSRPC=XWB(2,"RPC")
 S XWBCALL=XWB(2,"RTAG")_"^"_XWB(2,"RNAM")_"(.XWBY"_$S($L(PAR):","_PAR,1:"")_")",XWBCALL2=""
 K PAR
 O XWBNULL U XWBNULL ;p43 Make sure its open
 ;
 I $G(XWBDEBUG)>2 D LOG^XWBDLOG("Call: "_$E(XWBCALL,1,247))
 ;start RUM for RPC
 I $G(XWB(2,"CAPI"))]"" D LOGRSRC^%ZOSV(XWB(2,"CAPI"),2,1)
 ;
 D @XWBCALL S XWBCALL2=XWBCALL ;Save call for debug
 N X,STS S X="BUSARPC",STS="" X ^%ZOSF("TEST") S:$T STS=$$XWB^BUSARPC(.XWB) K X,STS  ;IHS/OIT/FBD - 4/17/2013 - BXWB*1.1 / XWB*1.1*1018 - ADDED LINE - ENABLE BUSA AUDITING (MU2 REQUIREMENT)
 ;
 I $G(XWBCOVER),XWB(2,"RTAG")="START",XWB(2,"RNAM")="ORWCV" D STRTCVR2(XWBY) I 1
 E  I $D(XWBCOVER),$D(XWBCSRPC) D ONECOVER ; JLI 110606
 ;
 ;restart RUM for handler
 D LOGRSRC^%ZOSV("$BROKER HANDLER$",2,1)
 ;
 U XWBTDEV
 Q
 ;
OARY() ;create storage array
 N A,DONE,I
 S I=1+$G(XWB("ARRAY")),XWB("ARRAY")=I
 S A="XWBS"_I
 K @A ;temp fix for single array
 S @A="" ;set naked
 Q A
 ;
CREF(R,P) ;Convert array contained in P to reference A
 N I,X,DONE,F1,S
 S DONE=0
 S S=""
 F I=1:1  D  Q:DONE
 . IF $P(P,",",I)="" S DONE=1 Q
 . S X(I)=$P(P,",",I)
 . IF X(I)?1"."1A.E D
 . . S F1=$F(X(I),".")
 . . S X(I)="."_R
 . S S=S_X(I)_","
 Q $E(S,1,$L(S)-1)
 ;
STRTCVR1 ; JLI 110606
 ; SET UP DATA FOR OBTAINING FOREGROUND PROCESSING TIMES FOR COVERSHEET LOADS
 ; REQUESTED FOR TIMING ON COMMODITY SERVERS, ETC.
 N DFN,IP,HWND,NODE
 ; ZEXCEPT: XWBCOVER - created here, will be killed when foreground processing is complete
 S XWBCOVER=1
 K ^TMP("XWBFGP",$J)
 S DFN=XWB(5,"P",0),IP=XWB(5,"P",1),HWND=XWB(5,"P",2)
 S NODE="ORWCV "_IP_"-"_HWND_"-"_DFN
 S ^TMP("XWBFGP",$J,"NODE")=NODE ; SO WE CAN GET IT EASILY EACH PASS
 S ^KMPTMP("KMPDT","ORWCV-FT",NODE)=XWBFGTIM_"^^"_$G(DUZ)_"^"_$G(IO("CLNM"))
 Q
 ;
STRTCVR2(RETRNVAL) ; JLI 110606 - setup after coming back from initial start for coversheets
 N XWBFGDIF,I
 ; the return value contains ids for coversheets to be handled in the foreground separated by commas
 F I=1:1 S XWBCSID=$P(RETRNVAL,";",I) Q:XWBCSID=""  D SETCSID(XWBCSID)
 K XWBFGTIM
 Q
 ;
SETCSID(XWBCSID) ; Obtain and setup selected coversheet ids for foreground processing
 N I,RPC
 ; The coversheet ID value (XWBCSID) will be used for a look-up on the "AC" cross-reference of file 101.24.
 ; It is possible to have multiple entries with the same ID value, so checking that the 8th piece of the zero node of the value is a "C" will be required.
 F I=0:0 S I=$O(^ORD(101.24,"AC",XWBCSID,I)) Q:I'>0  I $P(^ORD(101.24,I,0),U,8)="C" S RPC=$P(^(0),U,13),RPC=$P(^XWB(8994,RPC,0),U),^TMP("XWBFGP",$J,"TODO",RPC)=I Q
 I $D(^TMP("XWBFGP",$J,"TODO","ORQQPX REMINDERS LIST")) D
 .N XWBCSIEN S XWBCSIEN=^TMP("XWBFGP",$J,"TODO","ORQQPX REMINDERS LIST")
 .S ^TMP("XWBFGP",$J,"TODO","ORQQPXRM REMINDERS APPLICABLE")=XWBCSIEN
 .S ^TMP("XWBFGP",$J,"TODO","ORQQPXRM REMINDERS UNEVALUATED")=XWBCSIEN
 .S ^TMP("XWBFGP",$J,"TODO","ORQQPXRM REMINDER CATEGORIES")=XWBCSIEN
 .Q
 Q
ONECOVER ; called after data is returned to client
 I "^ORQQPXRM REMINDERS APPLICABLE^ORQQPXRM REMINDERS UNEVALUATED^ORQQPXRM REMINDER CATEGORIES^"[U_XWBCSRPC_U K ^TMP("XWBFGP",$J,"TODO","ORQQPX REMINDERS LIST")
 I XWBCSRPC="ORQQPX REMINDERS LIST" D
 .K ^TMP("XWBFGP",$J,"TODO","ORQQPXRM REMINDERS APPLICABLE")
 .K ^TMP("XWBFGP",$J,"TODO","ORQQPXRM REMINDERS UNEVALUATED")
 .K ^TMP("XWBFGP",$J,"TODO","ORQQPXRM REMINDER CATEGORIES")
 .Q
 ;
 K ^TMP("XWBFGP",$J,"TODO",XWBCSRPC),XWBCSRPC,XWBFGTIM
 I '$D(^TMP("XWBFGP",$J,"TODO")) D ENDCOVER
 Q
 ;
ENDCOVER ; no more cover sheets to process, so set final values, clean up
 N I,NODE,X
 S NODE=^TMP("XWBFGP",$J,"NODE")
 S $P(^KMPTMP("KMPDT","ORWCV-FT",NODE),U,2)=$H
 K XWBCOVER,^TMP("XWBFGP",$J)
 ;
