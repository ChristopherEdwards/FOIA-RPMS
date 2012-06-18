INHSZ1(SCR) ; cmi/flag/maw - JSH 20 Dec 1999 09:32 Script Compiler - perform compilation 07 Oct 91 6:44 AM ; [ 02/11/2005  11:43 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;**2,14**;JULY 1, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;SCR = script entry number to compile
 ;Main compile loop.
 I '$D(^INRHS(SCR,0)) D ERROR^INHSZ0("Script not found!",0) Q 0
 D K,EN,K Q X
K K SECT,DELIM,LCT,ER,INRL,WHILE,WARN,N,SET,DICOMPX,DOTLVL,CALL,WHSUB,LOOKUP,IDENT,IF,SUBDELIM,MCNT,LPARAM,REPEAT,REPEAT1,LVARS,MULT,FILE,FILE1,MODE,MNODE,OTHER,SLVL,INHSZ,FILEB,INDELIMS Q
 ;
EN S (FILEB,CALL,CALL(0,0),DOTLVL,LCT,ER,INRL,WARN,WHILE,GROUP,IF,LOOKUP,IDENT,DELIM,SUBDELIM,MCNT,REPEAT,REPEAT(0),REPEAT1,MULT,OTHER,SLVL)=0,(SECT,WHSUB,LPARAM,INDELIMS)="",CALL(0)=SCR,INHSZ=1
 S FILE=$P(^INRHS(SCR,0),U,3) I 'FILE D ERROR^INHSZ0("File not specified for this script!",0) S X=0 Q
 I '$D(^DIC(+FILE,0)) D ERROR^INHSZ0("File #"_+FILE_" does not exist!",0) S X=0 Q
 S (FILE1,FILE)=FILE_^DIC(+FILE,0,"GL")
 S MODE=$E($P(^INRHS(SCR,0),U,2))
 D INITCOD
 F  D GETLINE^INHSZ0 D:'$D(LINE) CALLU Q:CALL<0  D:$D(LINE)  Q:ER
 . W "." Q:LINE=""
 . Q:$E(LINE)=";"
 . I $E($$CASECONV^UTIL(LINE),1,7)="INCLUDE" D CALL Q
 . S LCT=LCT+1
 . I $E(LINE)="^" S LINE=$E(LINE,2,256) D MUMPS Q
 . I LINE?1.A1":" D  Q
 .. I SECT="END" D ERROR^INHSZ0("No other sections can follow END:",1) Q
 .. S SECT(0)=SECT,SECT=$$CASECONV^UTIL($P(LINE,":"),"U") I '$$CMD(SECT,"MUMPS^DATA^TRANS^REQUIRED^LOOKUP^STORE^END") D ERROR^INHSZ0("Invalid section name.",1) Q
 .. D SECTST
 . I SECT="" D ERROR^INHSZ0("Invalid command.",1) Q
 . I SECT="END" D WARN^INHSZ0("Line after END: ignored.",1) Q
 . D @SECT
 I ER W !!,"Compile aborted due to above error." S X=0 Q
 I SECT'="END" D ERROR^INHSZ0("Script ended without an END:") S X=0 Q
 W !!,"Compile completed with ",WARN," warnings and 0 errors."
 S X=1 Q
 ;
CALLU ;Up one call level
 S CALL=CALL-1 Q
 ;
CALL ;Down one call level
 N CS,CSN
 S CS=$$CASECONV^UTIL($$LBTB^UTIL($P(LINE," ",2,999)))
 S CSN=$O(^INRHS("B",CS,0)) I 'CSN D ERROR^INHSZ0("Script '"_CS_"' not found.",1) Q
 S CALL=CALL+1,CALL(CALL,0)=0,CALL(CALL)=CSN
 Q
 ;
SECTST ;Start of a new section
 I SECT(0)]"","MUMPS^DATA^TRANS^REQUIRED^LOOKUP^STORE^"[(SECT(0)_"^") D @("OUT^INHSZ"_$S(SECT(0)="DATA":2,SECT(0)="TRANS":3,SECT(0)="REQUIRED":4,SECT(0)="LOOKUP":5,SECT(0)="STORE":7,1:1))
 I SECT="MUMPS"
 I IF D ERROR^INHSZ0("IF not terminated before leaving "_SECT(0)_" section.",0) Q
 I MULT D ERROR^INHSZ0("All MULT blocks must be terminated before leaving "_SECT(0)_" section.",0) Q
 I OTHER D ERROR^INHSZ0("OTHER block must be terminated before leaving "_SECT(0)_" section.",0) Q
 I DOTLVL D ERROR^INHSZ0("All Loops not terminated before leaving "_SECT(0)_" sections",0) Q
 I MODE="O","TRANS^LOOKUP^STORE^"[(SECT_U) D ERROR^INHSZ0(SECT_" section not permitted in Output Mode.",1) Q
 W !,SECT," section." S A=" ;Entering "_SECT_" section." D L
 D @("IN^INHSZ"_$S(SECT="MUMPS":1,SECT="DATA":2,SECT="TRANS":3,SECT="REQUIRED":4,SECT="LOOKUP":5,SECT="END":6,SECT="STORE":7))
 Q
 ;
INITCOD ;Create the initialization code
 S A=" S X=""ERROR^"_ROU_""",@^%ZOSF(""TRAP"")" D L
 S A=" G START" D L
 S A="ERROR ;" D L
 S A=" S X="""",@^%ZOSF(""TRAP"") X ^INTHOS(1,3) D ERROR^INHS($$GETERR^%ZTOS)" D L
 S A=" Q 2" D L
 S A="START ;Initialize variables" D L
 I MODE="I" D
 . S A=" K FIELD,MDESC,INDA,DIPA S (INAUDIT,INLAYGO)=0" D L
 I MODE="O" D
 . S A=" K ^UTILITY(""INH"",$J) S (MESSID,INA(""MESSID""))=$$MESSID^INHD" D L
 .;X12 needs a number in addition to MESSID
 . I $G(INSTD)="X12" S A=" S INA(""INSEQ"")=$P(MESSID,$P($G(^INRHSITE(1,0)),U,8),2)#10000000" D L
 . S A=" K INUIF6 M INUIF6=INDA" D L  ; selective routing - pass INDA in msg
 S A=" K INREQERR,INHERR,INHERCNT,INV "
 ;cmi/maw - there is a possibility of changing the duz to something else
 ;S A=A_"D SETDT^UTDT S:'$G(DUZ) DUZ=.5,DUZ(0)=""@"",DUZ(""AG"")=""^1"",DTIME=1 S (LCT,GERR)=0,INMODE="""_MODE_""",INVS=$P(^INRHSITE(1,0),U,12),INV=$S(INVS<2:""INV"",1:""^UTILITY(""""INV"""",$J)""),(MULT,INSTERR)=0" D L  ;cmi/maw orig 8/9/2001
 S A=A_"D SETDT^UTDT S DUZ(0)=""@"",DUZ(""AG"")=""^1"",DTIME=1 S (LCT,GERR)=0,INMODE="""_MODE_""",INVS=$P(^INRHSITE(1,0),U,12),INV=$S(INVS<2:""INV"",1:""^UTILITY(""""INV"""",$J)""),(MULT,INSTERR)=0" D L  ;cmi/maw mod 8/9/2001
 S A=" S INHLDUZ=$O(^VA(200,""B"",""GIS,USER"",0)),DUZ=$S($G(INHLDUZ):INHLDUZ,1:.5)" D L  ;cmi/maw added for set of duz to gis user
 ;Support for HL7 Set ID
 S A=" S BHLMIEN="""_MESS_"""" D L  ;cmi/maw added to pass Message IEN
 ;cmi/anch/maw added the following to execute code before message
 S A=" I $G(^INTHL7M(BHLMIEN,4,1,0))]"""" X $G(^INTHL7M(BHLMIEN,4,1,0))" D L
 I INSTD="X12" S A=" S INEOSM="""_$G(INEOSM)_"""" D L  ;cmi/maw pass in eosm for x12
 S A=" K INSETID" D L
 S A=" S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)" D L
 ;Set up the field, component, and subcomponent separators for HL7
 S A=" S (DELIM,INDELIM)=$$FIELD^INHUT(),(SUBDELIM,INSUBDEL)=$$COMP^INHUT(),INSUBCOM=$$SUBCOMP^INHUT()" D L
 ;If outbound message set delimeter characters to CHCS default
 I MODE="O" S A=" S INDELIMS=$$FIELD^INHUT_$$COMP^INHUT_$$REP^INHUT_$$ESC^INHUT_$$SUBCOMP^INHUT" D L
 Q
 ;
MUMPS ;A line of MUMPS code
 I $D(LINE(1)) D ERROR^INHSZ0("Line of MUMPS code too long.",1) Q
 ;The DIM checker in IHS/VA does not allow a quit with value. The
 ;following strips out the quit code and checks only the user's
 ;lookup/store value.
 ;The following strips a specific instance of this from X before check 
 S X=LINE
 I X["Q:$G(INSTERR)" S X=$P(X,"Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  ",2)
 D ^DIM I '$D(X) D ERROR^INHSZ0("Invalid MUMPS code.",1) Q
 S A=" "_LINE D L
 Q
 ;
OUT ;Check for error signaled during MUMPS section
 D:MODE="I" QCHK^INHSZ0 Q
 ;
IN ;Code done at the start of every MUMPS section
 Q
 ;
L ;Place a line in the routine
 I DOTLVL S A=$P(A," ")_" "_$E("................",1,DOTLVL)_$P(A," ",2,999)
 S INRL=INRL+1,^UTILITY("IN",$J,"R",INRL)=A,A="" Q
 ;
DATA ;A line from the DATA section
 D DATA^INHSZ2 Q
 ;
TRANS ;A line from the TRANSFORM section
 D TRANS^INHSZ3 Q
 ;
REQUIRED ;A line from the REQUIRED section
 D REQUIRED^INHSZ4 Q
 ;
LOOKUP ;A line from the LOOKUP section
 D LOOKUP^INHSZ5 Q
 ;
STORE ;A line from the STORE section
 D STORE^INHSZ7 Q
 ;
CMD(%V,%L) ;Validate a command
 Q (%L_U)[($$CASECONV^UTIL(%V,"U")_U)
 ;
DOWN(%T) ;Move down a level at current line
 ;%T= type of level (W=while, G=group, ""=no type)
 S DOTLVL=DOTLVL+1,INDS(DOTLVL)=$G(%T)_U_INRL
 Q
 ;
UP ;Move up one level
 Q:'DOTLVL
 N SL,A
 S A=" Q" D L
 S SL=$P(INDS(DOTLVL),U,2),INDL(SL)=INRL,INDE(INRL)=SL,DOTLVL=DOTLVL-1
 Q
