ACPT28PF ;IHS/VEN/TOAD - ACPT*2.08*1 POST1 question ; 04/21/2008 13:35
 ;;2.08;CPT FILES;**1**;DEC 17, 2007
 ;
 ; This is the input transform for question POST1 of the post-init for
 ; ACPT*2.08*1. The input transform is called at POST1 by KIDS at the
 ; beginning of the installation of this patch.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at POST1 by KIDS during installation of
 ; ACPT*2.08*1.
 ;
 ; 2008 04 21 Rick Marshall wrote this routine to improve the directory
 ; prompt, which was originally in the main post-init routine (ACPTPOST,
 ; now called ACPT28PA). The question was moved out into the KIDS build
 ; definition as an installation question, and this routine was created
 ; to house the expanded input transform. Prior to this, no validation
 ; was performed to ensure that the selected directory actually contained
 ; the two files (acpt2008.01h and acpt2008.01c), leading to many errors
 ; during testing. This expanded input transform does just that. Also
 ; worked around a bug in all Cache for UNIX sites in RPMS, in which
 ; their ^%ZOSF("OS") instead says Cache for NT. Also worked around a bug
 ; in $$LIST^%ZISH in which the output array's format is different on
 ; Cache on UNIX, presumably also because of ^%ZOSF("OS") being wrong.
 ;
 ; The original unrefactored code was written by IHS/ASDST/DMJ and Shonda
 ; Render (SDR).
 ;
POST1(ACPTDIR) ; input transform for KIDS question POST1
 ;
 ; .ACPTDIR, passed by reference, is X from the Fileman Reader, the
 ; input to this input transform.
 ;
 I $ZV["UNIX" D  ; if unix, ensure proper syntax for unix
 . S ACPTDIR=$TR(ACPTDIR,"\","/") ; forward slash should delimit
 . S:$E(ACPTDIR)'="/" ACPTDIR="/"_ACPTDIR ; start with root (/)
 . S:$E(ACPTDIR,$L(ACPTDIR))'="/" ACPTDIR=ACPTDIR_"/" ; ensure trailing /
 ;
 E  D  ; otherwise, ensure proper syntax for other operating systems
 . S ACPTDIR=$TR(ACPTDIR,"/","\") ; back slash should delimit
 . I $E(ACPTDIR)'="\",ACPTDIR'[":" D
 . . S ACPTDIR="\"_ACPTDIR ; start with \ if not using : (?)
 . S:$E(ACPTDIR,$L(ACPTDIR))'="\" ACPTDIR=ACPTDIR_"\" ; ensure trailing \
 ;
 W !!,"Checking directory ",ACPTDIR,"..."
 ;
 N ACPTFIND S ACPTFIND=0 ; do we find our files in that directory?
 D  ; find out whether that directory contains those files
 . N ACPTFILE S ACPTFILE("acpt2008.01h")="" ; HCPCS description file
 . S ACPTFILE("acpt2008.01c")="" ; HCPCS modifiers file
 . N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTFIND")
 . D  Q:ACPTFIND  ; format for most platforms:
 . . Q:'$D(ACPTFIND("acpt2008.01h"))
 . . Q:'$D(ACPTFIND("acpt2008.01c"))
 . . S ACPTFIND=1
 . D  ; format for Cache on UNIX
 . . Q:'$D(ACPTFIND(ACPTDIR_"acpt2008.01h"))
 . . Q:'$D(ACPTFIND(ACPTDIR_"acpt2008.01c"))
 . . S ACPTFIND=1
 ;
 I $D(ACPTFIND("acpt2008.01h"))!$D(ACPTFIND(ACPTDIR_"acpt2008.01h")) D
 . W !,"HCPCS Description file acpt2008.01h found."
 I $D(ACPTFIND("acpt2008.01c"))!$D(ACPTFIND(ACPTDIR_"acpt2008.01c")) D
 . W !,"HCPCS Modifiers file acpt2008.01c found."
 ;
 I ACPTFIND D  Q  ; if they picked a valid directory
 . W !!,"Thank you. Both files are in that directory."
 . W !,"Proceeding with the install of ACPT*2.08*1."
 ;
 W !!,"I'm sorry, but that cannot be correct."
 W !,"Directory ",ACPTDIR," does not contain both files."
 ;
 D
 . N ACPTFILE S ACPTFILE("*")=""
 . N ACPTLIST
 . N Y S Y=$$LIST^%ZISH(ACPTDIR,"ACPTFILE","ACPTLIST")
 . W !!,"Directory ",ACPTDIR," contains the following files:"
 . N ACPTF S ACPTF="" F  S ACPTF=$O(ACPTLIST(ACPTF)) Q:ACPTF=""  D
 . . W !?5,ACPTF
 ;
 W !!,"Please select a directory that contains both HCPCS files."
 K ACPTDIR
 ;
 QUIT  ; end of POST1
 ;
 ;
 ; end of routine ACPT28PF
