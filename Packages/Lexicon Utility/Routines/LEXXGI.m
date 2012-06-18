LEXXGI ; ISL Global Import (Needs ^LEXM)          ;01-Aug-2001 23:50;PLS
 ;;2.0;LEXICON UTILITY;**4**;Sep 23, 1996
EN ; Update Lexicon Data
 D IMP Q
TASK ; Que Lexicon Update w/ Taskman
 S ZTRTN="EN^LEXXGI",ZTDESC="Importing Updated Lexicon Data",ZTIO="",ZTDTH=$H D ^%ZTLOAD,HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN Q
IMP ; Import
 D:'$D(^LEXM) NF Q:'$D(^LEXM)
 N %,LEXBEG,LEXELP,LEXEND,LEXTXT,LEXOK S LEXOK=0 I $O(^LEXM(0))>0,$E($O(^LEXM(0)),1,3)="757" S LEXOK=1
 Q:'LEXOK  S LEXBEG=$$HACK D IMPORT K ^LEXM(0) S LEXEND=$$HACK S LEXELP=$$ELAP(LEXBEG,LEXEND) S:LEXELP="" LEXELP="00:00:00"
 S LEXTXT="   Data Updated " D PB(LEXTXT)
 S LEXTXT="        Started:   "_$TR($$FMTE^XLFDT(LEXBEG),"@"," ") D PB(LEXTXT)
 S LEXTXT="        Finished:  "_$TR($$FMTE^XLFDT(LEXEND),"@"," ") D TL(LEXTXT)
 S LEXTXT="        Elapsed:   "_LEXELP D TL(LEXTXT)
 K LEXBEG,LEXCHG,LEXCNT,LEXCRE,LEXDT,LEXELP,LEXEND,LEXFI,LEXFIC,LEXI,LEXL,LEXL1,LEXL2,LEXLC,LEXMUMPS,LEXNM,LEXOK,LEXRV,LEXS,LEXTOT,LEXTXT,LEXVR Q
IMPORT ; Import by File
 N LEXFI,LEXFIC S (LEXFI,LEXFIC)=0 D:LEXOK HDR F  S LEXFI=$O(^LEXM(LEXFI)) Q:+LEXFI=0  D FILES
 Q
