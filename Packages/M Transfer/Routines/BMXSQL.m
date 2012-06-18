BMXSQL ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ; 
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
 Q
 ;
FLDNDX(BMXGBL,BMXFL,BMXFLD)   ;
 ;Returns index name and set code for all indexes on field
 ;on field BMXFLD in file BMXFL
 S BMX31=$C(31)_$C(31)
 K ^BMXTMP($J),^BMXTEMP($J)
 S BMXGBL="^BMXTEMP("_$J_")"
 I +BMXFL'=BMXFL D
 . S BMXFL=$TR(BMXFL,"_"," ")
 . I '$D(^DIC("B",BMXFL)) S BMXFL="" Q
 . S BMXFL=$O(^DIC("B",BMXFL,0))
 I '$G(BMXFL) D ERROUT("File number not provided.",1) Q
 ;
 ;Check for field name
 I +BMXFLD'=BMXFLD D
 . S BMXFLD=$TR(BMXFLD,"_"," ")
 . I '$D(^DD(BMXFL,"B",BMXFLD)) S BMXFLD="" Q
 . S BMXFLD=$O(^DD(BMXFL,"B",BMXFLD,0))
 I '$G(BMXFLD) D ERROUT("Field not provided",1) Q
 ;
 ;Set up Column names
 S ^BMXTEMP($J,0)="T"_$$NUMCHAR(30)_"INDEX^T"_$$NUMCHAR(200)_"CODE"_$C(30)
 ;
 ;Write field data to BMXTEMP
 S BMXI=0,I=0
 N BMXNAM,BMXCOD,BMXNOD,BMXTYP
 F  S BMXI=$O(^DD(BMXFL,BMXFLD,1,BMXI)) Q:'+BMXI  Q:$D(BMXERR)  D
 . S I=I+1
 . S BMXNOD=$G(^DD(BMXFL,BMXFLD,1,BMXI,0))
 . S BMXNAM=$P(BMXNOD,U,2)
 . S BMXTYP=$P(BMXNOD,U,3)
 . S:BMXTYP="" BMXTYP="REGULAR"
 . S BMXCOD=$G(^DD(BMXFL,BMXFLD,1,BMXI,1))
 . S BMXCOD=$TR(BMXCOD,"^","~")
 . S ^BMXTEMP($J,I)=BMXNAM_U_BMXTYP_U_BMXCOD_$C(30)
 Q
 ;
TLIST(BMXGBL,BMXFROM,BMXTO)      ;
 ;Returns list of Fileman files to which user has READ access
 ;TODO: Pass in type of access (RD,DL,WR) in BMXPAR
 ;
 N A,F,BMXF,BMXFLD,D0,BMXU,I,BMXCNT,BMXMFL,BMXRD,BMXMAX
 S U="^"
 S:$G(BMXFROM)="RD" BMXFROM=""
 K ^BMXTMP($J),^BMXTEMP($J)
 S BMXGBL="^BMXTEMP("_$J_")"
 S BMXF=1
 S BMXF("FILE")=1
 S BMXFLD("FILE")="1^.01"
 S BMXFLD("NUMBER")="1^.001" ;ADDED
 S BMXFLDN=$P(BMXFLD("FILE"),"^",2)
 S BMXFLDN(1,BMXFLDN)="FILE"
 S BMXFLDN=$P(BMXFLD("NUMBER"),"^",2) ;ADDED
 S BMXFLDN(1,BMXFLDN)="NUMBER" ;ADDED
 S BMXFLDO=2 ;CHANGED FROM 1 TO 2
 S BMXFLDO(0)="1^.01"
 S BMXFLDOX(1,.01,"E")=0
 S BMXFLDO(1)="1^.001" ;ADDED
 S BMXFLDOX(1,.001,"E")=1 ;ADDED
 S BMXFNX(1)="FILE"
 S BMXFO(1)="1"
 S BMXU=$G(DUZ(0))
 S BMXRD=$C(30)
 S ^BMXTEMP($J,0)="T00030FILE^N00010NUMBER"_BMXRD
 S BMXSET="S I=I+1,^BMXTEMP($J,I)=$P($G(^DIC(D0,0)),U)_U_D0_BMXRD,BMXCNT=BMXCNT+1"
 S D0=0,I=0,BMXCNT=0,BMXMAX=2000
 S BMXFROM=$G(BMXFROM),BMXTO=$G(BMXTO)
 I +BMXFROM=BMXFROM D  ;BMXFROM is a filenumber
 . S F=(+BMXFROM-1),T=+BMXTO
 . S:BMXTO<BMXFROM BMXTO=BMXFROM+1
 . S D0=F F  S D0=$O(^DIC(D0)) Q:'+D0  Q:D0>T  Q:BMXCNT>BMXMAX  I $D(^DD(D0)) D TLIST1
 I +BMXFROM'=BMXFROM D  ;F is a filename or is null
 . S F="",T="zzzzzzz"
 . S:$G(BMXFROM)]"" F=$O(^DIC("B",BMXFROM),-1)
 . S:$G(BMXTO)]"" T=BMXTO
 . F  S F=$O(^DIC("B",F)) Q:F=""  Q:F]T  Q:BMXCNT>BMXMAX  D
 . . S D0=0 F  S D0=$O(^DIC("B",F,D0)) Q:'+D0  D TLIST1
 ;
 S I=I+1,^BMXTEMP($J,I)=$C(31)
 Q
 ;
