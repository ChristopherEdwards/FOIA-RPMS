PSJLMUTL ;BIR/MLM-INPATIENT LISTMAN UTILITIES ;29 May 98 / 8:35 AM
 ;;5.0; INPATIENT MEDICATIONS ;**7,67,58,85**;16 DEC 97
 ;
 ; Reference to ^ORD(101 is supported by DBIA #872.
 ; Reference to ^PS(50.606 is supported by DBIA #2174.
 ; Reference to ^PS(50.7 is supported by DBIA #2180.
 ; Reference to ^PS(55 is supported by DBIA #2191.
 ; Reference to ^PSDRUG is supported by DBIA #2192.
 ; Reference to ^DIE is supported by DBIA #10018.
 ; Reference to ^DIR is supported by DBIA #10026.
 ; Reference to ^GMRAPEM0 is supported by DBIA #190.
 ; Reference to ^VALM is supported by DBIA #10118.
 ; Reference to ^VALM1 is supported by DBIA #10116.
 ;
NEWALL(DFN) ; Enter Allergy info.
 ;
 D FULL^VALM1,EN2^GMRAPEM0
 Q
DISALL(DFN) ; Display brief patient info list.
 K ^TMP("PSJALL",$J) N PSJLN,X,Y,PSGALG,PSGLDR,PSJGMRAL,PSJWHERE S PSJWHERE="PSJLMUTL"
 D ATS^PSJMUTL(57,57,2)
 I (PSJGMRAL=0) S ^TMP("PSJALL",$J,1,0)=" Allergies/Reactions: "_"NKA",PSJLN=2 G NARRATIV
 I (PSJGMRAL="") S ^TMP("PSJALL",$J,1,0)=" Allergies/Reactions: No Allergy Assessment",PSJLN=2 G NARRATIV
 I ($G(PSGVALG(1))="NKA")!((PSGVALG=0)&(PSGALG=0)) D
 .S ^TMP("PSJALL",$J,1,0)="           Allergies: "_$G(PSGVALG(1)),PSJLN=2,X=1
 I ($G(PSGVALG(1))'="NKA")&((PSGVALG>0)!(PSGALG>0)) D
 .S ^TMP("PSJALL",$J,1,0)="Allergies - Verified: "_$G(PSGVALG(1)),PSJLN=2,X=1
 .F  S X=$O(PSGVALG(X)) Q:'X  S ^TMP("PSJALL",$J,PSJLN,0)="                        "_PSGVALG(X),PSJLN=PSJLN+1
 .S ^TMP("PSJALL",$J,PSJLN,0)="        Non-Verified: "_$S($G(PSGALG(1))=0:"",1:$G(PSGALG(1))),PSJLN=PSJLN+1,X=1
 .F  S X=$O(PSGALG(X)) Q:'X  S ^TMP("PSJALL",$J,PSJLN,0)="                        "_PSGALG(X),PSJLN=PSJLN+1
 I ($G(PSGVADR(1))="NKA")!((PSGVADR=0)&(PSGADR=0)) D
 .S ^TMP("PSJALL",$J,PSJLN,0)="",^TMP("PSJALL",$J,PSJLN+1,0)="   Adverse Reactions: "_$G(PSGADR(1)),PSJLN=PSJLN+2,X=1
 I ($G(PSGVADR(1))'="NKA")&((PSGVADR>0)!(PSGADR>0)) D
 .S ^TMP("PSJALL",$J,PSJLN,0)="",^TMP("PSJALL",$J,PSJLN+1,0)="Reactions - Verified: "_$G(PSGVADR(1)),PSJLN=PSJLN+2,X=1
 .F  S X=$O(PSGVADR(X)) Q:'X  S ^TMP("PSJALL",$J,PSJLN,0)="              "_PSGVADR(X),PSJLN=PSJLN+1
 .S ^TMP("PSJALL",$J,PSJLN,0)="        Non-Verified: "_$G(PSGADR(1)),PSJLN=PSJLN+2,X=1
 .F  S X=$O(PSGADR(X)) Q:'X  S ^TMP("PSJALL",$J,PSJLN,0)="              "_PSGADR(X),PSJLN=PSJLN+1
 ;
NARRATIV ; print inpatient/outpatient narratives
 S ^TMP("PSJALL",$J,PSJLN,0)="" D SETNAR("PSJALL",$G(^PS(55,DFN,5.3)),"In")
 S ^TMP("PSJALL",$J,PSJLN+1,0)="" D SETNAR("PSJALL",$G(^PS(55,DFN,1)),"Out")
 ;S PSJLN=PSJLN+4 D SETNAR("PSJALL",$G(^PS(55,DFN,1)),"Out")
 S PSJLN=0 F X=0:0 S X=$O(^TMP("PSJALL",$J,X)) Q:'X  S PSJLN=PSJLN+1
 S VALMCNT=PSJLN
 Q
 ;
SETNAR(SUB,NARR,TYPE) ; Set up Narrative info.
 S NARR=TYPE_"patient Narrative: "_NARR,Y="" S:TYPE="In" NARR=" "_NARR
 S START=1 F  D  Q:NARR=""
 .I $L($P(NARR," "))>79 S PSJ=$E(NARR,START,START+79),NARR=$E(NARR,START+80,$L(NARR)) Q
 .I $L(NARR)>79 S PSJ=$P(NARR," ",1,$L($E(NARR,1,80)," ")-1),NARR=$E($P(NARR,PSJ,2),2,$L(NARR)) D SET Q
 .S PSJ=NARR,NARR="" D SET
 Q
 ;
SET ; Set ^TMP for narratives.
 S ^TMP(SUB,$J,PSJLN,0)=PSJ,PSJLN=PSJLN+1
 Q
 ;
ACTIONS() ;
 N DIC,X,Y
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 I Y="PSJ LM DC" Q $S(PSGACT["D":1,1:0)
 I Y="PSJU LM EDIT" Q $S(PSGACT["E":1,1:0)
 I Y="PSJU LM RENEW" Q $S(PSGACT["R":1,1:0)
 I Y="PSJ LM HOLD" Q $S(PSGACT["H":1,1:0)
 I Y="PSJU LM VERIFY" Q $S(PSGACT["V":1,1:0)
 I Y="PSJ LM EDIT NEW" Q $S(PSGACT["E":1,1:0)
 I Y="PSJ LM FLAG" Q $S(PSGACT["G":1,1:0)
 Q 1
RNACT() ;
 I '$G(PSJRNF),'$G(PSJIRNF) Q 0
 NEW X S X=$G(^PS(53.1,+PSJORD,0))
 S PSGACT=""
 I $S(+$P(X,U,13):1,$G(PSJRNF)&($P(X,U,4)="U"):1,$G(PSJIRNF)&($P(X,U,4)'="U"):1,1:0) S PSGACT="BFDE"
 NEW X,Y
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 I Y="PSJ LM DC" Q $S(PSGACT["D":1,1:0)
 I Y="PSJ LM BYPASS" Q $S(PSGACT["B":1,1:0)
 I Y="PSJ LM FINISH" Q $S(PSGACT["F":1,1:0)
 I Y="PSJI LM DISCONTINUE" Q $S(PSGACT["D":1,1:0)
 I Y="PSJI LM EDIT" Q $S(PSGACT["E":1,1:0)
 I Y="PSJI LM FINISH" Q $S(PSGACT["F":1,1:0)
 I Y="PSJ LM FLAG" Q 0
 Q 1
 ;
TECHACT() ; Allowable actions for IV technician (PSJI PHARM TECH)
 Q:'$G(PSJITECH) 0
 NEW X S X=$G(^PS(53.1,+PSJORD,0))
 I $S(+$P(X,U,13):1,$P(X,U,4)'="U":1,1:0) S PSGACT="F"
 N DIC,X,Y
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 I Y="PSJ LM DC" Q $S(PSGACT["D":1,1:0)
 I Y="PSJ LM BYPASS" Q $S(PSGACT["B":1,1:0)
 I Y="PSJ LM FINISH" Q $S(PSGACT["F":1,1:0)
 I Y="PSJI LM DISCONTINUE" Q $S(PSGACT["D":1,1:0)
 I Y="PSJI LM EDIT" Q $S(PSGACT["E":1,1:0)
 I Y="PSJI LM FINISH" Q $S(PSGACT["F":1,1:0)
 I Y="PSJ LM FLAG" Q 0
 Q 1
PATINFO()         ; Determines if detailed allergy info can be displayed.
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 ;I Y="PSJ LM DETAILED ALLERGY",'$G(GMRAL) Q 0
 I Y="PSJ LM SHOW PROFILE",$D(PSJLMPRO) Q 0
 Q 1
HIDDEN(CHK) ; Determines if certain Hidden actions are to be available.
 ;N Y S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 ;I Y="PSJ LM PNV JUMP",'$D(PSJPNV) Q 0
 I CHK="JUMP",'$G(PSJPNV) D NA("Jump is only available through Non-Verified/Pending Orders option.") Q 0
 I CHK="SPEED",'$D(PSJUDPRF) D NA("Speed options are only available from the Unit Dose Order Entry Profile.") Q 0
 Q 1
 ;
NA(TXT) ;
 D FULL^VALM1 W !!,TXT,!! N DIR S DIR(0)="E" D ^DIR
 Q
 ;
UPR(DFN)         ; UPDATE PATIENT SPECIFIC DATA IN 55
 N DIE,DR S PSJC10=VALMCNT
 S DA=DFN,DIE="^PS(55,",DR="62.2;62.01" D ^DIE,DISALL^PSJLMUTL(DFN)
 S VALMCNT=PSJC10 K PSJC10
 Q
 ;
DETALL(DFN)        ; Enter Detailed Allergy Display list.
 ;D EN^VALM("PSJ LM ALLERGY DETAIL"),DISALL^PSJLMUTL(DFN)
 D EN^VALM("PSJ LM ALLERGY DISPLAY")
 Q
BRFALL(DFN)        ;
 D EN^VALM("PSJ LM BRIEF PATIENT INFO")
 Q
PAUSE ;
 N DIR S DIR(0)="E" D ^DIR
 Q
DRUGNAME(DFN,ON) ; Find drug name to display
 ;If order is in 55:
 ;.If Dosage Ordered is found, returns OI_U_Dosage Ordered.
 ;.If no Dosage Ordered, returns Dispense Drug only.
 ;If order in 53.1:
 ;.If Dosage Ordered, returns OI_U_Dosage Ordered.
 ;.If Dispense Drug is found, returns Dispense Drug name_U_Instructions.
 ;.If no dispense drug, returns OI_U_Instructions.
 I ON["U" D  Q DN
 .S OIND=$G(^PS(55,DFN,5,+ON,.2))
 .I $P(OIND,U,2)]"",($G(^PS(50.7,+OIND,0))]"") S DN=$$OINAME(OIND)_U_.2 Q
 .S X=+$O(^PS(55,DFN,5,+ON,1,0)),X=$G(^PS(55,DFN,5,+ON,1,X,0)) I $P(X,U)]"" S DN=$$DDNAME(+X)_"^^"_$P(X,"^",2) Q  ;$S($P(OIND,U,2)]"":.2,1:.3) Q
 .S DN=$$OINAME(+OIND)_U_.3 Q
 S OIND=$G(^PS(53.1,+ON,.2)) Q:$P(OIND,U,2)]"" $$OINAME(OIND)_U_.2
 S X=+$O(^PS(53.1,+ON,1,0)) I X,'$O(^PS(53.1,+ON,1,X)) S X=$G(^PS(53.1,+ON,1,X,0)) I $P(X,U)]"" Q $$DDNAME(+X)_U_.3_$P(X,"^",2)
 Q $$OINAME(OIND)_U_.3
 ;
DDNAME(X) ; Return Dispense Drug N$G(PS(53.1,+ON,.3))
 Q $$FOUND($P($G(^PSDRUG(+X,0)),U),X,"PSDRUG(,")
 ;
OINAME(ND) ; Return Orderable Item Name_" "_Dose Form_U_Dosage Ordered
 N DF,DNME,X
 S X=$G(^PS(50.7,+ND,0)),DNME="" S:X]"" DF=$P($G(^PS(50.606,+$P(X,U,2),0)),U),DNME=$P(X,U)_" "_DF
 Q $$FOUND(DNME,+ND,"PS(50.7")
 ;
FOUND(DNME,DN,FN) ; Valid Drug Name?
 Q $S(DNME]"":DNME,1:"NOT FOUND "_DN_";"_FN)
