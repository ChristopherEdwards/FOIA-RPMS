BEHODC6 ;MSC/IND/MGH -  TIU Dictation Support ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**001001**;Mar 20, 2007
 ;=================================================================
 ;Routine processes message from PACS system for notes and stores them
 ;into TIU. The message is sent in an HL7 message with each line of the note
 ;a different OBX.  The note IEN is being sent in the message
 ;=====================================================================
 ;
EN ;EP - Entry Point for Incoming Message Array in MSG
 K MSG,ERRTX
 N X,Y,EVNDT,TIUDA,TIUERR,TIUHDR,TIUPRM0,TIUPRM1,TIUI,J,BEHAPP,BEHRTN,BEHINST,BEHBID
 N SSN,BEHSSN,BEHDPT,BEHHRN,BEHNAM,BEHN1,BEHN2,BEHDEF,BDATE1,BDATE2,LASTN1,LASTN2,TIME,X1,X2,BEHTIME
 N TIUEDT,TIUAUTH,TIUTITLE,TIUD0,TIUEXAM,TIULOC,TIUX,BEHYR,I,PID,BEHNUM,VADM,TIUCASE
 D SETPARM^TIULE S TIUI=0
 ;Read the entire message and store into the array MSG
 F I=1:1 X HLNEXT Q:HLQUIT'>0  S MSG(I)=HLNODE,J=0 F  S J=$O(HLNODE(J)) Q:'J  S MSG(I,J)=HLNODE(J)
 S BEHNUM=1
MSH ; Decode MSH
 K SEG
 S X="NOW" D ^%DT S EVNDT=Y
 S HLFS=HL("FS"),HLCOMP=$E(HL("ECH")),HLSUB=$E(HL("ECH"),4,4)
 I '$D(MSG(BEHNUM)) G KIL
 S X=$G(MSG(BEHNUM)),SEG("MSH")=X,BEHAPP=""
 I $E(X,1,3)'="MSH" S ERRTX="MSH not first record" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL
 S BEHAPP=$P(MSG(BEHNUM),HLFS,4) I BEHAPP="" G KIL
 S BEHNUM=BEHNUM+1
 D PROCESS^BEHODC7
 Q
CVT ; Convert to FM date
 Q:DATE=""
 S BEHYR=$E(DATE,1,4)-1700,TIME=+$E(DATE,9,$L(DATE))
 S DATE=BEHYR_$E(DATE,5,8)
 I TIME,$E(TIME,1,2)=24 S X1=DATE,X2=1 D C^%DTC S DATE=X,TIME="0001"
 K X1,X2
 S DATE=DATE_$S(TIME:"."_TIME,1:"")
 Q
PID ;EP - Check PID Need HRN
 ;Patient must match
 S SEG("PID")=X
 S BEHHRN=$P(X,HLFS,3)
 S BEHDPT=$P(X,HLFS,4)
 S BEHNAM=$P(X,HLFS,6),BEHSSN=$P(X,HLFS,20)
 I 'BEHDPT S ERRTX="Patient ien"_BEHDPT_" not found in patient file. Please check data and resend." D BOTH^BEHODC8(DFN,EVNDT,ERRTX) Q
 S DFN=BEHDPT
 D PID^VADPT6 S PID=$G(VA("PID")),BEHBID=$G(VA("BID")) K VA
 D DEM^VADPT
 D CHECK
 Q
CHECK ;Make checks on last name
 S LASTN1=$P(BEHNAM,"^"),LASTN2=$P(VADM(1),",")
 S BEHN1=$TR(LASTN1,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S BEHN2=$TR(LASTN2,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 I BEHN1'=BEHN2 S ERRTX="Patient's last names do not match. "_$$AGTEXT^BEHODC7()_" has "_BEHN2_" and the COTs has "_BEHN1 D BOTH^BEHODC8(DFN,EVNDT,ERRTX)
 Q
KIL ;EP - Kill Variables
 S DFN=""
 K MSG,BEHNUM,DATE,TIUAUTH,TIUDA,TIUEDT,TIUERR,TIUI,TIUTITLE,SEG
 Q
