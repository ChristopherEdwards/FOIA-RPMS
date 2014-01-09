BLR138PO ; IHS/MSC/MKK - Modified version of LR*5.2*138 Post Install Routine ;   [ 09/30/2012  8:00 AM ]
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997
 ;
 ; This routine will just create the OOS division in the
 ; HOSPITAL LOCATION (#44) file, and, if successful,
 ; will also update the DEFAULT OOS LOCATION field in
 ; the Laboratory Site (#69.9) file.
 ;
 ; It does utilize a lot of the code from the LR138PO,
 ; LRCAPPH2, and SCDXUAPI routines.
 ;
 ; The reason the code had to be cloned and modified is that
 ;      (1) the search for the LAB entry in the Package (#9.4)
 ;          file was using the wrong index, so it had to be
 ;          corrected, and
 ;      (2) needed to make sure the check for an OOS 'stop
 ;          code' was not used.
 ;
EN ;Builds Laboratory OOS Location
 ;
 D BMES^XPDUTL("Creating OOS Location in File 44")
 ;
LOCMAKE ;
 S LRPKG=$O(^DIC(9.4,"C","LR",0))
 I 'LRPKG S LRPKG=$O(^DIC(9.4,"B","LAB SERVICE",0))
 I 'LRPKG D  G END
 . D BMES^XPDUTL("*** Not able to find 'LAB SERVICE' in your Package (#9.4) file. ***")
 . D BMES^XPDUTL("*** Contact the IHS/OIT Helpdesk. POST INSTALL ABORTED!!        ***")
 . S XPDQUIT=2
 ;
 D BMES^XPDUTL("Creating Laboratory OOS Workload Locations")
 ;
SET S LROK=""
 S LRVN=$O(^LRO(67.9,0)) I LRVN S LRDIVN=LRVN D LK I $G(LROK)>0 S ^LAB(69.9,1,.8)=LROK
 I $G(LROK)>0 S LRVN1=0 F  S LRVN1=$O(^LRO(67.9,LRVN,1,LRVN1)) Q:LRVN1<1  S LRDIVN=LRVN1 D LK
 S LRDIVN=+$$SITE^VASITE I LRDIVN D LK I $G(LROK)>0,'$G(^LAB(69.9,1,.8)) S ^(.8)=LROK
 I $G(^LAB(69.9,1,.8)) D  G END
 . S STR=$$GET1^DIQ(69.9,"1,",.8)
 . D BMES^XPDUTL("DEFAULT LAB OOS LOCATION IS "_STR)
 ;
 S STR=$TR($J("",IOM)," ","=")
 D BMES^XPDUTL(STR)
 D MES^XPDUTL(STR)
 D BMES^XPDUTL("*** Not able to create LAB OOS Location in File 44!!     ***")
 D BMES^XPDUTL("*** Contact the IHS/OIT Helpdesk. POST INSTALL ABORTED!! ***")
 D BMES^XPDUTL(STR)
 D MES^XPDUTL(STR)
 S XPDQUIT=2
 Q
 ;
END ;
 Q:$G(LRDBUG)
 K DA,DATA,DIE,DIK,DIC,DR,LRDIV,LRDIVN,LRNAME,LROK,LRPKG,LRSCODE,LRVN
 K LRVN1,X
 Q
 ;
LK ;
 Q:$G(LRSDCX)
 ;
 NEW BLROUT
 S LRDIV=$S($G(^DIC(4,LRDIVN,99)):$P(^(99),U),1:LRDIVN)
 D FIND^DIC(40.7,,,,"LABORATORY SERVICES",,,,,"BLROUT")
 S LRSCODE=+$G(BLROUT("DILIST","ID",1,1))
 I LRSCODE<1 D  Q
 . D BMES^XPDUTL("*** 'LABORATORY SERVICES' NOT in File 40.7. ***")
 . D BMES^XPDUTL("*** POST INSTALL ABORTED!!                  ***")
 L
 S LRNAME="LAB DIV "_LRDIV_" OOS ID "_LRSCODE
 D LOADB
 Q
 ;
 ; Following code cloned from LOADB^LRCAPPH2
LOADB S LRNAME=$E(LRNAME,1,30) Q:$D(^SC("B",LRNAME))
 ;S X="SCDXUAPI" X ^%ZOSF("TEST") I '$T W !!,$$CJ^XLFSTR("Load SD*5.3*63 Patch",80),!! Q
 S X="SCDXUAPI" X ^%ZOSF("TEST") Q:'$T  ;IHS/DIR TUC/AAB 07/09/98
 S LROK=$$LOC(LRNAME,LRDIVN,LRSCODE,LRPKG,,)
 I $G(LRDBUG) W !,"LROK = ",LROK
 I LROK<1  D BMES^XPDUTL("*** "_$P(LROK,U,2)_" LOCATION NOT CREATED. ***")  Q
 ;
 D SHOW^LRCAPPH2
 D BMES^XPDUTL("LAB Location Added.")
 Q:$G(LRDBUG)  K DIC,DIE,DA,DIR
 Q
 ;
 ; Following code cloned from LOC^SCDXUAPI
LOC(NAME,INST,STOP,PKG,IEN,INACT) ; add/edit location for ancillary app
 ;
 ; Description:
 ; This call will accept the name, division, and stop code (DSS ID)
 ; of the clinic location to be add/edited.  If the IEN is passed in,
 ; the entry with that IEN will be updated.  Otherwise, a new entry will
 ; be added.  If the INACT variable is set to a date, it will INACTIVATE
 ; the location (if it exists).
 ;
 ;  Input:  NAME of clinic to be created (optional)
 ;          INST as pointer to the institution file (optional)
 ;          STOP as number of stop code (not IEN) for
 ;                occasion of service range of codes (optional)
 ;          PKG as package file IEN, name, or namespace - required!
 ;          IEN as IEN of location if you want to update an already
 ;                existing location (optional.  If not defined, NAME,
 ;                INST, STOP become required)
 ;          INACT as a date if you want to inactivate the location that
 ;                has the IEN you defined (optional)
 ;
 ; Output:  IEN of location created/inactivated - OR - 
 ;          -1^error message if problem encountered
 N ERR,I,SCERR,X
 S PKG=$$PKGIEN(PKG)
 F I="NAME","INST","STOP","INACT","IEN","PKG" I $G(@I) S SCERR(I)=@I
 S ERR=$$ERRCHK(.SCERR)
 I ERR]"" G LOCQ
 I $D(STOP) S STOP=$O(^DIC(40.7,"C",+STOP,0)) I 'STOP S Y=$$ERR(6) G LOCQ
 I $G(IEN)]"" D
 . N X
 . S X=$G(^SC(IEN,"OOS"))
 . I X,($P(X,"^",2)=PKG) D EDIT(IEN,$G(NAME),$G(INST),$G(STOP),PKG,$G(INACT)) Q
 . S ERR=$$ERR(7)
 E  D
 . F I="NAME","INST","STOP" I @I']"" S ERR=$$ERR(8) Q
 . S IEN=$$ADD(NAME,PKG) I IEN'>0 S ERR=$$ERR(9) Q
 . D EDIT(IEN,NAME,INST,STOP,PKG)
LOCQ Q $S(ERR]"":ERR,1:IEN)
 ;
 ;
