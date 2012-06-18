BGUCEKT ; IHS/OIT/MJL - GENERAL PATIENT LOOKUP FOR BGU WINDOWS ;
 ;;1.5;BGU;;MAY 26, 2005
 ;GUI from PTLIST^BGUKT
 ;
 ;===================================================================
PTLIST(RESULT,X)        ;-get list of patients and pass back
 ;INPUTS : X = SEARCH-KEY | BGUMAX
 ;         SEARCH-KEY = used to limit the search.
 ;            = partial last name - use PTLIST^BGUKT().
 ;                   - RETURNS A LIST
 ;            = 1st letter of LAST name +  4 digits of SSN- DPT("BS5"
 ;                   - RETURNS A LIST
 ;            = DOB   - ^DPT("ADOB",DOB
 ;                   - RETURNS EXACT FIND
 ;            = Chart Number(all numeric) - use FIND^DIC call W/ EXACT
 ;                -  ^AUPNPAT("D",    - RETURNS EXACT FIND
 ;            = SSN - (ALL numeric) - DPT("SSN" - use FIND^DIC call 
 ;                   - RETURNS EXACT FIND
 ;            = LOC - dont know what to do right now. - DPT("CN"
 ;         BGUMAX = max number of records to send per call.
 ;        ^DD("DD") = "S Y=$$FMTE^DILIBF(Y,""5U"")"  - disp day of week 
 ;
 ;if SEARCH-KEY is 1-6 digits - search by Chart Number.
 ;                   9 digits - search by SSN
 ;                 1A4N       - search by A1N4
 ;              contains "/", - search by DOB
 ;ELSE                        - search by partial name.
 ;OUTPUTS: RESULT() = NAME^DFN^DOB^SSN^HRCN
 ;
 K BGUDATA,RESULT
 N BGUCOUNT,BGUDFN,BGUMAX,BGUZROS
 S BGUMAX=$P(X,"|",2),X=$P(X,"|")
 S BGUQT="""",RESULT(0.01)=0
 ;
 S BGUROOT="^BGUCTMP("_$J,TROOT=BGUROOT_")"
 S TROOT=BGUROOT_")",MROOT=BGUROOT_","_BGUQT_"ERRMSG"_BGUQT_")"
 K @TROOT
 ;
 ;LIST - FIRST letter of last name and 4 digits of SSN:
 I X?1A4N D A1N4 Q
 ;
 ;FIND - If X contains "/", this is DOB (so DOB input must contain "/").
 I X["/" D DOB Q
 ; 
 ;FIND - SSN - EXACT 9 digits.  ADD ;.09 would give SSN, but...
 I X?9N D SSN Q
 ;
 ;FIND - Chart Number - EXACT 1-6 digits.   ^AUPNPAT("D",CHRT,DFN,FAC)
 ;In SCREEN^DICL2(), DIENTRY = the curr. chart number, DIEN=DFN.
 I X?1.6N D CHRT Q
 ;
 ;LIST - Assume PARTIAL NAME search ;I X?.A." ".A.",".A." ".A D LSTNM Q
 D LSTNM,KILL
 Q
 ;
A1N4 ;LIST
 S FILE=2,INDEX="BS5",FIELDS=".01",X1=$E(X),X2=$E(X,2,5)+10000
 S:X2'="10000" X2=X2-1,X=$E(X)_$E(X2,2,5)
 S:X2=10000 X1=$C($A(X1)-1),X=X1_9999
 S BGUNX="S BGUSTRT=$E(NM)_$E(SSN,1,4)"
 D DICLST,FMTOUT,KILL
 Q
 ;
DOB ;LOOK UP BY DOB- EXACT MATCH FIND
 ;DOB is a regular field in 2.   DOB is a COMPUTED field in 9000001.
 S FILE=2,INDEX="ADOB",FIELDS=".01"
 S BGUNX="S BGUSTRT=DOB"
 D DICFIND,FMTOUT,KILL
 Q
 ;
SSN ;EXACT MATCH FIND
 ;LIST- S X=1000000000+X-1,X=$E(X,2,10) D DICLST,FMTOUT,KILL Q
 S FILE=2,INDEX="SSN",FIELDS=".01;.09"
 S BGUNX="S BGUSTRT=SSN"
 D DICFIND,FMTOUT,KILL
 Q
 ;
CHRT ;EXACT MATCH FIND - 1 to 6 digits (No Leading zeros)
 ;LIST^DIC- In SCREEN^DICL2(), DIENTRY=the curr. chart number, DIEN=DFN.
 ;S SCREEN="I $D(^AUPNPAT(""D"",DIENTRY,DIEN,DUZ(2)))"
 ;S $P(BGUZROS,"0",$L(X)+1)="",BGUZROS=1_BGUZROS,X=BGUZROS+X-1,X=$E(X,2,$L(X))
 ;FIND^DIC- In ^DICF3,      DIVALUE=the curr. chart number, DIENTRY=DFN.
 S SCREEN="I $D(^AUPNPAT(""D"",DIVALUE,DIENTRY,DUZ(2)))"
 S FILE=9000001,INDEX="D",FIELDS=".01"
 S BGUNX="S BGUSTRT=CHRT"
 D DICFIND,FMTOUT,KILL
 Q
 ; 
DICLST ;SETUP to call LIST^DIC( ) - SCREEN code is executed in ^DIL2C
 S IEN="",FLAGS=""
 S NUMBER=BGUMAX+1,FROM=X
 S PART="",IDNTIFIR="",SCREEN=$G(SCREEN)
 D LIST^DIC(FILE,IEN,FIELDS,FLAGS,NUMBER,FROM,PART,INDEX,SCREEN,IDNTIFIR,TROOT)
 Q
 ;
DICFIND ;SETUP to call FIND^DIC() - SCREEN code is executed in ^DICF3
 S IEN="",FLAGS=""
 S NUMBER=BGUMAX+1,VALUE=X
 S IDNTIFIR="",SCREEN=$G(SCREEN)
 D FIND^DIC(FILE,IEN,FIELDS,FLAGS,VALUE,NUMBER,INDEX,SCREEN,IDNTIFIR,TROOT,MROOT)
 Q
 ;
FMTOUT ;FMT output
 N CHRT,DFN,GLB,I,NM,OUT,SSN
 S GLB=BGUROOT_","_BGUQT_"DILIST"_BGUQT_")",OUT="RESULT",BGUCTR=0
 S I=0 F  S I=$O(@GLB@(2,I)) Q:I=""  D
 . S DFN=@GLB@(2,I),NM=@GLB@("ID",I,".01")
 . S VAL=^DPT(DFN,0),Y=$P(VAL,U,3) X ^DD("DD")
 . S SSN=$P(VAL,U,9)
 . S HRCN=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 . S BGUCTR=BGUCTR+1,@OUT@(BGUCTR)=NM_U_DFN_U_Y_U_SSN_U_HRCN
 S @OUT@(0.01)=BGUCTR
 ;I BGUCTR>BGUMAX S @OUT@(BGUMAX+1)="..MORE^"_$G(@OUT@(BGUMAX+1))
 S BGUSTRT=""
 I BGUCTR>BGUMAX X $G(BGUNX) S @OUT@(BGUMAX+1)="..MORE^"_BGUSTRT
 E  S @OUT@(BGUCTR+1)="**END**"
 Q
 ; 
LSTNM ;Partial last name search
 S %=$O(^DPT("B",X),-1),BGUCOUNT=1
 F I=1:1 S %=$O(^DPT("B",%)) Q:BGUCOUNT>BGUMAX!(%="")!(%'[X)  D
 . F DFN=0:0 S DFN=$O(^DPT("B",%,DFN)) Q:'DFN  D
 . . I $G(^DPT(DFN,0))'="" S VAL=^DPT(DFN,0),Y=$P(VAL,U,3) X ^DD("DD") S BGUCOUNT=BGUCOUNT+1,RESULT(I)=%_U_DFN_U_Y_U_$P(VAL,"^",9)_U_$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 S:BGUCOUNT>BGUMAX&($L(%)) RESULT(I)="..MORE^"_%
 S:%="" RESULT(I)="**END**"
 S RESULT(0.01)=BGUCOUNT
 Q
KILL ;
 K @TROOT,@MROOT
 K %,BGUAGEG,BGUBYR,BGUCOUNT,BGUD,BGUDFN,BGUEYR,BGUINC,BGUJ,BGUMAX
 K BGUOBJ,BGUOBJN,BGUOBJV,BGUPARM,BGUQTR,BGURTN,BGUYQ,BGUYR
 K BGUCTR,FIELDS,FILE,FLAGS,FROM,GLB,I,IDNTIFIR,IEN,INDEX
 K NM,NUMBER,OUT,PART,BGUQT,BGUROOT,SCREEN,SSN,TROOT,VAL
 K X1,X2,BGUZROS
 Q
 ;
ZZZ ;
