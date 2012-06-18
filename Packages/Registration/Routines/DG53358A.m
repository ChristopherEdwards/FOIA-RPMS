DG53358A ;ALB/AEG - DG*5.3*358 POST INSTALL (CONT) ;3-5-2001
 ;;5.3;Registration;**358**;3-5-2001
 ;
DOAN ; Process records that are in a 'NO LONGER REQUIRED' status and pt.
 ; has a date of death.
 ;
 ; If test date is > date of death - invalid test and will be purged.
 ; If test date is '> date of death - test status will be recalculated.
 ;
 I '$D(^TMP($J,"DGDOA-N")) D  Q
 .D BMES^XPDUTL("PHASE IV - No records found for patients that have expired")
 .D MES^XPDUTL("and have a Means Test status of 'NO LONGER REQUIRED'")
 .D DOAN^DG53358M
 .D MES^XPDUTL("PHASE IV completed on "_$$FMTE^XLFDT($$NOW^XLFDT))
 I $D(^TMP($J,"DGDOA-N")) D
 .D BMES^XPDUTL("PHASE IV processing beginning at "_$$FMTE^XLFDT($$NOW^XLFDT))
 .D BMES^XPDUTL("Processing Records where a date of death exists and the")
 .D MES^XPDUTL("Means Test status is 'NO LONGER REQUIRED'")
 .N MTIEN,DGDOA,DGDFN,DGMTD,DGDOA1,DGMTI,DFN,DGMSGF,OLDNODE,NEWNODE
 .N DGMTYPT,ERRS,TDATE
 .S (MTIEN,DGDOA,DGDFN,DGMTD,DGDOA1,DGMTI,DFN,DGMSGF,OLDNODE,NEWNODE)=""
 .F  S DGDFN=$O(^TMP($J,"DGDOA-N",DGDFN)) Q:DGDFN=""  S MTIEN="" F  S MTIEN=$O(^TMP($J,"DGDOA-N",DGDFN,MTIEN)) Q:MTIEN=""  D
 ..S DGMTD=MTIEN
 ..S DGDOA="" F  S DGDOA=$O(^TMP($J,"DGDOA-N",DGDFN,MTIEN,DGDOA)) Q:DGDOA=""  D
 ...S DGDOA1=$P(DGDOA,".",1)
 ...; If date of test is greater than the date of death, test is not
 ...; valid and needs to be purged.
 ...D:DGMTD>DGDOA1
 ....S DGMTI=$P($G(^TMP($J,"DGDOA-N",DGDFN,MTIEN,DGDOA)),U,1)
 ....S DFN=DGDFN,DGMTYPT=1
 ....S ^TMP($J,"NLR-DEL",DFN_"~~"_DGMTI)=$G(^DGMT(408.31,DGMTI,0))
 ....I '$$EN^DG53358D(DGMTI) D
 .....S ERRS(408.31,DGMTI,"ALL")="Unable to delete means test" Q
 .....Q
 ....Q
 ...; If test date is not greater than date of death recalculate
 ...; status.  If status is returned as required add to ^TMP global
 ...; for further processing.
 ...D:DGMTD'>DGDOA1
 ....S DGMSGF=1,DFN=DGDFN
 ....S DGMTI=$P($G(^TMP($J,"DGDOA-N",DGDFN,MTIEN,DGDOA)),U,1)
 ....S OLDNODE=$$LST^DGMTU(DGDFN,MTIEN,1)
 ....I $$AUTOCOMP^DGMTR(DGMTI)
 ....H .5
 ....S NEWNODE=$$LST^DGMTU(DGDFN,MTIEN,1)
 ....I $P(NEWNODE,U,4)'="R" S ^TMP($J,"RECALC",DFN_"~~"_$P($G(NEWNODE),U,2))=$P($G(OLDNODE),U,3)_U_$P($G(NEWNODE),U,3)
 ....I $P(NEWNODE,U,4)="R" S ^TMP($J,"DGDOA-R",DGDFN,MTIEN,DGDOA)=$G(NEWNODE)
 ...I $D(XPDNM) S %=$$UPCP^XPDUTL("DGDFN",DGDFN)
 ...Q
 ..I $D(XPDNM) S %=$$UPCP^XPDUTL("MTIEN",MTIEN)
 ..Q
 .I $D(XPDNM) S %=$$UPCP^XPDUTL("DGDOA",DGDOA)
 .Q
 K ^TMP($J,"DGDOA-N")
 D DOAN^DG53358M
 D MES^XPDUTL("PHASE IV processing completed at "_$$FMTE^XLFDT($$NOW^XLFDT))
 Q
