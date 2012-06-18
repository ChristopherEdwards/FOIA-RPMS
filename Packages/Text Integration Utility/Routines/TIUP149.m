TIUP149 ;SLC/RMO - Post-Install for TIU*1*149 ;10/28/02@09:51:20
 ;;1.0;Text Integration Utilities;**149**;Jun 20, 1997
 ;
EN ;Entry point to queue a job to clean up certain documents
 ;linked to a different patient's visit
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK
 ;
 W !!,"PATCH TIU*1*149"
 W !!,"Search ALL entries in the TIU Document file (#8925) to link or"
 W !,"unlink documents associated with a different patient's visit that"
 W !,"meet the following criteria:"
 W !!,"- Addenda or components where the parent points to the correct visit will"
 W !,"  be linked, otherwise the addenda or components will be unlinked if they"
 W !,"  are associated with an incorrect visit different than the parent."
 W !!,"- Documents where the capture method is converted and a visit"
 W !,"  exists will be linked, otherwise the document will be unlinked"
 W !,"  from the incorrect visit."
 W !!,"- Documents where the reference date is prior to 10/1/98 will"
 W !,"  be unlinked from the incorrect visit."
 W !!,"- Documents that are Discharge Summaries will be unlinked"
 W !,"  from the incorrect visit."
 W !
 ;
 ;Set variables
 S ZTRTN="CLNUP^TIUP149",ZTIO="",ZTSAVE("DUZ")=""
 S ZTDESC="Clean up TIU Documents Different Patient's Visit - Patch 149"
 D ^%ZTLOAD
 I $G(ZTSK) D
 . W !!,"A task has been queued in the background and a bulletin will be sent"
 . W !,"to you upon completion of the task or if the task is stopped."
 . W !!,"The task number is "_$G(ZTSK)_"."
 Q
 ;
