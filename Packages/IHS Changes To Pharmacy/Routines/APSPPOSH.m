APSPPOSH ;IHS/CIA/PLS - Point of Sale Event Hook;21-Mar-2007 16:21;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1005**;01/22/2004
EN(DATA) N MSG
 I $D(DATA)=1 M MSG=@DATA
 E  M MSG=DATA
 ;D LOG(.MSG)
 ;D TASK
 Q
 ; Log data
LOG(ARY,NMSP) ;EP
 S NMSP="ABSPHOOK"_$S($G(NMSP)="":"",1:"."_NMSP)
 L +^XTMP("ABSPHOOK"):2
 M ^($O(^XTMP("ABSPHOOK",""),-1)+1)=ARY
 L -^XTMP("ABSPHOOK")
 Q
 ; Taskman Entry Point
TASK N SEG,LP,DL1,DL2,ERR,ACTION,IEN,RET
 Q:$G(PSOFROM)="PARTIAL"  ; Don't process partial fills
 S ZTREQ="@"
 S ERR=""
 S LP=0
 S SEG=$$SEG("MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 Q:$P(SEG,DL1,3)'="PHARMACY"
 S SEG=$$SEG("ORC",.LP)
 Q:'LP
 S IEN=$P($P(SEG,DL1,4),U)  ;Prescription IEN
 S ACTION=$P(SEG,DL1,2)  ;Order Control
 I ACTION?2U,$L($T(@ACTION)) D @ACTION
 Q
 ;
SN ; New Order
 S RET=$$EN^APSQBRES(IEN,"","A")
 Q
OD ; Discontinued Order
 S RET=$$EN^APSQBRES(IEN,"","D")
 Q
XX ; Edited Order
 S RET=$$EN^APSQBRES(IEN,"","A")
 Q
 ;
ZD ; Refill Order/Return to Stock
 S REF=$$EN^APSQBRES(IEN,$O(^PSRX(IEN,1,$C(1)),-1),"A")
 Q
OH ; Hold Order
 S RET=$$EN^APSQBRES(IEN,"","D")
 Q
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(MSG(LP)) Q:'LP  Q:$E(MSG(LP),1,$L(TYP))=TYP
 Q $S(LP:MSG(LP),1:"")
