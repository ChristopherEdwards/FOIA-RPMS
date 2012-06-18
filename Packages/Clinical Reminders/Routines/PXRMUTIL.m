PXRMUTIL ; SLC/PKR - Utility routines for use by PXRM. ;08/27/2001
 ;;1.5;CLINICAL REMINDERS;**2,5,7**;Jun 19, 2000
 ;
 ;=======================================================================
ANTON(ANUM) ;Convert an alphabetic number to its decimal form. This is the
 ;inverse of NTOAN.
 N INT
 S INT("A")=0,INT("B")=1,INT("C")=2,INT("D")=3,INT("E")=4,INT("F")=5
 S INT("G")=6,INT("H")=7,INT("I")=8,INT("J")=9,INT("K")=10,INT("L")=11
 S INT("M")=12,INT("N")=13,INT("O")=14,INT("P")=15,INT("Q")=16
 S INT("R")=17,INT("S")=18,INT("T")=19,INT("U")=20,INT("V")=21
 S INT("W")=22,INT("X")=23,INT("Y")=24,INT("Z")=25
 ;
 N LEN,NUMBR,P26,PWR
 S LEN=$L(ANUM),NUMBER=0,P26=1
 F DC=LEN:-1:1 D
 . S DIGIT=$E(ANUM,DC)
 . S NUMBER=NUMBER+(P26*INT(DIGIT))
 . S P26=26*P26
 Q NUMBER
 ;
 ;=======================================================================
