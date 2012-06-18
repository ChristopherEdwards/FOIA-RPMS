ABMDE32X ; IHS/SD/SDR - ERROR CHECKING - PAGE 3B ;      
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ; IHS/SD/SDR - abm*2.6*6 - New routine to do error checking on page 3B
 ;
 ;errors go here
XIT Q
ERR ;
 D ABMDE32X
 S ABME("TITL")="PAGE 3B - Third Party Liability/Worker's Comp"
 G XIT
 Q
