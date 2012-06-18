PXRMEXLB ;SLC/PJH - Reminder Dialog Exchange. ;12/19/2001
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;
 ;=====================================================================
 ;
 ;Build list of dialog components - called once from PXRMEXLC
 ;-------------------------------
DBUILD(IND,NITEMS,FILENUM) ;
 N DARRAY,DDATA,DDLG,DEND,DLOC,DMAP,DNAM,DNODE,DSEQ,DSTRT,DSUB,JND
 ;
 K ^TMP("PXRMEXTMP",$J),^TMP("PXRMEXFND",$J)
 ;
 ;Scan dialog components in 120 and save name and type
 S JND=0
 F  S JND=$O(^PXD(811.8,IEN,120,IND,1,JND)) Q:'JND  D
 .S DDATA=$G(^PXD(811.8,IEN,120,IND,1,JND,0)) Q:DDATA=""
 .S DNAM=$P(DDATA,U),DSTRT=$P(DDATA,U,2),DEND=$P(DDATA,U,3)
 .;Extract dialog type and text and findings from exchange file
 .D DPARSE
 ;Scan dialog components in 120 and save dialog links
 S JND="B"
 F  S JND=$O(^PXD(811.8,IEN,120,IND,1,JND),-1) Q:'JND  D
 .S DDATA=$G(^PXD(811.8,IEN,120,IND,1,JND,0)) Q:DDATA=""
 .S DSTRT=$P(DDATA,U,2),DEND=$P(DDATA,U,3)
 .S DDLG=$P(DDATA,U),DSUB=DSTRT+2
 .I JND=NITEMS D
 ..S ^TMP("PXRMEXTMP",$J,"PXRMDNAM")=DDLG
 ..I $P($G(^PXD(811.8,IEN,100,DSUB,0)),";",3)'["100~NATIONAL" Q
 ..S ^TMP("PXRMEXTMP",$J,"PXRMDNAT")=""
 .F  S DSUB=$O(^PXD(811.8,IEN,100,DSUB)) Q:DSUB>DEND  D
 ..S DNODE=$G(^PXD(811.8,IEN,100,DSUB,0)) I $P(DNODE,";")'="801.412" Q
 ..S DNODE=$P(DNODE,";",3) I $E(DNODE,1,4)'=".01~" Q
 ..S DSEQ=$P(DNODE,"~",2) Q:DSEQ=""
 ..S DNODE=$G(^PXD(811.8,IEN,100,DSUB+1,0)) I $P(DNODE,";")'="801.412" Q
 ..S DNODE=$P(DNODE,";",3) I $E(DNODE,1,2)'="2~" Q
 ..S DNAM=$P(DNODE,"~",2) Q:DNAM=""
 ..S DLOC=$G(^TMP("PXRMEXTMP",$J,"DLOC",DNAM))
 ..S ^TMP("PXRMEXTMP",$J,"DMAP",DDLG,DSEQ)=DNAM_U_DLOC
 ;
 ;Build index of dialog findings by name
 ;
 ;// This index will be unique with PKR's changes to the way findings
 ;// are stored in FDA. The section number may be needed to determine 
 ;// if a rename has been done.
 ;
 N FDATA,FILENAM,FILENUM,FNAME
 S IND=0
 F  S IND=$O(^PXD(811.8,IEN,120,IND)) Q:'IND  D
 .S FDATA=$G(^PXD(811.8,IEN,120,IND,0)) Q:FDATA=""
 .S FILENAM=$P(FDATA,U),FILENUM=$P(FDATA,U,2) Q:FILENAM=""  Q:'FILENUM
 .;Ignore reminder dialogs
 .I FILENAM="REMINDER DIALOG" Q
 .;Ignore reminder terms
 .I FILENAM="REMINDER TERM" Q
 .;Strip off trailing S in finding file name
 .I $E(FILENAM,$L(FILENAM))="S" S $E(FILENAM,$L(FILENAM))=""
 .S JND=0
 .F  S JND=$O(^PXD(811.8,IEN,120,IND,1,JND)) Q:'JND  D
 ..S FNAME=$P($G(^PXD(811.8,IEN,120,IND,1,JND,0)),U) Q:FNAME=""
 ..;Save entry
 ..S ^TMP("PXRMEXFND",$J,FNAME)=FILENUM_U_FILENAM_U_IND
 Q
 ;
 ;Scan exchange file to get dialog fields
 ;---------------------------------------
