ICD1857 ;ISL/KER - ICD*18.0*57 Env Check ;04/21/2014
 ;;18.0;DRG Grouper;**57**;Oct 20, 2000;Build 7
 ;               
 ;               
 ; Global Variables
 ;    ^%ZOSF("UCI")       ICR  10096
 ;    ^%ZOSF("UCICHECK")  ICR  10096
 ;    ^ICD0(1535)         N/A
 ;    ^ICD0(1548)         N/A
 ;    ^ICD0(366)          N/A
 ;    ^ICD9(11938)        N/A
 ;    ^ICD9(3066)         N/A
 ;    ^TMP("ICDKID")      SACC 2.3.2.5.1
 ;    ^TMP("ICDMSG")      SACC 2.3.2.5.1
 ;               
 ; External References
 ;    $$FMTE^XLFDT        ICR  10103
 ;    $$GET1^DIQ          ICR   2056
 ;    $$IENS^DILF         ICR   2054
 ;    $$NETNAME^XMXUTIL   ICR   2734
 ;    $$PATCH^XPDUTL      ICR  10141
 ;    $$PKG^XPDUTL        ICR  10141
 ;    $$VERSION^XPDUTL    ICR  10141
 ;    $$VER^XPDUTL        ICR  10141
 ;    BMES^XPDUTL         ICR  10141
 ;    EN^DIQ1             ICR  10015
 ;    FIELD^DID           ICR   2052
 ;    FILE^DID            ICR   2052
 ;    FIND^DIC            ICR   2051
 ;    BMES^XPDUTL         ICR  10141
 ;    FIND^DIC            ICR   2051
 ;    ^DIR                ICR  10026
 ;    ^XMD                ICR  10070
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     XPDABORT,XPDDIQ,XPDENV,XPDQUIT
 ;               
