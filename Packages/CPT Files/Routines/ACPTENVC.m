ACPTENVC ; IHS/SD/SDR - Environment checker for ACPT V2.10 ;4/21/08  14:11
 ;;2.10;CPT FILES;;DEC 18, 2009
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM),!
 ;
 S XPDQUIT=0,ACPTQUIT=0
 I '$$VCHK("XU","8",2)
 I '$$VCHK("XT","7.3",2)
 I '$$VCHK("DI","21",2)
 I '$$VCHK("ACPT","2.09",2) S XPDQUIT=2
 ;
 NEW DA,DIC
 S X="ACPT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ACPT")) D  S XPDQUIT=2
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ACPT"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 .Q
 ;
 I XPDQUIT D SORRY(XPDQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(ACPTPRE,ACPTVER,ACPTQUIT) ; Check versions needed.
 ;  
 NEW ACPTV
 S ACPTV=$$VERSION^XPDUTL(ACPTPRE)
 W !,$$CJ^XLFSTR("Need at least "_ACPTPRE_" v "_ACPTVER_"....."_ACPTPRE_" v "_ACPTV_" Present",IOM)
 I ACPTV<ACPTVER S XPDQUIT=ACPTQUIT W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
INSTALLD(ACPTINST) ;EP - Determine if patch ACPTINST was installed, where ACPTINST is
 ; the name of the INSTALL.  E.g "AG*6.0*10".
 ;;^DIC(9.4,D0,22,D1,PAH,D2,0)=
 ;;(#.01) PATCH APPLICATION HISTORY [1F] ^ (#.02)DATE APPLIED [2D] ^ (#.03) APPLIED BY [3P] ^ 
 NEW DIC,X,Y
 S X=$P(ACPTINST,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(ACPTINST,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACPTINST,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;
POST1(ACPTDIR) ; input transform for KIDS question POST1
 ;
 ; .ACPTDIR, passed by reference, is X from the Fileman Reader, the
 ; input to this input transform.
 ;
 I $ZV["UNIX" D  ; if unix, ensure proper syntax for unix
 .S ACPTDIR=$TR(ACPTDIR,"\","/") ; forward slash should delimit
 .S:$E(ACPTDIR)'="/" ACPTDIR="/"_ACPTDIR ; start with root (/)
 .S:$E(ACPTDIR,$L(ACPTDIR))'="/" ACPTDIR=ACPTDIR_"/" ; ensure trailing /
 ;
 E  D  ; otherwise, ensure proper syntax for other operating systems
 .S ACPTDIR=$TR(ACPTDIR,"/","\") ; back slash should delimit
 .I $E(ACPTDIR)'="\",ACPTDIR'[":" D
 ..S ACPTDIR="\"_ACPTDIR ; start with \ if not using : (?)
 .S:$E(ACPTDIR,$L(ACPTDIR))'="\" ACPTDIR=ACPTDIR_"\" ; ensure trailing \
 ;
 W !!,"Checking directory ",ACPTDIR,"..."
 ;
 N ACPTFIND S ACPTFIND=0 ; do we find our files in that directory?
 D  ; find out whether that directory contains those files
 .N ACPTFILE
 .S ACPTFILE("acpt2010.9l")=""
 .S ACPTFILE("acpt2010.9h")=""
 .S ACPTFILE("acpt2010.9d")=""
 .S ACPTFILE("acpt2010.l")=""
 .S ACPTFILE("acpt2010.d")=""
 .N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTFIND")
 .D  Q:ACPTFIND  ; format for most platforms:
 ..K ACPTQUIT
 ..I ($$VERSION^XPDUTL("BCSV")>0) D  Q:($G(ACPTQUIT)=1)
 ...I ('$D(ACPTFIND("acpt2010.9l"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.9l")))) S ACPTQUIT=1
 ...I ('$D(ACPTFIND("acpt2010.9h"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.9h")))) S ACPTQUIT=1
 ...I ('$D(ACPTFIND("acpt2010.9d"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.9d")))) S ACPTQUIT=1
 ...I ('$D(ACPTFIND("acpt2010.l"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.l")))) S ACPTQUIT=1
 ...I ('$D(ACPTFIND("acpt2010.d"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.d")))) S ACPTQUIT=1
 ..I ($$VERSION^XPDUTL("BCSV")<1) D  Q:($G(ACPTQUIT)=1)
 ..I ('$D(ACPTFIND("acpt2010.l"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.l")))) S ACPTQUIT=1
 ..I ('$D(ACPTFIND("acpt2010.d"))&('$D(ACPTFIND(ACPTDIR_"acpt2010.d")))) S ACPTQUIT=1
 ..I $G(ACPTQUIT)'=1 S ACPTFIND=1
 .;D  ; format for Cache on UNIX
 ..;Q:('$D(ACPTFIND("acpt2010.9l"))!'$D(ACPTFIND("acpt2010.9h"))!'$D(ACPTFIND("acpt2010.9d"))!'$D(ACPTFIND("acpt2010.l"))!'$D(ACPTFIND("acpt2010.d")))&($$VERSION^XPDUTL("BCSV")>0)
 ..;Q:('$D(ACPTFIND("acpt2010.l"))!'$D(ACPTFIND("acpt2010.d")))&($$VERSION^XPDUTL("BCSV")<1)
 ..;S ACPTFIND=1
 ;
 I $$VERSION^XPDUTL("BCSV")>0 D
 .I $D(ACPTFIND("acpt2010.9l"))!$D(ACPTFIND(ACPTDIR_"acpt2010.9l")) D
 ..W !,"CPT Description file acpt2010.9l found."
 .I $D(ACPTFIND("acpt2010.9d"))!$D(ACPTFIND(ACPTDIR_"acpt2010.9d")) D
 ..W !,"CPT delete file acpt2010.9d found."
 .I $D(ACPTFIND("acpt2010.9h"))!$D(ACPTFIND(ACPTDIR_"acpt2010.9h")) D
 ..W !,"HCPCS file acpt2010.9h found."
 ;
 I $D(ACPTFIND("acpt2010.l"))!$D(ACPTFIND(ACPTDIR_"acpt2010.l")) D
 .W !,"CPT Description file acpt2010.l found."
 I $D(ACPTFIND("acpt2010.d"))!$D(ACPTFIND(ACPTDIR_"acpt2010.d")) D
 .W !,"CPT delete file acpt2010.d found."
 ;
 I ACPTFIND D  Q  ; if they picked a valid directory
 .W !!,"Thank you. The file is in that directory."
 .W !,"Proceeding with the install of ACPT*2.10."
 ;
 I 'ACPTFIND D
 .W !!,"I'm sorry, but that cannot be correct."
 .W !,"Directory ",ACPTDIR," does not contain that file."
 .;
 .D
 ..N ACPTFILE S ACPTFILE("*")=""
 ..N ACPTLIST
 ..N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTLIST")
 ..W !!,"Directory ",ACPTDIR," contains the following file:"
 ..N ACPTF S ACPTF="" F  S ACPTF=$O(ACPTLIST(ACPTF)) Q:ACPTF=""  D
 ...W !?5,ACPTF
 .;
 .W !!,"Please select a directory that contains the CPT file."
 .K ACPTDIR
 ;
 Q
