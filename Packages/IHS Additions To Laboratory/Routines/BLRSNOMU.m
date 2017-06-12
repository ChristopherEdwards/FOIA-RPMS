BLRSNOMU ; IHS/OIT/MKK - IHS Lab SNOMED Utilities ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034**;NOV 1, 1997;Build 88
 ;
 ; Requires user to enter free text input so as to retrieve matches from the
 ; BSTS terminology server.
 ;
PEP ; EP
EP ; EP
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ; Requried variables are:
 ;     (1) DFN    -- Patient Pointer to file 2
 ;     (2) LRORD  -- Order Number
 ;     (3) LRODT  -- Order Date
 ;
GETSDIAG(LRORD,LRODT,TESTIEN) ; EP - Get & Store Diagnosis
 NEW (DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRORD,LRODT,PNM,HRCN,TESTIEN,U,XPARSYS,XQXFLG)
 ;
 S LRDFN=+$G(^DPT(DFN,"LR"))
 ;
 S PROBSTR=$$TEXTPOVI(DFN)
 ;
 I $L(PROBSTR)<1 D FATALERR  Q
 ;
 D STORDIAG
 Q
 ;
TEXTPOVI(DFN) ; EP - Use Text & BSTS Database
 NEW (DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,HRCN,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,PNM,U,XPARSYS,XQXFLG)
 ;
 ; User MUST enter a diagnosis.  No exceptions.
 S Y=0
 F  Q:Y  D
 . W !!
 . D ^XBFMK
 . S DIR(0)="F"
 . S DIR("A")="Enter Clinical Indication (Free Text)"
 . D ^DIR
 . I $G(X)="^^^"  S Y=99999999  Q      ; Trick to exit
 . ;
 . I $L(X)<1!(+$G(DIRUT)) D  Q
 .. W !!,?4,"Invalid.  Must Enter a Clinical Indication.",!
 .. D PRESSKEY^BLRGMENU(9)
 .. S Y=0
 . K VARS,IN
 . S OUT="VARS",IN=$G(X)_"^F^^^^300"
 . S Y=$$SEARCH^BSTSAPI(OUT,IN)
 . I Y<1 W !!,?9,"No entries found in the IHS STANDARD TERMINOLOGY database.  Try Again."
 ;
 D:$G(X)="^^^" FATALERR
 ;
 S (NUM,CNT)=0
 K ^TMP("BLRSNO"),BLRSNOX
 ; Call List Manager routine
 D EN^BLRSNO
 ;
 ;
 F  S NUM=$O(VARS(NUM))  Q:NUM<1  D
 . Q:$L($G(VARS(NUM,"ICD",1,"COD")))<1&($L($G(VARS(NUM,"10D",1,"COD")))<1)
 . ;
 . S CNT=CNT+1
 . ; Setup List Manager Array
 . D SET^VALM10(CNT,$J(CNT,3)_"  "_$$LJ^XLFSTR($G(VARS(NUM,"FSN","DSC")),14)_$G(VARS(NUM,"FSN","TRM")))
 . S BLRSNOX(CNT,NUM)=""            ; Build "Cross Reference" Array
 ;
 S VALMCNT=CNT
 S MAXSEARCH=$O(VARS("A"),-1)
 ;
 S WHATSEL=0
 F  Q:+WHATSEL!(BOOM)  D
 . D MAKEDIR(WHATSEL)
 . M TMPDIR=DIR
 . ;
 K ICDCODES
 S (CNT,NUM)=0
 F  S NUM=$O(VARS(NUM))  Q:NUM<1!(CNT>17)  D
 . Q:$L($G(VARS(NUM,"ICD",1,"COD")))<1&($L($G(VARS(NUM,"10D",1,"COD")))<1)
 . ;
 . Q:$L($G(ICDCODES($G(VARS(NUM,"ICD",1,"COD")))))
 . S ICDCODES($G(VARS(NUM,"ICD",1,"COD")))=$G(VARS(NUM,"FSN","TRM"))_"^^"_$G(VARS(NUM,"FSN","DSC"))
 . S CNT=CNT+1
 ;
 S DIRZERO="S^"
 S (CNT,ICDCODE)=0
 F  S ICDCODE=$O(ICDCODES(ICDCODE))  Q:ICDCODE<1  D
 . S ICDDESC=$P($G(ICDCODES(ICDCODE)),"^")
 . S SNOMED=$P($G(ICDCODES(ICDCODE)),"^",3)
 . S CNT=CNT+1
 . S DIRZERO=DIRZERO_CNT_":"_ICDCODE_";"
 . S STR=$J(CNT,4)_") "
 . S $E(STR,7)=ICDCODE
 . S:$G(DEBUG)'="YES" $E(STR,20)=$E(ICDDESC,1,53)
 . S:$G(DEBUG)="YES" $E(STR,20)=$E(ICDDESC,1,38),$E(STR,60)=$S(SORTDATE:$$FMTE^XLFDT(SORTDATE,"5DZ"),1:" ")
 . S DIRZERO(CNT)=$$LJ^XLFSTR(STR,75)
 . S ICDINDEX(CNT)=ICDCODE_"^"_ICDDESC_"^^"_SNOMED
 ;
 D MAKEDIR           ; Create DIR array
 ;
 M TMPDIR=DIR        ; Allows DIR array to be reset in the following FOR loop
 ;
 ; User MUST select an entry.  No exceptions.
 S Y=0
 F  Q:Y  D
 . W !!
 . D ^DIR
 . I +$G(Y)<1!(+$G(DIRUT)) D
 .. W !!,?4,"Invalid.  Must Select an Entry.",!
 .. D PRESSKEY^BLRGMENU(9)
 .. D ^XBFMK
 .. S Y=0
 .. M DIR=TMPDIR
 ;
 Q $G(ICDINDEX(Y))
 ;