DPARSE N DCNT,DFIND,DFIAD,DFNAM,DFQUIT,DLCT,DLINES,DSUB,DTEXT,DTXT,DTYP
 ;
 ;Find where all the field numbers are kept
 N DARRAY,DDATA,DFNUM,DRAW,DSTRING
 S DSUB=DSTRT,DSTRING=";4;5;15;24;25;"
 F  S DSUB=$O(^PXD(811.8,IEN,100,DSUB)) Q:'DSUB  D  Q:DSUB>DEND
 .S DDATA=$G(^PXD(811.8,IEN,100,DSUB,0)) Q:DDATA=""
 .I $P(DDATA,";")'=801.41 Q
 .S DFNUM=$P(DDATA,";",3),DFNUM=$P(DFNUM,"~") Q:DFNUM=""
 .I DSTRING[(";"_DFNUM_";") S DARRAY(DFNUM)=DSUB
 ;
 ;Determine dialog component type
 S DSUB=DARRAY(4) Q:'DSUB
 S DTYP=$P($G(^PXD(811.8,IEN,100,DSUB,0)),"~",2)
 S:DTYP[" " DTYP=$P(DTYP," ",2) S:DTYP="value" DTYP="forced"
 ;
 ;Initialise text and finding fields
 S DTXT="*NONE*",DFIND=""
 ;Get text appropriate for the type of component
 I (DTYP="element")!(DTYP="group") D
 .;search for WP text
 .S DSUB=$G(DARRAY(25)) D:DSUB
 ..S DTEXT=$P($G(^PXD(811.8,IEN,100,DSUB,0)),";",3) Q:DTEXT=""
 ..;Get the line count
 ..S DLINES=$P(DTEXT,"~",3),DCNT=0
 ..;Get the wp text lines
 ..F DLCT=DSUB+1:1:DSUB+DLINES D
 ...S DTEXT=$G(^PXD(811.8,IEN,100,DLCT,0))
 ...S DCNT=DCNT+1,DTXT(DCNT)=DTEXT
 ...;Check for embedded TIU templates
 ...D DTIU(DNAM,DTEXT)
 ..;Reformat text to 50 characters
 ..D DWP(.DTXT)
 .;
 .;Search for finding item
 .S DSUB=$G(DARRAY(15)) D:DSUB
 ..S DFIND=$P($G(^PXD(811.8,IEN,100,DSUB,0)),";",3) Q:DFIND=""
 ..;Finding name
 ..S DFIND=$P(DFIND,"~",2) Q:DFIND=""
 ..I $P(DFIND,".")="ICD9" S DFIND=$P(DFIND," ")
 .;
 .;Search for additional finding - start after WP text
 .S DSUB=+$G(DARRAY(25)) D:DSUB
 ..S DCNT=0,DFQUIT=0
 ..F DLCT=DSUB+1+DLINES:1 D  Q:DFQUIT  Q:DLCT>DEND
 ...S DTEXT=$G(^PXD(811.8,IEN,100,DLCT,0))
 ...;Ignore line if this is not an additional finding
 ...I $P(DTEXT,";")'=801.4118 S:$P(DTEXT,";")>801.4118 DFQUIT=1 Q
 ...S DFNAM=$P(DTEXT,"~",2) Q:DFNAM=""
 ...I $P(DFNAM,".")="ICD9" S DFNAM=$P(DFNAM," ")
 ...S DCNT=DCNT+1,DFIAD(DCNT)=DFNAM
 ;
 I DTYP="prompt" D
 .;search for prompt caption
 .S DSUB=$G(DARRAY(24)) Q:'DSUB
 .S DTEXT=$P($G(^PXD(811.8,IEN,100,DSUB,0)),";",3) Q:DTEXT=""
 .S DTXT=$P(DTEXT,"~",2)
 ;
 I DTYP="group" D
 .;search for group caption
 .S DSUB=$G(DARRAY(5)) Q:'DSUB
 .S DTEXT=$P($G(^PXD(811.8,IEN,100,DSUB,0)),";",3) Q:DTEXT=""
 .S DTXT=$P(DTEXT,"~",2)
 .Q
 ;
 ;Save dialog type
 S ^TMP("PXRMEXTMP",$J,"DTYP",DNAM)=DTYP
 ;Save dialog component text (first line only)
 S ^TMP("PXRMEXTMP",$J,"DTXT",DNAM)=DTXT
 ;
 ;Save main finding
 I DFIND]"" S ^TMP("PXRMEXTMP",$J,"DFND",DNAM,1)=$P(DFIND,".",2,99)
 ;Save additional findings
 S DSUB=0
 F   S DSUB=$O(DFIAD(DSUB)) Q:'DSUB  D
 .S ^TMP("PXRMEXTMP",$J,"DFND",DNAM,DSUB+1)=$P(DFIAD(DSUB),".",2,99)
 ;
 ;Save additional WP text lines
 S DSUB=0
 F   S DSUB=$O(DTXT(DSUB)) Q:'DSUB  D
 .S ^TMP("PXRMEXTMP",$J,"DTXT",DNAM,DSUB)=DTXT(DSUB)
 ;
 ;Save dialog's position in exchange file
 S ^TMP("PXRMEXTMP",$J,"DLOC",DNAM)=DSTRT_U_DEND_U_IND_U_JND
 Q
 ;
 ;Extract any TIU templates
 ;-------------------------
DTIU(DNAM,TEXT) ;
 N IC,TCNT,TLIST,TNAM
 ;Templates are in format {FLD:fldname}
 S TCNT=0 D TIUXTR^PXRMEXDG("{FLD:","}",TEXT,.TLIST,.TCNT) Q:'TCNT
 ;
 F IC=1:1:TCNT D
 .S TNAM=$G(TLIST(TCNT)) Q:TNAM=""
 .S ^TMP("PXRMEXTMP",$J,"DTIU",DNAM,TNAM)=""
 Q
 ;
 ;Process WP fields
 ;-----------------
DWP(TEXT) ;
 N DIWF,DIWL,DIWR,IC,X
 S DIWF="C50",DIWL=0,DIWR=50
 ;
 K ^UTILITY($J,"W")
 S IC=""
 F  S IC=$O(TEXT(IC)) Q:IC=""  D
 .S X=TEXT(IC)
 .D ^DIWP
 ;
 K TEXT
 S IC=0
 F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 .S DTEXT=$G(^UTILITY($J,"W",0,IC,0))
 .I IC=1 S TEXT=DTEXT Q
 .S TEXT(IC-1)=DTEXT
 ;
 K ^UTILITY($J,"W")
 Q