ENV ; ICD*18.0*57 Environment Check
 ;   Checks
 S XPDNOQUE=1 N DA,DIC,DIFROM,DIQ,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,ICD,ICD10,ICD9,ICDADR,ICDATA,ICDBUILD,ICDC,ICDC1,ICDC2,ICDC3
 N ICDC4,ICDCOM,ICDCONT,ICDD,ICDDA,ICDDD,ICDDT,ICDE,ICDENT,ICDF,ICDFI,ICDFULL,ICDFY,ICDG,ICDGBL,ICDI,ICDIEN,ICDIGHF
 N ICDINE,ICDINS,ICDLREV,ICDM,ICDMSG,ICDNM,ICDNS,ICDO,ICDOUT,ICDP,ICDPAT,ICDPI,ICDPK,ICDPN,ICDPRI,ICDPT,ICDPTYPE
 N ICDQTR,ICDR,ICDREL,ICDREQ,ICDREQP,ICDRT,ICDRV,ICDSCR,ICDSTR,ICDSUB,ICDT,ICDUCI,ICDV,ICDVD,ICDVI,ICDVER,ICDVR
 N IEN,X,XCNP,XMDUZ,XMSCR,XMSUB,XMTEXT,XMY,XMZ,Y D IMP K XPDDIQ("XPZ1","B"),XPDDIQ("XPI1","B")
 S XPDDIQ("XPZ1","B")="NO",XPDDIQ("XPI1","B")="NO",U="^"
 ;     User Variables
 D:+($$UR)'>0 ET("User not defined (DUZ)")
 ;     System Variables
 D:+($$SY)'>0 ET("Undefined IO variable(s)")
 ;     Data
 N ICDTEST D:+($$GOK)'>0 ET("Cannot locate import data global ^LEXM")
 I $D(ICDE) D ABRT Q
 ;     Version Number
 W !,?3,"Checking for ICD Version installations",!
 S ICDVER="ICD 18.0" S ICDINS=$$VER(ICDVER) I +ICDINS'>0 D  D ABRT Q
 . D ET(" Version 18.0 not found.  Please install ICD v 18.0")
 I +ICDINS>0,$P(ICDINS,"^",1)?7N,$L($P(ICDINS,"^",2)) D
 . W !,?5,ICDVER," installed ",$P(ICDINS,"^",2)
 S ICDVER="ICD*18.0*57" S ICDINS=$$VER(ICDVER)
 I +ICDINS>0,$P(ICDINS,"^",1)?7N,$L($P(ICDINS,"^",2)) D
 . W !,?5,ICDVER," installed ",$P(ICDINS,"^",2)
 ;     Required Patches
 D:$O(ICDREQP(0))'>0 IMP I $O(ICDREQP(0))>0 D
 . W ! N ICDPAT,ICDI,ICDPN,ICDP,ICDR,ICDC,ICDO,ICDC1,ICDC2,ICDC3,ICDC4,ICD
 . S (ICDR,ICDC)=0 S ICDC1=3,(ICDC2,ICDC3,ICDC4)=20,ICDC2=18
 . S ICDI=0  F  S ICDI=$O(ICDREQP(ICDI)) Q:+ICDI'>0  D
 . . S ICDC=ICDC+1,ICDPAT=$G(ICDREQP(ICDI))
 . . S:$P(ICDPAT,"^",2)?7N ICDR=ICDR+1,ICDC3=ICDC2+13,ICDC4=ICDC2+36
 . S ICDI=0  F  S ICDI=$O(ICDREQP(ICDI)) Q:+ICDI'>0  D
 . . N ICDPAT,ICDREL,ICDINS,ICDCOM,ICDINE,ICDREQ S ICDREQ=$G(ICDREQP(ICDI))
 . . S ICDPAT=$P(ICDREQ,"^",1),ICDREL=$P(ICDREQ,"^",2),ICDCOM=$P(ICDREQ,"^",3)
 . . S ICDPN=$$INS(ICDPAT) S ICDINS=$$INSD(ICDPAT),ICDINE=$P(ICDINS,"^",2)
 . . W:ICDI=1 !,?3,"Checking for ",?ICDC2,$S(+($G(ICDR))>0:"Released",1:"")
 . . W !,?ICDC1,ICDPAT
 . . W:ICDREL?7N ?ICDC2,$TR($$FMTE^XLFDT(ICDREL,"5DZ"),"@"," ")
 . . I +ICDPN>0 D
 . . . S ICDO=+($G(ICDO))+1 W ?ICDC3,"Installed " W:$L($G(ICDINE)) ICDINE
 . . . W:+ICDC4>0&(+ICDC4>ICDC3)&($L(ICDCOM)) ?ICDC4,ICDCOM
 . . I +ICDPN'>0 D ET((" "_ICDPAT_" not found, please install "_ICDPAT_" before continuing"))
 . W:+($G(ICDO))'=ICDC !
 ;     UCI
 I +($$UOK)'>0&('$D(ICDTEST)) W ! D ET("Unable to install in this UCI") G ABRT
 D STATUS S ICDCONT=$$CONT I +ICDCONT'>0 W ! D ET(" User aborted install") G ABRT
 I $D(ICDE) D ABRT Q
 I '$D(ICDFULL)&(+($G(XPDENV))'=1) D QUIT Q
 ;   Quit, Exit or Abort
QUIT ;     Quit   Passed Environment Check
 K ICDFULL D OK
 Q
EXIT ;     Exit   Failed Environment Check
 D:$D(ICDE) ED S XPDQUIT=2 K ICDE,ICDFULL Q
ABRT ;     Abort  Failed Environment Check, KILL the distribution
 D:$D(ICDE) ED S XPDABORT=1,XPDQUIT=1,XPDQUIT("ICD*18.0*57")=1,XPDQUIT("LEX*2.0*80")=1
 K ICDE,ICDFULL
 Q
SY(X) ;   Check System variables
 Q:'$D(IO)!('$D(IOF))!('$D(IOM))!('$D(ION))!('$D(IOSL))!('$D(IOST)) 0
 Q 1
UR(X) ;   Check User variables
 Q:'$L($G(DUZ(0))) 0
 Q:+($G(DUZ))=0!($$NOTDEF(+$G(DUZ))) 0
 Q 1
ET(X) ;   Error Text
 N ICDI S ICDI=+($G(ICDE(0))),ICDI=ICDI+1,ICDE(ICDI)="    "_$G(X),ICDE(0)=ICDI
 Q
