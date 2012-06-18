ABSPOS6G ; IHS/FCS/DRS - DUR stuff ;
 ;;1.0;PHARMACY POINT OF SALE;**1,31**;JUN 21, 2001
 Q
DURBRIEF(RXI)      ;EP - from ABSPOS6B ;
 ; $$ brief version - for the list manager line
 S RXI=$P(RXI,".",1)  ;IHS/OIT/SCR 05/07/09 patch 31 for some reason some RXIs come in with stuff after the "."
 N RESP S RESP=$P($G(^ABSPT(RXI,0)),"^",5)
 I 'RESP Q ""  ; no response message
 N POS S POS=$P($G(^ABSPT(RXI,0)),"^",9)
 I $G(POS)="" Q ""  ;IHS/OIT/SCR 05/07/07 avoid undefined error patch 1
 N DUR S DUR=$P($G(^ABSPR(RESP,1000,POS,525)),"^")
 I DUR="" Q ""
 N I,RET S RET="" F I=1,54,107 D
 . N Y S Y=$E(DUR,I,I+53-1)
 . N X S X=$E(Y,1,2)
 . I "  0  00"[X Q
 . S:RET]"" RET=RET_" " S RET=RET_$$DUR^ABSPECP2(X)
 . N MSG S MSG=$E(Y,20,49) F  Q:$E(MSG,$L(MSG))'=" "  D
 . . S MSG=$E(MSG,1,$L(MSG)-1)
 . I MSG]"" S RET=RET_"("_MSG_")"
 Q RET
