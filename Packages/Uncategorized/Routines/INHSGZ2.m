INHSGZ2 ;JSH,DGH; 21 Jan 2000 17:18 ;Interface - script generator for INPUT scripts
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 8; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
L(%L,%C) ;Place a line in the global
 ;%L = node after which to place the line of code
 ;%C = 1: place |CR| at the end   0: do not place |CR| at the end
L1 I $D(LSR),%L>699 Q
 S %L=%L+.1,^UTILITY("INS",$J,%L)=A_$P("|CR|",U,$G(%C)) Q
 ;
IN ;Enter here with:
 ;  FILE = file #
 ;  MESS = entry # of message
 ;  MESS(0) = zero node of message file entry
 ;
 ;Return with lines of script in ^UTILITY("INS",$J,n) [n=1,2,3...]
 ;  ERR is set on return.  0 = no errors occured  1 = there was an error
 ;
 D K,EN
K K DATA,TRANS,REQUIRED,A,SEG,FIELD,DTY,REQ,GL,TEMP,LOOKUP,IDENT,UFL,SVAR,OTHER,MULT,REPEAT,MULTF,MUMPS,SCODE,FLVL,SEGC,ROUTINE,FSAV,NOSTORE,GROUP,MULTL,INSYS,INAUDIT,STORE,LSR,SLVL,NOLS,LVAR Q
EN S (GROUP,FLVL,REPEAT,MULT,IDENT,DATA,SLVL)=0,TRANS=500,REQUIRED=600,LOOKUP=702,STORE=800,A="TRANS:" D L(.TRANS,1) S A="REQUIRED:" D L(.REQUIRED,1)
 S FILE(0)=FILE_U_^DIC(+FILE,0,"GL"),INSYS=$$SC^INHUTIL1,INAUDIT=+$P(MESS(0),"^",9) D:INAUDIT INIT^INHSGZ22
 S INSTD=$G(INSTD,"HL7")
 S A=";Generated from '"_$P(MESS(0),U)_"' "_INSTD_" message." D L(.DATA,1)
 S A="DATA:" D L(.DATA,1) I INAUDIT S A="^S INAUDIT=''$D(^INVQA(UIF)) I INAUDIT K ^UTILITY(""INVAUD"",$J) D INIT^"_ARNAME D L(.DATA,1)
 I $G(INSTD)="HL" S A="DELIM=$E(DATA,4)" D L(.DATA,1) S A="SUBDELIM=$E(DATA,5)" D L(.DATA,1) S A="" D L(.DATA,1)
 ;Hard-code NCPDP delimiter
 I $G(INSTD)="NC" S A="DELIM=""^""" D L(.DATA,1) S A="" D L(.DATA,1)
 ;Find X12 delimiters in ISA
 I $G(INSTD)="X12" S A="DELIM=$E(DATA,4)" D L(.DATA,1) S A="SUBDELIM=$E(DATA,105)" D L(.DATA,1) S A="" D L(.DATA,1)
