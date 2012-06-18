AGHL7 ; IHS/ASDS/EFG -- LOOP THROUGH XTMP USING DFN  ;  
 ;;7.1;PATIENT REGISTRATION;**9**;AUG 25,2005
 ;
START ;EP-HL7 CALL
 NEW DFN,INDA,DZ2,AGDUZ2
 S DZ2="" F  S DZ2=$O(^XTMP("AGHL7",DZ2)) Q:DZ2=""  S DFN="" F  S DFN=$O(^XTMP("AGHL7",DZ2,DFN)) Q:+DFN=0  D
 .L +^XTMP("AGHL7",DZ2,DFN):0 Q:'$T
 . S X=$O(^XTMP("AGHL7",DZ2,DFN,"")),X="AG "_X_" A PATIENT",DIC=101,INDA=DFN,AGDUZ2=DZ2
 . D EN^XQOR
 .K ^XTMP("AGHL7",DZ2,DFN)
 .L -^XTMP("AGHL7",DZ2,DFN)
 Q
 ; PROGRAMMERS NOTE:
 ; THIS ROUTINE IS CALLED, FROM THE TOP, BY A BHL ROUTINE, WITHOUT
 ; ANY AGREEMENT AMONG PACKAGES OR DEVELOPERS.  TO PREVENT BREAKING
 ; THE BHL ROUTINE, ANOTHER ENTRY POINT FOR THE AGMENU OPTION IS
 ; CREATED, BELOW, AND THE ABOVE CODE WILL REMAIN UNCHANGED.
 ;              George T. Huggins, June 2002
 ;
 ; The AG entry point is called from the Exit Action field of the
 ; AGMENU option.
 ;
 ; Variable DFN is KILL'd by KILL^AG, called from the Exit Action field
 ; of the AGMENU option.
 ;
 ; B/c of the spaghetti-code nature of AG, a Patient could be marked as
 ; having been updated during the entry of the patient as a new Patient.
 ;
 ; The REGISTER/UPDATE locations in AG mark the ^XTMP global as:
 ;       ^XTMP("AGHL7AG",SITE,1234,"REGISTER")=""
 ;       ^XTMP("AGHL7AG",SITE,1234,"UPDATE")=""
 ; so the SET'ing of X will get "REGISTER" -if- both have occured, and
 ; -only- invoke the "AG REGISTER A PATIENT" protocol.
 ;
AG ;EP - From AGMENU, EXIT ACTION.
 NEW DFN,DZ2,INDA,AGDFN,AGDUZ2
 S DZ2="" F  S DZ2=$O(^XTMP("AGHL7AG",DZ2)) Q:DZ2=""  D
 . S DFN="" F  S DFN=$O(^XTMP("AGHL7AG",DZ2,DFN)) Q:+DFN=0  D
 .. LOCK +^XTMP("AGHL7AG",DZ2,DFN):0
 .. E  Q
 .. S X=$O(^XTMP("AGHL7AG",DZ2,DFN,"")),X="AG "_X_" A PATIENT",DIC=101,(AGDFN,INDA)=DFN,AGDUZ2=DZ2
 .. D EN^XQOR
 .. KILL ^XTMP("AGHL7AG",DZ2,DFN)
 .. LOCK -^XTMP("AGHL7AG",DZ2,DFN)
 Q
