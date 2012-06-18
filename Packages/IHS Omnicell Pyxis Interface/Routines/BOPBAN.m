BOPBAN ;IHS/CIA/PLS - Banner for AUTOMATED DISPENSING INTERFACE Package;06-Apr-2005 13:41;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;;Jul 26, 2005
 ;
 N VER,LP,SITE
 S VER=$$VERSION^XPDUTL("AUTOMATED DISPENSING INTERFACE")
 S SITE=$$GET1^DIQ(4,$G(DUZ(2)),.01)
 W:$D(IOF) @IOF
 F LP=1:1 S LINE=$T(TEXT+LP) Q:$P(LINE,";",3)=""  D
 .W !?80-$L($P(LINE,";",3))\2,$P(LINE,";",3)
 W !?80-(8+$L(VER))\2,"Version ",VER
 I $G(DUZ(2)) W !!,?80-$L(SITE)\2,SITE
 Q
 ;
TEXT ;Main banner
 ;;********************************************************
 ;;** IHS Pharmacy Automated Dispensing Interface System **
 ;;********************************************************
 ;;