SEGARRY ;Set up array of defined segments
 ;
 N SLVL,IDX,INSG
 S A="^N INDEFSEG" D L(.DATA,1)
 S SLVL=0
 S INS="" F  S INS=$O(^INTHL7M(MESS,1,"AS",INS)) Q:'INS  S X=$O(^(INS,0)),MESS(1)=^INTHL7M(MESS,1,X,0) D:'$P(MESS(1),U,11) SEG1(X)
 ;
 S:$G(^INTHL7M(MESS,5))]"" LSR=^(5)  ;FRW
 S INS="",SEGC=0,STL=800 F  S INS=$O(^INTHL7M(MESS,1,"AS",INS)) Q:'INS  S X=$O(^(INS,0)),MESS(1)=^INTHL7M(MESS,1,X,0) D:'$P(MESS(1),U,11) SEG(X) Q:ERR
 Q:ERR
 I GROUP S A="ENDGROUP" D L(.DATA,1) S GROUP=0
 I '$D(LSR) S ^UTILITY("INS",$J,700)="LOOKUP:|CR|",^(800)="STORE:|CR|" S:$P(MESS(0),U,7)]"" ^(702)="PARAM "_$S($P(MESS(0),U,7)="O":"N",1:$P(MESS(0),U,7))_"|CR|" D
 . I $O(^INTHL7M(MESS,4,0)) S I=0 F  S I=$O(^INTHL7M(MESS,4,I)) Q:'I  I ^(I,0)]"" S A="^"_$P(^(0),"|CR|")_"|CR|" D L(.LOOKUP,1)
 S:$D(LSR) ^UTILITY("INS",$J,700)="^Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  D "_$$LBTB^UTIL(LSR)_"|CR|"
 I INAUDIT S A="^I INAUDIT S %X=$S(INV["")"":$E(INV,1,$L(INV)),1:INV),%Y=""^UTILITY(""""INVAUD"""",$J)"" M @%Y=@%X" D L(.DATA,1)
 F I=499,599,699,799,9999 S ^UTILITY("INS",$J,I)="|CR|"
 S ^UTILITY("INS",$J,10000)="END:|CR|" I INAUDIT S ^UTILITY("INS",$J,9999.999)="^I INAUDIT D FINISH^"_ARNAME_"|CR|" D FILE^INHSGZ22
 Q
 ;