STORDIAG ; EP - Store the Same ICD code on ALL tests in an order
 NEW DESCIEN,ERRS,FDA,ICDIEN,ICDSTR,ICDCODE,ICDDESC,ICDSTR,IENS,LATEST,LRSN,LRTST
 ;
 S ICDCODE=$P(PROBSTR,"^")
 S ICDDESC=$P(PROBSTR,"^",2)
 S PROVNARR=$P(PROBSTR,"^",3)                    ; Provider Narrative, if it exists
 S:$L(PROVNARR)<1 PROVNARR=ICDDESC               ; If it doesn't exist, set to ICD Description
 S SNOMED=$P(PROBSTR,"^",4)
 ;
 S LRSN=.9999999
 F  S LRSN=$O(^LRO(69,"C",LRORD,LRODT,LRSN)) Q:LRSN<1  D
 . S LRTST=.9999999
 . F  S LRTST=$O(^LRO(69,LRODT,1,LRSN,2,LRTST))  Q:LRTST<1  D
 .. D ^XBFMK
 .. K FDA,ERRS,IENS
 .. S IENS=LRTST_","_LRSN_","_LRODT_","
 .. S FDA(69.03,IENS,9999999.1)=$S($L(PROVNARR):PROVNARR,$L(ICDDESC):ICDDESC,1:" ")
 .. S:$L(SNOMED) FDA(69.03,IENS,9999999.2)=SNOMED
 .. D FILE^DIE("EKS","FDA","ERRS")
 .. I $D(ERRS) D ERRMSG("STORDIAG^BLRSNOMU FILE^DIE")
 .. Q:$L(ICDCODE)<1
 .. ;
 .. K FDA,ERRS
 .. S FDA(69.05,"?+1,"_IENS,.01)=ICDCODE
 .. D UPDATE^DIE("ES","FDA",,"ERRS")
 .. I $D(ERRS) D ERRMSG("STORDIAG^BLRSNOMU UPDATE^DIE")
 Q
 ;
MAKEDIR ; EP - Create DIR array for ICD Codes
 D ^XBFMK
 S DIR(0)=DIRZERO
 S DIR("L",1)="Select Clinical Indication for "_PNM_" ["_HRCN_"]:"
 S DIR("L",2)=" "
 S DIR("L",3)="     SNOMED         SNOMED Description"
 ;             12345678901234567890123456789012345678901234567890123456789012345678901234567890
 S DIR("L",4)="     ----------- ---------------------------------------------------------------"
 S BELOW=5
 S CNT=0
 F  S CNT=$O(DIRZERO(CNT))  Q:CNT<1  D
 . ; S DIR("L",BELOW)=$J("",2)_$G(DIR("L",BELOW))_DIRZERO(CNT)
 . S DIR("L",BELOW)=$G(DIR("L",BELOW))_DIRZERO(CNT)
 . S BELOW=BELOW+1
 ;
 S DIR("L")=""
 S DIR("A")="Selection"
 Q
 ;