CLNUP ;Entry point to clean up documents pointing to a different patient's
 ;visit
 ; Input  -- None
 ; Output -- ^XTMP("TIUP149", Global
 N NDBIF,TIUDA,TIUS,TIURSTDA
 ;
 ;Initialize re-start if check point exists
 I +$G(^XTMP("TIUP149","CHKPT")) D
 . S TIURSTDA=+$G(^XTMP("TIUP149","CHKPT"))
 ELSE  D
 . ;Clean up ^XTMP("TIUP149")
 . K ^XTMP("TIUP149"),^XTMP("TIU/PXAPI")
 . ;Initialize ^XTMP("TIUP149" if not re-start
 . S ^XTMP("TIUP149",0)=$$FMADD^XLFDT(DT,90)_U_DT
 . S ^XTMP("TIUP149","CNT","EX")=0 F TIUS=1:1:3 S ^XTMP("TIUP149","CNT","EX",TIUS)=0
 . S ^XTMP("TIUP149","CNT","LNK")=0
 . S ^XTMP("TIUP149","CNT","TOT")=0
 . S ^XTMP("TIUP149","CHKPT")=""
 K ^XTMP("TIUP149","STOP")
 S ^XTMP("TIUP149","T0")=$$NOW^XLFDT
 ;
 ;Set integrated facility NDBI flag
 S NDBIF=$$CHKINF
 ;
 ;Loop through documents
 S TIUDA=$S($G(TIURSTDA):TIURSTDA,1:0)
 F  S TIUDA=$O(^TIU(8925,TIUDA)) Q:+TIUDA'>0!($G(ZTSTOP))  I $D(^(TIUDA,0)) D
 . ;Clean up visit for one document
 . D CLNONE(TIUDA,$G(NDBIF))
 . ;
 . ;Set check point for Document IEN
 . S ^XTMP("TIUP149","CHKPT")=TIUDA
 . ;
 . ;Check if user requested to stop task
 . I $$S^%ZTLOAD S ZTSTOP=1
 ;
 ;Send bulletin, re-set check point and clean up variables
 I $G(ZTSTOP) S ^XTMP("TIUP149","STOP")=$$NOW^XLFDT
 S ^XTMP("TIUP149","T1")=$$NOW^XLFDT
 ;
 D MAIL^TIUP149P
 ;
 I '$G(ZTSTOP) S ^XTMP("TIUP149","CHKPT")=""
 K TIURSTDA
 Q
 ;
CHKINF() ;Check if Integrated Facility
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ; Output -- 1=Yes and 0=No
 N Y
 S Y=0
 I $$VERSION^XPDUTL("NDBI PRIMARY SYSTEM") S Y=1
 Q +$G(Y)
 ;
CLNONE(TIUDA,NDBIF) ;Entry point to clean up visit for one document
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ;           NDBIF    Integrated Facility Flag  (Optional)
 ; Output -- None
 N TIUD0,TIUDFN,TIUMVSTF,TIUVSIT,VSIT
 ;
 ;Set variables
 S TIUD0=$G(^TIU(8925,TIUDA,0))
 S TIUDFN=$P(TIUD0,U,2)
 S TIUVSIT=$P(TIUD0,U,3)
 ;
 ;Check if document linked to a different patient's visit can be
 ;cleaned up
 I TIUVSIT>0,TIUDFN>0,+$G(^AUPNVSIT(+TIUVSIT,0)),$P(^(0),U,5)'=TIUDFN,$$CHKDOC(TIUDA,+$P(TIUD0,U,6),+TIUD0) D
 . ;Exclude NDBI records
 . I TIUVSIT=1,$G(NDBIF) D SETXTMP(TIUDA,3) Q
 . ;Get correct visit to associate with document
 . D GETVST(TIUDA,TIUDFN,+$P(TIUD0,U,6),.VSIT,.TIUMVSTF)
 . ;If only one visit update the document with the visit
 . I $G(VSIT)>0,'$G(TIUMVSTF) D
 . . I $G(VSIT),$$UPDVST^TIUPXAP2(TIUDA,VSIT) D
 . . . ;Document linked to visit
 . . . D SETXTMP(TIUDA,,VSIT)
 . . . ;Update kids that are addenda or components
 . . . D UPDKIDS(TIUDA,VSIT)
 . . ELSE  D
 . . . ;Unable to correct - entry in use
 . . . D SETXTMP(TIUDA,1)
 . ELSE  D
 . . ;Unlink document from visit
 . . I $$DELVST(TIUDA) D
 . . . D SETXTMP(TIUDA,2)
 . . . ;Update kids that are addenda or components
 . . . D UPDKIDS(TIUDA)
 . . ELSE  D
 . . . ;Unable to correct - entry in use
 . . . D SETXTMP(TIUDA,1)
 S ^XTMP("TIUP149","CNT","TOT")=+$G(^XTMP("TIUP149","CNT","TOT"))+1
 Q
 ;
CHKDOC(TIUDA,TIUDAD,TITLE) ;Check if document can be cleaned up
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ;           TIUDAD   TIU document file (#8925) Parent's IEN
 ;           TITLE    TIU Document Definition file (#8925.1) IEN
 ; Output -- 1=Can be cleaned up and 0=Cannot be cleaned up
 N TIUD13,Y
 ;
 ;Set variables
 S Y=0
 S TIUD13=$G(^TIU(8925,TIUDA,13))
 ;
 ;If document is an addendum or component and the parent and child visit fields
 ;are different, set clean-up flag to yes
 I +$$ISADDNDM^TIULC1(TIUDA)!(+$$ISCOMP^TIUBR(TIUDA)) D  G CHKDOCQ
 . I $P($G(^TIU(8925,+TIUDAD,0)),U,3)'=$P($G(^TIU(8925,TIUDA,0)),U,3) S Y=1
 ;
 ;If capture method is converted or reference date is before 10/1/98 or
 ;document is a discharge summary, set clean up flag to yes
 I ("^C^")[(U_$P(TIUD13,U,3)_U)!(+TIUD13&(+TIUD13<2981001))!(+$$ISDS^TIULX(TITLE)) S Y=1
 ;
CHKDOCQ Q +$G(Y)
 ;
GETVST(TIUDA,TIUDFN,TIUDAD,VSIT,TIUMVSTF) ;Get visit to associate with document
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ;           TIUDFN   Patient file (#2) IEN
 ;           TIUDAD   TIU document file (#8925) Parent's IEN
 ; Output -- VSIT     Visit file (#9000010) IEN
 ;           TIUMVSTF Multiple Visit Flag
 ;           1=Multiple Visits
 ;
 N TIUD13,TIUDTM,TIUHL,VSITS
 ;
 ;Set variables
 S TIUD13=$G(^TIU(8925,TIUDA,13))
 S TIUHL=$P($G(^TIU(8925,TIUDA,12)),U,11)
 ;
 ;Check if document is an addendum or component, if it is use visit of parent
 I +$$ISADDNDM^TIULC1(TIUDA)!(+$$ISCOMP^TIUBR(TIUDA)) D  G GETVSTQ
 . I $D(^TIU(8925,+TIUDAD,0)),$P(^(0),U,3)>0 S VSIT=$P(^(0),U,3) D
 . . I $P($G(^AUPNVSIT(+VSIT,0)),U,5)'=TIUDFN S VSIT=""
 ;
 ;If document is converted, check PCE for a visit
 I (("^C^")[(U_$P(TIUD13,U,3)_U)) D
 . ;For DS use patient movement date/time, otherwise use reference date/time
 . I +$$ISDS^TIULX(+$G(^TIU(8925,TIUDA,0))) D
 . . I +$G(^TIU(8925,TIUDA,14))>0,+$G(^DGPM(+^(14),0))>0 S TIUDTM=+^(0)
 . ELSE  D
 . . I +TIUD13>0 S TIUDTM=+TIUD13
 . ;Check PCE for a visit
 . I $G(TIUDTM) D
 . . S VSITS=$$GETENC^PXAPI(TIUDFN,TIUDTM,TIUHL)
 . . I VSITS>0 S VSIT=+VSITS
 . . ;Set a flag if multiple visits
 . . I $P(VSITS,U,2)'="" S TIUMVSTF=1
GETVSTQ Q
 ;
SETXTMP(TIUDA,TIUEX,VSIT) ;Set ^XTMP for entries processed
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ;           TIUEX    Unable to correct Exception types:  (Optional)
 ;                    1=Entry in Use
 ;                    2=Unlink Visit
 ;                    3=NDBI Fix Needed
 ;           VSIT     Visit file (#9000010) IEN  (Optional)
 ; Output -- Set ^XTMP("TIUP149","LNK",TIUDA)=
 ;               1st piece= 1=Linked and 0=Not Linked
 ;               2nd piece= Exception type if not linked
 ;               3rd piece= Visit file (#9000010) IEN if linked
 I $G(TIUEX) D
 . S ^XTMP("TIUP149","LNK",TIUDA)=0_U_$G(TIUEX)
 . S ^XTMP("TIUP149","CNT","EX",TIUEX)=+$G(^XTMP("TIUP149","CNT","EX",TIUEX))+1
 . S ^XTMP("TIUP149","CNT","EX")=+$G(^XTMP("TIUP149","CNT","EX"))+1
 ELSE  D
 . S ^XTMP("TIUP149","LNK",TIUDA)=1_U_U_$G(VSIT)
 . S ^XTMP("TIUP149","CNT","LNK")=+$G(^XTMP("TIUP149","CNT","LNK"))+1
 Q
 ;
DELVST(TIUDA,ERROR) ;Delete Visit in TIU Document file #8925
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ; Output -- 1=Successful and 0=Failure
 ;           ERROR    Error Message  (Optional)
 N DIERR,OKF,TIUFDA
 ;
 ;Update document with visit
 S TIUFDA(8925,TIUDA_",",.03)="@"
 L +^TIU(8925,TIUDA):1 I $T D
 . D FILE^DIE("","TIUFDA","") L -^TIU(8925,TIUDA)
 . S ERROR=$G(DIERR)
 . S OKF=$S(+$G(ERROR):0,1:1)
 ELSE  D
 . S OKF=0
DELVSTQ Q +$G(OKF)
 ;
UPDKIDS(TIUDA,VSIT) ;Update Visit for kids that are addenda or components
 ; Input  -- TIUDA    TIU Document file (#8925) IEN
 ;           VSIT     Visit file (#9000010) IEN  (Optional)
 ; Output -- None
 N TIUKID
 S TIUKID=0
 F  S TIUKID=$O(^TIU(8925,"DAD",TIUDA,TIUKID)) Q:'TIUKID  D
 . ;If document is an addendum or component and visit of parent is different than visit of kid
 . I (+$$ISADDNDM^TIULC1(TIUKID)!(+$$ISCOMP^TIUBR(TIUKID))),$G(VSIT)'=$P($G(^TIU(8925,TIUKID,0)),U,3) D
 . . ;Link kid to visit
 . . I $G(VSIT)>0 D
 . . . I $$UPDVST^TIUPXAP2(TIUKID,VSIT) D
 . . . . D SETXTMP(TIUKID,,VSIT)
 . . . ELSE  D
 . . . . D SETXTMP(TIUKID,1)
 . . ELSE  D
 . . . ;Unlink kid from visit
 . . . I $$DELVST(TIUKID) D
 . . . . D SETXTMP(TIUKID,2)
 . . . ELSE  D
 . . . . D SETXTMP(TIUKID,1)
 Q