ATTVALUE(STRING,ATTR,SEP,AVSEP) ;STRING contains a list of attribute value
 ;pairs. Each pair is separated by SEP and the attribute value pair
 ;is separated by AVSEP. Return the value for the attribute ATTR.
 N AVPAIR,IND,NUMAVP,VALUE
 S NUMAVP=$L(STRING,SEP)
 S VALUE=""
 F IND=1:1:NUMAVP Q:VALUE'=""  D
 . S AVPAIR=$P(STRING,SEP,IND)
 . I AVPAIR[ATTR S VALUE=$P(AVPAIR,AVSEP,2)
 Q VALUE
 ;
 ;=======================================================================
AWRITE(REF) ;Write all the descendants of the array reference.
 ;REF is the starting array reference, for example A or ^TMP("PXRM",$J).
 N DONE,IC,IND,LEN,PROOT,ROOT,START,TEMP
 I REF="" Q
 S PROOT=$P(REF,")",1)
 ;Build the root so we can tell when we are done.
 S TEMP=$NA(@REF)
 S ROOT=$P(TEMP,")",1)
 S REF=$Q(@REF)
 I REF'[ROOT Q
 S DONE=0
 F IC=0:0 Q:(REF="")!(DONE)  D
 . S START=$F(REF,ROOT)
 . S LEN=$L(REF)
 . S IND=$E(REF,START,LEN)
 . W !,PROOT_IND,"=",@REF
 . S REF=$Q(@REF)
 . I REF'[ROOT S DONE=1
 Q
 ;
 ;=======================================================================
COND(FIND3,TFIND3,V) ;Evaluate the finding condition. TFIND3 will be defined
 ;if this is being called from a term evaluation. V is the value.
 N CASESEN,COND,CONVAL
 S CONVAL=""
 S COND=$P(TFIND3,U,1)
 S CASESEN=$P(TFIND3,U,2)
 I COND="" D
 . S COND=$P(FIND3,U,1)
 . S CASESEN=$P(FIND3,U,2)
 . I CASESEN="" S CASESEN=2
 I $L(COND)>0 D
 . S V=$TR(V," ","~")
 . I 'CASESEN D
 .. S COND=$$UP^XLFSTR(COND)
 .. S V=$$UP^XLFSTR(V)
 . X COND
 . S CONVAL=$T
 Q CONVAL
 ;
 ;=======================================================================
DIWPS(DIWF,DIWL,DIWR) ;Setup the formatting for the DIWP call. The variables
 ;should be NEWED by the caller.
 S DIWF="C70",DIWL=0,DIWR=70
DIWPK ;
 K ^UTILITY($J,"W")
 Q
 ;
 ;=======================================================================
FNFR(ROOT) ;Given the root of a file return the file number.
 Q +$P(@(ROOT_"0)"),U,2)
 ;
 ;=======================================================================
MATCH(N1,ARRAY1,KEY1,N2,ARRAY2,KEY2,NMAT,MARRAY) ;Given two sorted
 ;arrays look for matches between the KEY1 piece of ARRAY1 and the KEY2
 ;piece of ARRAY2. Return ARRAY1_U_ARRAY2 matches in MARRAY.
 ;Initialize the number of matches to 0.
 S NMAT=0
 I (N1'>0)!(N2'>0) Q
 N A1,A2,IC,JC
 S (IC,JC)=1
ML ;
 S A1=$P(@ARRAY1@(IC),U,KEY1),A2=$P(@ARRAY2@(JC),U,KEY2)
 I A1=A2 D  Q:IC>N1  Q:JC>N2  G ML
 . S NMAT=NMAT+1
 . S @MARRAY@(NMAT)=@ARRAY1@(IC)_U_@ARRAY2@(JC)
 . S IC=IC+1,JC=JC+1
 I A1<A2 S IC=IC+1 Q:IC>N1  G ML
 S JC=JC+1 Q:JC>N2  G ML
 Q
 ;
 ;=======================================================================
NTOAN(NUMBER) ;Given an integer N return an alphabetic string that can be
 ;used for sorting. This will be modulus 26. For example N=0 returns
 ;A, N=26 returns BA etc.
 N ALPH
 S ALPH(0)="A",ALPH(1)="B",ALPH(2)="C",ALPH(3)="D",ALPH(4)="E"
 S ALPH(5)="F",ALPH(6)="G",ALPH(7)="H",ALPH(8)="I",ALPH(9)="J"
 S ALPH(10)="K",ALPH(11)="L",ALPH(12)="M",ALPH(13)="N",ALPH(14)="O"
 S ALPH(15)="P",ALPH(16)="Q",ALPH(17)="R",ALPH(18)="S",ALPH(19)="T"
 S ALPH(20)="U",ALPH(21)="V",ALPH(22)="W",ALPH(23)="X",ALPH(24)="Y"
 S ALPH(25)="Z"
 ;
 N ANUM,DIGIT,NUM,P26,PC,PWR
 S ANUM="",NUM=NUMBER,PWR=0
 S P26(PWR)=1
 F PWR=1:1 S P26(PWR)=26*P26(PWR-1) I P26(PWR)>NUMBER Q
 S PWR=PWR-1
 F PC=PWR:-1:0 D
 . S DIGIT=NUM\P26(PC)
 . S ANUM=ANUM_ALPH(DIGIT)
 . S NUM=NUM-(DIGIT*P26(PC))
 Q ANUM
 ;
 ;=======================================================================
POSTFIX(PFSTACK,EXPR,OPER) ;Given an expression, EXPR, in infix notation
 ;convert it to postfix and return the result in PFSTACK. PFSTACK(0)
 ;will contain the number of elements in PFSTACK. OPER is a
 ;string containing allowable operators.
 N CHAR,IND,LEN,OPERP,PFP,SP,SPACE,STACK,SYM,SYMP,SYMT,TAB,TEMP
 S SPACE=$C(32)
 S TAB=$C(9)
 S TEMP=""
 S OPERP=OPER_"()"
 S SYMP=0
 S LEN=$L(EXPR)
 ;Break the expression into (, ), operators, and operands.
 ;Remove spaces and tabs and put the symbols onto the symbol
 ;stack in left to right order. Symbol number 1 is SYM(1).
 F IND=1:1:LEN D
 . S CHAR=$E(EXPR,IND)
 . I (CHAR=SPACE)!(CHAR=TAB) Q
 . I OPERP[CHAR D
 .. I $L(TEMP)>0 D
 ... S SYMP=SYMP+1
 ... S SYM(SYMP)=TEMP
 ... S TEMP=""
 .. S SYMP=SYMP+1
 .. S SYM(SYMP)=CHAR
 . E  S TEMP=TEMP_CHAR
 . I (IND=LEN)&(TEMP'="") D
 .. S SYMP=SYMP+1
 .. S SYM(SYMP)=TEMP
 ;Process the symbols.
 S (PFP,SP)=0
 S LEN=SYMP
 F SYMP=1:1:LEN D
 . S SYMT=SYM(SYMP)
 .;
 .;Symbol is "("
 . I SYMT="(" D  Q
 .. S SP=SP+1
 .. S STACK(SP)=SYMT
 .;
 .;Symbol is an operator
 . I OPER[SYMT D  Q
 .. S LEN=SP
 .. F IND=LEN:-1:1 S TEMP=STACK(IND) Q:TEMP="("  D
 ...;M has no operator precedence so we don't need to check.
 ... S PFP=PFP+1
 ... S PFSTACK(PFP)=TEMP
 ... K STACK(SP)
 ... S SP=SP-1
 .. S SP=SP+1
 .. S STACK(SP)=SYMT
 .;
 .;Symbol is ")"
 . I SYMT=")" D  Q
 .. S LEN=SP
 .. F IND=LEN:-1:1 S TEMP=STACK(IND) Q:TEMP="("  D
 ... S PFP=PFP+1
 ... S PFSTACK(PFP)=TEMP
 ... K STACK(SP)
 ... S SP=SP-1
 ..;Pop the "(" at the top of the stack.
 .. K STACK(SP)
 .. S SP=SP-1
 .;
 .;If we get to here then symbol is an operand.
 . S PFP=PFP+1
 . S PFSTACK(PFP)=SYMT
 ;
 ;Pop and output anything left on the stack.
 F IND=SP:-1:1 D
 . S PFP=PFP+1
 . S PFSTACK(PFP)=STACK(IND)
 ;
 ;Save the number of elements in PFSTACK.
 S PFSTACK(0)=PFP
 Q
 ;
 ;=======================================================================
SEHIST(FILENUM,ROOT,IEN) ;Set the edit date and edit by and prompt the
 ;user for the edit comment.
 N DIC,DIR,DWLW,DWPK,ENTRY,FDA,FDAIEN,IENS,IND,MSG,SFN,TARGET,X,Y
 K ^TMP("PXRMWP",$J)
 D FIELD^DID(FILENUM,"EDIT HISTORY","","SPECIFIER","TARGET")
 S SFN=+$G(TARGET("SPECIFIER"))
 I SFN=0 Q
 S ENTRY=ROOT_IEN_",110)"
 S IND=$O(@ENTRY@("B"),-1)
 S IND=IND+1
 S IENS="+"_IND_","_IEN_","
 S FDAIEN(IEN)=IEN
 S FDA(SFN,IENS,.01)=$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
 S FDA(SFN,IENS,1)=$$GET1^DIQ(200,DUZ,.01)
 ;Prompt the user for edit comments.
 S DIC="^TMP(""PXRMWP"",$J,"
 S DWLW=72
 S DWPK=1
 W !,"Input your edit comments."
 S DIR(0)="Y"_U_"AO"
 S DIR("A")="Edit"
 S DIR("B")="NO"
 D ^DIR
 I Y D
 . D EN^DIWE
 . K ^TMP("PXRMWP",$J,0)
 . I $D(^TMP("PXRMWP",$J)) S FDA(SFN,IENS,2)="^TMP(""PXRMWP"",$J)"
 D UPDATE^DIE("E","FDA","FDAIEN","MSG")
 I $D(MSG) D AWRITE^PXRMUTIL("MSG")
 K ^TMP("PXRMWP",$J)
 Q
 ;
 ;=======================================================================
SORT(N,ARRAY,KEY) ;Sort an ARRAY with N elements into ascending order,
 ;return the number of unique elements. KEY is the piece of ARRAY on
 ;which to base the sort. The default is the first piece.
 ;
 I (N'>0)!(N=1) Q N
 N IC,IND,TEMP
 I '$D(KEY) S KEY=1
 F IC=1:1:N D
 . S TEMP=@ARRAY@(IC)
 . S ^TMP($J,"SORT",$P(TEMP,U,KEY))=TEMP
 S IND=""
 F IC=1:1 S IND=$O(^TMP($J,"SORT",IND)) Q:IND=""  D
 . S @ARRAY@(IC)=^TMP($J,"SORT",IND)
 K ^TMP($J,"SORT")
 ;Get rid of any redundant elements.
 F IND=IC:1:N K @ARRAY@(IND)
 Q IC-1
 ;
 ;=======================================================================
STRREP(STRING,TS,RS) ;Replace every occurence of the target string (TS)
 ;in STRING with the replacement string (RS).
 ;Example 9.19 (page 220) in "The Complete Mumps" by John Lewkowicz:
 ;  F  Q:STRING'[TS  S STRING=$P(STRING,TS)_RS_$P(STRING,TS,2,999)
 ;fails if any portion of the target string is contained in the with
 ;string. Therefore a more elaborate version is required.
 ;
 N IND,NPCS,STR
 I STRING'[TS Q STRING
 ;Count the number of pieces using the target string as the delimiter.
 S NPCS=$L(STRING,TS)
 ;Extract the pieces and concatenate RS
 S STR=""
 F IND=1:1:NPCS-1 S STR=STR_$P(STRING,TS,IND)_RS
 S STR=STR_$P(STRING,TS,NPCS)
 Q STR
 ;
 ;=======================================================================
VEDIT(ROOT,IEN) ;This is used as a DIC("S") screen to select which entries
 ;a user can edit.
 N CLASS,ENTRY,VALID
 S ENTRY=ROOT_IEN_")"
 S CLASS=$P($G(@ENTRY@(100)),U,1)
 I CLASS="N" D
 . I ($G(PXRMINST)=1),(DUZ(0)="@") S VALID=1
 . E  S VALID=0
 E  S VALID=1
 Q VALID
 ;
