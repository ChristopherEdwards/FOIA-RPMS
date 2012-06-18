DG53358M ;ALB/AEG - DG*5.3*358 POST INSTALL (CONT) ;3-5-2001
 ;;5.3;Registration;**358**;3-5-2001
 ;
MBDST ; Called after Phase II processing completes to send user a message
 ; as to the details of mt status inconsistencies.
 I '$D(^TMP($J,"PAT")) D
 .S ^UTILITY($J,1)="No inconsistencies were noted between the CURRENT MEANS TEST"
 .S ^UTILITY($J,2)="STATUS field (#.14) of the PATIENT file (#2) and the STATUS"
 .S ^UTILITY($J,3)="field (#.03) of the ANNUAL MEANS TEST file (#408.31)."
 I $D(^TMP($J,"PAT")) D
 .S ^UTILITY($J,1)="The following inconsistencies were found between the CURRENT MEANS"
 .S ^UTILITY($J,2)="TEST STATUS field (#.14) of the PATIENT file (#2) and the"
 .S ^UTILITY($J,3)="STATUS field (#.03) of the ANNUAL MEANS TEST file (#408.31)."
 .S ^UTILITY($J,4)="The inconsistencies have been corrected."
 .S ^UTILITY($J,5)=" "
 .S ^UTILITY($J,6)=$$BLDSTR("PATIENT NAME","SSN","CATEGORY (PAT)","CATEGORY (MEANS)")
 .S ^UTILITY($J,7)=$$BLDSTR("------------","---","--------------","----------------")
 .N NM,IEN,I,DFN,DPTS,LST4,P1,P2,P3,P4,NM1
 .S (NM,IEN)=""
 .F I=8:1 S NM=$O(^TMP($J,"PAT",NM)) Q:NM=""  S IEN="" F  S IEN=$O(^TMP($J,"PAT",NM,IEN)) Q:IEN=""  D
 ..S DFN=$P($G(^TMP($J,"PAT",NM,IEN)),U,1),DPTS=$P($G(^TMP($J,"PAT",NM,IEN)),U,2)
 ..S DPTS=$S(DPTS'="":$P($G(^DG(408.32,DPTS,0)),U,1),DPTS="":" ",1:" ")
 ..S DGMTS=$P($G(^TMP($J,"PAT",NM,IEN)),U,4),DGMTS=$S(DGMTS'="":$P($G(^DG(408.32,DGMTS,0)),U,1),DGMTS="":" ",1:" ")
 ..S NM1=$E($G(NM),1,15) I NM1["^" S NM1=$P($G(NM1),U,1)
 ..S LST4=$E($P($G(^DPT(DFN,0)),U,9),6,9)
 ..S P1=NM1,P2=LST4,P3=DPTS,P4=DGMTS
 ..S ^UTILITY($J,I)=$$BLDSTR(P1,P2,P3,P4)
 ..Q
 .Q
 N DIFROM,%
 N XMDUZ,XMSUB,XMTEXT,XMY,Y
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^UTILITY($J,"
 D NOW^%DTC S Y=% D DD^%DT
 S XMSUB="DG*5.3*358 POST INSTALL - Phase II report "_Y
 D ^XMD
 D BMES^XPDUTL("     MAIL MESSAGE < #"_XMZ_" > sent.")
 K ^UTILITY($J),^TMP($J,"PAT")
 Q
BADEN ; Process Phase III portion of cleanup report
 K ^UTILITY($J)
 I '$D(^TMP($J,"BADEN")) D
 .S ^UTILITY($J,1)="No means test records found where the CURRENT MEANS TEST STATUS field (#.14)"
 .S ^UTILITY($J,2)="of the PATIENT file (#2) was populated without a corresponding"
 .S ^UTILITY($J,3)="Means Test on file."
 I $D(^TMP($J,"BADEN")) D
 .S ^UTILITY($J,1)="The following patients had the CURRENT MEANS TEST STATUS field (#.14)"
 .S ^UTILITY($J,2)="of the PATIENT file (#2) populated; however, there was no"
 .S ^UTILITY($J,3)="corresponding Means Test on File.  The PATIENT file has been"
 .S ^UTILITY($J,4)="updated."
 .S ^UTILITY($J,5)=" "
 .S ^UTILITY($J,6)=$$BLDSTR("PATIENT NAME","SSN","CURRENT MT STATUS","")
 .S ^UTILITY($J,7)=$$BLDSTR("------------","---","-----------------","")
 .N DGDFN,DPTSTAT,NM,NM1,LST4,DPTS,P1,P2,P3,P4
 .S (DGDFN,DPTSTAT)=""
 .F I=8:1 S DGDFN=$O(^TMP($J,"BADEN",DGDFN)) Q:'+DGDFN  S DPTSTAT="" F  S DPTSTAT=$O(^TMP($J,"BADEN",DGDFN,DPTSTAT)) Q:DPTSTAT=""  D
 ..S NM=$P($G(^DPT(DGDFN,0)),U),NM1=$E($G(NM),1,15)
 ..S LST4=$E($P($G(^DPT(DGDFN,0)),U,9),6,9)
 ..S DPTS=$P($G(^DG(408.32,DPTSTAT,0)),U,1),DPTS=$E($G(DPTS),1,15)
 ..S P1=NM1,P2=LST4,P3=DPTS,P4=""
 ..S ^UTILITY($J,I)=$$BLDSTR(P1,P2,P3,P4)
 ..Q
 .Q
 N DIFROM,%,Y
 N XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 D NOW^%DTC S Y=% D DD^%DT
 S XMSUB="DG*5.3*358 POST INSTALL - Phase III report "_Y
 S XMTEXT="^UTILITY($J,"
 D ^XMD
 D BMES^XPDUTL("    MAIL MESSAGE < #"_XMZ_" > sent.")
 K ^TMP($J,"BADEN"),^UTILITY($J)
 Q
DOAN ; Phase IV Process Reporting
 ;
 ; This reporting mechanism is broken down into 2 distinct parts.
 ;
 ; 1.  An email will be generated on those patients that were in a NLR
 ;     status and the date of the test was > than the date of death. The
 ;     tests meeting those criteria were treated as invalid and purged.
 ;
 ; 2.  An email will be generated for those test in an NLR status on 
 ;     expired patients where the date of the test was on or before the
 ;     date of death.  These test statii were recalculated to what they
 ;     were prior to date of death.
 ; 
 ; PART I
 I '$D(^TMP($J,"NLR-DEL")) D
 .S ^UTILITY($J,1)="No means test records were found in a status of 'NO LONGER REQUIRED'"
 .S ^UTILITY($J,2)="where the date of the test is greater than the date of death."
 I $D(^TMP($J,"NLR-DEL")) D
 .S ^UTILITY($J,1)="The following means tests were found in a status of 'NO LONGER REQUIRED'"
 .S ^UTILITY($J,2)="and the test date was entered after the date of death.  These tests"
 .S ^UTILITY($J,3)="are considered to be invalid and have been purged."
 .S ^UTILITY($J,4)=" "
 .S ^UTILITY($J,5)=$$BLDSTR("PATIENT NAME","SSN","DATE OF DEATH","DATE OF TEST")
 .S ^UTILITY($J,6)=$$BLDSTR("------------","---","-------------","------------")
 .N DGDFN,DGMTI,DGDOD,DGMTS,DOD,DOT,DOT1,DGDFN1
 .S (DGDFN,DGMTI,DGDFN1)=""
 .F I=8:1 S DGDFN1=$O(^TMP($J,"NLR-DEL",DGDFN1)) Q:'+DGDFN1  D
 ..S DGDFN=$P($G(DGDFN1),"~~",1),DGMTI=$P($G(DGDFN1),"~~",2)
 ..S NM=$P($G(^DPT(DGDFN,0)),U,1),NM1=$E($G(NM),1,15)
 ..S LST4=$E($P($G(^DPT(DGDFN,0)),U,9),6,9)
 ..S DOT=$P($G(^TMP($J,"NLR-DEL",DGDFN1)),U,1)
 ..S Y=DOT X ^DD("DD") S DOT1=Y
 ..S DOD=$P($G(^DPT(DGDFN,.35)),U),Y=$P($G(DOD),".",1)
 ..X ^DD("DD") S DGDOD=Y
 ..S P1=NM1,P2=LST4,P3=DGDOD,P4=DOT1
 ..S ^UTILITY($J,I)=$$BLDSTR(P1,P2,P3,P4)
 ..Q
 .Q
 N DIFROM,%,Y
 N XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^UTILITY($J,"
 N %,Y
 D NOW^%DTC S Y=% D DD^%DT
 S XMSUB="DG*5.3*358 POST INSTALL - PHASE IV (PART 1) "_Y
 D ^XMD
 D MES^XPDUTL("     MAIL MESSAGE < #"_XMZ_" > sent.")
 K ^UTILITY($J),^TMP($J,"NLR-DEL")
 ;
P2 ; PART 2
 I '$D(^TMP($J,"RECALC")) D
 .S ^UTILITY($J,1)="No means test records found where the status is 'NO LONGER REQUIRED'"
 .S ^UTILITY($J,2)="and the test date is on or before the date of death."
 I $D(^TMP($J,"RECALC")) D
 .N OLDSTAT,NEWSTAT,DGDFN,NEWCAT,OLDCAT,PID,TDATE,TDATE1,DGDFN1
 .S (OLDSTAT,NEWSTAT,DGDFN,DGDFN1)=""
 .S ^UTILITY($J,1)="The following patients have expired and had a means test"
 .S ^UTILITY($J,2)="on file in a status of 'NO LONGER REQUIRED'.  The test"
 .S ^UTILITY($J,3)="dates are on or prior to the date of death; therefore, the status"
 .S ^UTILITY($J,4)="has been recalculated to reflect the status at the time of"
 .S ^UTILITY($J,5)="death."
 .S ^UTILITY($J,6)=" "
 .S ^UTILITY($J,7)=$$BLDSTR("PATIENT SSN","TEST DATE","OLD STATUS","NEW STATUS")
 .S ^UTILITY($J,8)=$$BLDSTR("----------","---------","----------","----------")
 .F I=9:1 S DGDFN1=$O(^TMP($J,"RECALC",DGDFN1)) Q:'+DGDFN1  D
 ..S DGDFN=$P($G(DGDFN1),"~~",1),TDATE=$P($G(DGDFN1),"~~",2)
 ..S PID=$E($P($G(^DPT(DGDFN,0)),U,9),1,3)_"-"_$E($P($G(^DPT(DGDFN,0)),U,9),4,5)_"-"_$E($P($G(^DPT(DGDFN,0)),U,9),6,9)
 ..S Y=TDATE X ^DD("DD") S TDATE1=Y
 ..S OLDCAT=$P($G(^TMP($J,"RECALC",DGDFN1)),U,1)
 ..S NEWCAT=$P($G(^TMP($J,"RECALC",DGDFN1)),U,2)
 ..S P1=PID,P2=TDATE1,P3=OLDCAT,P4=NEWCAT
 ..S ^UTILITY($J,I)=$$BLDSTR(P1,P2,P3,P4)
 ..Q
 .Q
 N DIFROM,%,Y
 N XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^UTILITY($J,"
 D NOW^%DTC S Y=% D DD^%DT
 S XMSUB="DG*5.3*358 POST INSTALL - Phase IV (Part II) "_Y
 D ^XMD
 D MES^XPDUTL("     MAIL MESSAGE < #"_XMZ_" > sent.")
 K ^UTILITY($J),^TMP($J,"RECALC")
 Q
BLDSTR(P1,P2,P3,P4) ; Build a string from input
 N S1,S2,S3,S4
 S S1=$E(P1,1,15) I $L(S1)'>14 D
 .S S1=S1_$J("",(15-$L(S1)))
 S S2=P2
 S S3=$E(P3,1,15) I $L(S3)'>14 D
 .S S3=S3_$J("",(15-$L(S3)))
 S S4=$E(P4,1,15) I $L(S4)'>14 D
 .S S4=S4_$J("",(15-$L(S4)))
 Q S1_$J("",5)_S2_$J("",5)_S3_$J("",5)_S4
