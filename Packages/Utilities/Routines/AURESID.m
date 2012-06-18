AURESID ; CLEAN UP RESIDUAL ENTRIES IN ^DD [ 04/07/88  2:41 PM ]
 ;
 ;  This routine deletes residual entries in ^DD by a range of
 ;  dictionary numbers.  A residual entry is one that has no parent.
 ;  The process is reiterative, so an entry who has a parent
 ;  in ^DD, but the parent is deleted because it has no
 ;  parent, will also be deleted.  The parent of an entry
 ;  in ^DD is defined as another entry in ^DD for sub-files,
 ;  and an entry in ^DIC for primary files.
 ;
 ;  The range of dictionary numbers is inclusive but residual
 ;  entries for the high file number will not be deleted at
 ;  the sub-file level.  This is because sub-files are numbered
 ;  with the primary file number with decimal numbers appended.
 ;  The terminating check is ^DD entry greater than high file
 ;  number specified, so by definition all sub-files for the
 ;  high number are greater than the high number.
 ;
 ;  This routine can be called by another routine by setting
 ;  AURLO and AURHI and then D EN1^AURESID
 ;
 W !!,"This program deletes residual entries in ^DD by a range of dictionary numbers.",!!
 ;
LO R !,"Enter low  dictionary number: ",AURLO Q:AURLO'=+AURLO
HI R !,"Enter high dictionary number: ",AURHI Q:AURHI'=+AURHI!(AURHI'>AURLO)
 ;
EN1 ; ENTRY POINT FOR CALLING ROUTINE
 I $D(AURLO),$D(AURHI),AURLO=+AURLO,AURHI=+AURHI,AURHI>AURLO,AURLO'<2 G RESID
 W !!,"AURLO and/or AURHI missing or invalid!"
 G EOJ
 ;
RESID W !!,"Now checking for residual ^DD entries within range.",!
LOOP K ^UTILITY("AURESID",$J) S AURFILE=(AURLO-.00000001) F AURL=0:0 S AURFILE=$O(^DD(AURFILE)) Q:AURFILE>AURHI!(AURFILE'=+AURFILE)  D CHK
 S AURFILE=0 F AURL=0:0 S AURFILE=$O(^UTILITY("AURESID",$J,AURFILE)) Q:AURFILE=""  I ^(AURFILE),$D(^UTILITY("AURESID",$J,^UTILITY("AURESID",$J,AURFILE)))!($D(^DIC(^UTILITY("AURESID",$J,AURFILE)))) S ^UTILITY("AURESID",$J,AURFILE)="I"
 S (AURFILE,AURY)=0 F AURL=0:0 S AURFILE=$O(^UTILITY("AURESID",$J,AURFILE)) Q:AURFILE=""  I ^UTILITY("AURESID",$J,AURFILE)'="I" S AURY=1 W !,AURFILE K ^DD(AURFILE)
 G:AURY LOOP
 G EOJ
 ;
CHK ;
 W "."
 Q:$D(^DIC(AURFILE))
 I $D(^DD(AURFILE,0,"UP")),^("UP")'="",(^("UP")<AURLO!(^("UP")>AURHI)) Q
 S ^UTILITY("AURESID",$J,AURFILE)=$S($D(^DD(AURFILE,0,"UP"))#2:^("UP"),1:"")
 Q
 ;
EOJ ;
 K ^UTILITY("AURESID",$J)
 K AURFILE,AURHI,AURL,AURLO,AURY
 Q
