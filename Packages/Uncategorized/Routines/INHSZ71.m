INHSZ71 ;JSH; 19 Aug 93 10:11;Interface compiler - INHSZ7 (cont'd) ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L G L^INHSZ1
 ;
MULT ;Enter a multiple section
 I 'LOOKUP D ERROR^INHSZ0("LOOKUP section required to process a multiple.",1) Q
 N F,V,%1,X,Z,DIC
 S %1=$$LBTB^UTIL($P(LINE,COMM,2,99)),F=$P(%1,";"),V=$P(%1,";",2)
 I F="" D ERROR^INHSZ0("Missing field in MULT command",1) Q
 I V="" D ERROR^INHSZ0("Missing variable name in MULT command",1) Q
 S DIC="^DD("_+FILE_",",DIC(0)="",X=F D ^DIC I Y<0 D ERROR^INHSZ0("Field '"_F_"' not found in file #"_+FILE,1) Q
 S F=+Y
 S Z=^DD(+FILE,+F,0),(MULT0,X)=$P(Z,U,2) I 'X D ERROR^INHSZ0("Field '"_$P(Z,U)_"' is not a multiple",1) Q
 I $P(^DD(+X,.01,0),U,2)["W" D ERROR^INHSZ0("Field '"_$P(Z,U)_"' is not a multiple",1) Q
 I '$D(DICOMPX(V)) D ERROR^INHSZ0("Multiple identifier variable is unknown.",1) Q
 S A=" ;"_LINE D L
 S A=" D:$G(INDA)>0" D L,DOWN^INHSZ1("")
 I $D(LVARS(V)),LVARS(V)>SLVL D  Q
 . S MULT=MULT+1,MNODE(MULT)=$P($P(Z,U,4),";") S:'MNODE(MULT) MNODE(MULT)=""""_MNODE(MULT)_"""" D MDOWN,RLB^INHSZ51 S REPEAT1=0,REPEAT(MULT)=1
 S A=" N MDESC,FIELD S IDENT="_$$VEXP^INHSZ51(V)_",MDESC(2)="" .01 = ""_IDENT" D L
 S LPARAM="",IDENT=1,MCNT=2,MULT=MULT+1,MNODE(MULT)=$P($P(Z,U,4),";") S:'MNODE(MULT) MNODE(MULT)=""""_MNODE(MULT)_"""" D MDOWN S (REPEAT,REPEAT(MULT))=0 Q
 Q
 ;
ENDMULT ;End a MULT section
 I 'MULT D ERROR^INHSZ0("There is no active MULT section to end",1) Q
 I REPEAT D UP^INHSZ1,MUP,UP^INHSZ1 S SLVL=SLVL-1,REPEAT=REPEAT(MULT) Q
 D MUP,UP^INHSZ1 S REPEAT=REPEAT(MULT) Q
 ;
MDOWN ;move down a multiple level
 N I S A=" S MULT=MULT+1,INDA(0)=INDA,INDA=0 F I=MULT:-1:1 S INDA(I)=INDA(I-1)" D L S A=" K INDA(0) S INDA=0" D L
MFSET S FILE=FILE1 F I=MULT:-1:1 S FILE=FILE_"INDA("_I_"),"_MNODE(MULT-I+1)_","
 S $P(FILE,U)=+X Q
 ;
MUP ;move up a multiple level
 S A=" F I=1:1:MULT S INDA(I-1)=INDA(I)" D L
 S A=" S INDA=INDA(0) K INDA(0) S MULT=MULT-1" D L
 K LOOKUP(MULT) S MULT=MULT-1,X=FILE1 G MFSET
 ;
OTHER ;Move to another file
 I MULT!OTHER D ERROR^INHSZ0("Cannot nest an OTHER block.",1) Q
 N %1,DIC,X,Y
 S %1=$$LBTB^UTIL($P(LINE,COMM,2,99)),F=$$LBTB^UTIL($P(%1,";")),V=$$LBTB^UTIL($P(%1,";",2))
 I F="" D ERROR^INHSZ0("File missing from OTHER command.",1) Q
 I V="" D ERROR^INHSZ0("Variable missing from OTHER command.",1) Q
 I '$D(DICOMPX(V)) D WARN^INHSZ0("Identifier variable in OTHER command not known.",1)
 I F,'$D(^DIC(F,0)) D ERROR^INHSZ0("File #"_F_" not found.",1) Q
 I 'F D  Q:ER
 . S DIC=1,DIC(0)="",X=F X "N F D ^DIC" I Y<0 D ERROR^INHSZ0("File '"_F_"' is unknown or ambiguous.",1) Q
 . S F=+Y
 S FILE("OTHER")=FILE1,(FILE1,FILE)=F_^DIC(F,0,"GL"),OTHER=1,OTHER("LOOK")=0
 S A=" ;"_LINE D L
 I '$D(LVARS(V)) D  Q
 . S A=" S INOTHER(""DA"")=$G(INDA)" D L
 . S A=" K MDESC S INDA=0,IDENT=$G(@INV@("""_V_""")),MDESC(2)="" .01 = ""_IDENT K FIELD" D L
 . S LPARAM="",IDENT=1,MCNT=2 Q
 ;Looping OTHER section
 S A=" S INOTHER(""DA"")=$G(INDA)" D L,RLB^INHSZ51 S REPEAT1=0,REPEAT(0)=1
 Q
 ;
ENDOTHER ;End of other section
 I REPEAT D UP^INHSZ1 S SLVL=SLVL-1,(REPEAT(0),REPEAT)=0
 S OTHER=0,(FILE1,FILE)=FILE("OTHER")
 S A=" S INDA=INOTHER(""DA"")" D L
 Q
 ;
