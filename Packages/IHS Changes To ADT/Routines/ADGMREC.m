ADGMREC ; IHS/ADC/PDW/ENM - CALLS TO GET INSURANCE INFO ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
INS(DFN) ;EP--->prints insurance information
 Q $S(($$MCD=1)&($$MCR=1)&($$PRVX=1):"MCAID/MCARE/PRIV INS",($$MCD=1)&($$PRVX=1):"MCAID/PRIV INS",($$MCR=1)&($$PRVX=1):"MCARE/PRIV INS",($$MCR=1)&($$MCD=1):"MCARE/MCAID",$$MCR=1:"MCARE",$$MCD=1:"MCAID",$$PRVX=1:"PRIV INS",1:"")
 Q
PRVI() ; -- private insurance
 Q $O(^AUPNPRVT("B",DFN,0))
 ;
PRVM() ; -- private insurance eligible multiple ien
 Q $O(^AUPNPRVT(+$$PRVI,11,DT),-1)
 ;
PRVE() ; -- private insurance eligible end date
 Q $P($G(^AUPNPRVT(+$$PRVI,11,+$$PRVM,0)),U,7)
 ;
PRVX() ; -- private insurance eligible
 Q $S($$PRVE>DT:1,($$PRVM)&($$PRVE=""):1,1:"PI")
 ;
MCDC() ; -- medicaid eligibility code
 Q $P($G(^AUPNMCD(+$$MCDI,11,+$$MCDM,0)),U,3)
 ;
MCDN() ; -- medicaid eligibility number
 Q $P($G(^AUPNMCD(+$$MCDI,0)),U,3)
 ;
MCDI() ; -- medicaid eligible ien
 Q $O(^AUPNMCD("B",DFN,0))
 ;
MCDM() ; -- medicaid eligible multiple ien
 Q $O(^AUPNMCD(+$$MCDI,11,DT),-1)
 ;
MCDE() ; -- medicaid eligible end date
 Q $P($G(^AUPNMCD(+$$MCDI,11,+$$MCDM,0)),U,2)
 ;
MCD() ; -- medicaid eligible
 S MCDE=$$MCDE Q $S($$MCDE>DT:1,1:"MCD")
 ;
MCRI() ; -- medicare eligible ien
 Q $O(^AUPNMCR("B",DFN,0))
 ;
MCRM() ; -- medicare eligible multiple ien
 Q $O(^AUPNMCR(+$$MCRI,11,DT),-1)
 ;
MCRE() ; -- medicare eligible end date
 Q $P($G(^AUPNMCR(+$$MCRI,11,+$$MCRM,0)),U,2)
 ;
MCRB() ; -- medicare eligible eligibility
 Q $P($G(^AUPNMCR(+$$MCRI,11,+$$MCRM,0)),U,3)
 ;
MCR() ; -- medicare eligible
 Q $S($$MCRE>DT:1,$$MCRB="B":1,($$MCRM&'$$MCRE):1,1:"MCR")