ED ;   Error Display
 N ICDI S ICDI=0 F  S ICDI=$O(ICDE(ICDI)) Q:+ICDI=0  D M(ICDE(ICDI))
 D M(" ") K ICDE Q
NOTDEF(X) ;   Check to see if user is defined
 N DA,DR,DIQ,ICD,DIC S DA=+($G(X)),DR=.01,DIC=200,DIQ="ICD" D EN^DIQ1 Q '$D(ICD)
OK ;   Environment is OK
 N ICDPTYPE,ICDLREV,ICDREQP,ICDBUILD,ICDIGHF,ICDFY,ICDQTR,ICDT
 D IMP S ICDT="  Environment "_$S($L(ICDBUILD):("for patch/build "_ICDBUILD_" "),1:"")_"is ok"
 D BM(ICDT),M(" ")
 Q
MAIL ;   Mail global array in message
 N DIFROM,ICDPRI,ICDADR,ICDI,ICDM,ICDSUB,XCNP,XMDUZ,XMSCR,XMSUB,XMTEXT,XMY,XMZ,ICDPTYPE,ICDLREV,ICDREQP,ICDBUILD,ICDIGHF,ICDFY,ICDQTR
 D IMP K ^TMP("ICDMSG",$J) S ICDSUB="Lexicon/ICD-10 Installation" S:$L($G(ICDBUILD)) ICDSUB=$G(ICDBUILD)_" Installation"
 S ICDPRI=$$ADR G:'$L(ICDPRI) MAILQ S ICDPRI="G.ICDINS@"_ICDPRI S ICDADR=$$GET1^DIQ(200,+($G(DUZ)),.01) G:'$L(ICDADR) MAILQ
 S XMSUB=ICDSUB S ICDI=0 F  S ICDI=$O(^TMP("ICDKID",$J,ICDI)) Q:+ICDI=0  D
 . S ICDM=+($O(^TMP("ICDMSG",$J," "),-1))+1,^TMP("ICDMSG",$J,ICDM,0)=$E($G(^TMP("ICDKID",$J,ICDI)),1,79),^TMP("ICDMSG",$J,0)=ICDM
 K ^TMP("ICDKID",$J) G:'$D(^TMP("ICDMSG",$J)) MAILQ G:+($G(^TMP("ICDMSG",$J,0)))'>0 MAILQ S XMY(ICDPRI)="",XMY(ICDADR)=""
 S XMTEXT="^TMP(""ICDMSG"",$J,",XMDUZ=.5 D ^XMD
MAILQ ;   Quit Mail
 D KILL K XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
 Q
ADR(ICD) ;   Mailing Address
 N DIC,DTOUT,DUOUT,X,Y S DIC="^DIC(4.2,",DIC(0)="M",(ICD,X)="FO-SLC.MED.VA.GOV" D ^DIC Q:+Y>0 ICD
 S DIC="^DIC(4.2,",DIC(0)="M",(ICD,X)="ISC-SLC.MED.VA.GOV" D ^DIC Q:+Y>0 ICD
 Q "ISC-SLC.VA.GOV"
