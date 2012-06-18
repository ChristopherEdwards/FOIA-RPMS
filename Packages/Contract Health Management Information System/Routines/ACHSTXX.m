ACHSTXX ; IHS/ITSC/PMF - EXPORT DATA (1/9) ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; This is the lead program of the export process.  You
 ;start here whether you are exporting or REexporting
 ;
 ;Depending on which function you selected, the var ACHSREEX
 ;will be set to:
 ;       0       exporting
 ;       1       reexporting by batch
 ;       2       reexporting selected POs
 ;
 ;
 ;set up some special things FOR TESTING ONLY
 ;D ^ACHSPMF
 S ACHSREEX=0
 ;
 ;INIT some vars
 ;DO a series of checks, any of which may cause us to STOP
 ;
 ;if we don't stop, then
 ;  FOR each transaction in the time period
 ;  if an export record is called for, then
 ;    create it
 ;  end for
 ;  OPEN the unix file
 ;  FOR each export record created
 ;    send it to the unix file
 ;    record it in the database
 ;  endfor
 ;  PRINT the export report
 ;
 ;
 ;
 D INIT
 ;do the checks
 ;FOR TEST
 ;D ^ACHSTXCK I STOP D END Q
 ;get the list to export.  go different ways depending on REEX
 I ACHSREEX=1 D ^ACHSTX1R
 I ACHSREEX=2 D ^ACHSTX2R
 I 'ACHSREEX D ^ACHSTX11
 ;
 ;for testing only
 ;W !!,"back from tx11  " R PMF
 ;
 ;now that the transactions are created, bring them all into one
 ;global and send them.
 ;
 D END
 Q
 ;
END ; 
 ;we've come to the end of the job.  maybe we completed the
 ;export, maybe we didn't.  The value in tag STOP will tell
 ;us.
 ;
 ;if stop is true, do special stuff
 I STOP D STOP
 ;now do the stuff we do if stop is true or not
 ;
 X:$D(ACHSPCC) ACHSPPC
 U IO(0)
 ;
 ;for test
 ;I $$DIR^XBDIR("E","Press RETURN...")
 I '$$LOCK^ACHS("^ACHSF(DUZ(2),""D"")","-")
 K %DT,ACHSCRTN,DA,DFN,DIC,DIE,DOLRH,DR,DUOUT,DX,DY,LIST,NUM
 K OK,RET,ROUT,STOP,TNUM,VNDEINSX,W,X,X1,XBDT,XBF,XBGL,XBTIT,Y,Z
 D EN^XBVK("ACHS"),^%ZISC,^ACHSVAR
 ;
 ;for test
 D ^ACHSR1
 Q
 ;
STOP ;
 I STOP=1 W !,"User terminated this function - no export performed"
 I STOP=2 W !,"Register not closed"
 I STOP=3 W !,"Authorizing facility number invalid"
 I STOP=4 W !,"No data for facility"
 I STOP=5 W !,"DHR record not 80 chars"
 ;
 W !,"Abnormal end of function"
 ;
 ;any abnormal end means no export happened.  this line
 ;cleans out the record of it.
 I $G(DOLRH)'="" K ^ACHSXPRT(DOLRH)
 ;
 Q
 ;
INIT ;
 D ^ACHSVAR
 D ^ACHSUF
 D LINES^ACHSFU
 ;
 S ACHSYAYA="" F  S ACHSYAYA=$O(^ACHSXPRT(ACHSYAYA)) Q:ACHSYAYA=""  K ^ACHSXPRT(ACHSYAYA)
 K ACHSYAYA
 ;
 S STOP=0
 S ACHSRCT=0,ACHSCRTN=""
 S ACHSF638=($$PARM^ACHS(0,8)="Y")
 S DOLRH=$TR($H,",","_")
 K DUOUT,DTOUT
 Q
