BPMVER ; IHS/OIT/LJF - IHS CODE FOR VERIFY DUPLICATE FUNCTION
 ;;1.0;IHS PATIENT MERGE;;MAR 01, 2010
 ;
OVERWRIT(BPMFILE,BPMN,BPMFLDS) ;EP - called by CHK1^XDRRMRG1
 ; stuffs overwrite selections when selected and for correct patient file
 ; VA code only stuff for file 2 and only if pair is marked as verified now
 NEW BPMIEN,BPMFDA,BPMIENS,I
 S BPMIEN=$$FIND1^DIC(15.03,","_BPMN_",","X",BPMFILE)  ;is file already in subfile?
 ;
 ; if not, add it
 I BPMIEN'>0 D
 . S BPMIEN="+1,"_BPMN_","
 . S BPMIENS(1)=BPMFILE
 . S BPMFDA(15.03,BPMIEN,.01)=BPMFILE   ;stuff file number
 . S BPMFDA(15.03,BPMIEN,.02)=2         ;stuff reverse merge
 . D UPDATE^DIE("S","BPMFDA","BPMIENS")
 . S BPMIEN=BPMIENS(1)
 ;
 ; now loop thru overwrite fields and stuff them under file number
 S BPMIEN="+1,"_BPMIEN_","_BPMN_","
 S I=0 F  S I=$O(BPMFLDS(I)) Q:I'>0  D
 . K BPMFDA,BPMIENS
 . S BPMIENS(1)=I
 . S BPMFDA(15.031,BPMIEN,.01)=I
 . D UPDATE^DIE("S","BPMFDA","BPMIENS")
 Q
 ;
SHOWVER ; EP - display verified duplicate pair with merge direction and overwrite fields
 NEW DIC,XDRFILE,XDRGLB,DFNFR,DFNTO,XDRDA,DIR,FR,TO,L,FLDS,BY,IOP,BPMFLD,AUPNLK
 S XDRFILE=$$FILE^XDRDPICK() Q:XDRFILE'>0  S XDRGLB=$G(^DIC(XDRFILE,0,"GL")) Q:XDRGLB=""
 F  D  Q:XDRDA'>0
 . S DIC="^VA(15,",DIC(0)="AEQZ",DIC("S")="I $P(^VA(15,+Y,0),U,5)<2,$P(^(0),U,3)=""V"""
 . S DIC("A")="Select VERIFIED Pair: "
 . S AUPNLK("ALL")=1   ;allow lookup of inactive patients
 . W !! D ^DIC S XDRDA=+Y Q:XDRDA<0
 . S X=^VA(15,XDRDA,0)
 . I $P($G(^VA(15,XDRDA,2,1,0)),U,5)=2 S DFNTO=+X,DFNFR=+$P(X,U,2)
 . E  S DFNFR=+X,DFNTO=+$P(X,U,2)
 . ;
 . S DIC=15,L=0,FLDS="[BPM VERIFIED DISPLAY]",BY="@.001"
 . S (FR,TO)=XDRDA,IOP="HOME"
 . D EN1^DIP
 . ;
 . S DIR(0)="Y",DIR("A")="Do you wish to review demographic data",DIR("B")="YES"
 . D ^DIR K DIR Q:Y'=1  W @IOF
 . ;
 . F XDRFILE=2,9000001 D SHOW^XDRDSHOW(XDRFILE,DFNFR,DFNTO,.BPMFLD,0) Q:$D(DIRUT)
 . K FILREC1,FILREC2,FLD,NAME,NDIFFS,NLIN,NOD1,NOD2,NODE,PACKAGE,PIECE,XDRA  ;kill variables left over from VA call
 Q
 ;
DINUM ;EP - Check for possible overwrite data in DINUM'ed files
 ; Called by option BPM OVERWRITE CHECK
 ;
 NEW BPMPFILE,XDRGLB,BPMDA,AUPNLK,X,DIC,DFNFR,DFNTO,PACKAGE
 NEW BPMFL,XDRGL,PRIFILE,XDRDA,DFNTOX,DFNFRX,XDRFILE,FILEDIC,XDRY,REVIEW,OVERWRIT,FOUND
 ; select verified patient pair
 S BPMPFILE=$$FILE^XDRDPICK() Q:BPMPFILE'>0  S XDRGLB=$G(^DIC(BPMPFILE,0,"GL")) Q:XDRGLB=""
 F  D  Q:BPMDA'>0
 . S DIC="^VA(15,",DIC(0)="AEQZ",DIC("S")="I $P(^VA(15,+Y,0),U,5)<2,$P(^(0),U,3)=""V"""
 . S DIC("A")="Select VERIFIED Pair: "
 . S AUPNLK("ALL")=1   ;allow lookup of inactive patients
 . W !! D ^DIC S BPMDA=+Y Q:BPMDA<0
 . S X=^VA(15,BPMDA,0)
 . I $P($G(^VA(15,BPMDA,2,1,0)),U,5)=2 S DFNTO=+X,DFNFR=+$P(X,U,2)
 . E  S DFNFR=+X,DFNTO=+$P(X,U,2)
 . ;
 . ; loop through RPMS files, find DINUM'ed ones & check data
 . W !!,"SEARCHING, please wait . . ."
 . S BPMFND=0                                     ;flag to track if any overwrite data found for any file
 . S BPMFL=0 F  S BPMFL=$O(^DD(BPMFL)) Q:'BPMFL  D
 . . Q:BPMFL=9000001                              ;skip IHS Patient file
 . . Q:BPMFL=9000003.3                            ;skip DW Audit file
 . . Q:$P($G(^DD(BPMFL,.01,0)),U,5)'["DINUM"      ;skip files not DINUM'ed
 . . S X=$P($G(^DD(BPMFL,.01,0)),2)
 . . I (X'["P2")&(X'["P9000001") Q                ;skip if not pointer to VA Patient or Patient
 . . Q:X["P200"                                   ;skip if pointing to file 200
 . . Q:$P($G(^DIC(BPMFL,0)),U)=""                 ;skip if not top level of file
 . . ;
 . . ; set variables needed by VA code
 . . K OVERWRIT                                   ;flag to track if overwrite data found for this file
 . . S XDRGL=$P($P($G(^VA(15,BPMDA,0)),U),";",2) Q:XDRGL=""  S XDRGL=U_XDRGL S PRIFILE=+$P(@(XDRGL_"0)"),U,2)
 . . S XDRDA=BPMDA,DFNTOX=DFNTO,DFNFRX=DFNFR
 . . S PACKAGE=$G(^DD(BPMFL,0,"VRPK"))_" ("_$P($G(^DIC(BPMFL,0)),U)_")"
 . . S XDRFILE=BPMFL,FILEDIC=^DIC(XDRFILE,0,"GL")_"DFN)"
 . . I XDRFILE=63 S NAMIEN1=$$LABIEN^XDRRMRG2(XDRFILE,DFNFR),NAMIEN2=$$LABIEN^XDRRMRG2(XDRFILE,DFNTO)
 . . N DIR   ;could be left over from other options; SHOW doesn't check for it
 . . S XDRY="S",REVIEW=1 D SHOW^XDRDSHOW(XDRFILE,DFNFR,DFNTO,.OVERWRIT,REVIEW)
 . . I $D(OVERWRIT) S BPMFND=1 D OVERWRIT^BPMVER(XDRFILE,XDRDA,.OVERWRIT) K OVERWRIT
 . ;
 . I BPMFND=0 W !!,"NO NEW DATA OVERWRITES SET" D PAUSE^BPMU
 Q