TLIST1 ;
 I BMXU="@" X BMXSET Q
 Q:$D(^DIC(D0,0))'=11
 S A=$G(^DIC(D0,0,"RD"))
 I $D(^VA(200,DUZ,"FOF",D0,0)) D  Q
 . ;I $P(^(0),U,5)="1" X BMXSET Q
 . I $P(^VA(200,DUZ,"FOF",D0,0),U,5)="1" X BMXSET Q
 F J=1:1:$L(A) I DUZ(0)[$E(A,J) X BMXSET
 Q
 ;
SQLCOL(BMXGBL,BMXSQL)        ;EP
 D INTSQL(.BMXGBL,.BMXSQL,1)
 Q
 ;
SQLD(BMXGBL,BMXSQL) ;EP Serenji Debug Entrypoint
 ;D DEBUG^%Serenji("SQLD^BMXSQL(.BMXGBL,.BMXSQL)")
 Q
 ;
SQL(BMXGBL,BMXSQL) ;EP
 D INTSQL(.BMXGBL,.BMXSQL,0)
 Q
 ;
INTSQL(BMXGBL,BMXSQL,BMXCOL)        ;EP
 ;
 ;SQL Top Wait for debug break
 ;D  
 ;. F J=1:1:10 S K=$H H 1
 ;. Q
 ;
 S X="ERRTRAP^BMXSQL",@^%ZOSF("TRAP")
 I $G(BMXSQL)="" S BMXSQL="" D
 . N C S C=0 F  S C=$O(BMXSQL(C)) Q:'+C  D
 . . S BMXSQL=BMXSQL_BMXSQL(C)
 ;
 I BMXSQL["call SHAPE" S BMXSQL="SELECT JUNKNAME, MULTCOLOR FROM JUNKMULT"
 ; Global-scope variables
 K BMXTK
 N BMXF,BMXTK,T,BMXFLD,BMXTMP,BMXM,BMXXMAX,BMXFLDN,BMXV
 N BMXX,BMXFG,BMXFF,BMXSCR,BMXPFP
 N BMXERR,BMXFLDO,BMXFLDOX,BMXFJ,BMXFO,BMXFNX
 N BMXMFL,BMXFLDA
 D ^XBKVAR
 S U="^"
 I $D(^%ZOSF("MAXSIZ")) S X=640 X ^%ZOSF("MAXSIZ")
 K ^BMXTMP($J),^BMXTEMP($J),^BMXTMPD($J)
 S BMXGBL="^BMXTEMP("_$J_")"
 ;Remove CR and LF from BMXSQL
 S BMXSQL=$TR(BMXSQL,$C(13)," ")
 S BMXSQL=$TR(BMXSQL,$C(10)," ")
 S BMXSQL=$TR(BMXSQL,$C(9)," ")
 S BMXSQL=$TR(BMXSQL,$C(34),"")
 D PARSE^BMXPRS(BMXSQL)
 S BMXXMAX=1000000 ;Default Maximum records to return.
 D KW^BMXSQL1(.BMXTK)
 Q:$D(BMXERR)
 ;
 ;Get file names into BMXF("NAME")="NUMBER"
 ;Get file numbers into BMXFNX(NUMBER)="NAME"
 ;  Files are ordered in BMXFO(order)="NUMBER"
 ;
FROM S T=$G(BMXTK("FROM"))
 I '+T S BMXERR="'FROM' CLAUSE NOT FOUND" D ERROR Q
 S BMXF=0
 F  S T=$O(BMXTK(T)) Q:'+T  Q:T=$G(BMXTK("WHERE"))  Q:T=$G(BMXTK("ORDER BY"))  Q:T=$G(BMXTK("GROUP BY"))  D  Q:$D(BMXERR)
 . Q:BMXTK(T)=","
 . N BMXFNT
 . I BMXTK(T)["'" S BMXTK(T)=$P(BMXTK(T),"'",2)
 . S BMXTK(T)=$TR(BMXTK(T),"_"," ")
 . I '(BMXTK(T)?.N),'$D(^DIC("B",BMXTK(T))) S BMXERR="FILE NOT FOUND" D ERROR Q
 . S BMXF=BMXF+1
 . I BMXTK(T)?.N S BMXFNT=BMXTK(T)
 . E  S BMXFNT=$O(^DIC("B",BMXTK(T),0))
 . S BMXMFL(BMXFNT,"GLOC")=^DIC(BMXFNT,0,"GL")
 . D F1(BMXF,BMXTK(T),BMXFNT)
 . I '+BMXF(BMXTK(T)) S BMXERR="FILE NUMBER NOT FOUND" D ERROR Q
 . D  ;Test alias 
 . . Q:'+$O(BMXTK(T))
 . . N V
 . . S V=T+1
 . . Q:$G(BMXTK(V))=","
 . . Q:V=$G(BMXTK("WHERE"))
 . . Q:V=$G(BMXTK("ORDER BY"))
 . . Q:V=$G(BMXTK("GROUP BY"))
 . . S BMXTK(T,"ALIAS")=BMXTK(V)
 . . K BMXTK(V)
 . . Q
 . Q
 ;
 D SELECT^BMXSQL5
 I $D(BMXERR) G END
 D POST2^BMXPRS ;Remove commas from BMXTK
 D KW^BMXSQL1(.BMXTK)
 ;
 D WHERE^BMXSQL7
 ;
 ;Find the first WHERE field that has an index
 I $D(BMXERR) G END
 ;
 D INDEX(.BMXFF,.BMXX,.BMXTMP)
 ;
 S:BMXTMP BMXX=BMXTMP
 ;
 ;Set up screen logic for where fields
 D SCREEN^BMXSQL1
 D SETX^BMXSQL2(.BMXX,.BMXFG,.BMXSCR)
 ;
 ;
EXEC ;Execute enumerator and screen code to call Output routine
 ;
 N BMXOUT,J,BMXC
 S BMXOUT=0
 ;Debug lines (retain):
 ;K ^HW("BMXX") S J=0 F  S J=$O(BMXX(J)) Q:'+J  S ^HW("BMXX",J)=BMXX(J)
 ;K ^HW("BMXSCR") S ^HW("BMXSCR")=$G(BMXSCR) S J=0 F  S J=$O(BMXSCR(J)) Q:'+J  S ^HW("BMXSCR",J)=BMXSCR(J)
 ;Test for SHOWPLAN
 I $G(BMXTK("SHOWPLAN"))="TRUE" D WPLAN Q
 S BMXM=0
 I 'BMXCOL S J=0 F  S J=$O(BMXX(J)) Q:'+J  D  Q:BMXM>BMXXMAX
 . X BMXX(J)
 ;
 D WRITE^BMXSQL6
 ;
END Q
 ;
 ;
F1(BMXC,BMXNAM,BMXNUM) ;EP
 S BMXF(BMXNAM)=BMXNUM
 S BMXFNX(BMXNUM)=BMXNAM
 S BMXFO(BMXC)=BMXF(BMXNAM)
 Q
 ;
OUT ;Set result in ^BMXTMP
 S BMXOUT=BMXOUT+1
 S ^BMXTMP($J,"O",D0)=""
 S ^BMXTMP($J,BMXOUT)=D0
 S BMXM=BMXM+1
 Q
 ;
WPLAN ;Write execution plan
 ;Set up Column Names
 N BMXLEN,BMXTYP,BMXT,J,BMXSCRT,BMXXT
 S I=1
 F BMXT="VARIABLE^","VALUE"_$C(30) D
 . S ^BMXTEMP($J,I)=BMXT,BMXLEN(I)=15,BMXTYP(I)="T"
 . S I=I+1
 S J=0
 I $D(BMXX) F  S J=$O(BMXX(J)) Q:'+J  D
 . S ^BMXTEMP($J,I)="INDEX("_J_")^"
 . S I=I+1
 . S BMXXT(J)=BMXX(J)
 . S BMXXT(J)=$P(BMXXT(J)," X BMXSCR")
 . S ^BMXTEMP($J,I)=$TR(BMXXT(J),"^","~")_$C(30)
 . S:$L(^BMXTEMP($J,I))>BMXLEN(2) BMXLEN(2)=$L(^BMXTEMP($J,I))
 . S I=I+1
 S ^BMXTEMP($J,I)="SCREEN^"
 S I=I+1
 S BMXSCRT=$G(BMXSCR)
 S BMXSCRT=$P(BMXSCRT,"D:'$D(^BMXTMP")
 S ^BMXTEMP($J,I)=$TR(BMXSCRT,"^","~")_$C(30)
 S:$L(^BMXTEMP($J,I))>BMXLEN(2) BMXLEN(2)=$L(^BMXTEMP($J,I))
 S I=I+1
 S J=0
 I $D(BMXSCR("C")) F  S J=$O(BMXSCR("C",J)) Q:'+J  D
 . S ^BMXTEMP($J,I)="SCREEN("_J_")^"
 . S I=I+1
 . S ^BMXTEMP($J,I)=$TR(BMXSCR("C",J),"^","~")_$C(30)
 . S:$L(^BMXTEMP($J,I))>BMXLEN(2) BMXLEN(2)=$L(^BMXTEMP($J,I))
 . S I=I+1
 D COLTYPE
 S I=I+1
 D ERRTACK(I)
 Q
 ;
 ;
COLTYPE ;EP - Append column types and widths to output global
 ;REQUIRES - BMXLEN(),BMXTYP(),^BMXTEMP
 ;IHS/SET/HMW 4-22-2004 Modified to use new schema string
 ;
 ;"@@@meta@@@BMXIEN|FILE #|DA STRING"
 ;
 N C
 S C=0
 F  S C=$O(BMXLEN(C)) Q:'C  D
 . I BMXLEN(C)>99999 S BMXLEN(C)=99999
 . I BMXLEN(C)=0 S BMXLEN(C)=50 ;Default column length
 . S ^BMXTEMP($J,C)=BMXTYP(C)_$$NUMCHAR(BMXLEN(C))_^BMXTEMP($J,C)
 Q
 ;
 ;S ^BXTEMP($J,0)="@@@meta@@@BMXIEN|"_BMXF_"|" ;Last |-piece will be DA string
 ;N C
 ;S C=0
 ;F  S C=$O(BMXLEN(C)) Q:'C  D
 ;. I BMXLEN(C)>99999 S BMXLEN(C)=99999
 ;. I BMXLEN(C)=0 S BMXLEN(C)=50 ;Default column length
 ;. S ^BMXTEMP($J,C)=BMXTYP(C)_$$NUMCHAR(BMXLEN(C))_^BMXTEMP($J,C)
 ;Q
 ;
ERRTACK(I) ;EP
 ;
 S ^BMXTEMP($J,I)=$C(31)
 S:$D(BMXERR) ^BMXTEMP($J,I)=^BMXTEMP($J,I)_BMXERR
 Q
 ;
NUMCHAR(BMXN)      ;EP
 ;---> Returns Field Length left-padded with 0
 ;
 N BMXC
 S BMXC="00000"_BMXN
 Q $E(BMXC,$L(BMXC)-4,$L(BMXC))
 ;
 ;
INDEX(BMXFF,BMXRET,BMXXCNT) ;
 ;Returns executable enumerator on first where field with an index
 ;or "" if no indexed where field
 ;IN: BMXFF()
 ;OUT: BMXRET()
 ;     BMXXCNT  - size of BMXRET array
 ;
 N F,BMXNOD,BMXFNUM,BMXFLDNM,BMXHIT,BMXREF,BMXRNAM,BMXOP,Q,BMXGL
 N BMXTMP,BMXTMPV,BMXTMPI,BMXTMPL,BMXTMPN,BMXV,BMXRNOD,BMXTMPP
 S BMXXCNT=0
 S Q=$C(34)
 I 'BMXFF Q
 S F=0,BMXHIT=0
 ;
 ;--->Search BMXFF for special case WHERE clause 1 = "0"
 ;    reset BMXX(1) to return no records
 F F=1:1:BMXFF S BMXNOD=BMXFF(F) D  Q:$D(BMXERR)  Q:BMXHIT
 . I ($P(BMXFF(F),"^",2,4)="1^=^0")!($P(BMXFF(F),"^",2,4)="0^=^1") S BMXRET(1)="Q  ",BMXHIT=1,BMXXCNT=1
 . Q
 Q:BMXHIT
 ;
 ;Organize the first level into AND- and OR-parts
 N BMXR1,BMXR2,BMXE,BMXR3,BMXRNAM
 N BMXSTOP,BMXOR
 D PLEVEL^BMXSQL3(.BMXFF,.BMXR1,.BMXR2)
 ;
 N BMXPFF S BMXPFF=0
 S BMXR3=0
 ;Look for an AND-part with only one element.
 ;  If found, build an iterator on it and quit
 F J=1:1:$L(BMXR2,"&") D  Q:BMXHIT
 . S BMXE=$P(BMXR2,"&",J)
 . I +BMXE=BMXE,BMXR1(BMXE,"ELEMENTS")=1 D
 . . ;Test index for element
 . . F K=BMXR1(BMXE,"BEGIN"):1:BMXR1(BMXE,"END") I "(^)"'[BMXFF(K) D  Q  ;I'm not sure why this quit was here
 . . . Q:$D(BMXFF(K,"JOIN"))
 . . . S BMXPFP=K,BMXPFF=0
 . . . D XRTST^BMXSQL3(.BMXFF,K,.BMXR3,.BMXRNAM,.BMXPFP)
 . . . I BMXR3 S BMXHIT=1,BMXFF(K,"INDEXED")=1
 . Q:'BMXHIT
 . ;Build iterator and quit
 . D BLDIT^BMXSQL3(.BMXFF,K,.BMXRNAM,.BMXOR,.BMXPFP)
 . S BMXXCNT=1
 . S BMXRET(BMXXCNT)=BMXOR
 . Q
 Q:BMXHIT
 ;
 ;None of the single-element AND parts has a good index or
 ;  there are no single-element AND parts
 ;If there are no OR-parts, then there are no good indexes so quit
 I $L(BMXR2,"!")=1 Q
 ;
 ;Test each OR-part for a good index.
 ;If an OR-part is multi-element or
 ;if one OR-part doesn't have an index
 ;then set up to do a table scan and quit
 S BMXSTOP=0
 F J=1:1:$L(BMXR2,"!") D  Q:BMXSTOP
 . S BMXE=$P(BMXR2,"!",J)
 . I +BMXE=BMXE D
 . . I BMXR1(BMXE,"ELEMENTS")'=1 S BMXSTOP=1 Q  ;Multiple elements
 . . ;Test index elements
 . . F K=BMXR1(BMXE,"BEGIN"):1:BMXR1(BMXE,"END") I "(^)"'[BMXFF(K) D  Q
 . . . S BMXPFP=K,BMXPFF=0
 . . . D XRTST^BMXSQL3(.BMXFF,K,.BMXR3,.BMXRNAM,.BMXPFP)
 . . . I 'BMXR3 S BMXSTOP=1 Q
 . . . S BMXFF(K,"INDEXED")=1
 . . . S BMXR1(BMXE,"XREF")=BMXRNAM
 ;
 ;Build iterator and quit
 I BMXSTOP D  Q  ;One of the elements had no index
 . S J=0 F  S J=$O(BMXFF(J)) Q:'+J  K BMXFF(J,"INDEXED")
 S BMXXCNT=0
 F J=1:1:$L(BMXR2,"!") D
 . S BMXE=$P(BMXR2,"!",J)
 . I +BMXE=BMXE,BMXR1(BMXE,"ELEMENTS")=1 D
 . . F K=BMXR1(BMXE,"BEGIN"):1:BMXR1(BMXE,"END") I "(^)"'[BMXFF(K) D  Q
 . . . D BLDIT^BMXSQL3(.BMXFF,K,BMXR1(BMXE,"XREF"),.BMXOR,.BMXPFP)
 . . . S BMXXCNT=BMXXCNT+1
 . . . S BMXRET(BMXXCNT)=BMXOR
 . Q
 Q
 ;
 ;
 ;
ERROR ;EP - Error processing
 ;W !,BMXERR
 ;N A
 ;S A=0
 ;I $D(I) S A=I
 ;D ERROUT(BMXERR,A)
 ;B  ;ERROR in BMXSQL
 Q
 ;
ERROUT(BMXERR,I) ;EP
 ;---> Save next line for Error Code File if ever used.
 ;---> If necessary, use I>1 to avoid overwriting valid data.
 D ERRTACK(I)
 Q
 ;
ERRTRAP ;
 ;
 K ^BMXTEMP($J)
 S ^BMXTEMP($J,0)="T00030M_ERROR"_$C(30)
 S BMXZE=$$EC^%ZOSV
 S BMXZE=$TR(BMXZE,"^","~")
 S ^BMXTEMP($J,1)=BMXZE_$C(30)
 S ^BMXTEMP($J,2)=$C(31)
 Q
