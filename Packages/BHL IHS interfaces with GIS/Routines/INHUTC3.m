INHUTC3 ;bar; 22 May 97 12:08; API to error search and reporting functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 Q
 ;
ARRAY(INDA,INA) ; update entry in criteria file with array of parms passed in
 ;
 ; input: INDA = ien of entry in 4001.1 file
 ;        INA  = Array of values to stuff into criteria fields.
 ;               The value is the base name of the array rather than
 ;               the array itself so it can be used with indirection.
 ;               @INPARMS@("TTYPE",1)="DG REG"
 ;               Refer to table under FIELDS tag for field mnemonics
 ;
 N DIC,DIE,DA,DR,INX,INY,INFN
 Q:'$G(INDA)!('$L($G(INA)))  Q:'$D(^DIZ(4001.1,INDA,0))  Q:'$D(@INA)
 ; loop thru each field
 S INX="" F  S INX=$O(@INA@(INX)) Q:'$L(INX)  D
 . ; allow field numbers or mnemonics
 . S INY=$S(INX:INX,1:$P($T(@INX),";",3))
 . ; check if bad mnemonic
 . I 'INY S @INA@(INX)=@INA@(INX)_"^invalid field mnemonic" Q
 . ; is this a valid field?
 . I '$D(^DD(4001.1,INY)) S @INA@(INX)=@INA@(INX)_"^field not defined" Q
 . ; do not allow control fields except criteria name
 . I INY<1,INY'=".04" S @INA@(INX)=@INA@(INX)_"^field update not allowed" Q
 . ; handle multiples, check for subfile number
 . S INFN=$P($G(^DD(4001.1,INY,0)),U,2) I INFN D  Q
 .. ; clear multiple unless flagged to append
 .. I $G(@INA@(INX))'="A" K ^DIZ(4001.1,INDA,INY)
 .. ; setup DIC call variables
 .. N DIC,DO,DINUM,DA,X,Y,DR,INZ,DLAYGO
 .. S DA(1)=INDA,DIC="^DIZ(4001.1,"_DA(1)_","_INY_",",DIC(0)="FL",DIC("P")=INFN,DLAYGO=+INFN
 .. ; loop thru each multiple entry
 .. S INZ=0 F  S INZ=$O(@INA@(INX,INZ)) Q:INZ']""  D
 ... ;get value and check for NULL
 ... S X=@INA@(INX,INZ) Q:'$L(X)
 ... ; convert text to ien for pointer field
 ... I INFN["P" D  Q
 .... I X'=+X S X=+$$DIC^INHSYS05(U_$P($G(^DD(DLAYGO,.01,0)),U,3),X,"","F") Q:X<1
 .... ; add value to multiple list
 .... D ^DICN S:Y<1 @INA@(INX,INZ)=@INA@(INX,INZ)_"^invalid field value"
 ... ; add value to multiple list
 ... D ^DIC S:Y<1 @INA@(INX,INZ)=@INA@(INX,INZ)_"^invalid field value"
 . ;
 . ; add value to criteria field
 . I $L(@INA@(INX)) S DIE=4001.1,DA=INDA,DR=INY_"///^S X="""_@INA@(INX)_"""" D ^DIE S:$G(Y)=-1 @INA@(INX)=@INA@(INX)_"^invalid field value"
 Q
 ;
CVTCODE(X,FILE,FLD)      ; make external from set of codes
 ; X = internal value FILE=file number  FLD = field number
 Q:'$L($G(X))!'$L($G(FILE))!'$L($G(FLD)) $G(X)
 N %,C,S
 S S=$G(^DD(FILE,FLD,0)) D:$P(S,U,2)["S"
 . S C=";"_$P(S,U,3),%=$F(C,";"_X_":")
 . S:% X=$P($E(C,%,999),";")
 Q X
 ;
CVTDT(X) ; make external view of date
 N T,H,M,S
 ; adjust time, only worried about END date
 S T=$P(X,".",2),X=$P(X,"."),H=+$E(T,1,2),M=+$E(T,3,4),S=+$E(T,5,6)
 I T D
 . S:S>59 S=0,M=M+1 S:M>59 M=0,H=H+1 S:H>24 H=24,M=0,S=0
 . S X=+(X_"."_$J(H,2)_$J(M,2)_$J(S,2))
 S X=$$CDATASC^%ZTFDT(X,1,3)
 Q X
 ;
FIELDS ; All tags below this are used as a field table for 4001.1 file
 ; field numbers less than 1 are control fields and cannot be passed in.
 ; The tag line is the mnemonic. The values in the line are:
 ;; field # ; field name ; INSRCH name
 ;;
 ;;.01;ENTRY;;
 ;;.02;USER WHO CREATED;USER;S X=$P($G(^DIC(3,+USER,0)),U)
 ;;.03;CONTROL
NAME ;;.04;CRITERIA NAME;NAME;
 ;;.05;CRITERIA TYPE;
 ;;.06;FUNCTION;
 ;;.07;BACKGROUND ID
 ;;.08;APPLICATION;
 ;;.09;LAST DATE ACCESSED
STARTDT ;;1;START DATE;INSTART;S X=$$CVTDT^INHUTC3(X+.0000001)
ENDDT ;;1.1;END DATE;INEND;S X=$$CVTDT^INHUTC3(X)
DEST1 ;;2;DESTINATION;INDEST;S Y=$P($G(^INRHD(X,0)),U) S:$L(Y) X=Y
STAT1 ;;3;STATUS;INSTAT;S X=$$CVTCODE^INHUTC3(X,4001.1,3)
MSGID ;;4;MESSAGE ID;INID
SOURCE ;;5;SOURCE;INSOURCE
DIRECT ;;6;DIRECTION;INDIR;S X=$$CVTCODE^INHUTC3(X,4001.1,6)
TTYPE1 ;;7;ORIGINATING TRANSACTION TYPE;INORIG;S Y=$P($G(^INRHT(X,0)),U) S:$L(Y) X=Y
PATIENT ;;8;PATIENT;INPAT;S Y=$P($G(^DPT(X,0)),U) S:$L(Y) X=Y
TEXT ;;9;SEARCH STRING;INTEXT;S X=INOPT("INSRCH","INTEXT",X)
MATCH ;;10;FIELD MATCH TYPE;INTYPE;S X=$$CVTCODE^INHUTC3(X,4001.1,10)
LISTORD ;;11;LISTING ORDER;INORDER;S X=$$CVTCODE^INHUTC3(X,4001.1,11)
EXPAND ;;12;EXPANDED DISPLAY;INEXPAND;S X=$$CVTCODE^INHUTC3(X,4001.1,12)
 ;;13.01;ACCEPT ACK TRANSACTION TYPE
 ;;13.02;TYPE OF TEST
 ;;13.03;CLIENT/SERVER
 ;;13.04;ACCEPT ACK CONDITION
 ;;13.05;STEP MODE
 ;;13.07;START AT PROCESS
 ;;14;TEST CASE DESCRIPTION
MSGSTDT ;;15.01;TRANS START DATE;INMSGSTART;S X=$$CVTDT^INHUTC3(X)
MSGENDT ;;15.02;TRANS END DATE;INMSGEND;S X=$$CVTDT^INHUTC3(X)
ERRLOC ;;15.03;ERROR LOCATIONS;INERLOC;S Y=$P($G(^INTHERL(X,0)),U) S:$L(Y) X=Y
ERRRES ;;15.04;ERROR RESOLUTION STATUS;INERSTAT;S X=$$CVTCODE^INHUTC3(X,4001.1,15.04)
 ;;16.01;IP ADDRESS
 ;;16.02;IP PORT
 ;;16.03;OPEN HANG TIME
 ;;16.04;OPEN RETRIES
 ;;16.05;TRANSMITTER HANG
 ;;16.06;SEND HANG TIME
 ;;16.07;SEND RETRIES
 ;;16.08;SEND TIMEOUT
 ;;16.09;READ HANG TIME
 ;;16.1;READ RETRIES
 ;;16.11;READ TIMEOUT
 ;;16.12;END OF LINE
 ;;17.01;CLIENT INIT STRING
 ;;17.02;INIT RESPONSE
 ;;17.03;SECURITY KEY FRAME
 ;;18.01;LOCAL HOST IP ADDRESS
 ;;18.02;LOCAL HOST IP PORT
 ;;18.03;LOGON SERVER
 ;;18.04;APP SERVER
 ;;18.05;SAVED TEST FILE NAME
 ;;19;UNIVERSAL INTERFACE TEST MSG
 ;;20;BACKGROUND PROCCESS
 ;;21;PAGE REPAINT FREQUENCY
 ;;21.01;PRE PROCESS
 ;;22;DETAILED REPORT
 ;;22.01;POST PROCESS
 ;;23;MAXIMUM NUMBER OF ITERATIONS
 ;;23.01;DESTINATION DETERMINATION
 ;;24;ALWAYS SCAN TO END OF QUEUE
RELSTDT ;;24.01;RELATIVE START DATE
RELENDT ;;24.02;RELATIVE END DATE
DIV1 ;;24.03;DIVISION;INDIV;S Y=$P($G(^DG(40.8,X,0)),U) S:$L(Y) X=Y
USER ;;24.04;USER NAME;INUSER;S Y=$P($G(^DIC(3,X,0)),U) S:$L(Y) X=Y
RMSGSTDT ;;24.05;REL AUX DATE 1
RMGSENDT ;;24.06;REL AUX DATE 2
 ;;25;MAXIMUM TIME COMPILING
 ;;26;NUMBER OF TRIES FOR AN ENTRY
 ;;27;INCLUDE FUTURE TASKS
DEVICE ;;28;DEVICE
 ;;29;GENERIC Y/N
 ;;30;GENERIC NUMBER
TTYPE ;;31;TRANSACTION TYPES;MULTIORIG;S Y=$P($G(^INRHT(X,0)),U) S:$L(Y) X=Y
DEST ;;32;DESTINATIONS;MULTIDEST;S Y=$P($G(^INRHD(X,0)),U) S:$L(Y) X=Y
STATUS ;;33;STATUSES;MULTISTAT;S X=$$CVTCODE^INHUTC3(X,4001.15,.01)
DIVISION ;;34;DIVISIONS;MULTIDIV;S Y=$P($G(^DG(40.8,X,0)),U) S:$L(Y) X=Y
