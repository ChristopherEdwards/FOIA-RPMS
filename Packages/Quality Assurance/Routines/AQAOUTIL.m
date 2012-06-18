AQAOUTIL ; IHS/ORDC/LJF - QI MANAGEMENT UTILITY RTN ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains frequently used subrtns.  They include the 
 ;initialization of varialbes for printing reports, end-of-page
 ;control, a basic report heading, the question of printing a report
 ;in ASCII format, and the killing of local variables.
 ;
 Q
INIT ;ENTRY POINT >>> initialize variables <<<
 S:'$D(AQAOIOMX) AQAOIOMX=$S($D(IOM):IOM,1:80)
 S AQAOPAGE=0,AQAOSTOP="",AQAODUZ=$P(^VA(200,DUZ,0),U,2)
 S AQAOSITE=$P(^DIC(4,DUZ(2),0),U) ;set site
 S AQAOLINE="",$P(AQAOLINE,"=",AQAOIOMX)=""
 S AQAOLIN2="",$P(AQAOLIN2,"-",AQAOIOMX)=""
 Q
 ;
 ;
NEWPG ;ENTRY POINT  >>> SUBRTN for end of page control
 I IOST'?1"C-".E D HEADING S AQAOSTOP="" Q
 I AQAOPAGE>0 K DIR S DIR(0)="E" D ^DIR S AQAOSTOP=X
 I AQAOSTOP'=U D HEADING
 Q
 ;
 ;
HEADING ;ENTRY POINT  >>> SUBRTN to print heading
 W:(AQAOPAGE>0) @IOF I AQAOPAGE=0,(IOST["C-") W @IOF
 W !,AQAOLINE S AQAOPAGE=AQAOPAGE+1
 I $D(AQAOHCON) D
 .S X="*****Confidential "_AQAOHCON_" Data Covered by Privacy Act*****"
 .W !?AQAOIOMX-$L(X)/2,X
 W !,AQAODUZ,?AQAOIOMX-$L(AQAOSITE)/2,AQAOSITE
 W ! D TIME
 W ?AQAOIOMX-$L(AQAOTY)/2,AQAOTY,?AQAOIOMX-10,"Page: ",AQAOPAGE
 S Y=DT X ^DD("DD") W !,Y
 Q
 ;
 ;
TIME ;ENTRY POINT to print time only
 N X
 S X=$E($$HTFM^XLFDT($H),1,12)
 W $P($$FMTE^XLFDT(X,"2P")," ",2,3)
 Q
 ;
 ;
EXPORT ;ENTRY POINT for help text and questions about sending ASCII files
 ;called just prior to %ZIS calls in selected reports
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to capture the data into an ASCII file"
 S DIR("?",1)="  You can send this report to your personal computer"
 S DIR("?",2)="  in ASCII format which is readable to many statistical"
 S DIR("?",3)="  PC applications.  You must choose a DELIMITER that"
 S DIR("?",4)="  your application can understand.  This could be a "
 S DIR("?",5)="  comma, a slash, a semicolon, or other punctuation to"
 S DIR("?",6)="  separate each piece of data.  Check the PC software"
 S DIR("?",7)="  user manual for your possible choices."
 S DIR("?",8)="  Remember to answer the DEVICE question with HOME.  The"
 S DIR("?",9)="  data file will be displayed on your screen as it is"
 S DIR("?",10)="  captured.",DIR("?")=" "
 D ^DIR Q:$D(DIRUT)  Q:Y'=1
 ;
DELIM ;ask for delimiter
 W !! K DIR S DIR(0)="F^1:1^I Y'?1P S Y=-1"
 S DIR("?")="Enter punctuation mark to separate data fields in file."
 S DIR("A")="Type in DELIMITER" D ^DIR Q:$D(DIRUT)
 I Y=-1 W *7,"  ??" G DELIM
 S AQAODLM=Y
 W !!?10,"Start the capture at the device prompt.",!
 Q
 ;
 ;
DLMHDG ;ENTRY POINT  >>> SUBRTN to print ASCII heading
 W !
 I $D(AQAOHCON) D
 .W "*****Confidential "_AQAOHCON_" Data Covered by Privacy Act*****"
 W !,AQAODUZ,AQAODLM,AQAOSITE,AQAODLM D TIME
 W !,AQAOTY,AQAODLM
 S Y=DT X ^DD("DD") W $P(Y,",")," ",$P(Y,",",2),AQAODLM
 Q
 ;
 ;
KILL ;ENTRY POINT  >>> kill statement for options
 ;
 ; >>> kill ztsk variables
 I $D(ZTQUEUED) S ZTREQ="@" Q
 ;
 ; >> kill namespaced variables
 D ^AQAOVKL0
 ;S X="AQAO"
 ;F  S X=$O(@X) Q:X'?1"AQAO".E  D
 ;.K Y F I=1:1:4 I $P($T(SYS+I),";;",2)=X S Y=""
 ;.Q:$D(Y)
 ;.K @X
 ;K AQAO
 ;
 ; >>> kill fileman variables
 D ^XBFMK
 ;
 ; >>> kill non-namespaced variables
 K DFN
 ;
 ; >> kill single character variables
 K X,Y,Z,I,J,K,S,L,N,W
 ;
 Q
 ;
SYS ;;SYSTEM-WIDE VARIABLES
 ;;AQAOCHK
 ;;AQAOENTR
 ;;AQAOINAC
 ;;AQAOUA
 ;;AQAOXYZ
