BPMXDRV ;IHS/PHXAO/AEF - PATIENT MERGE SPECIAL ROUTINES DRIVER - 6/26/12 ;
 ;;1.0;IHS PATIENT MERGE;**2**;MAR 01, 2010;Build 1
 ;IHS/OIT/LJF 10/26/2006 routine originated from Phoenix Area Office
 ;                       changed namespace from BZXM to BPM
 ;                       changed names of speical merge routines
 ;                       added check for REPOINT DELETED VISITS parameter
 ;IHS/DIT/ENM 08/20/10 EDR MODS ADDED BELOW
 ;IHS/OIT/NKD  6/13/2012 Restricted merge batches to 1 pair of duplicates
 ;                       Moved EDR and MPI processing into separate routines
 ;                       Moved processing checks into BPMXVST and BPMXLR
 ;;
DESC ;;----- ROUTINE DESCRIPTION
 ;;
 ;;BPMXDRV:
 ;;THIS ROUTINE CALLS OTHER SPECIAL IHS MERGE ROUTINES USED TO MERGE
 ;;DUPLICATE PATIENT DATA.
 ;;
 ;;THIS ROUTINE IS ENTERED INTO THE 'NAME OF MERGE ROUTINE' FIELD OF THE
 ;;'AFFECTS RECORD MERGE' SUBFILE OF THE PACKAGE FILE FOR THE 'IHS
 ;;PATIENT MERGE' PACKAGE.  THIS ROUTINE IS THEN RUN BY THE KERNEL
 ;;TOOLKIT DUPLICATE PATIENT MERGE SOFTWARE.  THIS ROUTINE ELIMINATES
 ;;THE NEED TO HAVE EACH INDIVIDUAL MERGE ROUTINE ENTERED INTO EACH
 ;;INDIVIDUAL ENTRY IN THE PACKAGE FILE.
 ;;
 ;;THE IHS PATIENT MERGE SOFTWARE ENTERS AT EN LINE LABEL.  IT IS EXPECTED
 ;;THAT THE FOLLOWING GLOBAL WOULD HAVE BEEN SET UP BY THE PATIENT MERGE
 ;;SOFTWARE:
 ;;  ^TMP("XDRFROM",$J,FROMIEN,TOIEN,FROMIEN_GLOBROOT,TOIEN_GLOBROOT)=FILE
 ;;EXAMPLE:
 ;;  ^TMP("XDRFROM",2804,6364,1991,"6364;DPT(","1991;DPT(")=2
 ;;WHERE =2 IS THE PARENT FILE (VA PATIENT FILE).
 ;;
 ;;$$END
 ;
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
EN(BPMRY) ;EP
 ;----- MAIN ENTRY POINT FROM DUPLICATE PATIENT MERGE SOFTWARE
 ;
 ;      BPMRY  =  TEMP GLOBAL ARRAY SET UP BY THE PATIENT MERGE
 ;                 SOFTWARE, I.E., "^TMP(""XDRFROM"",$J)"
 ;
 ; Run iCare special merge; if FROM patient being edited, it stops
 I $L($T(CHK^BQIPTMRG)) D  I $D(ZTSTOP) Q
 . NEW FR S FR=$O(@BPMRY@(0)) Q:'FR
 . I '$$CHK^BQIPTMRG(FR) S ZTSTOP=1 Q
 . D EN^BQIPTMRG(BPMRY)
 ;
 ; Flag all visits for export for FROM patients
 D VISITS^BPMMRG(BPMRY)
 ;
 ;REPOINT VARIABLE POINTER FIELDS
 D EN^BPMXVP(BPMRY)
 ;                 
 ;REPOINT PT TAXONOMY FILE POINTERS
 D EN^BPMXTAX(BPMRY)
 ;
 ;REPOINT 3P CLAIM AND BILL PATIENTS
 D EN^BPMX3PB(BPMRY)
 ;
 ;REPOINT VISIT FILE POINTERS if REPOINT DELETED VISITS parameter turned ON
 ;IHS/OIT/NKD BPM*1.0*2 MOVED PROCESSING CHECK INTO BPMXVST ROUTINE
 ;I $$GET1^DIQ(15.1,2,99999.01)="YES" D EN^BPMXVST(BPMRY)
 D EN^BPMXVST(BPMRY)
 ;
 ;MERGE WORD PROCESSING FIELDS
 D EN^BPMXWP(BPMRY)
 ;
 ;MERGE LAB DATA (calls ^BLRMERG)
 ;IHS/OIT/NKD BPM*1.0*2 MOVED PROCESSING CHECK INTO BPMXLR ROUTINE
 ;I $L($T(EN^BLRMERG)) D EN^BPMXLR(BPMRY)
 D EN^BPMXLR(BPMRY)
 ;
 ;MERGE PROBLEM LIST
 D EN^BPMXPRB(BPMRY)
 ;
 ;IHS/OIT/NKD BPM*1.0*2 CALL NEW MPI/EDR ROUTINES - START OLD CODE
 ;IHS/DIT/ENM 02/23/10
 ;MERGE MPI DATA (Calls ^AGMPIHLO
 ;S X="AGMPIHLO" X ^%ZOSF("TEST") I $T D NEWMSG^AGMPIHLO(BPMRY)
 ;
 ;IHS/DIT/ENM 08/20/10 next 7 lines sent by FJ for the EDR project
 ;Added for support of GENERIC merge trigger to subscribing applications fje 8/13/10
 ;S X="BADEMRG" X ^%ZOSF("TEST") I $T D THIS LINE IS NOT NEEDED
 ;S BPMFR=$O(@BPMRY@(0))
 ;Q:'BPMFR
 ;S BPMTO=$O(@BPMRY@(BPMFR,0))
 ;Q:'BPMTO
 ;S X="BPM MERGE PATIENT ADT-A40",DIC=101,DFNFROM=+BPMFR,DFNTO=+BPMTO
 ;D EN^XQOR
 ;IHS/OIT/NKD BPM*1.0*2 END OLD CODE - START NEW CODE
 ;SEND MPI MESSAGE
 D EN^BPMXMPI(BPMRY)
 ;SEND EDR MESSAGE
 D EN^BPMXEDR(BPMRY)
 ;IHS/OIT/NKD BPM*1.0*2 END NEW CODE
 Q
QUE ;EP
 ;IHS/OIT/NKD BPM*1.0*2 New entry point from menu [BPM MERGE READY DUPLICATES]
 ;This is the entry point for queueing a merge process, modified for single pair batching
 ;Code functionality copied from QUE^XDRMERG0 and QUE^XDRMERGB
 ;Use of GOTO statement at end to continue processing in XDR routines
 ;
 D EN^XDRVCHEK ; update verified and/or ready to merge statuses if necessary
 ;
 N XDRXX,XDRYY,XDRMA,DIE,DIC,DIR,DR,ZTDTH,ZTSK
 N XDRX,XDRY,XDRFIL,XDRGLOB,X,Y,XDRNAME
 N XDRFDA,XDRIENS,XDRI,XDRJ,XDRK,DA,DIK
 ;
 S XDRFIL=$$FILE^XDRDPICK() Q:XDRFIL'>0
 I XDRFIL=2 D  Q:Y
 . N X,XDRKEY
 . S (X,XDRKEY)=0 F  S X=$O(^VA(200,DUZ,51,"B",X)) Q:X'>0!(XDRKEY)  D
 . . I $$GET1^DIQ(19.1,X,.01)="DG ELIGIBILITY" S XDRKEY=1
 . . Q
 . S Y=0 I 'XDRKEY W !!,"You should hold the 'DG ELIGIBILITY' key to run a patient file merge." S Y=1
 . Q
 S XDRDIC=^DIC(XDRFIL,0,"GL")
 S XDRGLOB=$E(XDRDIC,2,999)
 S X=""
 S XNCNT=0,XNCNT0=0
 F  S X=$O(^VA(15,"AVDUP",XDRGLOB,X)) Q:X=""  S Y=$O(^(X,0)) D
 . N YVAL S YVAL=^VA(15,Y,0)
 . I $P(YVAL,U,20)>0 Q  ; ALREADY DONE OR SCHEDULED
 . I $P(YVAL,U,3)'="V" Q  ; TAKE ONLY VERIFIED
 . I $P(YVAL,U,5)'=1 Q  ; TAKE ONLY IF MARKED READY TO MERGE
 . I $P(YVAL,U,13)>0 D
 . . I '$D(@(XDRDIC_(+YVAL)_",0)"))!'$D(@(XDRDIC_(+$P(YVAL,U,2))_",0)")) Q
 . . I $P(YVAL,U,4)'=2 S XDRX(+YVAL,+$P(YVAL,U,2))=Y ; get ien numbers from duplicate file
 . . E  S XDRX(+$P(YVAL,U,2),+YVAL)=Y ; Reverse - merge to switched
 . . S XNCNT=XNCNT+1
 W !!,XNCNT,"  Entries Ready to be included in merge"
 I $O(XDRX(0))'>0 D  Q
 . W !!?15,$C(7),"No Verified Duplicates included in merge",$C(7),!!
 ;
 ;IHS/OIT/NKD BPM*1.0*2 BEGIN NEW CODE - Restrict batch to one pair of duplicates
 D BATCH(.XDRX)
 I '$D(XDRX) W !,"None selected!" Q
 ;IHS/OIT/NKD BPM*1.0*2 END NEW CODE
 ;
 K DIR S DIR(0)="Y"
 S DIR("A",1)="This process will take a **LONG** time (usually over 15 hours, and sometimes"
 S DIR("A",2)="considerably longer), but you CAN stop and restart the process when you"
 S DIR("A")="want using the options.  OK"
 D ^DIR K DIR Q:Y'>0
 G NAME^XDRMERGB
 ;
 Q
 ;
BATCH(XDRX) ;
 ;IHS/OIT/NKD BPM*1.0*2 Restrict batch to one pair of duplicates
 ; Displays all pairs ready to be merged, and allows the selection of ONE to be batched
 N XNCNT,I,J,XDRY,X01,X1,X1S,X02,X2,X2S,XX
 M XDRY=XDRX
 K XDRX
 W @IOF
 S XNCNT=0
 F I=0:0 S I=$O(XDRY(I)) Q:I'>0  D  Q:$D(DUOUT)!$D(DTOUT)!$D(XDRX)
 . F J=0:0 S J=$O(XDRY(I,J)) Q:J'>0  D  Q:$D(DUOUT)!$D(DTOUT)!$D(XDRX)
 . . S X01=$G(@(XDRDIC_I_",0)")),X1=$P(X01,U),X1S=$P(X01,U,9),X1S=$E(X1S,1,3)_"-"_$E(X1S,4,5)_"-"_$E(X1S,6,15)
 . . S X02=$G(@(XDRDIC_J_",0)")),X2=$P(X02,U),X2S=$P(X02,U,9),X2S=$E(X2S,1,3)_"-"_$E(X2S,4,5)_"-"_$E(X2S,6,15)
 . . I X1=""!(X2="") K XDRY(I,J) Q
 . . F  Q:X1'["MERGING INTO"  S X1=$P($P(X1,"(",2,10),")",1,$L(X1,")")-1)
 . . S XNCNT=XNCNT+1,XX(XNCNT)=I_U_J
 . . ;
 . . W !!,$J(XNCNT,3),"  ",?8,X1,?42,X1S,?60,"[",I,"]",?70,"#",$$HRCN^BPMU(I,$G(DUZ(2)))
 . . W !,?8,X2,?42,X2S,?60,"[",J,"]",?70,"#",$$HRCN^BPMU(J,$G(DUZ(2)))
 . . ;
 . . I '(XNCNT#6) D ASK Q:$D(DUOUT)!$D(DTOUT)  W @IOF
 I '($D(DUOUT)!$D(DTOUT)!$D(XDRX)) D ASK
 Q
 ;
ASK ;
 ;IHS/OIT/NKD BPM*1.0*2 Restrict batch to one pair of duplicates
 N DIR,K,Y,N,N1,N2
 W ! S DIR(0)="LO^1:"_XNCNT,DIR("A")="Select an entry to schedule a merge"
 D ^DIR K DIR K DIRUT Q:$D(DUOUT)!$D(DTOUT)
 S K="" F  S K=$O(Y(K)) Q:K=""  S Y=Y(K) K Y(K) D
 . S N=$P(Y,",") Q:N=""
 . S N1=+XX(N),N2=$P(XX(N),U,2)
 . S XDRX(N1,N2)=XDRY(N1,N2)
 Q
 ;
