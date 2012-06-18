APSPHLP ;IHS/MSC/PLS - Field help utility ;21-Apr-2011 15:20;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1011**;Sep 23, 2004;Build 17
 ;=================================================================
EXTEXP ;EP-
 N CS
 S CS=+$P($G(^PSDRUG(DA,0)),U,3)
 I CS>0,CS<6 D
 .D EN^DDIOL("Extended prescription expiration not allowed for controlled substances.","","")
 .K X
 Q
WRITE ;EN^DDIOL call
 D EN^DDIOL(.PSOHLP) K PSOHLP
 Q
