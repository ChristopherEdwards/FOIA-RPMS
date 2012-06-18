BLRRLCOM ; cmi/anch/maw - BLR Get Order Comments for HL7 Order Message ;
 ;;5.2;LR;**1021**;Jul 27, 2006;Build 9
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;
 ;this routine will look up the test ien, ref lab and ask
 ;the appropriate order comments, it will then return an array
 ;with the appropriate result code and value to be stuffed into
 ;the order's OBX segment
 ;
COM(TIEN,LEDI)          ; EP -- check to see if there are any comments
 I $G(BLRPHASE)'="A",'$G(LEDI) Q ""  ;added check of LEDI for backward compatibility
 S BLRCRL=$P($G(^BLRSITE(DUZ(2),"RL")),U)
 I '$G(BLRCRL) Q "No Reference Lab Defined"
 S BLRRIEN=$O(^BLRRL("ALP",TIEN,BLRCRL,0))
 I '$G(BLRRIEN) Q "No Matching Reference Lab Test"
 I '$D(^BLRRL(BLRCRL,1,BLRRIEN,1,0)) Q "No comments for test"
 S BLRCN=0
 S BLRRC=0 F  S BLRRC=$O(^BLRRL(BLRCRL,1,BLRRIEN,1,BLRRC)) Q:'BLRRC  D
 . S BLRCN=BLRCN+1
 . S BLRTPC=$G(^BLRRL(BLRCRL,1,BLRRIEN,1,BLRRC,0))
 . S BLRTP=$O(^BLRRL("BRES",BLRTPC,BLRCRL,0))
 . Q:'BLRTP
 . S BLRRTI=$P($G(^BLRRL(BLRCRL,1,BLRTP,0)),U,7)
 . S BLRRSC=$P($G(^BLRRL(BLRCRL,1,BLRTP,0)),U,4)
 . S BLRRES=$$ASK(BLRRTI,BLRTP,BLRRSC)
 . I $G(BLRRES)]"" S BLRRLC(TIEN,BLRCN)=$G(BLRRES)
 Q $G(BLRRLC)
 ;
ASK(RTI,RTP,RSC)       ; EP -- ask the comment question and get the result
 N DIR
 S DIR(0)="FO",DIR("A")=RTI
 D ^DIR
 S BLRANS=Y
 Q RSC_U_RTI_U_BLRANS
 ;
