SROCON1 ;B'HAM ISC/MAM - MULTIPLES (.01) & CONCURRENTS ; 16 AUG 1990  1:30 PM
 ;;3.0; Surgery ;**78,107**;24 Jun 93
 ;
 ; Reference to ^TMP("CSLSUR1" supported by DBIA #3498
 ;
 W !!,"The information to be duplicated in the concurrent case will now be entered....",!!
EN ;
 I $D(SRODR) D FILE^DIE("","SRODR","^TMP(""SR"",$J)") D
 .N SROERR S SROERR=SRCON I $D(^TMP("CSLSUR1",$J)) D ^SROERR0 S ^TMP("CSLSUR1",$J)=""
 K DIR S DIR("A")="Press RETURN to continue  ",DIR(0)="FOA" D ^DIR K DIR
 Q
