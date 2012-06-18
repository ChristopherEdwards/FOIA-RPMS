BLRQUE ; IHS/HQT/MJL -Put requested transaction in a queue to refile ;
 ;;5.2;LR;**1010,1020**;SEP 13, 2005
 ;;MAR 01, 2001
 ;
TOP(BLRLOGDA,BLRQUIET)        ; EP
 Q:BLRLOGDA=""
 D ^BLREVTQ("M","REFILE","REFILE",,BLRLOGDA)
 Q
 ;
