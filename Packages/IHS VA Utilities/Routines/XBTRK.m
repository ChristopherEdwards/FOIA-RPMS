XBTRK ;IHS/ASDST/GTH - GET SITE PACKAGE INFO ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; IHS/SET/GTH XB*3*9 10/29/2002
 ;
 ; Thanks to Don Jackson and Carlos Cordova for the original routine.
 ;                June 6, 2001.
 ;
 ; This routine counts the number of patched routines in each namespace
 ; in each entry in the PACKAGE file, and, if run in foreground, only
 ; delivers a mail message with the results to all local programmers.
 ;  
 ; If Q'd thru option "XB PACKAGE TRACKING", in addition to the mail
 ; message getting generated, a file is sent to the system id(s)
 ; specified on the 2nd page of the TaskMan option scheduling function,
 ; with the id(s) set into variable XBSYSID(n), where "n" is a numeric
 ; subscript.
 ; 
 ; The option, "XB PACKAGE TRACKING", is recommended to run every 30
 ; days, and is atch'd to the Site Manager's menu, "XUSITEMGR", as a
 ; protection against deletion by the Kernel's dangling-option cleanup
 ; process.
 ;
 ; The format of the data global transmitted to the System(s) is:
 ;         CV^namespace^name^version^#routines^patch
 ; where "CV" means "Current Version" on that machine.  If the
 ; first piece is "PV", the info on that node means the the version
 ; of the routines was a "Previous Version".  This assumes there are
 ; no 'future' versions.
 ;
START ;EP - From TaskMan.
 ;
 I '$D(ZTQUEUED) D  Q:'$$DIR^XBDIR("Y","Proceed","N",$S($G(DTIME):DTIME,1:300),"If you answer 'Y', we'll go ahead and run this")  W !
 . D ^XBKVAR
 . S ^UTILITY($J,"XBTRK")=""
 . D EN^XBRPTL
 .Q
 ;
 KILL ^XBPKDATA ; KILL of unsubscripted work global.
 KILL ^TMP("XBTRK",$J),^TMP("XBTRK XMD",$J)
 ;
 ; Process every entry in the PACKAGE file that has a PREFIX value.
 ;
 NEW XBI,XBN
 S XBI=0
 F  S XBI=$O(^DIC(9.4,XBI)) Q:'XBI  D
 . S XBN=$P($G(^DIC(9.4,XBI,0)),U,2)
 . Q:XBN=""
 . W:'$D(ZTQUEUED) XBN,$J("",8-$L(XBN))
 . D:$$RSEL^ZIBRSEL(XBN_"*") ONEP(XBN)
 .Q
 ;
 ; SET info ^TMP("XBTRK",$J,namespace,version,patch) into ^XBPKDATA.
 ; "CV"=Current Version;  "PV"=Previous Version.
 ;
 S (C,N)=""
 ;
 F  S N=$O(^TMP("XBTRK",$J,N)) Q:(N="")  S V="" D
 . F  S V=$O(^TMP("XBTRK",$J,N,V)) Q:(V="")  S P="" D
 .. F  S P=$O(^TMP("XBTRK",$J,N,V,P)) Q:(P="")  D
 ... S I=$O(^DIC(9.4,"C",N,0))
 ... S S=$G(^DIC(9.4,I,"VERSION"))
 ... S C=C+1
 ... S ^XBPKDATA(C)=$S(S=V:"CV",1:"PV")_U_N_U_$P(^DIC(9.4,I,0),U)_U_V_U_^TMP("XBTRK",$J,N,V,P)_U_P
 ...Q
 ..Q
 .Q
 ;
 ; Set the 0th node.
 ;
 S %=$G(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0))
 S ^XBPKDATA(0)=$P(%,U,10)_U_$P(^DIC(4,+%,0),U,1)_U_DT_U_DT_U_DT_U_U_C
 ;
 KILL C,N,V,P,S,X
 D EN^XBVK("ZIB"),SAVE:$D(XBSYSID),MAIL,EN^XBVK("XB"),^XBKTMP
 ;
 KILL ^XBPKDATA ; KILL of unsubscripted work global.
 Q
 ;
ONEP(N) ;one package - N = namespace
 ; Process all the routines in namespace R.
 NEW R
 S R=""
 F  S R=$O(^TMP("ZIBRSEL",$J,R)) Q:R=""  D ONER(R)
 Q
 ;
