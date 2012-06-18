DG53376M ;;ALB/RTK DG*5.3*376 Edit Cat A Edit Mailman Msg; 04/11/01
 ;;5.3;Registration;**376**;Aug 13, 1993
 ;
 ; This routine will be run as part of the Cat A MT Edit in
 ; patch DG*5.3*376.
 ;
 ; A mail message will be sent to the user when the process
 ; is complete.
 ;
 ;
MAIL ; Send a mailman msg to user with results
 N DIFROM,%
 N DATA,DATA1,FILE,FLD,IENX,NODE,TEXT,I,X,XMDUZ,XMSUB,XMTEXT,XMY,Y,STA
 K ^TMP("DG53376",$J)
 S XMSUB="Cat A Means Test Edit"
 S XMDUZ="VistA Distribution",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^TMP(""DG53376"","_$J_","
 D NOW^%DTC S Y=% D DD^%DT
 S ^TMP("DG53376",$J,1)="Means Test Edit/Transmission"
 S ^TMP("DG53376",$J,2)="  "
 S TEXT="Means Test Records:"
 S ^TMP("DG53376",$J,3)=TEXT
 S TEXT="Cat A Recs    Edited"
 S ^TMP("DG53376",$J,4)=TEXT
 S ^TMP("DG53376",$J,5)=$$REPEAT^XLFSTR("=",$L(TEXT))
 S NODE=5
 S DATA=^XTMP("DG-EDIT",1)
 S TEXT=^XTMP("DG-MTRC",1)
 S TEXT=$$BLDSTR(DATA,TEXT,16,$L(DATA))
 S NODE=NODE+1
 S ^TMP("DG53376",$J,NODE)=TEXT
 F I=1:1:2 S NODE=NODE+1,^TMP("DG53376",$J,NODE)=" "
 ;
 ; add error reports to the mail message
 I $O(^XTMP("IVM-FERR",0))'="" D
 .S NODE=NODE+1
 .S ^TMP("DG53376",$J,NODE)="Some records were not edited due to filing errors:"
 .S NODE=NODE+1
 .S ^TMP("DG53376",$J,NODE)=" "
 .S TEXT="File #"
 .S TEXT=$$BLDSTR("Record #",TEXT,12,8)
 .S TEXT=$$BLDSTR("MTIEN",TEXT,22,9)
 .S TEXT=$$BLDSTR("Error Message",TEXT,32,13)
 .S NODE=NODE+1
 .S ^TMP("DG53376",$J,NODE)=TEXT
 .S FILE=""
 .F  S FILE=$O(^XTMP("DG-FERR",FILE)) Q:FILE=""  D
 ..S TEXT=FILE
 ..S IENX=""
 ..F  S IENX=$O(^XTMP("DG-FERR",FILE,IENX)) Q:IENX=""  D
 ...S FLD=""
 ...F  S FLD=$O(^XTMP("DG-FERR",FILE,IENX,FLD)) Q:FLD=""  D
 ....S DATA=^XTMP("DG-FERR",FILE,IENX,FLD)
 ....S TEXT=$$BLDSTR(IENX,TEXT,12,$L(IENX))
 ....S TEXT=$$BLDSTR(FLD,TEXT,22,$L(FLD))
 ....S TEXT=$$BLDSTR(DATA,TEXT,32,$L(DATA))
 ....S NODE=NODE+1
 ....S ^TMP("DG53376",$J,NODE)=TEXT
 ;
MAIL1 D ^XMD
 K ^TMP("DG53376",$J)
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
