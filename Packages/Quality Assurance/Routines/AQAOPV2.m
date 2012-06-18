AQAOPV2 ; IHS/ORDC/LJF - PRINT PROVIDER QI CODES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contians the user interface and call to DIP to print a
 ;listing of providers selected with their corresponding QI codes.
 ;
SINGLE ;display of selected provider codes
 D SINGLE^AQAOHPRV ;intro text
 K AQAOARR ;make sure array is empty to start
 S AQAOX=0 ;flag for first time thru
ASK ; >>> ask user for provider names to display
 K DIC S DIC=200,DIC(0)="AEQ",D="AK.PROVIDER",DIC("A")="Select "
 S DIC("A")=DIC("A")_$S('AQAOX:"PROVIDER NAME: ",1:"ANOTHER PROVIDER: ")
 S DIC("S")="I $P($G(^(""PS"")),U,4)=""""" ;screen out inactives
 D IX^DIC S AQAOX=1 G END:$D(DUOUT),END:$D(DTOUT),DEV:X="",DEV:Y=-1
 S AQAOARR(+Y)="" G ASK
 ;
DEV ; >>> get print device
 G END:'$D(AQAOARR) ;no providers selected
 W !! S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G PRINT
 K IO("Q") S ZTRTN="PRINT^AQAOPV2",ZTDESC="SINGLE PROV CODES"
 S ZTSAVE("AQAOARR(")="" D ^%ZTLOAD K ZTSK D ^%ZISC
 ;
 D PRTOPT^AQAOVAR G END
 ;
 ;
PRINT ; >>> loop thru selections and print data
 D INIT^AQAOUTIL S AQAOHCON="Provider",AQAOTY="PROVIDER QI CODES"
 D HEADING^AQAOUTIL,HEADING2 S AQAOX=0
 F  S AQAOX=$O(AQAOARR(AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HEADING2
 .K ^UTILITY("DIQ1",$J)
 .S DIC=200,DR=".01;53.5;9999999.039",DA=AQAOX D EN^DIQ1
 .W !!,"PROVIDER NAME:  ",$E($G(^UTILITY("DIQ1",$J,200,DA,.01)),1,25)
 .W ?45,"PROVIDER CLASS:  ",$E($G(^UTILITY("DIQ1",$J,200,DA,53.3)),1,18)
 .W !?6,"QI CODE:  ",AQAOX
 .W ?51,"PCC CODE:  ",$G(^UTILITY("DIQ1",$J,200,DA,9999999.039))
 ;
 I '$D(ZTQUEUED),(IOST["C-") D PRTOPT^AQAOVAR ;ask to  hit return
END ; >>> eoj
 K ^UTILITY("DIQ1",$J) D ^%ZISC D KILL^AQAOUTIL Q
 ;
 ;
HEADING2 ; >>> SUBRTN to print second half of heading
 W ?14,"(Please forward INACTIVE PROVIDER NAMES to proper dept.)"
 W !,AQAOLINE,! Q
