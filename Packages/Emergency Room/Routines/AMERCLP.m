AMERCLP ; IHS/ANMC/GIS - SELECT PATIENTS & PRINT CHART LABELS ;  
 ;;3.0;ER VISIT SYSTEM;**2**;FEB 23, 2009
 ;
EN(DFN)  ; EP FROM AMERBSDU TO ALLOW PARAMATER TO BE PASSED IN CORRECT NAMESPACE
 N X
 D AMER
 Q
AMER  ;
 ; Users would like to choose how many copies
 N DIR,Y,AMERCOPY
 S (DIR("B"),AMERCOPY)=4
 S DIR("?")="Enter the number of labels to print"
 ;S DIR("?",1)="Enter up to 10 labels to print"
 S DIR("?",1)="Enter up to 50 labels to print"
 ;S DIR(0)="N^1:10:0",DIR("A")="Enter number of labels to print"
 S DIR(0)="N^1:50:0",DIR("A")="Enter number of labels to print" ;IHS/SCR/OIT 072709 patch 2
 D ^DIR
 S:+Y'=-1 AMERCOPY=+Y
 K DIR,Y
DEV  ;
 S %ZIS("A")="LABEL PRINTER: "
 ;S %ZIS("B")="LER" - IHS/OIT/SCR - 10/15/08 - REMOVE HARD CODED PRINTER
 S %ZIS("B")=$P($G(^AMER(2.5,DUZ(2),0)),"^",2)
 D ^%ZIS
 I POP D HOME^%ZIS Q
START ;
 U IO
 ;
 S AGCHART="00000"_$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)
 S AGCHART=$E(AGCHART,$L(AGCHART)-5,$L(AGCHART))
 S AGSEX=$P(^DPT(DFN,0),U,2)   ;sex  ;chart #
 S AGNAME=$E($P(^DPT(DFN,0),U),1,20)    ;name
 S AGDOB=$P(^DPT(DFN,0),U,3)  ;dob
 S AGCOM=$P($G(^AUPNPAT(DFN,11)),U,18)  ;current community
 ;F AG=1:1:COPY D
 F AG=1:1:AMERCOPY D
 .W ?5,$E(AGCHART,1,2)_"-"_$E(AGCHART,3,4)_"-"_$E(AGCHART,5,6)
 .W ?20,AGSEX,!,?5,AGNAME
 .W !,?5,$E(AGDOB,4,5)_"/"_$E(AGDOB,6,7)_"/"_$E(AGDOB,2,3),?15,AGCOM
 .W !,?5,$S(($$MCD=1)&($$MCR=1)&($$PRVX=1):"MCAID/MCARE/PRIV INS",($$MCD=1)&($$PRVX=1):"MCAID/PRIV INS",($$MCR=1)&($$PRVX=1):"MCARE/PRIV INS",($$MCR=1)&($$MCD=1):"MCARE/MCAID",$$MCR=1:"MCARE",$$MCD=1:"MCAID",$$PRVX=1:"PRIV INS",1:"")
 .W !!!
 ;
END K AG,AGNAME,AGCHART,AGSEX,AGDOB,AGCOM,DFN
 D ^%ZISC
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
