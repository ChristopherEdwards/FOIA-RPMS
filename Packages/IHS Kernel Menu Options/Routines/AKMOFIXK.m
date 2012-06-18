AKMOFIXK ;BRJ/TUCSON/IHS;FIX SECURITY KEY FILE [ 06/21/91  9:10 AM ]
 ;;2.0;IHS KERNEL UTILITIES;;JUN 28, 1993
 W !,*7,"Please use correct entry label to run this program.",!!,"  Thanks. . No action occurred!",! Q
EN ;
 W !,"This routine will correct entries in your Security Key File.",!!,"Fixing."
 S AKMO("X")=0
 F  S AKMO("X")=$O(^DIC(19.1,AKMO("X"))) Q:'+AKMO("X")  D
 . S AKMO("Y")=0
 . F  S AKMO("Y")=$O(^DIC(19.1,AKMO("X"),2,AKMO("Y"))) Q:'+AKMO("Y")  D:$P(^(AKMO("Y"),0),"^",2)?1A.E
 .. S $P(^DIC(19.1,AKMO("X"),2,AKMO("Y"),0),"^",2)=$O(^DIC(3,"B",$P(^DIC(19.1,AKMO("X"),2,AKMO("Y"),0),"^",2),""))
 .. W "."
 W !!,*7,"Done fixing your Security Key File.   B y e. . ."
 Q
