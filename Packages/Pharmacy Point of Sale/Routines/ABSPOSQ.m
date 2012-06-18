ABSPOSQ ; IHS/FCS/DRS - POS background, Part 1 ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; ABSPOSQ1 - Assemble claim information
 ; ABSPOSQ2 - Put claims into packets for transmission
 ; ABSPOSQ3 - Send and Receive
 ; ABSPOSQ4 - Process Responses
 ;
 ; Numerous little $$'s called by ABSPOSQB, etc. are here
 ; .57 versions of these are in ABSPOS57, using IEN57
 ;
DRGDFN() ;EP -
 Q $P(^PSRX($$RXI,0),U,6) ; Given IEN59, return DRGDFN
DRGNAME()          Q $P(^PSDRUG($$DRGDFN,0),U) ; Given IEN59, return DRGNAME
RXI() ;EP -
 Q $P(^ABSPT(IEN59,1),U,11) ; Given IEN59, return RXI
RXR() ;EP -
 Q $P(^ABSPT(IEN59,1),U,1) ; Given IEN59, return RXR
N57LAST() ;EP -
 Q $O(^ABSPTL("NON-FILEMAN","RXIRXR",$$RXI,$$RXR,""),-1)
NDC() ;EP -
 I $$TYPE=1 Q $P(^ABSPT(IEN59,1),U,2)
 D IMPOSS^ABSPOSUE("P","TI","postage and supplies not implemented",,"NDC",$T(+0))
 Q
QTY() Q $P(^ABSPT(IEN59,5),U) ; Given IEN59, return quantity
AMT() ;EP -
 Q $P(^ABSPT(IEN59,5),U,5) ; return total $amount
CHG() Q $P(^ABSPT(IEN59,5),U,5) ; Given IEN59, ret total charge
CPTIEN() I $$TYPE=1 Q $O(^ABSCPT(9002300,"AVMED",$$DRGDFN,0))
 ; CPT code for postage could vary by insurer and amount?
 ; A complication not yet programmed
 I $$TYPE=2 Q $P($G(^ABSP(9002313.99,1,"POSTAGE")),U)
 I $$TYPE=3 Q $$EXTRCPT3 ; extract CPT from  visitien.cptien3
 Q "" ; not reach; $$TYPE already checked for 1, 2, 3
EXTRCPT3()          N X S X=IEN59,X=$P(X,".",2),X=$E(X,1,$L(X)-1) Q +X
PATIENT()          Q $P(^ABSPT(IEN59,0),U,6)
VISITIEN() Q $P(^ABSPT(IEN59,0),U,7)
USER() N X S X=$P(^ABSPT(IEN59,0),U,10) S:'X X=$G(DUZ) Q X
TYPE() ;EP -
 N X S X=$E(IEN59,$L(IEN59)) ; 1=prescription, 2=postage, 3=other
 I X'=1,X'=2,X'=3 D  S X=""
 . D IMPOSS^ABSPOSUE("DB","TI","Bad type for IEN59="_IEN59,,"TYPE",$T(+0))
 Q X
NOW() N %,%H,%I,X D NOW^%DTC Q %
FILLDATE()         N RXI,RXR S RXI=$$RXI,RXR=$$RXR
 Q:RXR $P(^PSRX(RXI,1,RXR,0),U)  Q:RXI $P(^PSRX(RXI,2),U,2)
 Q $$VISDATE
VISDATE() Q $P($P(^AUPNVSIT($$VISITIEN,0),U),".")
VMED() N RXI,RXR S RXI=$$RXI,RXR=$$RXR
 Q:RXR $P(^PSRX(RXI,1,RXR,999999911),U) Q $P(^PSRX(RXI,999999911),U)
PROVIDER()         Q $P(^PSRX($$RXI,0),U,4)
VCN() Q $P(^AUPNVSIT($$VISITIEN,"VCN"),U)
 ;
ARSYSTEM()         Q $P(^ABSP(9002313.99,1,"A/R INTERFACE"),U)
MAKEVCN() ;EP - true/false  should we assign a VCN # to the visit?
 N AR S AR=$$ARSYSTEM
 I AR=0 Q 1 ; yes, for ILC A/R
 I AR=2 Q 1 ; yes, for ANMC A/R
 Q 0 ; no, for everybody else
LOG2LIST(MSG) ;EP -
 D LOG2LIST^ABSPOSL(MSG) Q
LOG2CLM(MSG,IEN02) ;EP 
 D LOG2CLM^ABSPOSL(MSG,IEN02) Q
LOG59(MSG,IEN59) ;EP -
 D LOG59^ABSPOSL(MSG,IEN59) Q
