INHUTC1 ;bar; 22 Jul 97 15:37; Internal Functions for Criteria Mgmt 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 Q
 ;
GET(INOPT) ; return a working  entry in the INTERFACE CRITERIA file
 ; selection and edit are called if appropriate
 ;
 ; input:   INOPT array. See top of INHUTC for description.
 ; returns: ien of record in INTERFACE CRITERIA file
 ;          if function does not complete, reason text is returned
 ;
 N X,Y,INDA,INX,INAME,INFROM
 ; validate name or ien passed in. if name is ien convert to name
 S INFROM=0,INAME=$G(INOPT("NAME"))
 I INAME=+INAME S INFROM=INAME,INAME=$P($G(^DIZ(4001.1,INFROM,0)),U,4)
 E  I $L(INAME),'INFROM S INFROM=$$LOOKUP(.INOPT,INAME,0)
 I INFROM,'$$VALID(.INOPT,INFROM,"WUS") Q "GET: NAME value: "_INOPT("NAME")_" is not a valid INTERFACE CRITERIA type."
 ; user lookup here
 I '$G(INOPT("NONINTER")) S X="" D  S INFROM=$S(X<1:0,1:X) I X["^" Q "GET: User abort from select"
 . N INB
 . I $D(INOPT("PROMPT")) S INB=INOPT("PROMPT")
 . E  D
 .. S INB=$G(INOPT("TYPE")),INB="Select Interface "_$E(INB)_$$DNCASE^%ZTF($E(INB,2,$L(INB)))_" criteria name: "
 .. S INB=INB_";;;;"_$G(INAME)_";;;;S X=$$LOOKUP^INHUTC1(.INOPT,X,1) K:'X X"
 .;If system is IHS, call ScreenMan
 .I '$$SC^INHUTIL1 D  Q
 ..S X=$$NEW(.INOPT,"W")
 ..S DA=X
 ..N DDSFILE,DR,DDSPAGE,DDSPARM,DDSAVE
 ..S DDSFILE="^DIZ(4001.1,",DR="["_INOPT("GALLERY")_"]",DDSPAGE=1,DDSPARM="S"
 ..D ^DDS
 ..I '$G(DDSSAVE) S X="^"
 ..;END IHS BRANCH
 . D CLEAR^DW F  D  Q:X!(X["^")
 .. D ^UTWRD(INB,1) Q:X!(X["^")
 .. I '$L(X) S X=$$NEW(.INOPT,"W") Q
 .. I X="?" D GETHELP(.X) Q:'$L(X)!(X["^")
 .. S X=$$LOOKUP^INHUTC1(.INOPT,X,1) Q:X!(X["^")  Q:$D(DTOUT)!$D(DUOUT)
 . D CLEAR^DW
 ; save selected entry name
 S:INFROM INOPT("SELECTED")=INFROM_U_$P($G(^DIZ(4001.1,INFROM,0)),U,4)
 ; if the entry is a working rec, just use it
 I INFROM,$P($G(^DIZ(4001.1,INFROM,0)),U,3)="W" Q INFROM
 ; get a work entry and populate with found entry
 S INDA=$$WORKREC(.INOPT,$G(INOPT("NEW"),0)) D COPY(INFROM,INDA,"W")
 Q INDA
 ;
GETHELP(INX) ; help for criteria lookup screen
 D MESS^DWD(14,2)
 W !,"Interface Criteria:"
 W !,"    Enter '??' for a list of saved criteria entries."
 W !,"    Enter '^' or the press the <ABORT> key to exit"
 W !,"    Enter a name or partial name to look up a saved criteria."
 W !,"    <SPACE> and <RETURN> will recall the last criteria used."
 W !,"    <RETURN> or <ENTER> alone will create a new criteria entry."
 W !!," A criteria entry does not need to be 'named'.  If not named,"
 W !," it is a working entry and is temporary.  The last working"
 W !," entry can be recalled with the <SPACE>."
 S %=$$CR^UTSRD,INX=$S(%:"^",1:"??") D CLPOP^DWD
 Q
 ;
LOOKUP(INOPT,X,INUS) ; lookup entry in INTERFACE CRITERIA file
 ;
 ; input:   INOPT array. See INHUTCD for description.
 ;          X      = value to look up
 ;          INUS   = if TRUE (1) will call full screen selection
 ;                   
 ; returns: ien of record in INTERFACE CRITERIA file
 ;          if function does not complete, reason text is returned
 ;
 ; quit if user information does not exist, validate input variables
 N D,Y,DIC K DUOUT,DTOUT
 ; check for spacebar
 S X=$G(X) Q:X=" " $$WORKREC(.INOPT,0)
 S DIC=4001.1,D="C",DIC(0)="FNXY",DIC("S")=$$FILTER(.INOPT)
 S:$G(INUS) DIC(0)="EFNR"
 D IX^DIC Q:$D(DTOUT)!$D(DUOUT) "LOOKUP: User exit"
 ; if multiple entries pick last one
 I Y=0 S Y=+$O(Y(" "),-1)
 Q $S(Y<1:0,1:+Y)
 ;
FILTER(INOPT) ; create filter screen for lookup in INTERFACE CRITERIA file
 ;
 ; input:   INOPT array. See INHUTCD for description.
 ; returns: executable text for use with DIC("S") for lookup
 ;          ie; S %=^(0) I ($P(%,U,3)="U"&($P(%,U,2)=185))
 ;
 N INI,INP,INCTRL,INFLD,INSTR
 S INCTRL=$S($L($G(INOPT("CONTROL"))):INOPT("CONTROL"),1:"SU")
 ; build based on control values
 S INSTR="" S:INCTRL["U" INSTR="($P(%,U,3)=""U""&($P(%,U,2)="_$G(INOPT("DUZ"))_"))"
 S INCTRL=$TR(INCTRL,"U")
 F INI=1:1 S INP=$E(INCTRL,INI) Q:'$L(INP)  S INSTR=INSTR_$S($L(INSTR):"!",1:"")_"($P(%,U,3)="""_INP_""")"
 ; build based on TYPE values
 F INI=1:1:3 D
 . S INP=$P("5,8,6",",",INI),INFLD=$G(INOPT($P("TYPE,APP,FUNC",",",INI)))
 . S:$L(INFLD) INSTR=INSTR_",$P(%,U,"_INP_")="""_INFLD_""""
 Q "S %=^(0) I "_INSTR
 ;
VALID(INOPT,INDA,INCTRL) ; validate an entry matches options passed
 ;
 ; input:   INOPT array. See INHUTCD for description.
 ;          INDA = entry in INTERFACE CRITERIA file
 ;          INCTRL = Allowable control values. ie; "SU"
 ; returns: Boolean. TRUE = valid, FALSE = invalid
 ;
 Q:'$G(INDA) 0
 Q:'$D(^DIZ(4001.1,INDA,0)) 0
 N INX S INX=^DIZ(4001.1,INDA,0)
 Q:$P(INX,U,2)'=$G(INOPT("DUZ")) 0
 Q:$P(INX,U,5)'=$G(INOPT("TYPE")) 0
 Q:$G(INCTRL)'[$P(INX,U,3) 0
 Q:$P(INX,U,8)'=$G(INOPT("APP")) 0
 Q:$P(INX,U,6)'=$G(INOPT("FUNC")) 0
 Q 1
 ;
WORKREC(INOPT,INEW) ; lookup last working record, create new if none
 ;
 ; input:   INOPT array. See INHUTCD for description.
 ;          INEW = force a new record
 ; returns: ien of record in INTERFACE CRITERIA file
 ;          if function does not complete, reason text is returned
 ;
 N INDA S INDA=0
 I '$G(INEW) D
 . N I,INA
 . F I=1:1:4 S INA(I)=$G(INOPT($P("DUZ,TYPE,APP,FUNC",",",I))) S:'$L(INA(I)) INA(I)="NULL"
 . S Y=" " F  D  Q:INDA!('$L(Y))
 .. S Y=$O(^DIZ(4001.1,"AUSER",INA(1),INA(2),"W",INA(3),INA(4),Y),-1)
 .. I Y,$$LOCK^INHUTC(Y,1,5) S INOPT("LOCK",Y)=$G(INOPT("LOCK",Y))+1,INDA=Y
 ; if no working record or its locked, create a new one
 I 'INDA S INDA=$$NEW(.INOPT,"W") Q:'INDA INDA
 Q $S(INDA<1:"WORKREC: Cannot create entry in INTERFACE CRITERIA file.",1:INDA)
 ;
NEW(INOPT,INCTRL) ; create new entry in INTERFACE CRITERIA file
 ;
 ; input:   INOPT array. See INHUTCD for description.
 ;          INCTRL = S, U, B, or W. control value of new record
 ; returns: ien of record in INTERFACE CRITERIA file
 ;          if function does not complete, reason text is returned
 ;
 Q:'$L($G(INCTRL)) "NEW: Control value not supplied"
 N DIC,DIE,DLAYGO,DA,DR,X,Y,INDA,INI
 S DIC=4001.1,DIC(0)="LF",DLAYGO=4001.1,X="NEW"
 F INI=1:1:5 D  Q:INDA
 . D:$$SC^INHUTIL1 EN^DICN
 . ;Branch for IHS
 . I '$$SC^INHUTIL1 S DIC="^DIZ(4001.1," D NEW^DICN
 . S (DA,INDA)=+Y Q:INDA<0
 . ; get lock on entry
 . S:'$$LOCK^INHUTC(INDA,1,5) INDA=0 S:INDA INOPT("LOCK",INDA)=$G(INOPT("LOCK",INDA))+1
 Q:INDA<0 "NEW: Entry could not be created"
 S DIE=DIC,DR=".01///"_DA_";.02///^S X=DUZ;.03///"_INCTRL_";.09///^S X=DT"_$S($L($G(INOPT("TYPE"))):";.05///"_INOPT("TYPE"),1:"")
 S DR=DR_$S($L($G(INOPT("FUNC"))):";.06///"_INOPT("FUNC"),1:"")_$S($L($G(INOPT("APP"))):";.08///"_INOPT("APP"),1:"")_";11///0;12///0"
 D ^DIE
 Q INDA
 ;
SAVE(INOPT,INDA,INCTRL) ; save working record to user defined record
 Q $$SAVE^INHUTC11(.INOPT,$G(INDA),$G(INCTRL))
 ;
COPY(INFROM,INTO,INCTRL) ; copy search fields from one entry to another
 D COPY^INHUTC11($G(INFROM),$G(INTO),$G(INCTRL))
 Q
 ;
EDIT(INDA,INGALL) ; edit criteria entry
 Q $$EDIT^INHUTC11($G(INDA),$G(INGALL))
 ;
