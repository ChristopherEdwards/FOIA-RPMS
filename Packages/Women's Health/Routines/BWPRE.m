BWPRE ;IHS/ANMC/MWR - PRE-INIT ROUTINE ;15-Feb-2003 22:07;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  PRE-INIT ROUTINE TO REMOVE PREVIOUS DATA DICTIONARIES IN THE
 ;;  9002086-9002086.9999 NUMBER SPACE.
 ;
 D SETVARS^BWUTL5 S BWPOP=0
 S Y=$P($P($T(BWPRE+1),";;",2),";")
 S BWPTITL="v"_Y_" PRE-INIT PROGRAM"
 D PERMISS(.BWPOP) I BWPOP D EXIT S BWPOP=1 Q
 D DD
 D FORMS
 D EXIT S BWPOP=0
 Q
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
PERMISS(BWPOP) ;EP
 ;---> SET UP PROPER PERMISSION TO DELETE DATA DICTIONARIES.
 S BWPOP=0
 Q:DUZ(0)["@"
 W !!!! D TITLE^BWUTL5(BWPTITL)
 D TEXT1,DIRZ^BWUTL3 S BWPOP=1
 Q
 ;
DD ;EP
 ;---> DELETE ALL BW PACKAGE DATA DICTIONARIES.
 N N
 D TITLE^BWUTL5(BWPTITL)
 D TEXT2
 ;---> BY DD#.
 S N=9002085.99999,DIU(0)="T"
 F  S N=$O(^DD(N)) Q:'+N  Q:N'<9002087  D
 .W ?6,N
 .S DIU=N
 .D EN^DIU2
 W !?5,"Data Dictionary deletion complete." H 1
 F N="PR","PN","DIAG","CUR","MAMT","LET","MDE","DOC" D
 .D ZGBL^BWUTL8("^BW"_N)
 W !?5,"Old BW standard tables deletion complete." H 1
 Q
 ;
FORMS ;EP
 ;---> DELETE ALL BW FORMS AND BLOCKS.
 W !!!?6,"The Pre-Initialization Program is removing all old Screenman"
 W !?6,"forms and blocks.  Please stand by...",!
 S N="BW",DIK="^DIST(.403,"
 F  S N=$O(^DIST(.403,"B",N)) Q:N=""!(N]"BWZZZ")  D
 .S DA=$O(^DIST(.403,"B",N,0))
 .D ^DIK
 ;
 S N="BW",DIK="^DIST(.404,"
 F  S N=$O(^DIST(.404,"B",N)) Q:N=""!(N]"BWZZZ")  D
 .S DA=$O(^DIST(.404,"B",N,0))
 .D ^DIK
 W !?6,"Screen deletions complete." H 1
 Q
 ;
TEXT1 ;
 ;;This preinit clears all data dictionaries out of the Women's Health
 ;;number space (9002086-9002086.99) before loading the new data
 ;;dictionaries.  In order for this to occur, your DUZ(0) must contain
 ;;the "@".  Your DUZ(0), however, does NOT contain the "@", and the
 ;;SAC standards prevent this program from setting it for you.
 ;;
 ;;You can set your DUZ(0)=@ by entering S DUZ(0)="@" at the programmer
 ;;prompt, or by entering Fileman in programmer mode: enter D P^DI at
 ;;the programmer prompt and then simply press RETURN to back out of it.
 ;;
 ;;After resetting your DUZ(0), you may begin the init process again
 ;;by entering D ^BWINIT at the programmer prompt.
 ;;
 ;;This init will now terminate without having made any changes to the
 ;;current software.
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
TEXT2 ;
 S BWTAB=5,BWLINL="TEXT2" D PRINTX
 ;The Pre-Initialization Program is removing all old Data Dictionaries
 ;in the 9002086-9002086.9999 number space and old BW standard tables.
 ;Please stand by...
 Q
 ;
 ;
PRINTX ;EP <---REMOVE LEADING "Z" FROM THIS LINE LABEL.
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
