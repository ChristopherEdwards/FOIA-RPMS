ASDN1 ; IHS/ADC/PDW/ENM - IHS CHANGES TO NO-SHOW LETTERS ; [ 09/26/2000  3:55 PM ]
 ;;5.0;IHS SCHEDULING;**5**;MAR 25, 1999
 ;
ARBK(DATE) ;EP; called by SDN1 to find if uncancelled auto-rebooked appt exists
 ; -- DATE is date of rebooked appt; returns value to SDR
 NEW ASDY,ASDZ
 S ASDY=$P($G(^DPT(DFN,"S",DATE,0)),U,2) I ASDY="" Q 1
 ;IHS/ASDST/POC/ENM NX LINE CHNG C=CANCEL, N=NOSHOW, PC=PATIENT CANCEL
 ;I ASDY="C"!(ASDY="N") Q 0
 I ((ASDY="C")!(ASDY="N")!(ASDY="PC")) Q 0 ;IHS/ASDST/POC/ENM 09/26/00
 ;I ASDY["A" S ASDZ=$P(^DPT(DFN,"S",DATE,0),U,10) I ASDZ="" Q 0
 S ASDZ=$P(^DPT(DFN,"S",DATE,0),U,10) I ((ASDY["A")&(ASDZ=""))!(ASDZ="") Q 0 ;INS/ASDST/POC/ENM 09/26/00 "A"=AUTO-REBOOK STATUS
 I $P($G(^DPT(DFN,"S",ASDZ,0)),U,2)'["C" Q 1
 Q $$ARBK(ASDZ)
 ;
FINDA ;EP called by SDN1 to find uncancld auto-rebooked appt
 ; -- variables to reset SDX,SDC,S
 NEW ASDX,ASDY,ASDZ
 S ASDX=SDX
 S ASDY=$P($G(^DPT(DFN,"S",ASDX,0)),U,2) I ASDY="" Q  ;okay
 I ASDY="C"!(ASDY="N") S ASDQ="" Q  ;deadend, no new appt
 S ASDZ=$P(^DPT(DFN,"S",ASDX,0),U,10)
 I ASDZ="" S ASDQ="" Q  ;deadend all cancelled
 S SDX=ASDZ,S=^DPT(DFN,"S",SDX,0),SDC=$P(^(0),U)
 I $P($G(^DPT(DFN,"S",ASDZ,0)),U,2)'["C" Q  ;this one okay
 D FINDA Q  ;loop again
 ;
RBKDT(SDX,DFN) ;EP called by SDNOS1 to return date of uncancld rebooked appt
 NEW SDC,S D FINDA Q SDX
