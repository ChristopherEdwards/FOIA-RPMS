ABSPOS6K ; IHS/FCS/DRS - Other options ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
MENU ;    
 D FULL^VALM1
 N X
 F  D  Q:X<1
 . S X=$$SET^ABSPOSU3("Select 1: Log diagnostic info // ","1",0,"V","1:Diagnostics")
 . Q:X<1
 . I X=1 D
 . . D DIAG
 . ;E  I X=2 D
 . S X=-1 ; for now, cause it to bump out
 . ; worthwhile to loop and ask again when you get more options here
 S VALMBCK="R"
 Q
DIAG ; collect diagnostic information
 N X
 W !,"This logs diagnostic information to a file for later analysis",!
 W "by programming staff.  ",!
 W !
 W "Select 1 to log general information about the system.",!
 W "Select 2 to log information about your screen in particular.",!
 W "Select 3 to do both 1 + 2.",!
 S X=$$SET^ABSPOSU3("Select 1: General  2: Your screen  3:Both // ","1",0,"H","1:General;2:Your screen;3:Both")
 W !
 I X<1 W !,"Nothing logged.",! Q
 D FULL^ABSPOSUB:X=1,JOB^ABSPOSUB:X=2,BOTH^ABSPOSUB:X=3
 D ANY^ABSPOS2A ; press any key
 Q
