DG53292M ;ALB/RKS DG*5.3*292 POST-INSTALL TO MAILMAN MSG ; 05/22/00
 ;;5.3;Registration;**292**;AUG 13,  1993
 ;
 ;This routine will be run as part of the post-install for patch
 ;DG*5.3*292
 ;
 ;A mail message will be sent to the user when the post-install is 
 ; complete.
 ;
 ;
MAIL ; Send a mailman msg to user with results
 N DIFROM,%
 N DATA,FILE,IENX,NODE,TEXT,X,XMDUZ,XMSUB,XMTEXT,XMY,Y
 K ^TMP("DG53292",$J)
 S XMSUB="Update of DATE/TIME COMPLETED in Annual Means Tests"
 S XMDUZ="DG/HEC PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^TMP(""DG53292"",$J,"
 D NOW^%DTC S Y=% D DD^%DT
 S ^TMP("DG53292",$J,1)="Update of DATE/TIME COMPLETED field in the ANNUAL MEANS TEST file"
 S ^TMP("DG53292",$J,2)="  "
 S TEXT="Number of records updated"
 S ^TMP("DG53292",$J,3)=TEXT
 S ^TMP("DG53292",$J,4)=$$REPEAT^XLFSTR("=",$L(TEXT))
 S ^TMP("DG53292",$J,5)=+$G(^XTMP("DG-DTC"))
 ;
 ; add error reports to the mail message
 I $O(^XTMP("DG-DTCERR",0))'="" D
 . S ^TMP("DG53292",$J,6)="  "
 . S NODE=7
 . S ^TMP("DG53292",$J,NODE)="Some records were not edited due to filing errors:"
 . S NODE=NODE+1
 . S ^TMP("DG53292",$J,NODE)=" "
 . S TEXT="Record #"
 . S TEXT=$$BLDSTR("Error Message",TEXT,12,13)
 . S NODE=NODE+1
 . S ^TMP("DG53292",$J,NODE)=TEXT
 . S TEXT=""
 . S IENX=0
 . F  S IENX=$O(^XTMP("DG-DTCERR",408.31,IENX)) Q:'IENX  D
 . . S TEXT=IENX
 . . S DATA=^XTMP("DG-DTCERR",408.31,IENX)
 . . S TEXT=$$BLDSTR(DATA,TEXT,12,$L(DATA))
 . . S NODE=NODE+1
 . . S ^TMP("DG53292",$J,NODE)=TEXT
 ;
MAIL1 D ^XMD
 K ^TMP("DG53292",$J)
 Q
 ;
BLDSTR(NSTR,STR,COL,NSL) ; build a string
 ; Input:
 ;   NSTR = a string to be added to STR
 ;   STR  = an existing string to which NSTR will be added
 ;   COL  = column location at which NSTR will be added to STR
 ;   NSL  = length of new string
 ; Output:
 ;   returns STR with NSTR appended at the specified COL
 ;
 Q $E(STR_$J("",COL-1),1,COL-1)_$E(NSTR_$J("",NSL),1,NSL)_$E(STR,COL+NSL,999)
