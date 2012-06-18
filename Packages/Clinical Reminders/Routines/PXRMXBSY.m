PXRMXBSY ; SLC/PJH - Let the user know the computer is busy. ;01/12/2002
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ;
 ;=======================================================================
INIT(SPINCNT) ;Initialize the busy display components.
 S SPINCNT=0
 Q
 ;
 ;=======================================================================
DONE(DTEXT) ;Write out the done message.
 W @IOBS,DTEXT,!
 Q
 ;
 ;=======================================================================
SPIN(SPINTEXT,SPINCNT) ;Move the spinner.
 N QUAD
 I SPINCNT=0 W !!,SPINTEXT,"  "
 S SPINCNT=SPINCNT+1
 S QUAD=SPINCNT#8
 I QUAD=1 W @IOBS,"|"
 I QUAD=3 W @IOBS,"/"
 I QUAD=5 W @IOBS,"-"
 I QUAD=7 W @IOBS,"\"
 Q
