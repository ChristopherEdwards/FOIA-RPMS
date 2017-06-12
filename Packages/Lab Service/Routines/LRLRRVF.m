LRLRRVF ;VA/SLC/GDU - LAB REFERENCE RANGE VALUE FORMATTING - LAB UTILITY; 22-Oct-2013 09:22 ; MKK
 ;;5.2;LAB SERVICE;**372,1027,1033**;NOV 01, 1997
 ;
EN(RLV,RHV) ;Entry point for this routine
 ;RLV - Range low value
 ;RHV - Range high value
 ;
 ;If both are null return the low value and quit
 ; I RLV="",RHV="" Q RLV
 I $TR(RLV," ")="",$TR(RHV," ")="" Q RLV    ; IHS/MSC/MKK - LR*5.2*1033
 ;
 I RLV["Ref"&(RHV="") Q RLV
 I RHV["REF"&(RLV="") Q RHV
 I RLV["Ref"&(RHV["Ref") Q $$TRIM^XLFSTR($P(RLV,"Ref:",2)_" "_$P(RHV,"Ref:",2),"LR"," ")
 ;
 ;If only the low is defined
 I RLV'="",RHV="" D  Q RLV
 . I $E(RLV)'?1N S RLV="Ref: "_RLV  Q  ; IHS/MSC/MKK - LR*5.2*1033 -- If first character is non-numeric, just return it
 . I RLV=0 S RLV="Ref: >="_RLV Q
 . I ($E(RLV,1,1)="<")!($E(RLV,1,1)=">") S RLV="Ref: "_RLV Q
 . I (RLV?.N.".".N) S RLV="Ref: >="_RLV Q
 . S RLV="Ref: "_RLV
 ;
 ;If only the high is defined
 I RLV="",RHV'="" D  Q RHV
 . I $E(RHV)'?1N S RHV="Ref: "_RHV  Q  ; IHS/MSC/MKK - LR*5.2*1033 -- If first character is non-numeric, just return it
 . I RHV=0 S RHV="Ref: "_RHV Q
 . I ($E(RHV,1,1)="<")!($E(RHV,1,1)=">") S RHV="Ref: "_RHV Q
 . I (RHV?.N.".".N) S RHV="Ref: <="_RHV Q
 . S RHV="Ref: "_RHV
 ;
 ;If both are defined
 Q RLV_" - "_RHV
