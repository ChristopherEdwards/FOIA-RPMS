DG53296M ;ALB/JAT DG*5.3*296 POST-INSTALL TO MAILMAN MSG;01 JUNE 2000
 ;;5.3;Registration;**296**;JUNE 1 2000
 ;
 ;This was copied from DG53285M
 ;
 ;This routine will be run as part of the post-install for patch
 ;DG*5.3*296
 ;
 ;A mail message will be sent to the user when the post-install is
 ; complete.
 ;
 ;
MAIL ; Send a mailman msg to user with results
 N DIFROM,%
 N DATA,DATA1,FILE,FLD,IENX,IY,NODE,TEXT,I,X,XMDUZ,XMSUB,XMTEXT,XMY,Y,STA
 K ^TMP("DG53296",$J)
 S XMSUB="Purge of Duplicate Means Tests"
 S XMDUZ="IVM/HEC PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^TMP(""DG53296"",$J,"
 D NOW^%DTC S Y=% D DD^%DT
 S ^TMP("DG53296",$J,1)="Purge of Duplicate Means Tests"
 S ^TMP("DG53296",$J,2)="  "
 S TEXT="Income year"
 S TEXT=$$BLDSTR("# of IVM MT purged",TEXT,20,18)
 S ^TMP("DG53296",$J,3)=TEXT
 S ^TMP("DG53296",$J,4)=$$REPEAT^XLFSTR("=",$L(TEXT))
 S IY=0,NODE=4
 F  S IY=$O(^XTMP("DG-AMTIY",IY))  Q:'IY  D
 . S DATA=^XTMP("DG-AMTIY",IY)
 . S TEXT=IY+1700
 . S DATA1=$J(+$P(DATA,U),6)
 . S TEXT=$$BLDSTR(DATA1,TEXT,20,$L(DATA1))
 . S NODE=NODE+1
 . S ^TMP("DG53296",$J,NODE)=TEXT
 F I=1:1:2 S NODE=NODE+1,^TMP("DG53296",$J,NODE)=" "
 ;
 ; add error reports to the mail message
 I $O(^XTMP("DG-AMTERR",0))'="" D
 .S NODE=NODE+1
 .S ^TMP("DG53296",$J,NODE)="Some records were not edited due to filing errors:"
 .S NODE=NODE+1
 .S ^TMP("DG53296",$J,NODE)=" "
 .S TEXT="File #"
 .S TEXT=$$BLDSTR("Record #",TEXT,12,8)
 .S TEXT=$$BLDSTR("Field #",TEXT,22,7)
 .S TEXT=$$BLDSTR("Error Message",TEXT,30,13)
 .S NODE=NODE+1
 .S ^TMP("DG53296",$J,NODE)=TEXT
 .S FILE=0
 .F  S FILE=$O(^XTMP("DG-AMTERR",FILE)) Q:'FILE  D
 ..S TEXT=FILE
 ..S IENX=0
 ..F  S IENX=$O(^XTMP("DG-AMTERR",FILE,IENX)) Q:'IENX  D
 ...S FLD=0
 ...F  S FLD=$O(^XTMP("DG-AMTERR",FILE,IENX,FLD)) Q:'FLD  D
 ....S DATA=^XTMP("DG-AMTERR",FILE,IENX,FLD)
 ....S TEXT=$$BLDSTR(IENX,TEXT,12,$L(IENX))
 ....S TEXT=$$BLDSTR(FLD,TEXT,22,$L(FLD))
 ....S TEXT=$$BLDSTR(DATA,TEXT,30,$L(DATA))
 ....S NODE=NODE+1
 ....S ^TMP("DG53296",$J,NODE)=TEXT
 ;
MAIL1 D ^XMD
 K ^TMP("DG53296",$J),^XTMP("DG-AMTERR"),^XTMP("DG-AMTIY")
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
