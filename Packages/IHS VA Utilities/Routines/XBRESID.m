XBRESID ; IHS/ADC/GTH - CLEAN UP RESIDUAL ENTRIES IN ^DD ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine deletes residual entries in ^DD by a range of
 ; dictionary numbers.  A residual entry is one that has no
 ; parent.  The process is reiterative, so an entry who has a
 ; parent in ^DD, but the parent is deleted because it has no
 ; parent, will also be deleted.  The parent of an entry in
 ; ^DD is defined as another entry in ^DD for sub-files, and
 ; an entry in ^DIC for primary files.
 ;
 ; The range of dictionary numbers is inclusive but residual
 ; entries for the high file number will not be deleted at
 ; the sub-file level.  This is because sub-files are numbered
 ; with the primary file number with decimal numbers appended.
 ; The terminating check is ^DD entry greater than high file
 ; number specified, so by definition all sub-files for the
 ; high number are greater than the high number.
 ;
 ; This routine can be called by another routine by setting
 ; XBRLO and XBRHI and then D EN1^XBRESID.
 ;
START ;
 W !!,"This program deletes residual entries in ^DD by a range of dictionary numbers.",!!
 ;
LO ;
 R !,"Enter low  dictionary number: ",XBRLO:$G(DTIME,999)
 Q:XBRLO'=+XBRLO
HI ;
 R !,"Enter high dictionary number: ",XBRHI:$G(DTIME,999)
 Q:XBRHI'=+XBRHI!(XBRHI'>XBRLO)
 ;
EN1 ;PEP - Clean residual entries in ^DD(.  Hi/Lo file numbers must be set.
 I $D(XBRLO),$D(XBRHI),XBRLO=+XBRLO,XBRHI=+XBRHI,XBRHI>XBRLO,XBRLO'<2 G RESID
 W !!,"XBRLO and/or XBRHI missing or invalid!"
 G EOJ
 ;
RESID ;
 W !!,"Now checking for residual ^DD entries within range.",!
LOOP ;
 KILL ^TMP("XBRESID",$J)
 S XBRFILE=(XBRLO-.00000001)
 F XBRL=0:0 S XBRFILE=$O(^DD(XBRFILE)) Q:XBRFILE>XBRHI!(XBRFILE'=+XBRFILE)  D CHK
 S XBRFILE=0
 F XBRL=0:0 S XBRFILE=$O(^TMP("XBRESID",$J,XBRFILE)) Q:XBRFILE=""  I ^(XBRFILE),$D(^TMP("XBRESID",$J,^TMP("XBRESID",$J,XBRFILE)))!($D(^DIC(^TMP("XBRESID",$J,XBRFILE)))) S ^TMP("XBRESID",$J,XBRFILE)="I"
 S (XBRFILE,XBRY)=0
 F XBRL=0:0 S XBRFILE=$O(^TMP("XBRESID",$J,XBRFILE)) Q:XBRFILE=""  I ^TMP("XBRESID",$J,XBRFILE)'="I" S XBRY=1 W !,XBRFILE KILL ^DD(XBRFILE)
 G:XBRY LOOP
 G EOJ
 ;
CHK ;
 W "."
 Q:$D(^DIC(XBRFILE))
 I $D(^DD(XBRFILE,0,"UP")),^("UP")]"",(^("UP")<XBRLO!(^("UP")>XBRHI)) Q
 S ^TMP("XBRESID",$J,XBRFILE)=$G(^DD(XBRFILE,0,"UP"))
 Q
 ;
EOJ ;
 D ^XBKTMP
 KILL XBRFILE,XBRHI,XBRL,XBRLO,XBRY
 Q
 ;
