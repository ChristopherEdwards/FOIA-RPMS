BOPTU ;IHS/ILC/CAP - ILC RX - Utility Subroutines;26-Jan-2006 08:58;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;
 ;The following function returns the value of the Automation Site and
 ;a code for the type of NursingUnit/Room/Bed decoding that is
 ;necessary.
 ;
 ;The LOCATION DECODING TYPE is necessary because different facilities
 ;use room/bed and Nursing Unit in different formats.  Type 1, for
 ;instance (Palo-Alto defaults to this type as it was installed before
 ;the implementation of this field) indicates that NU-Room-Bed is all
 ;stored in the Room-Bed field.  At Hines, type 2, the NU is stripped
 ;of all "-"'s.
 ;
SITE(X) ;EP - Return BOP Site, Room Decoding Code
 ;I X is null or zero, only the Automation site is returned
 ;If X is 1, the return has two "^" pieces, the second being
 ;       the Location Decoding Code (defaulted to if none on file)
 ;
 ;If no Automation Site is on file, one is automatically created from
 ;the MailMan domain on file at ^XMB("NETNAME").
 ;Set up BOP defaults
 ;
 ; N C,Y,Z
 S Z=$O(^BOP(90355,0)),Y=$S(Z:$G(^(Z,"SITE")),1:""),C=Y
 I $P(Y,U)="" S $P(Y,U)=^XMB("NETNAME")
 I $P(Y,U,2)="" S $P(Y,U,2)=0
 ;
 ;Update BOP Site Parameters if pieces were null
 I C'=Y,Z S ^BOP(90355,Z,"SITE")=Y
 ;
 Q $S(X:Y,1:$P(Y,U))
 ;
INTFACE(X) ;EP -  Return which intererface is being used
 ;  if none there default pyxis
 ;  'X' is the internal site number
 ;
 N A,B S A=$G(^BOP(90355,X,2)),B=$P(A,"^",5)
 Q $S(B'="":B,1:"P")
 ;
 ;BOPA = the ien of the file #90355.1
FORMU(BOPA) ;EP - ef value = 'Y' if formulary, ='N' if else
 Q $S($P($G(^BOP(90355.1,BOPA,0)),"^",50)="Y":"Y",1:"N")
 ; Return most recent vital of specified type
 ; Return value is IEN^VALUE^DATE
VITAL(DFN,TYP) ; EP
 N IDT,IEN,DAT,VIS
 S:TYP'=+TYP TYP=$O(^AUTTMSR("B",TYP,0))
 Q:'TYP ""
 S IDT=$O(^AUPNVMSR("AA",DFN,TYP,0))
 Q:'IDT ""
 S IEN=+$O(^AUPNVMSR("AA",DFN,TYP,IDT,$C(1)),-1)
 Q:'IEN ""
 S X=$G(^AUPNVMSR(IEN,0)),DAT=+$G(^(12))
 S:'DAT DAT=+$G(^AUPNVSIT(+$P(X,U,3),0))
 Q IEN_U_$P(X,U,4)_U_DAT
 ; Return height in cm
VITCHT(VAL) ; EP
 Q $J($G(VAL)*2.54,0,2)
 ; Return weight in kg
VITCWT(VAL) ; EP
 Q $J($G(VAL)/2.2046226,0,2)
 ; Return vital date in format MM/DD/YYYY
VITDT(VAL) ; EP
 Q $$FMTE^XLFDT(VAL,"5DZ0")