DOAR ; Process records that are in a 'REQUIRED' status and pt. has a
 ; date of death.
 ;
 ; If test date > date of death - invalid test and will be purged.
 ; If test date '> date of death - Report these as tests that need
 ; completion.
 ;
 I '$D(^TMP($J,"DGDOA-R")) D  Q
 .D BMES^XPDUTL("PHASE V - No records found for patients that have expired")
 .D MES^XPDUTL("and have a Means Test status of 'REQUIRED'")
 .D DOAR^DG53358N
 .D BMES^XPDUTL("PHASE V completed on "_$$FMTE^XLFDT($$NOW^XLFDT))
 I $D(^TMP($J,"DGDOA-R")) D
 .D BMES^XPDUTL("PHASE V processing beginning at "_$$FMTE^XLFDT($$NOW^XLFDT))
 .D BMES^XPDUTL("Processing records where a date of death exists and the")
 .D MES^XPDUTL("Means Test status is 'REQUIRED'")
 .N MTIEN,DGDOA,DGDFN,DGMTD,DGDOA1,DGMTI,DFN,DGMTYPT
 .S (MTIEN,DGDOA,DGDFN,DGMTD,DGDOA1,DGMTI,DFN,DGMTYPT)=""
 .F  S DGDFN=$O(^TMP($J,"DGDOA-R",DGDFN)) Q:DGDFN=""  S MTIEN="" F  S MTIEN=$O(^TMP($J,"DGDOA-R",DGDFN,MTIEN)) Q:MTIEN=""  D
 ..S DGMTD=MTIEN
 ..S DGDOA="" F  S DGDOA=$O(^TMP($J,"DGDOA-R",DGDFN,MTIEN,DGDOA)) Q:DGDOA=""  D
 ...S DGDOA1=$P(DGDOA,".",1)
 ...; If the date of the test is > the date of death, test is not
 ...; considered valid and will be purged.
 ...D:DGMTD>DGDOA1
 ....S DGMTI=$P($G(^TMP($J,"DGDOA-R",DGDFN,MTIEN,DGDOA)),U,1)
 ....S DFN=DGDFN,DGMTYPT=1
 ....S ^TMP($J,"REQ",DFN_"~~"_DGMTI)=$G(^DGMT(408.31,DGMTI,0))
 ....I '$$EN^DG53358D(DGMTI) D
 .....S ERRS(408.31,DGMTI,"ALL")="Unable to delete means test" Q
 .....Q
 ....Q
 ...; If the test date is not greater than the date of death, store
 ...; those records in a different node to report these test to user
 ...; running the tasks.
 ...D:(DGMTD'>DGDOA1)&(DGMTD'<$$INCY(DT))
 ....S DGMTI=$P($G(^TMP($J,"DGDOA-R",DGDFN,MTIEN,DGDOA)),U,1)
 ....S DFN=DGDFN
 ....S ^TMP($J,"REQ-COMP",DFN_"~~"_DGMTI)=$G(^DGMT(408.31,DGMTI,0))
 ....I $D(XPDNM) S %=$$UPCP^XPDUTL("DGDFN",DGDFN)
 ....Q
 ...I $D(XPDNM) S %=$$UPCP^XPDUTL("MTIEN",MTIEN)
 ...Q
 ..I $D(XPDNM) S %=$$UPCP^XPDUTL("DGDOA",DGDOA)
 ..Q
 .Q
 D DOAR^DG53358N
 K ^TMP($J,"DGDOA-R")
 D MES^XPDUTL("PHASE V processing completed at "_$$FMTE^XLFDT($$NOW^XLFDT))
 Q
INCY(DT) ; Determine previous income year
 N X,%DT,Y,DGINY
 S X="T",%DT="" D ^%DT
 S DGINY=Y,DGINY=$$LYR^DGMTSCU1(DGINY)
 Q (DGINY-10000)