XPORT ;EP - From TaskMan for regular xport.
 NEW AGDUZ2,AGTIME,AGQUIT,AGTXBDT,AGTXDATE,DFN,DIC,INDA
 S AGTIME=$$NOW^XLFDT
 W:'$D(ZTQUEUED) !,"Beginning Regular Xport @ ",$$FMTE^XLFDT(AGTIME)
 ;Check if regular export run today.  If so, quit.
 ;>>>  need code
 I '$G(DUZ(2)) S DUZ(2)=$P(^AUTTSITE(1,0),U)
 S AGDUZ2=DUZ(2)
 KILL ^TMP("AGHL7",$J,"REGULAR XPORT")
 W:'$D(ZTQUEUED) !,"Determining start date..."
 ;If nothing in ag message file, get seed from agtxst.  This'll be like an RG export:  send all adds/edits from the date of the last export, thru -yesterday-.
 I '$O(^AGTXMSG(0)) D  I 1
 . NEW AGTXSITE,AGLIEN
 . S AGTXSITE=$P(^AUTTSITE(1,0),U)
 . D AGR1^AGTXST
 . S AGTXBDT=$S($G(AGLIEN):$P(^AGTXST(AGTXSITE,1,AGLIEN,0),U,3),1:0),AGTXBDT=$P(AGTXBDT,".",1)
 . ;AGTXBDT is ready to go.
 .Q
 E  D
 . S %=$P(^AGTXMSG(0),U,3)+1
 . ;Backup and find the first regular xport.
 . F  S %=$O(^AGTXMSG(%),-1) Q:'%  I $P(^(%,0),U,3)="X" Q
 . ;We have to subtract a day.
 . S AGTXBDT=$S(%:$P($P(^AGTXMSG(%,0),U),".",1),1:0),AGTXBDT=$$FMADD^XLFDT(""_AGTXBDT_"",-1)
 .Q
 W:'$D(ZTQUEUED) $$FMTE^XLFDT(AGTXBDT)
 ;Check for NEW pats in ^aupnpat,  keep track, enter in ag message.
 ;
 W:'$D(ZTQUEUED) !,"Checking for NEW Patients...",!
 S AGTXDATE=AGTXBDT
 F  S AGTXDATE=$O(^AUPNPAT("ADTE",AGTXDATE)) Q:('AGTXDATE)!(AGTXDATE=DT)  D
 . S DFN=0
 . F  S DFN=$O(^AUPNPAT("ADTE",AGTXDATE,DFN)) Q:'DFN  D
 .. W:'$D(ZTQUEUED) $J(DFN,8)
 .. D GEN("REGISTER","X",DFN)
 .. SET ^TMP("AGHL7",$J,"REGULAR XPORT",DFN,"REGISTER")=""
 ..Q
 .Q
 ;Check for edited pats in ^aupnpat.  dont's send update if register.
 W:'$D(ZTQUEUED) !,"Checking for EDITED Patients...",!
 S DFN=0
 F  S DFN=$O(^AUPNPAT(DFN)) Q:+DFN=0  D
 . Q:'($P(^AUPNPAT(DFN,0),U,3)>AGTXBDT)  ;edit must be after seed date.
 . Q:$P(^AUPNPAT(DFN,0),U,3)=DT  ;edit is TODAY.
 . Q:$P(^DPT(DFN,0),U,19)  ;merged pt
 . Q:$D(^TMP("AGHL7",$J,"REGULAR XPORT",DFN,"REGISTER"))
 . S (AGQUIT,DUZ(2))=0
 . F  S DUZ(2)=$O(^AUPNPAT(DFN,41,DUZ(2))) Q:'DUZ(2)  D  Q:AGQUIT
 .. Q:'$D(^AGFAC("AC",DUZ(2)))  ; ORF
 .. I $L($P(^AUPNPAT(DFN,41,DUZ(2),0),U,5)) Q:"DM"[$P(^(0),U,5)  ; deleted or merged patient
 .. W:'$D(ZTQUEUED) $J(DFN,8)
 .. D GEN("UPDATE","X",DFN)
 .. S AGQUIT=1
 ..Q
 .Q
 S DUZ(2)=AGDUZ2
 KILL ^TMP("AGHL7",$J,"REGULAR XPORT")
 ;check for ACKs for all previous messages.
 D MSGIDS
 ;re-q xport task
 ;>>>need code
 ;
 S $P(AGTIME,U,2)=$$NOW^XLFDT
 Q:$D(ZTQUEUED)
 W !,"Ending Regular Xport @ ",$$FMTE^XLFDT($P(AGTIME,U,2)),!,"Elapsed time: ",$S($P(AGTIME,U,2)=$P(AGTIME,U):"Less than a second.",1:$$FMDIFF^XLFDT($P(AGTIME,U,2),$P(AGTIME,U,1),3))
 I $$DIR^XBDIR("E")
 Q
REGALL ;EP - From menu.
 ;; This option sends a "REGISTER" message to the Integration Engine
 ;; for all active Patients in your database.
 ;;
 ;;###
 D HELP^XBHELP("REGALL","AGHL7")
 Q:'$$DIR^XBDIR("YO","Proceed","N","","Do you want to proceed and send a ""REGISTER"" message for all Pat's to the IE (Y/N)")
 NEW AG4,AGB,AGC,AGE,AGDUZ2,DFN,DIC,INDA
 S AGB=$$NOW^XLFDT
 W !,"Begin at ",$$FMTE^XLFDT(AGB),"."
 S AGDUZ2=DUZ(2),DFN=0,AG4=$P(^AUPNPAT(0),U,4),AGC=0
 W !,AG4," Patients",!
 F  S DFN=$O(^AUPNPAT(DFN)) Q:+DFN=0  D
 . Q:'$D(^DPT(DFN))
 . Q:$P(^DPT(DFN,0),U,19)  ;merged pt
 . S DUZ(2)=0
 . F  S DUZ(2)=$O(^AUPNPAT(DFN,41,DUZ(2))) Q:'DUZ(2)  D
 .. Q:'$D(^AGFAC("AC",DUZ(2)))  ;ORF
 .. I $L($P(^AUPNPAT(DFN,41,DUZ(2),0),U,5)) Q:"DM"[$P(^(0),U,5)  ; deleted or merged patient
 .. D GEN("REGISTER","A",DFN)
 ..Q
 . S AGC=AGC+1
 . I '(AGC#100) W " | ",$J(AGC/AG4*100,0,0),"%"
 .Q
 S DUZ(2)=AGDUZ2
 S AGE=$$NOW^XLFDT
 W !,"  End at ",$$FMTE^XLFDT(AGE),"."
 W !,"Elapsed time: ",$$FMDIFF^XLFDT(AGE,AGB,3)
 I $$DIR^XBDIR("E","Done.  Press RETURN")
 Q
GEN(AGTYPE,AGCAUSE,INDA)       ;
 NEW DA,DIC,DR,INHF,X
 S X="AG "_AGTYPE_" A PATIENT",DIC=101
 D EN^XQOR
 D TXMSG(DFN,AGTYPE,AGCAUSE,INHF)
 Q
TXMSG(DFN,AGTYPE,AGCAUSE,INHF) ;make entry into agtxmsg
 NEW DA,DIC,DR,X
 S X=$$NOW^XLFDT,AGTYPE=$S(AGTYPE="REGISTER":"A28",AGTYPE="UPDATE":"A08",1:"Z00")
 KILL DD,DO,DIC,DA,DR
 S DIC="^AGTXMSG(",DIC(0)="L",DIC("DR")=".02////"_DFN_";.03///"_AGCAUSE_";.04////2600101;.05////2600101;.06///H;.07///"_AGTYPE_";.08////"_INHF
 D FILE^DICN
 Q
MSGIDS ;TM a job to update date/time msg sent, ack received.
 S ZTRTN="MSGIDSTM^AGHL7",ZTIO="",ZTDESC="Update AG MESSAGE TRANSACTONS file.",ZTDTH=$H,ZTDTH=$$HADD^XLFDT($H,0,0,30,0)
 D ^%ZTLOAD
 Q
MSGIDSTM       ;EP - from TaskMan.
 NEW AGIEN,AGXREF,DA,DIC,DIE,DR,X
 F AGXREF="D","E" D
 . S AGIEN=0
 . F  S AGIEN=$O(^AGTXMSG("D",2600101,AGIEN)) Q:'AGIEN  D
 .. S X="IHS-"_$P(^AGTXMSG(AGIEN,0),U,8),DIC="^INTHU(",DIC(0)="",D="C"
 .. D IX^DIC
 .. Q:'(+Y>0)
 .. S DIE="^AGTXMSG(",DA=AGIEN,DR=".04////"_$P(Y,U,2)
 .. I $P(^INTHU(DA,0),U,18) S DR=DR_";.05////"_$P(^INTHU($P(^INTHU(DA,0),U,18),0),U,1)
 .. D ^DIE
 ..Q
 .Q
 S ZTREQ="@"
 Q
