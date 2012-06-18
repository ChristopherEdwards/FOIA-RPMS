BZXPTMSG ;IHS/PHXAO/AEF - ISSUE PATIENT MESSAGES
 ;;1.0;ANNE'S SPECIAL ROUTINES;;APR 9, 2004
 ;;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This option allows entry of messages into the BZX PATIENT MESSAGE
 ;;file.  A text message can be entered which will be displayed whenever
 ;;a patient is selected.  You can cause the message to blink, display
 ;;in bold letters, or reverse video.  You can also choose a color for
 ;;the text message.
 ;;
 ;;$$END
 Q
 ;
EN ;EP -- MAIN ENTRY POINT TO ADD/EDIT BZX PATIENT MESSAGE FILE ENTRIES
 ;
 D ^XBKVAR
 ;
 D HOME^%ZIS
 ;
 D TXT
 ;
 D ADD
 ;
 Q
ADD ;----- ADD/EDIT BZX PATIENT MESSAGE FILE ENTRY
 ;
 N DA,DIC,DIE,DLAYGO,DR,DTOUT,DUOUT,X,Y
 ;
 S DIC="^BZXPTMSG(1991258,"
 S DIC(0)="AEMQLI"
 S DLAYGO=1991258
 D ^DIC
 Q:$D(DTOUT)!($D(DUOUT))
 Q:+Y'>0
 S DA=+Y
 S DIE=DIC
 S DR="[BZX ADD NEW MESSAGE]"
 D ^DIE
 W !
 G ADD
 Q
TXT ;----- PRINT OPTION TEXT
 ;
 N I,X
 F I=1:1 S X=$P($T(DESC+I),";",3) Q:X["$$END"  W !,X
 Q 
MSG(D0) ;EP;CALLED BY AUPNLK
 ;----- ISSUE MESSAGE
 ;
 ;      D0  =  PATIENT IEN
 ;
 N BZXCOLOR,BZXZIS5,BZXZIS7,DIR,X,Y
 ;      
 Q:$G(^BZXPTMSG(1991258,D0,99.01))']""
 ;
 D ^XBKVAR
 ;
 D HOME^%ZIS
 ;
 D COLORS(.BZXCOLOR)
 ;
 S BZXZIS5=$G(^%ZIS(2,+$G(IOST(0)),5))
 S BZXZIS7=$G(^%ZIS(2,+$G(IOST(0)),7))
 ;
 D SPEC(D0,BZXZIS5,BZXZIS7,.BZXCOLOR)
 ;
 W *7
 W !,$G(^BZXPTMSG(1991258,D0,99.01))
 ;
 D RESET(BZXZIS5,BZXZIS7,.BZXCOLOR)
 ;
 W !
 ;
 I D0  D
 . S DIR(0)="E"
 . S DIR("A")="Press the RETURN key to continue"
 . D ^DIR
 Q
SPEC(D0,BZXZIS5,BZXZIS7,BZXCOLOR) ;
 ;----- SPECIAL DISPLAY CHARACTERISTICS
 ;
 N BZXCOL,BZXDATA
 ;
 S BZXDATA=$G(^BZXPTMSG(1991258,D0,1))
 I $P(BZXDATA,U),$P(BZXZIS5,U,8)]"" W @($P(BZXZIS5,U,8))    ;BLINK ON
 I $P(BZXDATA,U,2),$P(BZXZIS5,U,4)]"" W @($P(BZXZIS5,U,4))  ;REV VIDEO ON
 I $P(BZXDATA,U,3),$P(BZXZIS7,U)]"" W @($P(BZXZIS7,U))      ;BOLD ON
 S BZXCOL=$P($G(^BZXPTMSG(1991258,D0,2)),U)
 I BZXCOL]"" W @(BZXCOLOR(BZXCOL))                          ;COLOR ON
 ;
 Q
RESET(BZXZIS5,BZXZIS7,BZXCOLOR) ;
 ;----- RESET THE DEVICE
 ;
 I $P(BZXZIS5,U,9)]"" W @($P(BZXZIS5,U,9))                  ;BLINK OFF
 I $P(BZXZIS5,U,5)]"" W @($P(BZXZIS5,U,5))                  ;REV VIDEO OFF
 I $P(BZXZIS7,U,3)]"" W @($P(BZXZIS7,U,3))                  ;BOLD OFF
 W @$G(BZXCOLOR("RESET"))                                   ;COLOR OFF
 W *27,*91,*109    ;*** TESTING - AEF *** RESET
 W $C(27,91,109)   ;*** TESTING - AEF *** RESET
 Q
COLORS(BZXCOLOR) ;
 ;----- SET UP COLORS
 ;
 S BZXCOLOR("BLACK")="$C(27),""[30m"""
 S BZXCOLOR("RED")="$C(27),""[31m"""
 S BZXCOLOR("GREEN")="$C(27),""[32m"""
 S BZXCOLOR("YELLOW")="$C(27),""[33m"""
 S BZXCOLOR("BLUE")="$C(27),""[34m"""
 S BZXCOLOR("MAGENTA")="$C(27),""[35m"""
 S BZXCOLOR("CYAN")="$C(27),""[36m"""
 S BZXCOLOR("WHITE")="$C(27),""[37m"""
 S BZXCOLOR("RESET")="$C(27),""[m"""
 Q
