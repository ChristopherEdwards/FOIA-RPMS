SDPHARM ;ALBANY OIFO/KEITH - Determine patients for Rx benefit ; 6/30/03
 ;;5.3;Scheduling;**300**;AUG 13,1993
LOOK ;Search PATIENT file for eligible patients
 ;
 N DFN,SDPT,SDSS,SDATE,SDATE2
 D INIT
 ;
 ;Roll through patient file
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:'DFN  S SDPT=$$PAT(DFN)
 Q
 ;
INIT ; Initialize variables
 ;INPUT: SDL=lag for future date (optional) (Now date is hard set)
 ;
 N SDI,SDII
 S SDATE=3031021.2359
 S SDATE2=3011021.2359
 ;Create primary care DSS credit pair array
 F SDI=322,323,350 F SDII="000",185,186,187 S SDSS(SDI_SDII)=""
 Q
 ;
PAT(DFN) ;Evaluate a patient
 ;INPUT:  DFN=patient ien
 ;OUTPUT: (fail) 0^_<reason for failure>
 ;        (success) 1^Patient appears to be eligible
 ;
 N SDAP0,SDCL0,SDCP,SDEN,SDEN0,SDIV,SDOUT,SDT
 ;
 Q:$D(^PS(52.91,DFN,0)) "0^Patient is already in TPB ELIGIBILITY File"
 Q:'$D(^DPT(DFN,0)) "0^Patient recird not found"
 Q:'$O(^DPT(DFN,"S",SDATE)) "0^No appointment later than 10/21/03"
 Q:+$G(^DPT(DFN,.35)) "0^Patient is deceased"
 Q:$P($G(^DPT(DFN,"VET")),U)'="Y" "0^Patient is not a veteran"
 ;Should we not quit in next line if date is in future
 Q:+$P($G(^DPT(DFN,.15)),U,2) "0^Patient is ineligible"
 Q:'$L($P($G(^DPT(DFN,0)),U)) "0^Invalid name value"
 Q:$D(^DPT(DFN,-9)) "0^Merged patient record"
 Q:$P(^DPT(DFN,0),U)["MERGING INTO" "0^Merging patient record"
 Q:$E($P(^DPT(DFN,0),U,9),1,5)="00000" "0^Test patient"
 ;Next 2 checks have been moved to the Pharmacy routine
 ;Q:'$$DATE^ENROLD(DFN) "0^Not enrolled by date required"
 ;Q:$$RX^PSOGAPBL(DFN) "0^Active prescriptions exist"
 S SDT=SDATE,SDOUT=0
 F  S SDT=$O(^DPT(DFN,"S",SDT)) Q:'SDT  D
 .S SDAP0=$G(^DPT(DFN,"S",SDT,0)) Q:'+SDAP0  ;Get appt 0 node
 .Q:$P(SDAP0,U,2)["C"  ;Skip cancelled appointments
 .Q:'$P(SDAP0,U,19)  ;Need 'date entered'
 .Q:$P(SDAP0,U,19)>3030724
 .S SDCL0=$G(^SC(+SDAP0,0)) Q:'$L(SDCL0)  ;Get clinic 0 node
 .S SDCP=$$CPAIR(SDCL0)  ;Get DSS credit pair
 .Q:'$D(SDSS(SDCP))  ;Not a primary care appointment
 .S SDIV=$$DIV(SDCL0)  ;Get clinic division
 .Q:$G(SDIV)'>0  ;No Institution
 .I $$FMDIFF^XLFDT(SDT,$P(SDAP0,"^",19),1)<31 S ^XTMP("SDPSO145","PAT","S",DFN,SDIV,SDT)="1^0^"_$P($G(^DPT(DFN,"S",SDT,1)),"^") Q
 .S ^XTMP("SDPSO145","PAT","S",DFN,SDIV,SDT)="0^0^"_$P($G(^DPT(DFN,"S",SDT,1)),"^")
 .Q
 Q:'$D(^XTMP("SDPSO145","PAT","S",DFN)) "0^No future primary care appointment"
 ;Examine past encounters
 S SDT=SDATE2 F  S SDT=$O(^SCE("ADFN",DFN,SDT)) Q:'SDT!SDOUT  D
 .S SDEN=0 F  S SDEN=$O(^SCE("ADFN",DFN,SDT,SDEN)) Q:'SDEN!SDOUT  D
 ..S SDEN0=$G(^SCE(SDEN,0)) Q:'$L(SDEN0)  ;Get encounter 0 node
 ..Q:$P(SDEN0,U,6)  ;Child encounter
 ..Q:'$P(SDEN0,"^",4)
 ..S SDCL0=$G(^SC(+$P(SDEN0,U,4),0)) Q:'$L(SDCL0)  ;Get clinic 0 node
 ..S SDCP=$$CPAIR(SDCL0)  ;Get DSS credit pair 
 ..Q:'$D(SDSS(SDCP))  ;Not a primary care encounter 
 ..;S SDIV=$$DIV(SDCL0)  ;Get clinic division 
 ..K ^XTMP("SDPSO145","PAT","S",DFN) S SDOUT=1  ;Kill all entries for that patient
 ..;S:'$D(^XTMP("SDPSO145","PAT","S",DFN)) SDOUT=1  ;Quit if no future pc appts left
 ..Q
 .Q
 Q:SDOUT "0^Patient has a Primary Care encounter within past 2 years"
 Q "1^Patient appears to be eligible"
 ;
CPAIR(SDCL0) ;Get credit pair
 ;Input: SDCL0=hospital location zeroeth node
 N SDX
 S SDX=$P($G(^DIC(40.7,+$P(SDCL0,U,7),0)),U,2)
 S SDX=SDX_$P($G(^DIC(40.7,+$P(SDCL0,U,18),0)),U,2)
 ;S:'$L(SDX) SDX="000000"
 S SDX=$E(SDX_"000000",1,6)
 Q SDX
 ;
DIV(SDCL0) ;Get facility division name and number
 ;Input: SDCL0=hospital location zeroeth node
 N SDIVV,SDHOLD S SDIVV=$P(SDCL0,U,15)
 S SDHOLD=0
 I SDIVV>0 S SDHOLD=$P($$SITE^VASITE(,SDIVV),"^")
 I SDHOLD>0 Q SDHOLD
 S SDHOLD=$P(SDCL0,"^",4)
 I 'SDHOLD Q 0
 I SDHOLD,'$D(^DIC(4,SDHOLD,0)) S SDHOLD=0
 Q SDHOLD