SEG(SEG) ;Process segment
 ;SEG = IEN in segment multiple of message
 S MESS(1)=^INTHL7M(MESS,1,SEG,0),SEG(2)=SEG,SEG=+MESS(1)
 Q:'$D(^INTHL7S(SEG,0))  S SEG(0)=^(0)
 K ^UTILITY("INDIA",$J) N MULTL,OTHER,REPEAT,MUMPS,SCODE,ROUTINE,NOSTORE,WP,MULTF,CH
 N LOOPST,LOOPDAD,LOOPID,NODATA,INCOUNT,ALIAS,LOOPREC,LOOPM1,LOOPM2
 S (MULTL,TEMP)=0
 ;Set NCPDP variables for id field and id value
 I $G(INSTD)="NC" S INIDF=$P(MESS(1),U,18),INIDV=$P(MESS(1),U,19)
 S NOLS=0 I $P(MESS(1),U,7)="P" S NOLS=1,OTHER="",REPEAT=$P(MESS(1),U,3),NOSTORE=1 K SVAR(.01) S:REPEAT SVAR(.01)=$P(SEG(0),U,2)_1,SLVL=SLVL+1 G NOLS
 S OTHER=$P(MESS(1),U,4,99) S:OTHER FLVL=FLVL+1,FILE(FLVL)=$P(OTHER,U,2)_U_^DIC($P(OTHER,U,2),0,"GL")
 S REPEAT=$P(MESS(1),U,3),MUMPS="^INTHL7M("_+MESS_",1,"_SEG(2)_",1)",SCODE="^INTHL7M("_+MESS_",1,"_SEG(2)_",2)",ROUTINE="^INTHL7M("_+MESS_",1,"_SEG(2)_",3)"
 S NOSTORE=$S('OTHER&'REPEAT:$P(MESS(0),U,7)="O",1:$P(OTHER,U,4)="O")!$D(LSR)
 I REPEAT,'OTHER K DIC S WP=0,DIC="^DD("_+FILE(FLVL)_",",DIC(0)="F",X=$P(OTHER,U,5) D  Q:WP
 . D ^DIC I Y<0 D ERROR("Multiple field '"_$P(OTHER,U,5)_"' not found for segment: "_$P(SEG(0),U)) Q
 . S MULTF=+Y,FLVL=FLVL+1,FILE(FLVL)=+$P(^DD(+FILE(FLVL-1),+Y,0),U,2)_U_FILE(FLVL-1)_"INDA(""S"")," I 'FILE(FLVL) D ERROR("Field '"_$P(OTHER,U,5)_"' is not a multiple.") Q
 . I $P(^DD(+FILE(FLVL),.01,0),U,2)["W" S WP=1 D WP^INHSGZ20 Q
 Q:ERR  S:REPEAT SLVL=SLVL+1 D:INAUDIT SEGINIT^INHSGZ22
NOLS S A=";'"_$P(SEG(0),U,2)_"' segment" D L(.DATA,1)
 S CP=0,CL="LINE("_$P(SEG(0),U,2)_"*) "
 ;If NCPDP, Set specialized LINE before "normal" LINE.
 I $G(INSTD)="NC",INIDF S A="LINE NCID "_INIDF_"="_INIDV D L(.DATA,1)
 ;If standard is HL7 or NCPDP, use HL7s group logic
 I $G(INSTD)'="X1" D
 .I REPEAT S CL="LINE ",A="ENDGROUP" D:GROUP L(.DATA,1) S GROUP=0,A="WHILE "_$S($P(MESS(1),U,9):"~REQUIRED~ ",1:"")_"$P(DATA,DELIM)="""_$P(SEG(0),U,2)_"""" D L(.DATA,1)
 .I 'REPEAT,'GROUP,'$P(MESS(1),U,11) S A="GROUP" D L(.DATA,1) S GROUP=1
 ;Establish transform section based on correct standard
 ;I $G(INSTD)'["NC" S A="IF $D(@INV@("""_$P(SEG(0),U,2)_"1""))" D L(.TRANS,1)
 D:$G(INSTD)'["NC"
 .N FF,FIELD S FF=1
 .S FIELD=+$O(^INTHL7S(SEG,1,"AS",0)),FIELD=+$O(^INTHL7S(SEG,1,"AS",FIELD,0))
 .S FIELD=+$G(^INTHL7S(SEG,1,FIELD,0))
 .S:$O(^INTHL7F(FIELD,10,0)) FF=1.1
 .S A="IF $D(@INV@("""_$P(SEG(0),U,2)_FF_"""))" D L(.TRANS,1)
 I $G(INSTD)="NC" S A="IF $D(@INV@("""_$P(SEG(0),U,2)_"""))" D L(.TRANS,1)
 K REPEAT("REQ") K:'NOLS SVAR(.01) S (INF0,INF)=""
 F  S INF0=$O(^INTHL7S(SEG,1,"AS",INF0)) Q:'INF0  S INF=INF0,X=$O(^(INF0,0)),(SEG(1),Y)=^INTHL7S(SEG,1,X,0),FIELD=+Y,REQ=$P(Y,U,3),UFL=$P(Y,U,5) D:$D(^INTHL7F(FIELD,0)) FIELD^INHSGZ20 Q:ERR
 Q:ERR  ;quit if there was an error in the field processing
 I CL]"" S A=CL D L(.DATA,1)
 ;If end-of-segment processing is needed, insert here
 I MULT S FLVL=FLVL-1,MULT=0,A="||" D:'FLVL TL^INHSGZ21
 K T S T1=$TR($P(OTHER,U,3),"[]") I T1="",'NOSTORE,$O(^UTILITY("INDIA",$J,.01)) D
 . N T1 S SEGC=SEGC+1,T="IU"_$E(SCR#1000+1000,2,5)_$C($S(SEGC<27:64,1:70)+SEGC)
 . N I S I=0 F  S I=$O(MULTL(I)) Q:'I  S ^UTILITY("INDIA",$J,+MULTL(I))="S:$G(DIPA("""_$P(MULTL(I),U,2)_"""))="""" Y="""_$P(MULTL(I),U,3)_""""_$S($P(MULTL(I),U,3)="":",INEXIT=1",1:"")
 . W !,"Creating and Compiling Input Template: "_T S F=$S(REPEAT&'OTHER:FLVL-1,1:FLVL) D:$P(OTHER,U,7) LINK^INHSGZ21 D ^INHDIA(T,+FILE(F)_^DIC(+FILE(F),0,"GL")) W !
 I 'OTHER,'REPEAT,'NOLS D
 . S:'SEGC SEGC=SEGC+1 S A="IF $D(@INV@("""_$P(SEG(0),U,2)_1_"""))" D L(.STORE,1)  I $D(T)!(T1]"") S A="TEMPLATE=["_$S(T1]"":T1,1:T)_"]" D L(.STORE,1)
 . I $G(@ROUTINE)]"" S A="ROUTINE= ^"_@ROUTINE D L(.STORE,1)
 . I INAUDIT S Z=ARSEG($P(SEG(0),U,2)),A="IF INAUDIT" D L(.STORE,1) S A="ROUTINE= "_$P(SEG(0),U,2)_U_ARNAME_$S(Z>1:$C(63+Z),1:"") D L(.STORE,1) S A="ENDIF" D L(.STORE,1)
 . S A="ENDIF" D L(.STORE,1)
 . I $O(@SCODE@(0)) S I=0 F  S I=$O(@SCODE@(I)) Q:'I  S A=$P(@SCODE@(I,0),"|CR|") D:$L(A) L(.LOOKUP,1)
 . I $O(@MUMPS@(0)) S I=0 F  S I=$O(@MUMPS@(I)) Q:'I  S A="^"_$P(@MUMPS@(I,0),"|CR|") D:$L(A) L(.LOOKUP,1)
 I $D(REPEAT("REQ")),$D(SVAR(.01)) D
 . S I="" F  S I=$O(REPEAT("REQ",I)) Q:I=""  S A=I_"^"_SVAR(.01)_$S('$P(MESS(1),U,9):"^D KILL^INHVA1("""_$P(SEG(0),U,2)_""","""_REPEAT("REQ",I)_""",.INI)",1:" ;"_REPEAT("REQ",I)) D L(.REQUIRED,1)
 I 'NOLS D:OTHER!REPEAT ROPOST^INHSGZ20 D:INAUDIT SEGEND^INHSGZ22
 I $D(^INTHL7M(MESS,1,"ASP",SEG)) S CH=0 F  S CH=$O(^INTHL7M(MESS,1,"ASP",SEG,CH)) Q:'CH  D SEG($O(^(CH,0)))
 S A="ENDIF" D L(.TRANS,1) S A="" D L(.TRANS,1)
 I REPEAT S A="ENDWHILE" D L(.DATA,1) S SLVL=SLVL-1
 I 'NOLS D:OTHER!REPEAT ROPOST1^INHSGZ20
 Q
 ;
SEG1(SEG) ;Process segment
 ;SEG = IEN in segment multiple of message
 S MESS(1)=^INTHL7M(MESS,1,SEG,0),SEG=+MESS(1)
 Q:'$D(^INTHL7S(SEG,0))  S SEG(0)=^(0)
 N REPEAT,CH
 S REPEAT=$P(MESS(1),U,3) S:REPEAT SLVL=SLVL+1 G NOLS1
 Q
 ;
NOLS1 ; Recursively process child segment if applicable
 S INSG=$P(SEG(0),U,2)
 S A="^S INDEFSEG("""_INSG_""","_SLVL_")="_+$P(MESS(1),U,3) D L(.DATA,1)
 I $D(^INTHL7M(MESS,1,"ASP",SEG)) S CH=0 F  S CH=$O(^INTHL7M(MESS,1,"ASP",SEG,CH)) Q:'CH  D SEG1($O(^(CH,0)))
 I REPEAT S SLVL=SLVL-1
 Q
 ;
ERROR(%M) ;Process an error
 ;%M = error text
 W !,*7,"ERROR: "_$G(%M) S ERR=1 Q
 ;
WARN(%M) ;Display a warning
 ;%M = warning text
 W !,*7,"WARNING: "_$G(%M) Q
