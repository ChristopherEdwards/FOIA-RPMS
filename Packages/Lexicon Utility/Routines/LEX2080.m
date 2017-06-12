LEX2080 ;ISL/KER - LEX*2.0*80 Env Check ;04/21/2014
 ;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 10
 ;               
 ; Global Variables
 ;    ^%ZOSF("UCI"        ICR 10096
 ;    ^%ZOSF("UCICHECK"   ICR 10096
 ;    ^LEXM(              N/A
 ;    ^TMP("LEXKID")      SACC 2.3.2.5.1
 ;    ^TMP("LEXMSG")      SACC 2.3.2.5.1
 ;               
 ; External References
 ;    ^DIC                ICR  10006
 ;    FIND^DIC            ICR   2051
 ;    $$IENS^DILF         ICR   2054
 ;    $$GET1^DIQ          ICR   2056
 ;    EN^DIQ1             ICR  10015
 ;    $$FMTE^XLFDT        ICR  10103
 ;    ^XMD                ICR  10070
 ;    $$NETNAME^XMXUTIL   ICR   2734
 ;    $$PATCH^XPDUTL      ICR  10141
 ;    $$PKG^XPDUTL        ICR  10141
 ;    $$VERSION^XPDUTL    ICR  10141
 ;    $$VER^XPDUTL        ICR  10141
 ;    BMES^XPDUTL         ICR  10141
 ;    MES^XPDUTL          ICR  10141 
 ;        
 ; Local Variables NEWed or KILLed Elsewhere
 ;     XPDABORT,XPDDIQ,XPDENV,XPDQUIT
 ;               
ENV ; LEX*2.0*80 Environment Check
 ;   Checks
 S XPDNOQUE=1 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR,LEXG,LEXE,LEXSTR D IMP
 K XPDDIQ("XPZ1","B"),XPDDIQ("XPI1","B") S XPDDIQ("XPZ1","B")="NO",XPDDIQ("XPI1","B")="NO"
 S U="^"
 ;     User Variables
 D:+($$UR)'>0 ET("User not defined (DUZ)")
 ;     System Variables
 D:+($$SY)'>0 ET("Undefined IO variable(s)")
 I $D(LEXE) D ABRT Q
 ;     Version Number
 I $$VERSION^XPDUTL("LEX")'="2.0" D  D ABRT Q
 . D ET("Version 2.0 not found.  Please install Lexicon Utility v 2.0")
 ;     Required Patches
 D:$O(LEXREQP(0))'>0 IMP I $O(LEXREQP(0))>0 D
 . W ! N LEXPAT,LEXI,LEXPN,LEXP,LEXR,LEXC,LEXO,LEXC1,LEXC2,LEXC3,LEXC4,LEX
 . S (LEXR,LEXC)=0 S LEXC1=3,(LEXC2,LEXC3,LEXC4)=20,LEXC2=18
 . S LEXI=0  F  S LEXI=$O(LEXREQP(LEXI)) Q:+LEXI'>0  D
 . . S LEXC=LEXC+1,LEXPAT=$G(LEXREQP(LEXI))
 . . S:$P(LEXPAT,"^",2)?7N LEXR=LEXR+1,LEXC3=LEXC2+13,LEXC4=LEXC2+36
 . S LEXI=0  F  S LEXI=$O(LEXREQP(LEXI)) Q:+LEXI'>0  D
 . . N LEXPAT,LEXREL,LEXINS,LEXCOM,LEXINE,LEXREQ,LEXTX S LEXREQ=$G(LEXREQP(LEXI))
 . . S LEXPAT=$P(LEXREQ,"^",1),LEXREL=$P(LEXREQ,"^",2),LEXCOM=$P(LEXREQ,"^",3)
 . . S LEXPN=$$INS(LEXPAT) S LEXINS=$$INSD(LEXPAT),LEXINE=$P(LEXINS,"^",2)
 . . W:LEXI=1 !,?3,"Checking for ",?LEXC2,$S(+($G(LEXR))>0:"Released",1:"")
 . . S LEXTX=$J(" ",LEXC1)_LEXPAT
 . . S:LEXREL?7N LEXTX=LEXTX_$J(" ",(LEXC2-$L(LEXTX)))_$TR($$FMTE^XLFDT(LEXREL,"5DZ"),"@"," ")
 . . I +LEXPN>0 D
 . . . S LEXO=+($G(LEXO))+1 S LEXTX=LEXTX_$J(" ",(LEXC3-$L(LEXTX)))_"Installed "
 . . . S:$L($G(LEXINE)) LEXTX=LEXTX_LEXINE
 . . . S:+LEXC4>0&(+LEXC4>LEXC3)&($L(LEXCOM)) LEXTX=LEXTX_$J(" ",(LEXC4-$L(LEXTX)))_LEXCOM
 . . D M(LEXTX)
 . . I +LEXPN'>0 D ET((" "_LEXPAT_" not found, please install "_LEXPAT_" before continuing"))
 . W:+($G(LEXO))'=LEXC !
 I $D(LEXE) D M(),ABRT Q
 D IG I $D(LEXE) D M(),ABRT Q
 I '$D(LEXFULL)&(+($G(XPDENV))'=1) D QUIT Q
 I $D(LEXE) D ABRT Q
 S LEXG=$$RGBL
 I $D(LEXE)&(+LEXG=0) D ABRT Q
 I $D(LEXE)&(+LEXG<0) D ABRT Q
 I '$D(LEXFULL)&(+($G(XPDENV))'=1) D QUIT Q
 ;                    
 ;   Install Package(s)
 ;
 ;     XPDENV = 1 Environment Check during Install
 ;
 ;       Check Data "is installed" or "is translated"
 N LEXIT S LEXIT=0 I '$D(LEXFULL)&(LEXIT) D QUIT Q
 ;       Checking Global "Write" Protection 
 D:+($G(XPDENV))=1 GBLS I $D(LEXE) D ABRT Q
 ;       Check Import Global Checksum 
 D:+($G(XPDENV))=1 CS I $D(LEXE) D ABRT Q
 ;   Quit, Exit or Abort
QUIT ;     Quit   Passed Environment Check
 K LEXFULL D OK
 Q
EXIT ;     Exit   Failed Environment Check
 D:$D(LEXE) ED S XPDQUIT=2 K LEXE,LEXFULL Q
ABRT ;     Abort  Failed Environment Check, KILL the distribution
 D:$D(LEXE) ED S XPDABORT=1,XPDQUIT=1,XPDQUIT("LEX*2.0*80")=1,XPDQUIT("ICD*18.0*57")=1
 K LEXE,LEXFULL
 Q
ENV2 ;   Environment Check #2 - XPDENV=1
 N XPDENV S XPDENV=1 D ENV
 Q
GBLS ;   Check Write access on globals
 N LEXB1,LEXB2,LEXE,LEXGBL,LEXRT,LEXT,LEXF,LEXI,LEXX,LEXOK,LEXS,X S LEXOK=1
 D BM("   I will now check the protection on ^LEX, ^ICD9 and ^ICD0 Globals.")
 D M("   If you get an ERROR, you will need to change the protection on ")
 D M("   these globals to allow read/write as indicated:")
 D BM("                        Owner     Group    World   Network")
 D M("      Cache systems      RWD       RW       RW      RWD")
 D BM("   Checking:"),M(" ")
 S LEXS="",X=1 F LEXI=1:1 D  Q:'$L(LEXX)
 . S LEXX="" S LEXE="S LEXX=$T(GD+"_LEXI_")" X LEXE S LEXX=$$TRIM(LEXX) Q:'$L(LEXX)  Q:'$L($TR(LEXX,";",""))
 . S LEXGBL=$P(LEXX,";",3) Q:LEXGBL["^LEXM"  S LEXRT=$P(LEXX,";",4),LEXT=$P(LEXX,";",5),LEXF=$P(LEXX,";",6)
 . S (LEXB1,LEXB2)="",$P(LEXB1," ",(19-$L(LEXRT)))="",$P(LEXB2," ",(28-$L(LEXT)))=""
 . I '$D(@LEXGBL) D RGNF S LEXOK=0 D M(("      <"_LEXRT_" not found>")) Q
 . D M(("      "_LEXRT_LEXB1_LEXT_LEXB2_LEXF)) S @LEXGBL=$G(@LEXGBL) H 1
 D:LEXOK M("    --> ok") D:'LEXOK M("    ??") D M(" ")
 Q
RGBL(X) ;   Check Write access on globals
 N LEXS,LEXI,LEXX,LEXEC,LEXGBL,LEXRT,LEXT,LEXF,LEXB1,LEXB2
 S LEXS="",X=1 F LEXI=1:1 D  Q:'$L(LEXX)
 . S LEXX="" S LEXEC="S LEXX=$T(GD+"_LEXI_")" X LEXEC S LEXX=$$TRIM(LEXX) Q:'$L(LEXX)  Q:'$L($TR(LEXX,";",""))
 . S LEXGBL=$P(LEXX,";",3) Q:LEXGBL["^LEXM"  S LEXRT=$P(LEXX,";",4),LEXT=$P(LEXX,";",5),LEXF=$P(LEXX,";",6)
 . S (LEXB1,LEXB2)="",$P(LEXB1," ",(15-$L(LEXRT)))="",$P(LEXB2," ",(28-$L(LEXT)))=""
 . I '$D(@LEXGBL) S:LEXS'[LEXRT LEXS=LEXS_", "_LEXRT S X=-1 S:LEXGBL["LEXM("&(X=1) X=0
 I $L(LEXS),X'>0 D
 . S:LEXS[", " LEXS=$P(LEXS,", ",1,($L(LEXS,", ")-1))_" and "_$P(LEXS,", ",$L(LEXS,", "))
 . S:$E(LEXS,1,2)=", " LEXS=$E(LEXS,3,$L(LEXS)) S:$E(LEXS,1,7)[" and " LEXS=$P(LEXS," and ",2)
 . D:X=-1 ET(("Global"_$S(LEXS[", "!(LEXS[" and "):"s",1:"")_" "_LEXS_" either not found or incomplete."))
 . D:X=0 CM
 Q X
RGNF ;   Required global not found
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP Q:'$L(LEXBUILD)  Q:$D(^TMP("LEX*2.0*80",$J,"NODATA"))
 D:$G(LEXGBL)["^LEX"&($G(LEXGBL)'["^LEXM") ET(""),ET("Required global "_$P($G(LEXGBL),"(",1)_" not found.")
 D:$G(LEXGBL)["^LEX"&($G(LEXGBL)["^LEXM") CM
 Q
UOK(X) ; UCI Ok for Install
 N X,Y S X=$$NETNAME^XMXUTIL(.5) Q:X["LEXDEV1.FO-BAYPINES" 0
 X ^%ZOSF("UCI") Q:$G(Y)["LEXDEV1" 0  S X="LEXDEV1" X ^%ZOSF("UCICHECK")  Q:$G(X)=$G(Y) 0
 Q 1
GOK(X) ; Input Global Ok for Install
 D IMP Q:'$L(LEXBUILD) 0  Q:$D(^TMP("LEX*2.0*80",$J,"NODATA")) 1
 Q:'$D(^LEXM) 0  Q:'$D(^LEXM(80)) 0  Q:'$D(^LEXM(80.1)) 0  Q:'$D(^LEXM(80.4)) 0
 Q:$G(^LEXM(0,"BUILD"))'=$G(LEXBUILD) 0
 Q 1
CS ;   Checksum for import global
 K LEXE D IMP Q:'$L(LEXBUILD)  Q:$D(^TMP("LEX*2.0*80",$J,"NODATA")) 
 D BM("   Running checksum routine on the ^LEXM import global, please wait")
 N LEXCK,LEXND,LEXV S LEXCK=+($G(^LEXM(0,"CHECKSUM")))
 S LEXND=+($G(^LEXM(0,"NODES"))),LEXV=+($$VC(LEXCK,LEXND))
 D M(" ") D:LEXV>0 M("     Checksum is ok"),M(" ")
 D:LEXV=0 CM D:LEXV=-1 CW D:LEXV=-2 CU D:LEXV=-3 CF
 Q
VC(X,Y) ;   Verify Checksum for import global
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR
 D IMP Q:'$L(LEXBUILD) 0  Q:$D(^TMP("LEX*2.0*80",$J,"NODATA")) -4
 I $G(^LEXM(0,"BUILD"))'=$G(LEXBUILD) Q -1
 N LEXCK,LEXND,LEXCNT,LEXLC,LEXL,LEXS,LEXNC,LEXD,LEXN,LEXC,LEXGCS,LEXP,LEXT
 S LEXCK=+($G(X)),LEXND=+($G(Y))
 Q:LEXCK'>0!(LEXND'>0) -2
 S LEXL=64,(LEXCNT,LEXLC)=0,LEXS=(+(LEXND\LEXL))
 S:LEXS=0 LEXS=1 D:+($O(^LEXM(0)))>0 M("")
 S (LEXC,LEXN)="^LEXM",(LEXNC,LEXGCS)=0 W "   "
 F  S LEXN=$Q(@LEXN) Q:LEXN=""!(LEXN'[LEXC)  D
 . Q:LEXN="^LEXM(0,""CHECKSUM"")"
 . Q:LEXN="^LEXM(0,""NODES"")"
 . S LEXCNT=LEXCNT+1
 . I LEXCNT'<LEXS S LEXLC=LEXLC+1 W:LEXLC'>LEXL "." S LEXCNT=0
 . S LEXNC=LEXNC+1,LEXD=@LEXN,LEXT=LEXN_"="_LEXD
 . F LEXP=1:1:$L(LEXT) S LEXGCS=$A(LEXT,LEXP)*LEXP+LEXGCS
 Q:LEXNC'=LEXND -3
 Q:LEXGCS'=LEXCK -3
 Q 1
SY(X) ;   Check System variables
 Q:'$D(IO)!('$D(IOF))!('$D(IOM))!('$D(ION))!('$D(IOSL))!('$D(IOST)) 0
 Q 1
UR(X) ;   Check User variables
 Q:'$L($G(DUZ(0))) 0
 Q:+($G(DUZ))=0!($$NOTDEF(+$G(DUZ))) 0
 Q 1
 ; Error messages
 ;
CM ;   Missing ^LEXM
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP D ET(""),ET("Missing import global ^LEXM.") D CO
 Q
CW ;   Wrong ^LEXM
 N LEXB,LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP S LEXB=$G(^LEXM(0,"BUILD")) D ET("")
 I $L(LEXBUILD),$L(LEXB),LEXBUILD'=LEXB D  Q
 . D ET(("Incorrect import global ^LEXM found ("_LEXB_" global).")) D CKO
 D ET("Incorrect import global ^LEXM found.") D CKO
 Q
CU ;   Unable to verify
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP D ET(""),ET("Unable to verify checksum for import global ^LEXM (possibly corrupt).") D CKO
 Q
CF ;   Failed checksum
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP D ET("") D ET("Import global ^LEXM failed checksum.") D CKO
 Q
CO ;   Obtain new global
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP
 D ET(""),ET("    Please obtain a copy of the import global ^LEXM contained in the ")
 D ET(("    global host file "_LEXIGHF_" before continuing with the "_LEXBUILD))
 D ET(("    installation."))
 Q
CKO ;   Kill and Obtain new global
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP D ET("")
 D ET(("    Use the entry point KALL^LEXXGI2 to safely KILL the existing "))
 D ET(("    import global ^LEXM from your system.  Then obtain a new copy"))
 D ET(("    of ^LEXM contained in the global host file "_LEXIGHF_" before"))
 D ET(("    continuing with the "_LEXBUILD_" installation."))
 Q
IG ; Import Global
 D IMP Q:'$L($G(LEXBUILD))  Q:$D(^TMP("LEX*2.0*80",$J,"NODATA"))  N CT S CT=0
 D:+($G(^LEXM(80,0)))'>0 IGT("ICD Diagnosis data") D:+($G(^LEXM(80.1,0)))'>0 IGT("ICD Procedure data")
 D:+($G(^LEXM(757,0)))'>0 IGT("Lexicon Major Concept data") D:+($G(^LEXM(757.001,0)))'>0 IGT("Lexicon Frequency data")
 D:+($G(^LEXM(757.01,0)))'>0 IGT("Lexicon Expressions data") D:+($G(^LEXM(757.02,0)))'>0 IGT("Lexicon Code data")
 D:+($G(^LEXM(757.03,0)))'>0 IGT("Lexicon Coding System data") D:+($G(^LEXM(757.033,0)))'>0 IGT("Lexicon Coding Character data")
 D:+($G(^LEXM(757.1,0)))'>0 IGT("Lexicon Semantic Map data") D:+($G(^LEXM(757.2,0)))'>0 IGT("Lexicon Subset Definition data")
 D:+($G(^LEXM(757.3,0)))'>0 IGT("Lexicon Screen data") D:+($G(^LEXM(757.31,0)))'>0 IGT("Lexicon Display data")
 I $D(LEXE) D
 . N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP D ET("  ")
 . D ET(("Obtain a copy of the data import global ^LEXM contiained in"))
 . D ET(("the global host file "_LEXIGHF_" before continuing with"))
 . D ET(("the installation."))
 Q
IGT(X) ; Import Global Error Text
 N TXT S TXT=$G(X) Q:'$L(TXT)  S CT=+($G(CT))+1 D:CT=1 ET("Import Global ^LEXM Missing:"),ET("  ") D ET(("    "_TXT))
 Q
ET(X) ;   Error Text
 N LEXI S LEXI=+($G(LEXE(0))),LEXI=LEXI+1,LEXE(LEXI)="    "_$G(X),LEXE(0)=LEXI
 Q
ED ;   Error Display
 N LEXI S LEXI=0 F  S LEXI=$O(LEXE(LEXI)) Q:+LEXI=0  D M(LEXE(LEXI))
 D M(" ") K LEXE Q
NOTDEF(IEN) ;   Check to see if user is defined
 N DA,DR,DIQ,LEX,DIC S DA=IEN,DR=.01,DIC=200,DIQ="LEX" D EN^DIQ1 Q '$D(LEX)
OK ;   Environment is OK
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR,LEXT
 D IMP S LEXT="  Environment "_$S($L(LEXBUILD):("for patch/build "_LEXBUILD_" "),1:"")_"is ok"
 D BM(LEXT),M(" ")
 Q
MAIL ;   Mail global array in message
 N DIFROM,LEXPRI,LEXADR,LEXI,LEXM,LEXSUB,XCNP,XMDUZ,XMSCR,XMSUB,XMTEXT,XMY,XMZ
 N LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR D IMP Q:'$L(LEXBUILD)
 H:$D(^TMP("LEX*2.0*80",$J,"NODATA")) 2 K ^TMP("LEXMSG",$J) S LEXSUB="Lexicon/ICD-10 Installation"
 S:$L($G(LEXBUILD)) LEXSUB=$G(LEXBUILD)_" Installation" S LEXPRI=$$ADR G:'$L(LEXPRI) MAILQ
 S LEXPRI="G.LEXINS@"_LEXPRI S LEXADR=$$GET1^DIQ(200,+($G(DUZ)),.01) G:'$L(LEXADR) MAILQ
 S XMSUB=LEXSUB S LEXI=0 F  S LEXI=$O(^TMP("LEXKID",$J,LEXI)) Q:+LEXI=0  D
 . S LEXM=+($O(^TMP("LEXMSG",$J," "),-1))+1
 . S ^TMP("LEXMSG",$J,LEXM,0)=$E($G(^TMP("LEXKID",$J,LEXI)),1,79)
 . S ^TMP("LEXMSG",$J,0)=LEXM
 K ^TMP("LEXKID",$J) G:'$D(^TMP("LEXMSG",$J)) MAILQ
 G:+($G(^TMP("LEXMSG",$J,0)))'>0 MAILQ S XMY(LEXPRI)="",XMY(LEXADR)=""
 S XMTEXT="^TMP(""LEXMSG"",$J,",XMDUZ=.5 D ^XMD
MAILQ ;   Quit Mail
 D KILL K XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
 Q
ADR(LEX) ;   Mailing Address
 N DIC,DTOUT,DUOUT,X,Y S DIC="^DIC(4.2,",DIC(0)="M",(LEX,X)="FO-SLC.MED.VA.GOV" D ^DIC Q:+Y>0 LEX
 S DIC="^DIC(4.2,",DIC(0)="M",(LEX,X)="ISC-SLC.MED.VA.GOV" D ^DIC Q:+Y>0 LEX
 Q "ISC-SLC.VA.GOV"
KILL ;   Kill all ^TMP(
 K ^TMP("LEXMSG",$J),^TMP("LEXKID",$J)
 Q
INS(X) ;
 N LEX,LEXP,LEXV,LEXI S LEX=$G(X) I $L(LEX,"*")=3 S X=$$PATCH^XPDUTL(LEX) Q X
 S LEXP=$$PKG^XPDUTL(LEX),LEXV=$$VER^XPDUTL(LEX),LEXI=$$VERSION^XPDUTL(LEXP)
 Q:+LEXV>0&(LEXV=LEXI) 1
 Q 0
INSD(X) ;   Installed on
 N DA,LEX,LEXDA,LEXE,LEXI,LEXMSG,LEXNS,LEXOUT,LEXPI,LEXPN,LEXSCR,LEXVI,LEXVD,LEXVI,LEXVR S LEX=$G(X)
 S LEXNS=$$PKG^XPDUTL(LEX),LEXVR=$$VER^XPDUTL(LEX),LEXPN=$P(X,"*",3)
 Q:'$L(LEXNS) ""  S LEXVR=+LEXVR Q:LEXVR'>0 ""  S LEXPN=+LEXPN S:LEXVR'["." LEXVR=LEXVR_".0"
 S LEXSCR="I $G(^DIC(9.4,+($G(Y)),""VERSION""))="""_LEXVR_""""
 D FIND^DIC(9.4,,.01,"O",LEXNS,10,"C",LEXSCR,,"LEXOUT","LEXMSG")
 S LEXPI=$G(LEXOUT("DILIST",2,1)) K LEXOUT,LEXMSG Q:+LEXPI'>0 ""  Q:'$D(@("^DIC(9.4,"_LEXPI_",22)")) ""
 K DA S DA(1)=LEXPI S LEXDA=$$IENS^DILF(.DA)
 D FIND^DIC(9.49,LEXDA,".01;1I;2I","O",LEXVR,10,"B",,,"LEXOUT","LEXMSG")
 S LEXVD=$G(LEXOUT("DILIST","ID",1,2)) I $E(LEXVD,1,7)?7N&(+LEXPN'>0) D  Q X
 . S X=$E(LEXVD,1,7)_"^"_$TR($$FMTE^XLFDT($E(LEXVD,1,7),"5DZ"),"@"," ")
 S:$E(LEXVD,1,7)'?7N LEXVD=$G(LEXOUT("DILIST","ID",1,1)) I $E(LEXVD,1,7)?7N&(+LEXPN'>0) D  Q X
 . S X=$E(LEXVD,1,7)_"^"_$TR($$FMTE^XLFDT($E(LEXVD,1,7),"5DZ"),"@"," ")
 Q:+LEXPN'>0 ""  S LEXVI=$G(LEXOUT("DILIST",2,1)) K LEXOUT,LEXMSG
 Q:+LEXVI'>0 ""  Q:'$D(@("^DIC(9.4,"_LEXPI_",22,"_LEXVI_",""PAH"")")) ""
 K DA S DA(2)=LEXPI,DA(1)=LEXVI S LEXDA=$$IENS^DILF(.DA)
 S LEXSCR="I $G(^DIC(9.4,"_LEXPI_",22,"_LEXVI_",""PAH"",+($G(Y)),0))[""SEQ #"""
 D FIND^DIC(9.4901,LEXDA,".01;.02I",,LEXPN,10,"B",LEXSCR,,"LEXOUT","LEXMSG")
 S LEXI=$G(LEXOUT("DILIST","ID",1,.02)) I '$L(LEXI) D
 . S LEXSCR="" D FIND^DIC(9.4901,LEXDA,".01;.02I",,LEXPN,10,"B",LEXSCR,,"LEXOUT","LEXMSG")
 . S LEXI=$G(LEXOUT("DILIST","ID",1,.02))
 Q:'$L(LEXI) ""  Q:$P(LEXI,".",1)'?7N ""  S LEXE=$TR($$FMTE^XLFDT(LEXI,"5DZ"),"@"," ")
 Q:'$L(LEXE) ""  S X=LEXI_"^"_LEXE
 Q X
BM(X) ;   Blank Line with Message
 D BMES^XPDUTL($G(X)) Q
M(X) ;   Message
 D MES^XPDUTL($G(X)) Q
TRIM(X) ;   Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
IMP ;   Import names
 S LEXREQP(1)="LEX*2.0*25^3030924^CSV"
 S LEXREQP(2)="LEX*2.0*30^3041008^CTD"
 S LEXREQP(3)="LEX*2.0*62^3090506^Queries"
 S LEXREQP(4)="LEX*2.0*81^3120214^Fix Cross-Reference"
 ;S LEXREQP(5)="PSO*7.0*404^3120814^Global Read of ICD files"
 ;S LEXREQP(6)="ONC*2.11*56^3120927^Global Read of ICD files"
 ;S LEXREQP(7)="RA*5.0*112^3130417^Global Read of ICD files"
 S LEXREQP(5)="ICD*18.0*62^3130501^DRG Grouper Fixes"
 ;S LEXREQP(9)="GMPL*2.0*43^3130514^Global Read of ICD files"
 ;S LEXREQP(10)="TIU*1.0*267^3130514^Global Read of ICD files"
 S LEXREQP(6)="ICD*18.0*69^3130621^DRG Grouper Fixes"
 ;S LEXREQP(12)="DG*5.3*870^3130715^Global Read of ICD files"
 ;S LEXREQP(13)="IBD*3.0*64^3130903^Global Read of ICD files"
 ;S LEXREQP(14)="LR*5.2*429^3130918^Global Read of ICD files"
 ;S LEXREQP(15)="ACKQ*3.0*22^3131212^Global Read of ICD files"
 S LEXREQP(7)="LEX*2.0*94^3140114^FY14 2nd Qtr Update"
 S LEXPTYPE="ICD-10 Implementation",LEXLREV="80"
 S LEXBUILD="LEX*2.0*80",LEXIGHF="ICD_18_57.GBL",LEXFY="",LEXQTR=""
 Q
GD ;   Global Data
 ;;^LEX(757.01);^LEX(*;Lexicon;757-757.41
 ;;^ICD9(0);^ICD9(;ICD Diagnosis;80
 ;;^ICD0(0);^ICD0(;ICD Operation/Procedure;80.1
