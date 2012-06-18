XBHFMAN ; IHS/ADC/GTH - HELP FRAME MANUAL (1/2) ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Print a help frame manual for an IHS application, using
 ; OPTION descriptions and HELP FRAME texts in the namespace
 ; of the application selected from the PACKAGE file.
 ;
 ; Information for the title and preface pages, and for
 ; indexed words, is expected to be in a routine named
 ; <namespace>HFMN.  The title page lines are expected to
 ; begin at line TITLE+1, and the preface page at PREFACE+1.
 ; Any words to be indexed are expected to begin at line
 ; INDEX+1.  See routine XBHFMAN2 for an example.
 ;
 ; If entered from the top, user is asked for application.
 ; Entry point EN() must have the namespace of the application
 ; as the parameter.  That allows programmers to create their
 ; own option and call it, without forcing user to select the
 ; applcation.
 ;
 D HOME^%ZIS,DT^DICRW
 NEW DIR,XBSEL
 G EN1
 ;
EN(XBSEL) ;PEP ----- From application options, with namespace of application.
 ;
EN1 ;
 S DIC=9.4,DIC(0)="AEM",DIC("S")="I ""AB""[$E($P(^(0),U,2))"
 I $D(XBSEL) S X=XBSEL,DIC(0)="",D="C" D IX^DIC I 1
 E  D ^DIC
 I Y<1 W !,"^DIC( LOOKUP FAILED." Q
 S XBSEL=+Y
DEV ;
 S %ZIS="OPQ"
 D ^%ZIS
 I POP S IOP=$I D ^%ZIS G K
 G:'$D(IO("Q")) START
 KILL IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 S ZTRTN="START^XBHFMAN",ZTDESC="Help Frame Manual for "_$P(^DIC(9.4,XBSEL,0),U),ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTSAVE("XBSEL")=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
K ;
 KILL XB,ZTSK
 D ^%ZISC
 D END^XBHFMAN1
 Q
 ;
START ;EP ----- From TaskMan.
 ;
 I '$D(ZTQUEUED),'$D(IO("S")) U IO(0) D WAIT^DICD U IO
 ;
 NEW DIWL,DIWR,DIWF,DIRUT
 NEW XBBM,XBCHAP,XBCONT,XBSAVX,XBTM,XBTITL,XBPG,XBHDR,XBHDRE,XBHDRO,XBDASH,XBSTRIP,XBNOHDR,XBIENI,XBLEVEL,XBNAME,XBNS
 ;
 KILL ^TMP("XBHFMAN",$J),^UTILITY($J)
 ;
 ; S X=$O(^DIC(9.4,XBSEL,22,"B","0.5",0))
 ; I X S %=0 F  S %=$O(^DIC(9.4,XBSEL,22,X,"P",%)) Q:'%  S Y=^(%,0) I $L(Y) S ^TMP("XBHFMAN-I",$J,Y)=""
 ;
 ; ----- Set namespace and read indexed words into ^TMP("XBHFMAN-I",$J.
 S XBNS=$P(^DIC(9.4,XBSEL,0),U,2)
 F X=1:1 S Y=$P($T(@"INDX"+X^@(XBNS_"HFMN")),";",3) Q:'$L(Y)  S ^TMP("XBHFMAN-I",$J,Y)=""
 ;
 S DIWL=10,DIWR=74,DIWF="W"
 S XBBM=IOSL-5,XBTM=6,XBTITL=$P(^DIC(9.4,XBSEL,0),U)_" HELP FRAME MANUAL",XBPG=0,XBHDR="Index",(XBHDRE,XBHDRO)="",XBDASH="",$P(XBDASH,"-",81)="",XBDASH=$E(XBDASH,DIWL,DIWR)
 S XBSTRIP=^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 S (XBCHAP,XBLEVEL)=1,(XBCONT,XBHDR,XBPG,XBNOHDR)=0
 ;
 ; ----- Set primary menu as chapter 1.
 D SETTMP($O(^DIC(19,"B",XBNS_"MENU",0)),"1")
 ;
 S XBNAME=XBNS
 F  S XBNAME=$O(^DIC(19,"B",XBNAME)) Q:$E(XBNAME,1,$L(XBNS))'=XBNS  I '$D(^DIC(19,"AD",$O(^DIC(19,"B",XBNAME,0)))) S ^TMP("XBHFMAN-M",$J,XBNAME)=""
 KILL ^TMP("XBHFMAN-M",$J,XBNS_"MENU")
 D MENU($O(^DIC(19,"B",XBNS_"MENU",0)))
 ;
 S XBCHAP=1,XBNAME=""
 F  S XBNAME=$O(^TMP("XBHFMAN-M",$J,XBNAME)) Q:XBNAME=""  S XBCHAP=+$P(XBCHAP,".")+1,XBLEVEL=1 D SETTMP($O(^DIC(19,"B",XBNAME,0)),XBCHAP),MENU($O(^DIC(19,"B",XBNAME,0)))
 ;
 U IO
 D ^XBHFMAN1
 Q
 ;
 ;
MENU(I) ; ----- Assign chapter number to OPTIONs. Recurse if OPTION is a menu.
 Q:'$G(I)
 NEW X
 S X=0,XBLEVEL=XBLEVEL+1
 F  S X=$O(^DIC(19,I,10,X)) Q:'X  S $P(XBCHAP,".",XBLEVEL)=$P(XBCHAP,".",XBLEVEL)+1,Y=+^(X,0) D SETTMP(Y,XBCHAP) I $$DATA(Y,0,4)="M" D MENU(Y) S $P(XBCHAP,".",XBLEVEL)=0,XBLEVEL=XBLEVEL-1
 Q
 ;
DATA(I,N,P) ;
 Q $P(^DIC(19,I,N),U,P)
 ;
 ;
 ;
RTRN ;EP ----- If interactive, ask usr to press RETURN.
 I IOST["C-",'$D(IO("S")),$$DIR^XBDIR("E","Press RETURN To Continue or ""^"" to exit","","","","",1)
 Q
 ;
SETTMP(I,N) ; ----- Set option IEN and chapter designation into ^TMP.
 NEW X,Y
 I '$D(ZTQUEUED),'$D(IO("S")) U IO(0) W "." U IO
 F %=1:1 I '$P(N,".",%) S N=$P(N,".",1,%-1) Q
 S ^(0)=$G(^TMP("XBHFMAN",$J,0))+1
 S ^TMP("XBHFMAN",$J,^TMP("XBHFMAN",$J,0))=I_"^"_N
 Q
 ;
