BSDXERR ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING COMMON ERROR ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;  ERROR  = General error catch routine used by @^%ZOSF("TRAP")
 ;  ERR    = Error logging routine
 ;
ERROR ;
 D ERR("RPMS Error")
 Q
 ;
ERR(BSDXERR) ;Error processing
 ; BSDXERR = Error text OR error code
 ; BSDXI   = pointer into return global array (might decide to pass this in for clarity)
 I +BSDXERR S BSDXERR=BSDXERR+134234112 ;vbObjectError
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
