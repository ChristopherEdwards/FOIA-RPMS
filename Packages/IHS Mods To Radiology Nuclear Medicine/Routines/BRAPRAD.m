BRAPRAD ;CIA/PLS,IHS/ITSC/CLS - Radiology Protocol Event API ; 28 Apr 2014  4:26 PM
 ;;5.0;Radiology/Nuclear Medicine;**1001,1003,1006**;Nov 01, 2010;Build 2
 ;
HOOK ;
 ;S $ZE="RAD PCC TEST" D ^ZTER  ;IHS/ITSC/CLS testing
 N SEG,LP,DL1,DL2,RAPCC,ACTION,ORDSTS
 ; Get SEND PCC AT EXAMINED field
 S RAPCC=+$G(^RA(79,+$G(RAMDIV),9999999))
 S LP=0
 S SEG=$$SEG("MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 Q:$P(SEG,DL1,3)'="RADIOLOGY"
 S SEG=$$SEG("ORC",.LP)
 Q:'LP
 S ORDSTS=$P(SEG,DL1,6)  ; Order Status
 S ACTION=$P(SEG,DL1,2)  ; Order Control
 I ACTION?2U,$L($T(@ACTION)) D @ACTION
 Q
 ;
 ;
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(RAMSG(LP)) Q:'LP  Q:$E(RAMSG(LP),1,$L(TYP))=TYP
 Q $S(LP:RAMSG(LP),1:"")
 ;
 ;
SN ; New Order (doesn't create visit - "PCC" node absent)
 Q
 ;
 ;
SC ; Status Change (scheduled, registered, or unverified)
 ; Status Change (registered - ORSTS="ZR", ACTION="SC")
 ; Status Change (examined   - ORSTS="", ACTION="SC")
 ; Status Change (unverified - ORSTS=ZU, ACTION="SC")
 ;
 ;Released report was unverified
 I ORDSTS="ZU" D
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;
 ;Don't create visit for registered
 ;Do create visit if examined and 'Send PCC at Examined' is YES
 I ORDSTS="" D
 .I RAPCC D
 ..D CREATE^BRAPCC
 ..D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
 ;
 ;
OH ; Exam on Hold, not even registered yet so no action necessary
 Q
 ;
 ;
OD ; Delete Exam and request
 I RAPCC D
 .D DELETE^BRAPCC
 .D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
 ;
 ;
OC ; Cancelled
DC ; Discontinued
 D DELETE^BRAPCC
 D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
 ;
 ;
RE ; Report verification
 ;
 I +$G(RADFN)=0 Q
 I +$G(RADTI)=0 Q
 I +$G(RACNI)=0 Q
 ;
 ;We have a verified report and 'Send PCC at Examined' is NO,
 ;then create the PCC Visit and create the Women's Health entry
 I $P($G(RA74("0")),U,5)="V",'RAPCC D  Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;We have a verified report and 'Send PCC at Examined' is YES,
 ;but no PCC visit has been created,
 ;then create the PCC Visit and create the Women's Health entry
 I $P($G(RA74("0")),U,5)="V",RAPCC D  Q
 .I +$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,3) Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;We have a verified report and 'Send PCC at Examined' is YES,
 ;and we have a PCC visit already created,
 ;then update the V Rad entry and update the Women's Health entry
 I $P($G(RA74("0")),U,5)="V",RAPCC D  Q
 .I +$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,3)=0 Q
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDTDX^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;Create visit and V RAD if exam status override to complete 
 ;and No PCC Visit exists
 I $P(^RA(72,$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,3),0),U)["COMPLETE" D  Q
 .I +$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,3) Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;Update visit and V Rad if exam status override to complete,
 ;and a PCC Visit exists
 I $P(^RA(72,$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,3),0),U)["COMPLETE" D  Q
 .I +$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,3)=0 Q
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDTDX^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 Q
