INHSYSUL ;FRW,WOM; 23 Aug 1999 12:25;GIS Pre/Post init routines 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
BACKUP(QN,H,INQF) ;Backup utility
 ; Backup all GIS Control Globals before install into ^UTILITY.
 ; This function is not called directly by the GIS TRANSACTION MOVER but
 ; should be used by installation software prior to calls to EN5^INHSYS.
 ;
 ; This function is called by INHPRE and INHPCO as part of the
 ; pre-packaging of the GIS control files
 ;
 ; Input QN: SIR #, Quick Fix #, Install # , etc.
 ;           used as first index of backup
 ;       H: Should be $H - used as second index of backup
 ;       INQF: Class # or other ID for error message
 ; Output: Returns 1 for success, 0 for failure
 N I,GL,ER,ERD,C S QN=$G(QN),H=$G(H),INQF=$G(INQF),ER=0,ERD="",C=0
 S:QN="" QN="GIS Install" S:H="" H=$H S:INQF="" INQF=QN
 ; If H is in $H format, change to force ASCII collating sequence in
 ;      ^UTILITY
 I $P(H,",")?5N,$P(H,",",2)?1.5N,$L(H,",")=2 D
 . S GL=$P(H,",",2),I=$L(GL) F I=5-I:-1:1 S GL="0"_GL
 . S $P(H,",",2)=GL
 K ^UTILITY("INSAVE",QN,H)
 F I=4000,4005,4004,4011,4010,4012,4012.1,4090.2,4020,4006 D
 . S GL=$$GLE(I) I GL="" S ER=1,C=C+1,$P(ERD,"^",C)=I Q
 . M ^UTILITY("INSAVE",QN,H,I)=@GL
 I ER D  Q 0
 . W ! F I=1:1:C W !," Error detected - file #"_$P(ERD,"^",I)_" not saved for "_INQF
 Q 1
GLE(FN) ;return global name from file number or "" for error
 N GL,L
 S GL=$G(^DIC(FN,0,"GL")),L=$L(GL) Q:GL="" GL
 S GL=$E(GL,1,L-1)_$S($E(GL,L)=",":")",1:"")
 Q GL