ONER(R) ;one routine
 ; Do not process init's, pre's, or post's.
 I R["IN0"!(R["I00")!(R["INI")!(R["PRE")!(R["POS") Q
 I $E(R,5,6)["I0"!(R["IN1") Q
 ; Get the version line, then the 3rd and 5th ";" pieces.
 S R=$T(+2^@R)
 Q:'$L($P(R,";",3))
 S R(3)=$P(R,";",3),R(5)=$TR($P(R,";",5),"*")
 ; Increment patch count in ^TMP("XBTRK",$J,namespace,version,patch)
 F %=1:1:$L(R(5),",") S ^TMP("XBTRK",$J,N,R(3),+$P(R(5),",",%))=$G(^TMP("XBTRK",$J,N,R(3),+$P(R(5),",",%)))+1
 Q
 ;
SAVE ; Send the global to XBSYSID(n), as defined in the option schedule.
 ;
 NEW XB
 ;
 S XBQTO=$O(XBSYSID(""))
 Q:'$L(XBQTO)
 ;
 D XBUF
 S XBGL="XBPKDATA",XBMED="F",XBTLE="Package tracking info via XBTRK from",XBQ="Y",XBFN="XBTK"_$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0)),U,10)_"."_$$RJ^XLFSTR($$JDT^XBFUNC(DT),3,"0"),XBFLT=1
 D ^XBGSAVE
 I $G(XBFLG)=-1,'$D(ZTQUEUED) W !,"XBGSAVE has returned this error :  ",$G(XBFLG(1)),".",! I $$DIR^XBDIR("E","Press RETURN") Q
 ;
 S XBQTO=$O(XBSYSID(""))
 F  S XBQTO=$O(XBSYSID(XBQTO)) Q:'$L(XBQTO)  D  Q:$G(XBFLG)=-1
 . D XBUF
 . S XBFN="XBTK"_$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0)),U,10)_"."_$$RJ^XLFSTR($$JDT^XBFUNC(DT),3,"0")
 . I ^%ZOSF("OS")["UNIX" D UUCPQ^ZIBGSVEM I 1
 . E  D UUCPQ^ZIBGSVEP
 . I $G(XBFLG)=-1,'$D(ZTQUEUED) W !,"XBGSAVE has returned this error :  ",$G(XBFLG(1)),".",! I $$DIR^XBDIR("E","Press RETURN") Q
 .Q
 Q
 ;
XBUF ;
 I ^%ZOSF("OS")["UNIX" S XBUF="/usr/spool/uucppublic"
 E  S XBUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 Q
 ;
MAIL ; Send a local mail note to current user and programmers.
 ;;Routine count by package, version, patch.
 ;;  
 ;;This note contains a count of routines in this uci, by patch level.
 ;;Patch level '0' indicates the routines are not patched.
 ;;  
 ;;The routines are limited to the namespaces of the packages in the PACKAGE file.
 ;;  
 ;;'CV' indicates the routines belong to the currently installed version
 ;;of the application in the PACKAGE file.  'PV' means that the version
 ;;line of the routine (2nd line) does not match the currently installed
 ;;version of the application.
 ;;  
 ;;A summary patch report can be obtained from IHS MailMan by selecting:
 ;;  Patch User Menu ...
 ;;and then:
 ;;  Latest/Highest Patch for all Packages 
 ;;  
 ;;For a description of how to control this report, and any file
 ;;produced/sent by this function, read the DESCRIPTION field of 
 ;;option "XB PACKAGE TRACKING".
 ;;E.g., ITSC is requesting a copy of the file be sent to
 ;;   "cmbsyb.hqw.DOMAIN.NAME"
 ;;and the option description will describe how you can control that
 ;;sending, or configure the option to send the information to other
 ;;systems.
 ;;  
 ;;CV/PV Prefix Name                Version #Rtns Patch
 ;;----- ------ ------------------  -----   ----- -----
 ;;
 ;;###
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 S XMSUB=$P($T(MAIL+1),";",3),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""XBTRK XMD"",$J,",XMY(DUZ)="",XMY(1)=""
 D SINGLE("XUPROGMODE")
 F %=1:1 D RSLT($P($T(MAIL+%),";",3)) Q:$P($T(MAIL+%+1),";",3)="###"
 F %=0:0  S %=$O(^XBPKDATA(%)) Q:'%  S X=^(%) D
 . F Y=1:1:6 S X(Y)=$P(X,U,Y)
 . S X(3)=$E(X(3),1,18)
 . D RSLT(X(1)_"    "_X(2)_$J("",7-$L(X(2)))_X(3)_$J("",20-$L(X(3)))_X(4)_$J("",8-$L(X(4)))_$J(X(5),5)_$J(X(6),5))
 .Q
 ; ^XBPKDATA(n)=CV^namespace^name^version^#routines^patch
 KILL X,Y
 D ^XMD
 KILL ^TMP("XBTRK XMD",$J)
 I '$D(ZTQUEUED) W !!,"The results are in your MailMan 'IN' basket.",!
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("XBTRK XMD",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
