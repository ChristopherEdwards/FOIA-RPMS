ABMDE6X ; IHS/ASDST/DMJ - Page 6 - ERROR CHECKS ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;
 ; Added code for new error 217
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20435
 ;   Removed error from claim editor; AIDC said these
 ;   should be caught during PCC data entry and error
 ;   is no longer needed
 ;
ERR S ABME("TITL")="PAGE 6 - DENTAL INFORMATION"
A S ABMX=0 F ABMX("I")=1:1 S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABMX)) Q:'ABMX  D A1
 I ABMX("I")=1 S ABME(137)=""
 G XIT
A1 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABMX,0)
 I $P(ABMX("X0"),U,7)="" S DA(1)=ABMP("CDFN"),DIK="^ABMDCLM(DUZ(2),"_DA(1)_",33,",DA=ABMX D ^DIK Q
 I $P(ABMX("X0"),U,2)=""&($P(^ABMDEXP(ABMP("EXP"),0),U)["UB") S ABME(121)=""
 S ABMCODXS=$P(ABMX("X0"),U,4)
 I ABMCODXS'="" D
 .F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ..;start old code abm*2.6*8 NOHEAT
 ..;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ..;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ..;end old code start new code
 ..I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ..I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ..;end new code
 I $P(ABMX("X0"),U,7)]"",$P(ABMX("X0"),U,7)<ABMP("VDT") S ABME(127)=""
 I $P(^AUTTADA(+ABMX("X0"),0),U,9)]"" Q
 I $P(ABMX("X0"),U,5)="",$P(ABMX("X0"),U,11)="" S ABME(133)=""
 Q
 ;
XIT K ABMX
 Q
