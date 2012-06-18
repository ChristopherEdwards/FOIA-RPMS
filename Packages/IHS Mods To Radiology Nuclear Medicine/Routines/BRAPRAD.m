BRAPRAD ;CIA/PLS,IHS/ITSC/CLS - Radiology Protocol Event API
 ;;5.0;Radiology/Nuclear Medicine;**1001**;Feb 20, 2004
 ;BRAPCCZ was modified at line VRAD+25 with $G(RARPT)
 ;BRAPCCZ seems to have problems if CREATE is called with
 ; an existing V Rad entry. A new entry is added but the
 ; old entry is not removed. The API should update the
 ; existing entry when needed.
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
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(RAMSG(LP)) Q:'LP  Q:$E(RAMSG(LP),1,$L(TYP))=TYP
 Q $S(LP:RAMSG(LP),1:"")
 ;
 ; Register exam
SN ; New Order (doesn't create visit - "PCC" node abscent)
 Q  ;IHS/ITSC/CLS 01/08/2004 doesn't need to run through the code
SC ; Status Change (scheduled, registered, or unverified)
 ; Status Change (registered - ORSTS="ZR", ACTION="SC")
 ; Status Change (examined   - ORSTS="", ACTION="SC")
 ; Status Change (unverified - ORSTS=ZU, ACTION="SC")
 I ORDSTS="ZU" D  ;IHS/ITSC/CLS 01/08/2004 released report was unverified
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 .Q
 ;
 I ORDSTS="" D  ;IHS/ITSC/CLS 12/31/2003 don't create visit for registered
 .I RAPCC D  ; Set to capture when Status Change is made
 ..D CREATE^BRAPCC
 ..D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
OH ; Exam on Hold, not even registered yet so no action necessary
 Q  ;IHS/ITSC/CLS 01/14/2004
OD ; Delete Exam and request
 I RAPCC D
 .D DELETE^BRAPCC
 .D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
OC ; Cancelled
DC ; Discontinued
 D DELETE^BRAPCC
 D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
RE ; Report verification
 I $P($G(RA74("0")),U,5)="V",'RAPCC D  Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;IHS/ITSC/CLS 12/16/2003 just update impression, visit & v rad already created
 I $P($G(RA74("0")),U,5)="V",RAPCC D  Q
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 ;
 ;IHS/ITSC/CLS 02/13/2004 create visit and v rad if exam status override to complete 
 I $P(^RA(72,$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),"^",3),0),"^")["COMPLETE",'RAPCC D
 .D CREATE^BRAPCC
 .D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
