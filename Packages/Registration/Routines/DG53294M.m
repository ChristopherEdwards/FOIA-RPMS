DG53294M ;ALB/RTK DG*5.3*318 MT Cleanup Mailman Msg ; 10/23/00
 ;;5.3;Registration;**294**;Aug 13, 1993
 ;
 ; This routine will be run at sites as part of the Ineligible
 ; project ELIGIBILITY VERIF. SOURCE reset in patch DG*5.3*294.
 ;
 ; A mail message will be sent to the user when the edit process
 ; is complete.
 ;
 ;
MAIL ; Send a mailman msg to user with results
 N DIFROM,%
 N DATA,DATA1,FILE,FLD,IENX,NODE,TEXT,I,X,XMDUZ,XMSUB,XMTEXT,XMY,Y,STA
 K ^TMP("DG53294",$J)
 S XMSUB="ELIGIBILITY VERIF. SOURCE Edit"
 S XMDUZ="DG Edit Package",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^TMP(""DG53294"",$J,"
 D NOW^%DTC S Y=% D DD^%DT
 S ^TMP("DG53294",$J,1)="ELIGIBILITY VERIF SOURCE Edit Cleanup"
 S ^TMP("DG53294",$J,2)="  "
 S TEXT="Recs Scanned"
 S TEXT=$$BLDSTR("# of ELIGIBILITY VERIF. SOURCE Sets",TEXT,20,35)
 S ^TMP("DG53294",$J,3)=TEXT
 S ^TMP("DG53294",$J,4)=$$REPEAT^XLFSTR("=",$L(TEXT))
 S NODE=4
 S DATA=^XTMP("DG-SRCSET",1)
 S TEXT=^XTMP("DG-SRCREC",1)
 S TEXT=$$BLDSTR(DATA,TEXT,20,$L(DATA))
 S NODE=NODE+1
 S ^TMP("DG53294",$J,NODE)=TEXT
 F I=1:1:2 S NODE=NODE+1,^TMP("DG53294",$J,NODE)=" "
 ;
 ; add error reports to the mail message
 I $O(^XTMP("DG-SRCERR",0))'="" D
 .S NODE=NODE+1
 .S ^TMP("DG53294",$J,NODE)="Some records were not edited due to filing errors:"
 .S NODE=NODE+1
 .S ^TMP("DG53294",$J,NODE)=" "
 .S TEXT="File #"
 .S TEXT=$$BLDSTR("Record #",TEXT,12,8)
 .S TEXT=$$BLDSTR("Node",TEXT,22,9)
 .S TEXT=$$BLDSTR("Error Message",TEXT,32,13)
 .S NODE=NODE+1
 .S ^TMP("DG53294",$J,NODE)=TEXT
 .S FILE=""
 .F  S FILE=$O(^XTMP("DG-SRCERR",FILE)) Q:FILE=""  D
 ..S TEXT=FILE
 ..S IENX=""
 ..F  S IENX=$O(^XTMP("DG-SRCERR",FILE,IENX)) Q:IENX=""  D
 ...S FLD=""
 ...F  S FLD=$O(^XTMP("DG-SRCERR",FILE,IENX,FLD)) Q:FLD=""  D
 ....S DATA=^XTMP("DG-SRCERR",FILE,IENX,FLD)
 ....S TEXT=$$BLDSTR(IENX,TEXT,12,$L(IENX))
 ....S TEXT=$$BLDSTR(FLD,TEXT,22,$L(FLD))
 ....S TEXT=$$BLDSTR(DATA,TEXT,32,$L(DATA))
 ....S NODE=NODE+1
 ....S ^TMP("DG53294",$J,NODE)=TEXT
 ;
MAIL1 D ^XMD
 K ^TMP("DG53294",$J)
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