DIC() ;Returns IEN of FILEMAN lookup or "B" x-ref
 I $L(X)>30 D  S:Y="" Y=-1 Q Y
 . S Y=$O(@(DIC_"""B"","""_X_""","""")")) Q:Y=""
 . S:$O(@(DIC_"""B"","""_X_""","""_Y_""")")) Y=-1
 D ^DIC Q Y
LIST(INCOMP) ; ListMan front end for RESTORALL and RESTORE
 ; Input: INCOMP - 0 for restoration of site specific data only
 ;             - 1 for restoration of all GIS control files
 ;             - else ERROR
 ; Output: Returns 1 for success, 0 failure
 ;
 S INCOMP=$G(INCOMP) Q:$L(INCOMP)'=1!(INCOMP'?1N)!(INCOMP>1) 0
 I $D(^UTILITY("INSAVE"))/10=0 W !,"Nothing to process." Q 0
 N I,J,J1,C1,C2,INARRAY,DWLR,DWL,DWLRF,DWLB D ENV^UTIL S (I,J,C1)=""
 ;
 ; Find all possible variations for restore
 F  S I=$O(^UTILITY("INSAVE",I)),C1=C1+1,C2=0 Q:I=""  F  S J=$O(^UTILITY("INSAVE",I,J)),C2=C2+1 Q:J=""  D
 . S INARRAY(C1,C2)=I_"/"_$S(J?5N1","5N:$$CDATASC^%ZTFDT($P(J,",")_","_+($P(J,",",2)),1,1),1:J),INARRAY(C1,C2,0)=J
 ; On your mark, get set...
 S DWLRF="INARRAY",DWLB="2^5^12^40^20",DWL="HWXXM-1A2"
 ; Go...
 D ^DWL I '$D(DWLMK)/10 W !!,"Nothing selected." Q 0
 S I=$O(DWLMK("")),J=$O(DWLMK(I,"")) W !!,"You are about to restore ",$S(INCOMP:"all data",1:"site specific fields"),!," from the backup identified by: ",INARRAY(I,J),!,"Ok"
 I '$$YN^%ZTF(0) W !,"Restoration aborted!" Q 0
 W !!,"Restoration in progress. Please wait."
 S J1=J,J=INARRAY(I,J,0),I=$P(INARRAY(I,J1),"/")
 I '$S(INCOMP:$$RESTORAL(I,J),1:$$RESTORE(I,J)) W !!,"Restore of ",$S(INCOMP:"all data",1:"site specific fields")," unsuccessful!!" Q 0
 Q 1
RESTORAL(QN,H,INQF) ; Restore entire ^UTILITY to GIS control files
 ;
 ; Input QN:   SIR #, Quick Fix #, Install # , etc.
 ;             used as first index of backup
 ;          H:    Should be $H - used as second index of backup
 ;          INQF: Class # or other ID for error message
 ; Output: Returns 1 for success, 0 for failure
 ;
 N IN,GL,C,ERD,FN S C=0,ER=0
 ;
 S QN=$G(QN),H=$G(H),INQF=$G(INQF),IN="INSAVE" S:QN="" QN="GIS Install" S:INQF="" INQF=QN
 I H="" W *7,!,"Subscript parameters are invalid - aborting restore." Q 0
 I $D(^UTILITY(IN,QN,H))/10=0 W *7,!,"Backup global not found - aborting restore." Q 0
 S FN="" F  S FN=$O(^UTILITY(IN,QN,H,FN)) Q:'FN  D
 . S GL=$$GLE(FN) I GL="" S ER=1,C=C+1,$P(ERD,"^",C)=FN Q
 . K @GL M @GL=^UTILITY("INSAVE",QN,H,FN)
 I ER D  Q 0
 . W ! F FN=1:1:C W !," Error detected - file #"_$P(ERD,"^",FN)_" not restored for "_INQF
 Q 1
RESTORE(QN,H,INQF) ; Restore fields from ^UTILITY built by tag BACKUP
 ;
 ; Input QN:   SIR #, Quick Fix #, Install # , etc.
 ;             used as first index of backup
 ;          H:    Should be $H - used as second index of backup
 ;          INQF: Class # or other ID for error message
 ; Output: Returns 1 for success, 0 for failure
 ;
 N FN,FLDS,IN,IEN,C,ER,I,FLD,GL,PI,R,DIC,X,Y,DIK,DA,GLBL,X
 ; Set error trap
 S X="ERR^INHSYSUL",@^%ZOSF("TRAP")
 ;
 S QN=$G(QN),H=$G(H),INQF=$G(INQF),IN="INSAVE",C=",",ER=0 S:QN="" QN="GIS Install" S:INQF="" INQF=QN
 I H="" W *7,!,"Subscript parameters are invalid - aborting restore." Q 0
 I $D(^UTILITY(IN,QN,H))/10=0 W *7,!,"Backup global not found - aborting restore." Q 0
 K FLDS
 S FLDS(4000,.05)=""
 F I=.02,5,6,7.02,7.04,7.05,1.01,1.1,1.2,1.3,1.4,1.5,1.6,1.8,1.9,1.11,1.12,1.14,10.01,10.02 S FLDS(4004,I)=""
 F I=3.01,1,5,7.01,7.02,7.03,9 S FLDS(4005,I)=""
 S FN="" F  S FN=$O(FLDS(FN)) Q:'FN  D
 . S IEN=0 F  S IEN=$O(^UTILITY(IN,QN,H,FN,IEN)) Q:'IEN  D
 . . S X=$P(^UTILITY(IN,QN,H,FN,IEN,0),U),DIC=^DIC(FN,0,"GL"),DIC(0)="X"
 . . S Y=$$DIC I Y<0 W !,"Entry ",IEN,"=",X," for file #",FN," not found.",!,"This entry will not be restored!!" S ER=1 Q
 . . I +Y'=IEN W !,"Entry # ",IEN,"for file #",FN,"has changed to ",+Y,!
 . . S FLD="" F  S FLD=$O(FLDS(FN,FLD)) Q:FLD=""  D
 . . . S GL=$P(^DD(FN,FLD,0),U,4),INMUL=$P(^DD(FN,FLD,0),U,2)
 . . . S PI=$P(GL,";",2),GL=$P(GL,";")
 . . . S R=$P($G(^UTILITY(IN,QN,H,FN,IEN,GL)),U,PI)
 . . . S GLBL=DIC_(+Y)_","_GL_")"
 . . . ;normal data field
 . . . I PI,(R'=""!($P($G(@GLBL),U,PI)'="")) S $P(@GLBL,U,PI)=R
 . . . ;multiples and $E type fields
 . . . I 'PI,(INMUL!($E(PI)="E")) D
 . . . . I '$D(^UTILITY(IN,QN,H,FN,IEN,GL)),'$D(@GLBL) Q
 . . . . K @GLBL M @GLBL=^UTILITY(IN,QN,H,FN,IEN,GL)
 . . ; Re-index
 . . S DA=IEN,DIK=DIC D IX1^DIK
 Q 'ER
ERR ; Error trap for tag RESTORE
 W !,"A MUMPS error has occurred during the restoration of",!," site specific GIS fields!",!
 W "Please validate that the active GIS Interfaces are configured correctly.",!
 D ET^%ZTF
 Q 0
