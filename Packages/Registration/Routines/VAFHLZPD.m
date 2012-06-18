VAFHLZPD ;ALB/KCL - Create generic HL7 ZPD segment ; 10 Febuary 1993
 ;;5.3;Registration;**94,122,160,220,247**;Aug 13, 1993
 ;
 ;
EN(DFN,VAFSTR) ; This generic extrinsic function was designed to
 ;          return the HL7 ZPD segment.  This segment contains
 ;          VA-specific patient information that is not contained
 ;          in the HL7 PID segment.
 ;
 ;  Input - DFN as internal entry number of the PATIENT file.
 ;          VAFSTR as the string of fields requested seperated by commas.
 ;
 ;     *****Also assumes all HL7 variables returned from*****
 ;          INIT^HLTRANS are defined.
 ;
 ; Output - String of data forming the ZPD segment.
 ;
 ;
 N VAFNODE,VAFY,X,X1
 I '$G(DFN)!($G(VAFSTR)']"") G QUIT
 S $P(VAFY,HLFS,21)="",VAFSTR=","_VAFSTR_","
 S VAFNODE=$G(^DPT(DFN,0)),$P(VAFY,HLFS,1)=1 ; Always one (Required field)
 D OPD^VADPT ; Other patient data from VADPT.
 I VAFSTR[",2," S $P(VAFY,HLFS,2)=$S($P(VAFNODE,"^",10)]"":$P(VAFNODE,"^",10),1:HLQ) ; Remarks
 I VAFSTR[",3," S $P(VAFY,HLFS,3)=$S(VAPD(1)]"":VAPD(1),1:HLQ) ; Place of birth (city)
 I VAFSTR[",4," S X1=$P($G(^DIC(5,$P(+VAPD(2),"^",1),0)),"^",2),$P(VAFY,HLFS,4)=$S(X1]"":X1,1:HLQ) ; Place of birth (State abbrv.)
 I VAFSTR[",5," S X=$P(VAFNODE,"^",14),X1=$P($G(^DG(408.32,+X,0)),"^",2),$P(VAFY,HLFS,5)=$S(X1]"":X1,1:HLQ) ; Current means test status
 I VAFSTR[",6," S $P(VAFY,HLFS,6)=$S(VAPD(3)]"":VAPD(3),1:HLQ) ; Fathers name
 I VAFSTR[",7," S $P(VAFY,HLFS,7)=$S(VAPD(4)]"":VAPD(4),1:HLQ) ; Mothers name
 I VAFSTR[",8," S X1=$$YN^VAFHLFNC($P($G(^DPT(DFN,.29)),"^",12)),$P(VAFY,HLFS,8)=$S(X1]"":X1,1:HLQ) ; Rated incompetent
 I VAFSTR[",9," S X=$P($G(^DPT(DFN,.35)),"^",1),X1=$$HLDATE^HLFNC(X),$P(VAFY,HLFS,9)=$S(X1]"":X1,1:HLQ) ; Date of Death
 I VAFSTR[10 D
 .S X=$P($G(^DPT(DFN,.36)),"^",11)
 .S X1=$P($G(^DPT(+X,0)),"^",1),$P(VAFY,HLFS,10)=$S(X1]"":X1,1:HLQ) ; Collateral sponser name
 I VAFSTR[11 S X=$$INS^VAFHLFNC(DFN),X1=$$YN^VAFHLFNC(X),$P(VAFY,HLFS,11)=$S(X1]"":X1,1:HLQ) ; Active Health Insurance?
 I VAFSTR[12!(VAFSTR[13) D
 .S X=$G(^DPT(DFN,.38))
 .I VAFSTR[12 S X1=$$YN^VAFHLFNC($P(X,"^",1)),$P(VAFY,HLFS,12)=$S(X1]"":X1,1:HLQ) ; Eligible for Medicaid
 .I VAFSTR[13 S X1=$$HLDATE^HLFNC($P(X,"^",2)),$P(VAFY,HLFS,13)=$S(X1]"":X1,1:HLQ) ; Date Medicaid last asked
 I VAFSTR[14 S X=$P(VAFNODE,"^",6) S X1=$P($G(^DIC(10,+X,0)),"^",2),$P(VAFY,HLFS,14)=$S(X1]"":X1,1:HLQ) ; Race
 I VAFSTR[15 S X=$P(VAFNODE,"^",8) S X1=$P($G(^DIC(13,+X,0)),"^",4),$P(VAFY,HLFS,15)=$S(X1]"":X1,1:HLQ) ; Religious Preference
 I VAFSTR[16 S X=$T(HOMELESS^SOWKHIRM) S $P(VAFY,HLFS,16)=$S(X]"":$$HOMELESS^SOWKHIRM(DFN),1:HLQ) ;Homeless Indicator
 I ((VAFSTR[",17,")!(VAFSTR[",20,")) D
 .;POW Status & Location
 .N VAF52,POW,LOC
 .S VAF52=$G(^DPT(DFN,.52))
 .;POW Status Indicated?
 .S POW=$P(VAF52,"^",5)
 .S:(POW="") POW=HLQ
 .;POW Confinement Location (translates pointer to coded value)
 .S LOC=$P(VAF52,"^",6)
 .S:(LOC="") LOC=HLQ
 .;POW Locations 1-6 coverted to 4-9.  & and higher converted to alphas
 .I (LOC'=HLQ) S LOC=$S(LOC>0&(LOC<7):LOC+3,LOC>6&(LOC<9):$C(LOC+58),1:"")
 .;Add to output string
 .S:(VAFSTR[",17,") $P(VAFY,HLFS,17)=POW
 .S:(VAFSTR[",20,") $P(VAFY,HLFS,20)=LOC
 I VAFSTR[18 S X=+$$INSTYP^IBCNS1(DFN),$P(VAFY,HLFS,18)=$S(X]"":X,1:HLQ) ; Insurance Type
EXEMPT I VAFSTR[19 S X=+$$RXST^IBARXEU(DFN),$P(VAFY,HLFS,19)=$S(X'<0:X,1:HLQ) ; RX Copay Exemption Status
 I (VAFSTR[",21,") D
 .;Primary Care Team  (as defined in PCMM)
 .S X=$$OUTPTTM^SDUTL3(DFN)
 .S X=$P(X,"^",2)
 .S:(X="") X=HLQ
 .S $P(VAFY,HLFS,21)=X
 ;
QUIT ; cleanup
 D KVA^VADPT
 Q "ZPD"_HLFS_$G(VAFY)
