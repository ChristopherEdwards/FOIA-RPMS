BLRLBOE ;IHS/CIA/PLS - OE/RR Lab Order Label Driver;22-Jul-2005 23:17;SM
 ;;5.2;LR;**1020**;Sep 13, 2005
 ; This routine is called by the Compiled code field of the
 ; OE/RR Print Formats file entry.
 ;
 ; Example of use:  Q:$$EN^BLRLBOE()
 ;
EN() ;EP
 N FORM
 S FORM=$$UP^XLFSTR($$GET1^DIQ(3.5,+$G(IOS),17))
 I $$OK(FORM) D OUT Q 1
 E  Q 0
OUT ;
 I FORM["INTERMEC" D OUT^BLRLBMEC()
 E  I FORM["MICROCOM" D OUT^BLRLB400()
 Q
 ;
OK(FORM) ;EP
 Q FORM["INTERMEC"!(FORM["MICROCOM")
