%ET ; cmi/flag/maw - CHEM, JC Hrubovcak, Tools 26 Oct 2000 20:38 DSM/MSM error handler ; [ 05/22/2002  2:53 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUL 01, 2001
 ;;v4.604 ; 27 October 2000
 ;COPYRIGHT 2000 SAIC
 ; shipped as ZETDVX, installed as %ET and %ZET
 ; Set $ZTRAP="INT^%ZET" to trap without message
 ;Format:
 ; ^%ET(-$h) = n
 ; ^%ET(-$h,n)       = $ZERROR
 ; ^%ET(-$h,n,"$I")  = $IO, $ZA, $ZB, $ZIO
 ; ^%ET(-$h,n,"$J")  = $JOB, Process name, Username, Nodename
 ; ^%ET(-$h,n,"$ZH") = $ZHOROLOG
 ; ^%ET(-$h,n,"$ZU") = UCI info
 ; ^%ET(-$h,n,"$ZR") = $ZREFERENCE
 ; ^%ET(-$h,n,#) #   = 1...n (for n variables in the symbol table)
 ; ^%ET(-$h,n,#,"V") = local variable
 ; ^%ET(-$h,n,#,"D") = datum of the local variable
 ;
 I $ZE="" Q:$QUIT "" Q
 D INT U $P W !!," An error has occurred."_$C(7)
 S %="The error is: "_$ZE_"." F  Q:'$L(%)  W !," "_$E(%,1,79) S %=$E(%,80,$L(%)) Q:'$L(%)
 W !," Please contact your site manager.",!
 Q:$QUIT "" Q
INT ;  Entry point for trap without message
 S $ZTRAP="ERROR^"_$T(+0) ; Trap internal errors
 ;S $ZWATCH(9)="A>;"_$ZREFERENCE ; Save naked ref.
 L:$ZE["-LCKERR"   ; lock limit exceeded?
 ; exclusive access to trap, set ^%ET to -$H, if % defined, save it & descendants
 L +^%ET(0) S ^%ET=-$H,^%ET(^%ET)=$G(^%ET(^%ET))+1,^%ET(^%ET,^%ET(^%ET))=$ZE M:$D(%) ^%ET(^%ET,^%ET(^%ET),"~","%")=% K % S %(0)=^%ET,%(1)=^%ET(%(0)) L -^%ET(0)
 ; %(0)=-$H, %(1)=error #
 ;S ^%ET(%(0),%(1),"$ZH")=$ZHOROLOG,^("$ZR")=$P($ZWATCH(9),"A>;",2,99) K $ZWATCH(9)
 ; save job info
 ;S ^%ET(%(0),%(1),"$J")=$J_$C(255)_$ZC(%GETJPI,0,"PRCNAM")_$C(255)_$ZC(%GETJPI,0,"USERNAME")_$C(255)_$ZC(%GETSYI,"NODENAME")
 ;S ^%ET(%(0),%(1),"$I")=$IO_$C(255)_$ZA_$C(255)_$ZB_$C(255)_$ZIO,^("$ZU")=$&ZLIB.%UCI(),%(2)=1
 ; Save symbol table, %(2)=symbol counter
 D:$D(^%ET(%(0),%(1),"~"))   ; get % variable data, if there
 .I $D(^%ET(%(0),%(1),"~","%"))'[0 S %(9)=^("%") D DV(%(9),"%")
 .F  S %(9)=$Q(^%ET(%(0),%(1),"~","%")) Q:%(9)'["~"  D DV(@%(9),"%("_$P(%(9),",""%"",",2,999)) K @%(9)
 S %(8)="%"   ; save local vars. & descendants
 F  S %(8)=$ZSORT(@%(8)) Q:%(8)=""  D:$D(@%(8))'[0 DV(@%(8),%(8)) S %(9)=%(8) F  S %(9)=$Q(@%(9)) Q:%(9)=""  D DV(@%(9),%(9))
 D STACK  ; save stack information
EXIT ; Exit, error in this routine comes here
 L -^%ET(0)   ; in case of internal error
 ; CHCS customization
 K %,IO("DEVICE OPEN") I $G(ZISPL),$D(^%ZISPJS(ZISPL)) D SETSTAT^%ZISAPI3(ZISPL,"T")
 I $ZE["-ENDOFILE",$G(DTIME)=1,$G(XQM),$L($T(NOTSK^XQTASK)) D NOTSK^XQTASK  ; option that wasn't to be tasked
 Q:$QUIT "" Q
 ;
 ; DV saves datum D for variable V and increments count in %(2)
DV(D,V) S ^%ET(%(0),%(1),%(2),"D")=D,^("V")=V,%(2)=%(2)+1 Q
 ;
STACK ; save stack info
 N C,S S C=1 F S=0:1:$ST(-1) S ^%ET(%(0),%(1),"%STACK",C)=" Context Level:"_$J(S,3)_"  Type: "_$ST(S)_"  Place: "_$ST(S,"PLACE"),^(C+1)="        M code: "_$ST(S,"MCODE"),C=C+2
 S $EC="" Q   ; erase stack info for error
 ;
ERROR ; Handle internal error
 S ^%ET(-$H,$G(^%ET(-$H))+1)="%DSM-E-ET, Error in ^"_$T(+0)_", "_$ZE
 U $P G EXIT
 ;