ERRCHK(SC,RAD) ; check input variables for consistency
 ;
 ; if RAD defined, don't check division/institution
 ;
 N LOC,OK,X,Y
 S Y=""
 I $D(SC("IEN")) D  I +Y<0 G ERRCHKQ
 . N IEN
 . S IEN=SC("IEN")
 . S LOC=$G(^SC(+IEN,0))
 . I LOC']"" S Y=$$ERR(1) Q                                ; invalid ptr
 . I '$G(RAD),'$D(^DIC(4,+$G(SC("INST")),0)) D  I Y]"" Q
 . . I '$P(LOC,"^",4),'$P(LOC,"^",15) S Y=$$ERR(2) Q       ; bad inst/div
 . S X=$G(^SC(IEN,"I"))
 . I +X,('$P(X,"^",2)!($P(X,"^",2)>DT)) S Y=$$ERR(3) Q     ; inactive
 . S X=$G(^SC(IEN,"OOS"))
 . I +X,($P(X,"^",2)'=SC("PKG")) S Y=$$ERR(5) Q            ; wrong pkg
 I PKG'>0 S Y=$$ERR(4) G ERRCHKQ                           ; pkg invalid
 I $D(SC("STOP")) D  I Y]"" G ERRCHKQ
 . N STOP
 . S STOP=SC("STOP")
 . S STOP=$O(^DIC(40.7,"C",+STOP,0))
 . I 'STOP S Y=$$ERR(6) Q                                  ; bad stop code
 . ; I '$$EX^SDCOU2(+STOP) S Y=$$ERR(10) Q                   ; not oos stop
ERRCHKQ Q Y
 ;
 ;
NONCOUNT(IEN) ; convert location to non-count
 ;
 ;  Input:  IEN of location to convert
 ; Output:  none
 ;
 N DA,DIE,DR
 S DIE="^SC(",DA=IEN,DR="2502////Y"
 D ^DIE
 Q
 ;
 ;
UPD(IEN,PKG) ; update existing entry
 ;
 ;  Called from within routine only...not supported
 ;  Input:  IEN as IEN of location to update
 ;          PKG as calling package
 ;
 N SC
 D VAR(IEN,.SC)
 D EDIT(IEN,SC("NAME"),SC("INST"),SC("STOP"),PKG)
 Q
 ;
 ;
NEW(IEN,PKG) ; create new entry given parameters from existing entry
 ;
 ;  Called from within routine only...not supported
 ;  Input:  IEN as IEN of location to update
 ;          PKG as calling package
 ;
 N SC
 D VAR(IEN,.SC)
 S IEN=$$ADD(SC("NAME"),PKG)
 D EDIT(IEN,SC("NAME"),SC("INST"),SC("STOP"),PKG)
 Q IEN
 ;
 ;
 ;
VAR(IEN,SC) ; set up variables for ADD and EDIT calls based on existing entry
 ;
 ;  Input:  IEN as IEN of existing location
 ; Output:  SC("NAME") as name of location
 ;          SC("INST") as institution file ptr
 ;          SC("STOP") as IEN of clinic stop file
 ;
 N DIV,X
 S X=$G(^SC(+$G(IEN),0))
 S SC("NAME")=$P(X,"^",1)
 S SC("STOP")=$P(X,"^",7)
 I $P(X,"^",4) S SC("INST")=$P(X,"^",4) G VARQ
 S DIV=$P(X,"^",15),SC("INST")=$P($G(^DG(40.8,+DIV,0)),"^",7)
VARQ Q
 ;
 ;
PKGIEN(PKG) ; get IEN of package file entry
 ;
 ;  Input:  PKG as IEN, name, or abbreviation of PKG
 ; Output:  IEN of package file
 ;
 N Y
 S PKG=$G(PKG)
 I PKG']"" S Y=-1 G PKGIENQ
 I PKG S Y=PKG G PKGIENQ
 S Y=$O(^DIC(9.4,"C",PKG,0)) I Y G PKGIENQ
 S Y=$O(^DIC(9.4,"B",PKG,0)) I Y G PKGIENQ
 S Y=-1
PKGIENQ Q Y
 ;
 ;
DIV(INST) ; return division associated with institution
 Q $O(^DG(40.8,"AD",+INST,0))
 ;
 ;
CHK(IEN) ; check to see if patterns exist for IEN
 ;
 ;  Input:  IEN of hospital location file
 ; Output:  1 if ok (no patterns exist); 0 otherwise
 ;
 N I,OK
 S OK=1
 I $G(^SC(IEN,"SL"))]"" S OK=0 G CHKQ
 I $O(^SC(IEN,"ST",0)) S OK=0 G CHKQ
 I $O(^SC(IEN,"T",0)) S OK=0 G CHKQ
 F I=0:1:6 I $O(^SC(IEN,"T"_I,0)) S OK=0 Q