KILL ;   Kill all ^TMP(
 K ^TMP("ICDMSG",$J),^TMP("ICDKID",$J)
 Q
CONT(X) ; Continue
 N DIR,DIRUT,DIROUT,DTOUT,DUOUT,Y
 W !!,"   WARNING    WARNING    WARNING    WARNING    WARNING    WARNING    WARNING",!
 W !,"   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
 W !,"   *                                                                       *"
 W !,"   *  This Install will delete both the ICD-9 Data Dictionary and data in  *"
 W !,"   *  files #80 and #80.1.  It will then install a new Data Dictionary     *"
 W !,"   *  for files #80 and #80.1.  The new Data Dictionary will accommodate   *"
 W !,"   *  both the ICD-9 and ICD-10 coding systems.  The new data will be      *"
 W !,"   *  installed by the accompanying Lexicon patch LEX*2.0*80.  These       *"
 W !,"   *  changes will affect this namespace and any other namespace that      *"
 W !,"   *  the ^ICD9 and ^ICD0 globals are mapped to.  If your current          *"
 W !,"   *  namespace is mapped to another namespace, make sure the other        *"
 W !,"   *  namespace is also scheduled to be updated by this patch before       *"
 W !,"   *  continuing.                                                          *"
 W !,"   *                                                                       *"
 W !,"   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
 S DIR(0)="YAO",DIR("A")="   Do you wish to continue?  (Y/N)  "
 S DIR("PRE")="S:X[""?"" X=""??""" S (DIR("?"),DIR("??"))="^D CONTH^ICD1857"
 W ! D ^DIR S (X,Y)=+($G(Y)) S:Y'>0 XPDABORT=1,XPDQUIT=1,XPDQUIT("ICD*18.0*57")=1,XPDQUIT("LEX*2.0*80")=1
 Q X
CONTH ;   Continue Help
 W !,?5,"Answering 'Yes' will:",!
 W !,?7,"1)  Delete the Data Dictionaries and the data for the following:",!
 W !,?11,"ICD DIAGNOSIS            file #80      ^ICD9("
 W !,?11,"ICD OPERATION/PROCEDURE  file #80.1    ^ICD0(",!
 W !,?7,"2)  Install the new joint ICD-9/10 Data Dictionaries."
 W !,?7,"3)  Update legacy ICD-9 APIs and install new ICD-9/10 APIs."
 W !,?7,"4)  Populate files #80 and #80.1 with ICD-9/10 data (LEX*2.0*80)",!
 W !,?7,"      This affects the current namespace and any "
 W !,?7,"      namespace that the Data Dictionary and files"
 W !,?7,"      #80 and file #80.1 are mapped to.",!
 W !,?5,"Answering 'No' will abort the installation of this patch"
 Q
UOK(X) ; UCI Ok for Install
 N X,Y S X=$$NETNAME^XMXUTIL(.5) Q:X["LEXDEV1.FO-BAYPINES" 1
 X ^%ZOSF("UCI") Q:$G(Y)["LEXDEV1" 1
 Q 1
GOK(X) ; Input Global Ok for Install
 Q:$D(^TMP("LEX*2.0*80",$J,"NODATA")) 1
 N ND,OK S OK=1 F ND="^LEXM","^LEXM(80)","^LEXM(80.1)","^LEXM(80.4)" S:'$D(@ND) OK=0
 S ND="^LEXM(0,""BUILD"")" S:$G(@ND)'="LEX*2.0*80" OK=0
 S X=OK
 Q X
VER(X) ;
 N DA,ICD,ICDDA,ICDE,ICDI,ICDMSG,ICDNS,ICDOUT,ICDPI,ICDPN,ICDSCR,ICDVI,ICDVD,ICDVI,ICDVR S ICD=$G(X)
 S ICDNS=$$PKG^XPDUTL(ICD),ICDVR=$$VER^XPDUTL(ICD),ICDPN=$P(X,"*",3)
 Q:'$L(ICDNS) 0  S ICDVR=+ICDVR Q:ICDVR'>0 0  S ICDPN=+ICDPN S:ICDVR'["." ICDVR=ICDVR_".0"
 D FIND^DIC(9.4,,.01,"O",ICDNS,10,"C",,,"ICDOUT","ICDMSG") S ICDPI=$G(ICDOUT("DILIST",2,1))
 K ICDOUT,ICDMSG Q:+ICDPI'>0 0  Q:'$D(@("^DIC(9.4,"_ICDPI_",22)")) 0
 K DA S DA(1)=ICDPI S ICDDA=$$IENS^DILF(.DA)
 D FIND^DIC(9.49,ICDDA,".01;1I;2I","O",ICDVR,10,"B",,,"ICDOUT","ICDMSG")
 S ICDVD=$G(ICDOUT("DILIST","ID",1,2)) I $E(ICDVD,1,7)?7N&(+ICDPN'>0) D  Q X
 . S X=$E(ICDVD,1,7)_"^"_$TR($$FMTE^XLFDT($E(ICDVD,1,7),"5DZ"),"@"," ")
 S:$E(ICDVD,1,7)'?7N ICDVD=$G(ICDOUT("DILIST","ID",1,1)) I $E(ICDVD,1,7)?7N&(+ICDPN'>0) D  Q X
 . S X=$E(ICDVD,1,7)_"^"_$TR($$FMTE^XLFDT($E(ICDVD,1,7),"5DZ"),"@"," ")
 Q:+ICDPN'>0 0  S ICDVI=$G(ICDOUT("DILIST",2,1)) K ICDOUT,ICDMSG
 Q 0
INS(X) ;
 N ICD,ICDP,ICDV,ICDI S ICD=$G(X) I $L(ICD,"*")=3 S X=$$PATCH^XPDUTL(ICD) Q X
 S ICDP=$$PKG^XPDUTL(ICD),ICDV=$$VER^XPDUTL(ICD),ICDI=$$VERSION^XPDUTL(ICDP)
 Q:+ICDV>0&(ICDV=ICDI) 1
 Q 0
INSD(X) ;   Installed on
 N DA,ICD,ICDDA,ICDE,ICDI,ICDMSG,ICDNS,ICDOUT,ICDPI,ICDPN,ICDSCR,ICDVI,ICDVD,ICDVI,ICDVR S ICD=$G(X)
 S ICDNS=$$PKG^XPDUTL(ICD),ICDVR=$$VER^XPDUTL(ICD),ICDPN=$P(X,"*",3)
 Q:'$L(ICDNS) 0  S ICDVR=+ICDVR Q:ICDVR'>0 0  S ICDPN=+ICDPN S:ICDVR'["." ICDVR=ICDVR_".0"
 D FIND^DIC(9.4,,.01,"O",ICDNS,10,"C",,,"ICDOUT","ICDMSG") S ICDPI=$G(ICDOUT("DILIST",2,1))
 K ICDOUT,ICDMSG Q:+ICDPI'>0 0  Q:'$D(@("^DIC(9.4,"_ICDPI_",22)")) 0
 K DA S DA(1)=ICDPI S ICDDA=$$IENS^DILF(.DA)
 D FIND^DIC(9.49,ICDDA,".01;1I;2I","O",ICDVR,10,"B",,,"ICDOUT","ICDMSG")
 S ICDVD=$G(ICDOUT("DILIST","ID",1,2)) I $E(ICDVD,1,7)?7N&(+ICDPN'>0) D  Q X
 . S X=$E(ICDVD,1,7)_"^"_$TR($$FMTE^XLFDT($E(ICDVD,1,7),"5DZ"),"@"," ")
 S:$E(ICDVD,1,7)'?7N ICDVD=$G(ICDOUT("DILIST","ID",1,1)) I $E(ICDVD,1,7)?7N&(+ICDPN'>0) D  Q X
 . S X=$E(ICDVD,1,7)_"^"_$TR($$FMTE^XLFDT($E(ICDVD,1,7),"5DZ"),"@"," ")
 Q:+ICDPN'>0 0  S ICDVI=$G(ICDOUT("DILIST",2,1)) K ICDOUT,ICDMSG
 Q:+ICDVI'>0 ""  Q:'$D(@("^DIC(9.4,"_ICDPI_",22,"_ICDVI_",""PAH"")")) ""
 K DA S DA(2)=ICDPI,DA(1)=ICDVI S ICDDA=$$IENS^DILF(.DA)
 S ICDSCR="I $G(^DIC(9.4,"_ICDPI_",22,"_ICDVI_",""PAH"",+($G(Y)),0))[""SEQ #"""
 D FIND^DIC(9.4901,ICDDA,".01;.02I",,ICDPN,10,"B",ICDSCR,,"ICDOUT","ICDMSG")
 S ICDI=$G(ICDOUT("DILIST","ID",1,.02)) I '$L(ICDI) D
 . S ICDSCR="" D FIND^DIC(9.4901,ICDDA,".01;.02I",,ICDPN,10,"B",ICDSCR,,"ICDOUT","ICDMSG")
 . S ICDI=$G(ICDOUT("DILIST","ID",1,.02))
 Q:'$L(ICDI) ""  Q:$P(ICDI,".",1)'?7N ""  S ICDE=$TR($$FMTE^XLFDT(ICDI,"5DZ"),"@"," ")
 Q:'$L(ICDE) ""  S X=ICDI_"^"_ICDE
 Q X
IMP ;   Import names
 S ICDREQP(1)="ICD*18.0*6^3030924^CSV"
 S ICDREQP(2)="ICD*18.0*12^3041008^CTD"
 S ICDREQP(3)="ICD*18.0*15^3050609^Legacy APIs"
 S ICDREQP(4)="ICD*18.0*29^3071115^Legacy APIs"
 S ICDREQP(5)="LEX*2.0*81^3120214^Fix Cross-Reference"
 ;S ICDREQP(6)="PSO*7.0*404^3120814^Global Read of ICD files"
 ;S ICDREQP(7)="ONC*2.11*56^3120927^Global Read of ICD files"
 ;S ICDREQP(8)="RA*5.0*112^3130417^Global Read of ICD files"
 S ICDREQP(6)="ICD*18.0*62^3130501^DRG Grouper Fixes"
 ;S ICDREQP(10)="GMPL*2.0*43^3130514^Global Read of ICD files"
 ;S ICDREQP(11)="TIU*1.0*267^3130514^Global Read of ICD files"
 S ICDREQP(7)="ICD*18.0*69^3130621^DRG Grouper Fixes"
 ;S ICDREQP(13)="DG*5.3*870^3130715^Global Read of ICD files"
 ;S ICDREQP(14)="IBD*3.0*64^3130903^Global Read of ICD files"
 ;S ICDREQP(15)="LR*5.2*429^3130918^Global Read of ICD files"
 ;S ICDREQP(16)="ACKQ*3.0*22^3131212^Global Read of ICD files"
 ;S ICDREQP(17)="LEX*2.0*94^3140114^FY14 2nd Qtr Update"
 S ICDPTYPE="ICD-10 Implementation",ICDLREV=""
 S ICDBUILD="ICD*18.0*57",ICDIGHF="",ICDFY="",ICDQTR=""
 Q
STATUS ; ICD-9/10 Status in files 80/80.1
 N ICD10,ICD9,ICDATA,ICDD,ICDDT,ICDENT,ICDF,ICDFI,ICDIEN,ICDM,ICDNM,ICDNS,ICDPK,ICDPT,ICDRT,ICDRV,ICDUCI,ICDVR,ICDT,ICDX,X,Y
 K ICDDD,ICDGBL X ^%ZOSF("UCI") S (ICDNS,ICDUCI)=Y S:ICDNS[","&($L($P(Y,",",1))) ICDNS=$P(Y,",",1)
 S ICDX="   Checking "_$S($L(ICDNS):(ICDNS_" "),1:"")_"ICD Data Dictionary/Global/Data Status:" D BM(ICDX)
 D FIELD^DID(80.066,60,"N","LABEL","ICD9","ICDM")
 D FIELD^DID(80.012,.01,"N","LABEL","ICD10","ICDM")
 D BM("     Data Dictionary:"),M(" ")
 D:'$D(ICD9) M("       Legacy ICD Data Dictionary does not exist")
 D:$D(ICD9) M("       Remnants of the legacy ICD Data Dictionary found") S:$D(ICD9) ICDDD(1)=""
 D:'$D(ICD10) M("       ICD-9/ICD-10 Data Dictionary does not exist") S:'$D(ICD10) ICDDD(2)=""
 D:$D(ICD10) M("       ICD-9/ICD-10 Data Dictionary found")
 D BM("     Global:"),M(" ")
 F ICDT=80,80.1 D
 . D FILE^DID(ICDT,"N","DATE;GLOBAL NAME;NAME;PACKAGE REVISION DATA;VERSION;LOOKUP PROGRAM","ICDF","ICDM")
 . N ICDRT,ICDFI,ICDNM,ICDVR,ICDPK,ICDRV,ICDDT,ICDPT,ICDIEN,ICDENT S ICDRT=$G(ICDF("GLOBAL NAME"))
 . S ICDRT=ICDRT_$J(" ",(8-$L(ICDRT))) S ICDFI=$G(ICDT),ICDFI=ICDFI_$J(" ",(6-$L(ICDFI)))
 . S ICDNM=$G(ICDF("NAME")),ICDNM=ICDNM_$J(" ",(25-$L(ICDNM))),ICDVR=$G(ICDF("VERSION")) S:+ICDVR'>0 ICDVR="18.0"
 . S ICDPK="ICD",ICDRV=$G(ICDF("PACKAGE REVISION DATA")),ICDDT=$P(ICDRV,"^",2),ICDRV=$P(ICDRV,"^",1)
 . S ICDPT="" S:$L(ICDPK)&(+($G(ICDVR))>0)&(+($G(ICDRV))>0) ICDPT=ICDPK_"*"_ICDVR_"*"_ICDRV
 . S ICDPT=ICDPT_$J(" ",(13-$L(ICDPT))),ICDDT=$S(ICDDT?7N:$TR($$FMTE^XLFDT(ICDDT,"5DZ"),"@"," "),1:"")
 . S ICDDT=ICDDT_$J(" ",(12-$L(ICDDT)))
 . D:ICDT=80 M("       Global Name              #     Root    Patched      Updated")
 . D M(("       "_ICDNM_ICDFI_ICDRT_ICDPT_ICDDT))
 D BM("     Data:") I '$D(^ICD9(3066,"DRG"))&('$D(^ICD9(11938,66,3,"DRG")))&($L($G(^ICD9(3066,0)),"^")'>1) S ICDATA(80,9)="No "
 I $D(^ICD9(3066,"DRG"))!($D(^ICD9(11938,66,3,"DRG")))!($L($G(^ICD9(3066,0)),"^")>1) S ICDGBL(1)="",ICDATA(80,9)="Yes"
 I '$D(^ICD9(3066,7,1,0)) S ICDGBL(2)="",ICDATA(80,10)="No "
 I $D(^ICD9(3066,7,1,0)) S ICDATA(80,10)="Yes"
 I '$D(^ICD0(366,"MDC"))&($L($G(^ICD0(1535,0)),"^")'>1) S ICDATA(80.1,9)="No "
 I $D(^ICD0(366,"MDC"))!($L($G(^ICD0(1535,0)),"^")>1) S ICDGBL(1)="",ICDATA(80.1,9)="Yes"
 I '$D(^ICD0(1548,3,1,0))&($L($G(^ICD0(1548,1)),"^")'>1) S ICDGBL(2)="",ICDATA(80.1,10)="No "
 I $D(^ICD0(1548,3,1,0))&($L($G(^ICD0(1548,1)),"^")>1) S ICDATA(80.1,10)="Yes"
 S ICDX="       ",ICDX=ICDX_$J(" ",(32-$L(ICDX)))_"Legacy ICD-9"
 S ICDX=ICDX_$J(" ",(50-$L(ICDX)))_"Updated ICD-10" D M(ICDX)
 S ICDX="       Data Type         ",ICDX=ICDX_$J(" ",(32-$L(ICDX)))_"Data Format"
 S ICDX=ICDX_$J(" ",(50-$L(ICDX)))_"Data Format" D M(ICDX)
 S ICDX="       ICD Diagnosis Data",ICDX=ICDX_$J(" ",(37-$L(ICDX)))_$G(ICDATA(80,9))
 S ICDX=ICDX_$J(" ",(55-$L(ICDX)))_$G(ICDATA(80,10)) D M(ICDX)
 S ICDX="       ICD Procedure Data",ICDX=ICDX_$J(" ",(37-$L(ICDX)))_$G(ICDATA(80.1,9))
 S ICDX=ICDX_$J(" ",(55-$L(ICDX)))_$G(ICDATA(80.1,10)) D M(ICDX)
 Q
M(X) ;   Blank/Text
 D MES^XPDUTL($G(X)) Q
BM(X) ;   Blank/Text
 D BMES^XPDUTL($G(X)) Q
TRIM(X) ;   Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
