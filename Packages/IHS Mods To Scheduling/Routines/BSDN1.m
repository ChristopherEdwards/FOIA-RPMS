BSDN1 ; IHS/ANMC/LJF - IHS CHANGES TO NO-SHOW LETTERS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
ARBK(DATE) ;EP; called by SDN1 to find if uncancelled auto-rebooked appt exists
 ; -- DATE is date of rebooked appt; returns value to SDR
 NEW BSDY,BSDZ
 S BSDY=$P($G(^DPT(DFN,"S",DATE,0)),U,2)  ;appt status
 I (BSDY="")!(BSDY="NT")!(BSDY="I") Q 1   ;appt okay
 I BSDY'["A" Q 0                          ;not rebooked
 S BSDZ=$P(^DPT(DFN,"S",DATE,0),U,10)     ;rebook appt date/time
 I BSDZ="" Q 0                            ;not really rebooked
 Q $$ARBK(BSDZ)
 ;
FINDA ;EP called by SDN1 to find uncanceled auto-rebooked appt
 ;follows path thru every rebooked no-show and cancellation
 ; -- variables to reset SDX,SDC,S
 NEW BSDX,BSDY,BSDZ
 S BSDX=SDX
 S BSDY=$P($G(^DPT(DFN,"S",BSDX,0)),U,2)    ;appt status
 I (BSDY="")!(BSDY="NT")!(BSDY="I") Q       ;okay
 I BSDY="C"!(BSDY="N") S BSDQ="" Q          ;deadend, no new appt
 S BSDZ=$P(^DPT(DFN,"S",BSDX,0),U,10)       ;rebooked appt date/time
 I BSDZ="" S BSDQ="" Q                      ;deadend all cancelled
 ;
 ; reset appt date, data node and clinic then loop again
 S SDX=BSDZ,S=^DPT(DFN,"S",SDX,0),SDC=$P(^(0),U)
 D FINDA
 Q
 ;
RBKDT(SDX,DFN) ;EP called by SDNOS1 to return date of uncancld rebooked appt
 NEW SDC,S D FINDA Q SDX