CHKQ Q OK
 ;
 ;
ADD(SCNAME,SCPKG) ; add new entry
 ;
 N DD,DIC,DINUM,DO,X,Y
 S DIC="^SC(",X=SCNAME,DIC(0)="L"
 S DIC("DR")="50.01////1;50.02////^S X=$$PKGIEN^SCDXUAPI(SCPKG);"
 D FILE^DICN
 Q +Y
 ;
EDIT(SCIEN,SCNAME,SCINST,SCSTOP,SCPKG,SCINACT) ; update fields
 ;
 N DA,DIE,DR,INST,X
 S DIE="^SC(",DA=SCIEN,DR=""
 I $G(SCNAME)]"" S DR=DR_".01///^S X=SCNAME;"    ; name
 S DR=DR_"2////C;"                               ; type = clinic
 I $G(SCINST)]"" D
 . S DR=DR_"3////^S X=SCINST;"                   ; inst ptr
 . S DR=DR_"3.5////^S X=$$DIV^SCDXUAPI(SCINST);" ; division
 I $G(SCSTOP)]"" S DR=DR_"8////^S X=SCSTOP;"     ; stop code
 S DR=DR_"2504////Y;"                            ; clinic meets here
 S DR=DR_"9////0;"                               ; service=none
 S DR=DR_"2502////N;"                            ; non-count=no
 S DR=DR_"2502.5////0;"                          ; on fileroom list = no
 S DR=DR_"26////1;"                              ; ask provider = yes
 S DR=DR_"27////0;"                              ; ask diagnosis = no
 S DR=DR_"2500////Y;"                            ; prohibit access=yes
 S DR=DR_"50.01////1;"                           ; occasion of serv loc
 S DR=DR_"50.02////^S X=$$PKGIEN^SCDXUAPI(SCPKG);"  ; calling pkg
 I $G(SCINACT) D
 . S DR=DR_"2505////^S X=SCINACT;"              ; inact date
 . S DR=DR_"2506///@;"                          ; remove react date
 D ^DIE
 Q
 ;
 ;
