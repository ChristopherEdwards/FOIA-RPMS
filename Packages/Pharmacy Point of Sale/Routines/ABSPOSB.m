ABSPOSB ; IHS/FCS/DRS - utilities used by ABSPOSB* ;     
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ;  A/R Interfaces - in routines ABSPOSB*
 ;
 ;  ABSPOSBC,ABSPOSBD - the billing background job
 ;  ABSPOSBB - calls to various interfaces
 ;  ABSPOSBB - Third Party Billing
 ;  ABSPOSBQ - reserved for Other interfaces (stub)
 ;  ABSPOSBT - reserved for ANMC
 ;  ABSPOSBP - reserved for PAC (BBM*)
 ;  ABSPOSBV,ABSPOSBW - ILC A/R, main program
 ;  ABSPOSB* all others - mostly ILC A/R, many obsolete
 ; 
 ;  ILC old A/R's NCPDP forms printing in ABSPOSN*
 ;  New NCPDP forms printing in ABSPOSF* - usable by all, not just ILC
 ;
 ;  The following ILC A/R routines are invoked by Point of Sale:
 ;  (this list written on November 12, 2000)
 ;  EN^ABSB1592 - called by ABSPOSN1 - main routine to print bills
 ;  ^ABSBMAKE - called by ABSPOSBM - create an A/R account
 ;  OFFNCPDP^ABSBPBRX - called by ABSPOSBM -
 ;  ^ABSBVCN - called by ABSPOSQD - to assign a VCN
 Q
AGE57(N) ;EP - ABSPOSB5 ; how old is ^ABSPTL(N,... ?   
 ; $$AGE57(N)=number of days, with decimal
 N %,%H,%I,X D NOW^%DTC ; % = now
 N LAST S LAST=$P(^ABSPTL(N,0),U,8)
 I 'LAST S LAST=$P(^ABSPTL(N,0),U,11)
 N RET S RET=$$TIMEDIFI^ABSPOSUD(LAST,%)
 Q RET/86400
ARSYSTEM()  ;EP - what A/R system do we interface to?
 ; 0 (or null?) is the ILC system.
 ; Other true-valued ones are IHS 3PBilling, etc.
 ; The value "NONE" is non-zero, too
 Q $P($G(^ABSP(9002313.99,1,"A/R INTERFACE")),U)
DOINGAR() ;EP - from many places - Do we do a Billing Interface in ABSPOSB*?
 Q $S($$ISABMAR:1,$$ISILCAR:1,1:0)
ISILCAR() ;EP - various places
 Q $$ARSYSTEM=0 ; returns TRUE if it's ILC's billing system
ISABMAR() ; EP - various places
 Q $$ARSYSTEM=3 ; returns TRUE if it's IHS 3rd Party Billing
MUSTILC() ; EP - from many places
 I $$ISILCAR Q 1
 W "Requires the ILC Accounts Receivable system",!
 D PRESSANY^ABSPOSU5()
 Q
 ; ZWRITE command
ZW(%) ;EP - ABSPOSB* ; should instead ZWRITE^ABSPOS
 I $D(%)=0 W %," undefined",! Q
 I $D(%)#10=1 W %,"=",@%,!
 N Q S Q=% F  S Q=$Q(@Q) Q:Q=""  W Q,"=",@Q,!
 Q