FILES ; File Data
 N LEXTXT,LEXCHG,LEXI,LEXL,LEXLC,LEXNM,LEXTOT,LEXCNT,LEXS,LEXMUMPS
 S (LEXCNT,LEXLC,LEXI)=0,LEXL=68,LEXFIC=LEXFIC+1,LEXTOT=+($G(^LEXM(LEXFI,0))) Q:LEXTOT=0  S LEXNM=$G(^LEXM(LEXFI,0,"NM"))
 S:$L(LEXNM)&((LEXNM'["FILE")&(LEXNM'["File")&(LEXNM'["file")) LEXNM=LEXNM_" FILE" S:$L(LEXNM) LEXNM=$$MIX(LEXNM) S LEXCHG=$G(^LEXM(LEXFI,0))
 S LEXTXT="   "_LEXNM,LEXTXT=LEXTXT_$J("",(40-$L(LEXTXT)))_LEXFI D:LEXFIC=1 PB(LEXTXT) D:LEXFIC'=1 TL(LEXTXT)
 S LEXS=+(LEXTOT\LEXL) S:LEXS=0 LEXS=1 W:+($O(^LEXM(LEXFI,0)))>0 !,"   "
 F  S LEXI=$O(^LEXM(LEXFI,LEXI)) Q:+LEXI=0  D
 . S LEXCNT=LEXCNT+1 I LEXCNT'<LEXS S LEXLC=LEXLC+1 W:LEXLC'>LEXL "." S LEXCNT=0
 . S LEXMUMPS=$G(^LEXM(LEXFI,LEXI)) X:$L(LEXMUMPS) LEXMUMPS
 K ^LEXM(LEXFI) Q
HDR ; Header
 N LEXNM,LEXL1,LEXL2,LEXVR,LEXRV,LEXDT,LEXCRE S (LEXL1,LEXL2)=""
 S LEXNM=$$MIX($G(^LEXM(0,"PKG"))),LEXCRE=$G(^LEXM(0,"CREATED")),LEXCRE=$S(+LEXCRE>0:($$MIX($$FMTE^XLFDT(LEXCRE))),1:"") S:$L($P(LEXCRE,"@",2)) LEXCRE=$P(LEXCRE,"@",1)_" at "_$P(LEXCRE,"@",2)
 S LEXVR=$G(^LEXM(0,"VR")),LEXRV=$G(^LEXM(0,"VRRV")),LEXDT=$$MIX($P($G(^LEXM(0,"VRRVDT")),"^",2))
 S LEXL1="Updating "_LEXNM
 S:$L(LEXVR) LEXL1=LEXL1_" to version "_LEXVR
 S:$L(LEXVR)&($L(LEXRV)) LEXL1=LEXL1_" revision "_LEXRV
 S:$L(LEXVR)&($L(LEXRV))&($L(LEXDT)) LEXL1=LEXL1_" dated "_LEXDT
 S:$L(LEXCRE)&($L(LEXL1)) LEXL2="using export global created "_LEXCRE
 S:$L(LEXL1) LEXL1=" "_LEXL1 S:$L(LEXL2) LEXL2=" "_LEXL2 D:$L(LEXL1) PB(LEXL1) D:$L(LEXL2) TL(LEXL2)
 Q
INS ; Installed
 S LEXIN=$TR($G(LEXIN),"@"," ") D PB(("Import Global ^LEXM was installed on "_LEXIN)) Q
NF ; Import Global Not Found
 D PB("Import Global ^LEXM not found, consult the installation instructions") D TL("to install this global") Q
BL ; Blank Line
 N X S X="" W:'$D(XPDNM) ! D:$D(XPDNM) MES^XPDUTL(X) Q
PB(X) ; Preceeding Blank Line
 S X=$G(X) Q:'$L(X)  W:'$D(XPDNM) !!,X D:$D(XPDNM) BMES^XPDUTL(X) Q
TL(X) ; Text Line
 S X=$G(X) Q:'$L(X)  W:'$D(XPDNM) !,X D:$D(XPDNM) MES^XPDUTL(X) Q
HACK(X) ; Time Hack
 N %,%H,%I D NOW^%DTC S X=% Q X
ELAP(X1,X2) ; Elapsed Time (start,end)
 N X S X=$$FMDIFF^XLFDT(+($G(X2)),+($G(X1)),3)
 S:X="" X="00:00:00" S X=$TR(X," ","0") S X1=X Q X1
 ;
CHECKSUM ; ^LEXM Checksum for Environment Check
 W !!,"Running checksum routine on the ^LEXM import global, please wait"
 N LEXCHK,LEXNDS,LEXVER S LEXCHK=+($G(^LEXM(0,"CHECKSUM")))
 S LEXNDS=+($G(^LEXM(0,"NODES"))),LEXVER=+($$VER(LEXCHK,LEXNDS))
 W ! W:LEXVER>0 "  ok",!
 D:LEXVER=0 ET("Import global ^LEXM is missing.  Please obtain a copy of ^LEXM before"),ET("continuing.")
 D:LEXVER=-1 ET("Unable to verify checksum for import global ^LEXM (possibly corrupt). "),ET("Please obtain a new copy of ^LEXM before continuing.")
 D:LEXVER=-2 ET("Import global ^LEXM failed checksum.  Please obtain a new copy of ^LEXM"),ET("before continuing.")
 I LEXVER=-3 D
 . D ET("Import global ^LEXM failed checksum.  Additionally, your copy of the import")
 . D ET("global ^LEXM is not complete (the number of global nodes exported and the")
 . D ET("number of global nodes received do not match).  Please obtain a new copy of")
 . D ET("^LEXM before continuing.")
 D:$D(LEXE)&('$D(XPDNM)) ED
 Q
VER(LEXCHK,LEXNDS) ; Verify ^LEXM Global
 ;
 Q:'$D(^LEXM) 0
 ; N LEXCNT,LEXLC,LEXL,LEXS,LEXNC,LEXD,LEXN,LEXC,LEXGCS,LEXP,LEXT,LEXE
 S LEXCHK=+($G(LEXCHK)),LEXNDS=+($G(LEXNDS)) Q:LEXCHK'>0!(LEXNDS'>0) -1
 S LEXL=68,(LEXCNT,LEXLC)=0,LEXS=+(LEXNDS\LEXL)
 S:LEXS=0 LEXS=1 W:+($O(^LEXM(0)))>0 !
 S (LEXC,LEXN)="^LEXM",(LEXNC,LEXGCS)=0
 F  S LEXN=$Q(@LEXN) Q:LEXN=""!(LEXN'[LEXC)  D
 . Q:LEXN="^LEXM(0,""CHECKSUM"")"  Q:LEXN="^LEXM(0,""NODES"")"
 . S LEXCNT=LEXCNT+1
 . I LEXCNT'<LEXS S LEXLC=LEXLC+1 W:LEXLC'>LEXL "." S LEXCNT=0
 . S LEXNC=LEXNC+1,LEXD=@LEXN,LEXT=LEXN_"="_LEXD,LEXE=$L(LEXT)
 . F LEXP=1:1:LEXE S LEXGCS=$A(LEXT,LEXP)*LEXP+LEXGCS
 Q:LEXNC'=LEXNDS -3 Q:LEXGCS'=LEXCHK -2 Q 1
ET(X) N LEXI S LEXI=+($G(LEXE(0))),LEXI=LEXI+1,LEXE(LEXI)=$G(X),LEXE(0)=LEXI Q
ED N LEXI S LEXI=0 F  S LEXI=$O(LEXE(LEXI)) Q:+LEXI=0  W !,LEXE(LEXI)
 W ! K LEXE Q
MIX(X) ; Mixed Case
 S X=$G(X) N LEXTXT,I S LEXTXT=""
 F I=1:1:$L(X," ") S LEXTXT=LEXTXT_" "_$$UP($E($P(X," ",I),1))_$$LO($E($P(X," ",I),2,$L($P(X," ",I))))
 F  Q:$E(LEXTXT,1)'=" "  S LEXTXT=$E(LEXTXT,2,$L(LEXTXT))
 S X=LEXTXT Q X
UP(X) ; Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
LO(X) ; Lowercase
 Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