FATALERR ; EP - Hard Crash the process
 NEW ROWSTARS,SPACER,SPACERLN,STR,STRLEN
 ;
 S STR="@NO@SIGN@NOR@SYMPTOM!@FORCE@CRASH!@"
 S STRLEN=$L(STR)
 S SPACER=$TR($J("",STRLEN)," ","@")
 S ROWSTARS=$TR($J("",IOM)," ","*")
 S SPACERLN=$TR($$CJ^XLFSTR(SPACER,IOM),"@ "," *")
 ;
 D ^XBCLS
 W ROWSTARS,!
 W ROWSTARS,!
 W SPACERLN,!
 W $TR($$CJ^XLFSTR(STR,IOM),"@ "," *")
 W SPACERLN,!
 W ROWSTARS,!
 W ROWSTARS,!
 ;
 W !!,"Occurring in "  F X=5:-1:1 W X,"..."  H 1
 ;
 D ^LRKILL
 ;
 D BIGWORD("BOOM")
 W 1/0
 Q
 ;
BIGWORD(LRLTR) ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRLTR,U,XPARSYS,XQXFLG)
 ;
 I '$D(^TMP("LRLTR",$J,"A")) D ^LRLTR2
 ;
B1 ; EP
 S LRLTY=$E(LRLTR,1,6),LRLTX=""
 F LRLT1=1:1:$L(LRLTY) I $A(LRLTY,LRLT1)>32,$D(^TMP("LRLTR",$J,$E(LRLTY,LRLT1))) S LRLTX=LRLTX_$E(LRLTY,LRLT1)
 D B2
 K LRLT1,LRLT2,LRLT3,LRLTX,LRLTY,LRLT,LRJ0,LRJ02 W !
 Q
 ;
B2 ; EP
 W !
 F LRLT1=9:-1:1 W ! F LRLT3=1:1:$L(LRLTX) S X=^TMP("LRLTR",$J,$E(LRLTX,LRLT3)) W "   " F LRLT2=1:1:5 W $S($E(X,(LRLT2-1*9+LRLT1)):"XXX",1:"   ")
 Q
 ;
ERRMSG(MSG) ; EP - Error occurred during a DIE call
 NEW LRCNT,LRMTXT,MESSAGE,NOWDTIME,TAB,WOTARR1,WOTARR2,WOTVAR
 ;
 S TAB=$J("",10)
 ;
 S MESSAGE="FileMan DBS call failed."
 ;
 S LRMTXT(1)=MSG_" Issue"
 S LRMTXT(2)=" "
 S LRMTXT(3)="The following debugging information is provided to assist"
 S LRMTXT(4)="support staff in resolving the error."
 ;
 S LRMTXT(5)=" "
 S LRCNT=5
 ;
 S LRCNT=LRCNT+1,LRMTXT(LRCNT)="     DUZ="_$G(DUZ)
 S LRCNT=LRCNT+1,LRMTXT(LRCNT)="     DUZ(2)="_$G(DUZ(2))
 S LRCNT=LRCNT+1,LRMTXT(LRCNT)=" "
 ;
 ; Store Arrays
 F WOTARR1="ERRS","FDA","FDAIEN","LR68","LRAA","LRAD","LRAN","LRDFN","LRDIE","LRSS","LRTSTS","LRUNQ","LRWLC","XQY","XQY0" D
 . S X=$G(@WOTARR1)
 . I X'="" S LRCNT=LRCNT+1,LRMTXT(LRCNT)=WOTARR1_"="_X
 . S WOTARR2=WOTARR1
 . F  S WOTARR2=$Q(@WOTARR2) Q:WOTARR2=""  S LRCNT=LRCNT+1,LRMTXT(LRCNT)=WOTARR2_"="_@WOTARR2
 ;
 ; Store variables
 F WOTVAR="DFN","LRORD","LRODT","LRSP","PROBSTR","SNOMED","DESCPROB","ICDCODE","ICDDESC" D
 . S LRCNT=LRCNT+1,LRMTXT(LRCNT)=TAB_WOTVAR_"="_$G(@WOTVAR)
 ;
 ; D MAILALMI^BLRUTIL3(.MESSAGE,.LRMTXT,"BLRSNOMU",1)
 ;
 ; Store errors for 30 days
 S NOWDTIME=$$HTFM^XLFDT($H)
 I +$P($G(^XTMP("BLRSNOMU",0)),"^")'>(+NOWDTIME) D
 . K ^XTMP("BLRSNOMU")
 . S ^XTMP("BLRSNOMU",0)=$$HTFM^XLFDT(+$H+30)_"^"_$$DT^XLFDT_"^Temporary Error Message Storage for BLRSNOMU routine"
 ;
 M ^XTMP("BLRSNOMU",NOWDTIME,MSG)=LRMTXT
 Q
