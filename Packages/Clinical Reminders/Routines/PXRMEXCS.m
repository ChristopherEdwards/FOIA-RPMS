PXRMEXCS ; SLC/PKR - Routines to compute checksums. ;05/16/2001
 ;;1.5;CLINICAL REMINDERS;**5**;Jun 19, 2000
 ;======================================================================
FILE(FILENUM,IEN) ;Return checksum for entry IEN in file FILENUM.
 N CS,IND,LC,REF,ROOT,TARGET
 D FILE^DID(FILENUM,"","GLOBAL NAME","TARGET")
 S ROOT=$$CREF^DILF(TARGET("GLOBAL NAME"))
 M ^TMP("PXRMEXCS",$J)=@ROOT@(IEN)
 S REF="^TMP(""PXRMEXCS"",$J)"
 S REF=$NA(@REF)
 S (CS,LC)=0
 S IND=""
 F  S REF=$Q(@REF) Q:REF'["PXRMEXCS"  D
 . S LC=LC+1
 . S CS=CS+$$LINECS(LC,@REF)
 K ^TMP("PXRMEXCS",$J)
 Q CS
 ;
 ;======================================================================
HFCS(PATH,FILENAME) ;Return checksum for host file.
 N CS,GBL,GBLZISH,SUCCESS
 K ^TMP("PXRMHFCS",$J)
 S GBL="^TMP(""PXRMHFCS"",$J)"
 S GBLZISH="^TMP(""PXRMHFCS"",$J,1)"
 S GBLZISH=$NA(@GBLZISH)
 S SUCCESS=$$FTG^%ZISH(PATH,FILENAME,GBLZISH,3)
 I SUCCESS S CS=$$HFCSGBL(GBL)
 E  S CS=-1
 K ^TMP("PXRMHFCS",$J)
 Q CS
 ;
 ;======================================================================
HFCSGBL(GBL) ;Return checksum for host file loaded into global GBL.
 N IND,LINE
 S (CS,IND)=0
 F  S IND=$O(@GBL@(IND)) Q:+IND=0  D
 . S LINE=@GBL@(IND)
 . S CS=CS+$$LINECS(IND,LINE)
 Q CS
 ;
 ;======================================================================
LINECS(LINENUM,STRING) ;Return checksum of line number LINEUM whose contents
 ;is STRING.
 N CS,IND,LEN
 S CS=0
 S LEN=$L(STRING)
 F IND=1:1:LEN D
 . S CS=CS+($A(STRING,IND)*(LINENUM+IND))
 Q CS
 ;
 ;======================================================================
MMCS(XMZ) ;Return checksum for MailMan message ien XMZ.
 N CS,IND,LINE,NLINES
 S NLINES=+$P($G(^XMB(3.9,XMZ,2,0)),U,3)
 S CS=0
 F IND=1:1:NLINES D
 . S LINE=$G(^XMB(3.9,XMZ,2,IND,0))
 . S CS=CS+$$LINECS(IND,LINE)
 Q CS
 ;
 ;======================================================================
ROUTINE(RA) ;Return checksum for a routine loaded in array RA. RA has the
 ;form created by ^%ZOSF("LOAD") i.e, RA(1,0) ... RA(N,0).
 N CS,IND,LINE
 S (CS,IND)=0
 F  S IND=$O(RA(IND)) Q:+IND=0  D
 . S CS=CS+$$LINECS(IND,RA(IND,0))
 Q CS
 ;
 ;======================================================================
RTN(ROUTINE) ;Return checksum for a routine ROUTINE.
 N CS,DIF,RA,X,XCNP
 S XCNP=0
 S DIF="RA("
 S X=ROUTINE
 ;Make sure the routine exists.
 X ^%ZOSF("TEST")
 I $T D
 . X ^%ZOSF("LOAD")
 . S CS=$$ROUTINE(.RA)
 E  S CS=-1
 Q CS
 ;