ERR(NUMBER) ; return error message corresponding to the number passed in
 ;
 ;  Input:  NUMBER of error message to return
 ; Output:  -1^NUMBER^Error Message Text
 ;
 Q "-1^"_NUMBER_"^"_$P($T(ERRORS+NUMBER),";;",2)
 ;
 ;
ERRORS ; list of error messages
 ;;Hospital Location IEN is Invalid
 ;;Neither institution nor division defined properly for existing entry
 ;;Location has an inactivation date
 ;;Invalid PKG variable passed in
 ;;IEN belongs to another package (PKG file entries don't match)
 ;;Invalid stop code passed
 ;;Invalid IEN passed to LOC call (package doesn't 'own' IEN)
 ;;NAME, INST, and STOP not all defined before LOC call when IEN not set
 ;;Unable to add entry to Hospital Location file
 ;;Stop code not an occassion of service stop
 ;
 ;
SCREEN(PKG) ; screen to only allow OOS locations for specified package
 Q "I +$G(^(""OOS"")),($P(^(""OOS""),""^"",2)="_$$PKGIEN(PKG)_")"
 ;
EXEMPT() ; screen on clinic stop file to select only OOS stops
 Q "I $$EX^SDCOU2(+Y)"
 ;
PKGNM(SCPKG) ; Return Name of Package
 ;  Input:     SCPKG - Pointer to Package File (9.4)
 ;  Returned:  Name of Package or 'Bad or Missing Pointer'
 ;
 N SCOS
 D:$G(SCPKG) GETS^DIQ(9.4,SCPKG,.01,"E","SCOS")
 Q $S($D(SCOS(9.4,(+$G(SCPKG))_",",.01,"E")):SCOS(9.4,(+$G(SCPKG))_",",.01,"E"),1:"Bad or Missing Pointer")
