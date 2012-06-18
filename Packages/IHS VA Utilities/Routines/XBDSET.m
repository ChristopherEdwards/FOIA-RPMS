XBDSET ; IHS/ADC/GTH - BUILDS LIST OF FILEMAN FILES ; [ 12/11/2000   3:13 PM ]
 ;;3.0;IHS/VA UTILITIES;**8**;FEB 07, 1997
 ; XB*3*8 - IHS/ASDST/GTH 12-07-00 - Add ability to select from BUILD file.
 ;
 ; This routine selects FileMan dictionaries individually,
 ; by a range, or for a specific package. This routine can
 ; be called from another routine by setting the variables
 ; XBDSLO, XBDSHI and then D EN1^XBDSET.
 ;
 ; If the variable XBDSND exist upon entry no default menu
 ; option will be displayed.
 ;
START ;
 S IOP=0
 D ^%ZIS
 KILL DIC,DIR,^UTILITY("XBDSET",$J)
 S (XBDSP,XBDSQ)=0
 F  D GETFILES Q:XBDSQ
 D EOJ
 Q
 ;
GETFILES ;
 W !
 ; S DIR(0)="SO^"_$S('XBDSP:"O:One file only;",1:"")_"S:Selected files;R:Range of files;P:Package;"_$S($D(^UTILITY("XBDSET",$J)):"L:List of files already selected; : ",1:" : "); XB*3*8
 S DIR(0)="SO^"_$S('XBDSP:"O:One file only;",1:"")_"S:Selected files;R:Range of files;P:Package;B:Build;"_$S($D(^UTILITY("XBDSET",$J)):"L:List of files already selected; : ",1:" : ") ; XB*3*8
 S DIR("A")="Choose one,"_$S(XBDSP!($D(XBDSND)):" RETURN to continue,",1:"")_" or ^ to cancel"
 I 'XBDSP,'$D(XBDSND) S DIR("B")="O"
 S DIR("?")=$S(XBDSP:"Do you want",1:"Do you want one file,")
 ; S DIR("?")=DIR("?")_" a range of files by number, files from a specific package, "_$S($D(^UTILITY("XBDSET",$J)):"individual files, or a list of files already selected?",1:"or individual files?") ; XB*3*8
 S DIR("?")=DIR("?")_" a range of files by number, files from a specific package or build, "_$S($D(^UTILITY("XBDSET",$J)):"individual files, or a list of files already selected?",1:"or individual files?") ; XB*3*8
 D ^DIR
 KILL DIR
 I $D(DIRUT) K:$D(DUOUT)!($D(DTOUT)) ^UTILITY("XBDSET",$J) S XBDSQ=1 Q
 D OPTION ;                 Get files for selected option
 I $D(^UTILITY("XBDSET",$J)) S XBDSP=1
 Q
 ;
OPTION ; GET FILES FOR SELECTED OPTION
 W !
 I Y="O" D ONEFILE Q  ;      Get one file and exit
 I Y="S" D SELECT Q  ;       Get selected files
 I Y="R" D RANGE Q  ;        Get range of files
 I Y="P" D PACKAGE Q  ;      Get files from package
 I Y="L" D LIST Q  ;         List selected files
 I Y="B" D BUILD Q  ;        Get files from build ; XB*3*8
 Q
 ;
ONEFILE ; GET ONE FILE AND EXIT
 S XBDSND=1
 S DIC="^DIC(",DIC(0)="AEMQ"
 D ^DIC
 KILL DIC
 Q:Y<0
 S ^UTILITY("XBDSET",$J,+Y)=""
 S XBDSQ=1
 Q
 ;
SELECT ; GET SELECTED FILES
 S DIC="^DIC(",DIC(0)="AEMQ"
 F  D ^DIC Q:Y<0  S ^UTILITY("XBDSET",$J,+Y)=""
 KILL DIC
 I '$O(^UTILITY("XBDSET",$J,""))!($D(DUOUT)) S XBDSQ=1 Q
 Q
 ;
RANGE ; GET RANGE OF FILES
 S DIR(0)="NO^1:99999999:3",DIR("A")="From file number"
 D ^DIR
 KILL DIR
 I $D(DIRUT) S XBDSQ=1 Q
 S XBDSFF=+Y
 F  S DIR(0)="NO^1:99999999:3",DIR("A")="Thru file number" D ^DIR KILL DIR Q:$D(DIRUT)  D  Q:'XBDSQ  S XBDSQ=0
 . I +Y<XBDSFF W !,"  'Thru FILE' number less than 'From FILE' number!",*7 S XBDSQ=9
 .Q
 I $D(DIRUT) S XBDSQ=1 Q
 S XBDSTF=+Y
 D RANGE2
 W !
 I XBDSC W !?4,XBDSC," file",$S(XBDSC=1:"",1:"s")," selected" I 1
 E  W !?4,"No files selected",*7
 Q
 ;
RANGE2 ; LABEL FOR EXTERNAL ENTRY POINT EN1
 S XBDSFILE=XBDSFF,XBDSC=0
 F  D  S XBDSFILE=$O(^DIC(XBDSFILE)) Q:XBDSFILE'=+XBDSFILE!(XBDSFILE>XBDSTF)
 . Q:'$D(^DIC(XBDSFILE,0))
 . S ^UTILITY("XBDSET",$J,XBDSFILE)=""
 . S XBDSC=XBDSC+1
 .Q
 Q
 ;
PACKAGE ; GET FILES FROM SPECIFIC PACKAGE
 S DIC=9.4,DIC(0)="AEMQ"
 D ^DIC
 KILL DIC
 Q:Y<0
 S Y=+Y,X=0
 F  S X=$O(^DIC(9.4,Y,4,X)) Q:X'=+X  I $D(^DIC(^DIC(9.4,Y,4,X,0),0)) S ^UTILITY("XBDSET",$J,^DIC(9.4,Y,4,X,0))=""
 Q
 ;
 ; XB*3*8 start block
BUILD ; Get files from selected BUILD
 S DIC=9.6,DIC(0)="AEMQ"
 D ^DIC
 KILL DIC
 Q:Y<0
 S Y=+Y,X=0
 F  S X=$O(^XPD(9.6,Y,4,X)) Q:X'=+X  I $D(^XPD(9.6,Y,4,X,0)) S ^UTILITY("XBDSET",$J,^XPD(9.6,Y,4,X,0))=""
 Q
 ; XB*3*8 end block
 ;
LIST ; LIST FILES ALREADY SELECTED
 I '$D(^UTILITY("XBDSET",$J)) W !,"No files selected." Q
 W @IOF,"Files already selected:",!
 S XBDSX=""
 F  S XBDSX=$O(^UTILITY("XBDSET",$J,XBDSX)) Q:XBDSX=""  W !,XBDSX,?14,$P(^DIC(XBDSX,0),U,1) I $Y>(IOSL-3) D PXBSE Q:$D(DUOUT)  W @IOF
 I '$D(DUOUT),$Y>(IOSL-10) D PXBSE
 Q
 ;
PXBSE ; GIVE USER A CHANCE TO SEE LAST PAGE AND QUIT
 I IO=IO(0),$E(IOST,1,2)="C-" S Y=$$DIR^XBDIR("E")
 Q
 ;
EN1 ;EP - Non-interactive selection of range of files.
 KILL ^UTILITY("XBDSET",$J)
 I '$D(XBDSLO)!('$D(XBDSHI)) Q
 S XBDSFF=XBDSLO,XBDSTF=XBDSHI
 D RANGE2
 D EOJ
 Q
 ;
EOJ ;
 KILL XBDSC,XBDSFF,XBDSFILE,XBDSHI,XBDSL,XBDSLO,XBDSND,XBDSP,XBDSQ,XBDSTF,XBDSX
 KILL DIC,DIR,DIRUT,DTOUT,DUOUT,X,Y
 Q
 ;
