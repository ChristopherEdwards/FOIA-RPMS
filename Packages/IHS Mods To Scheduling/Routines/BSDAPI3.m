BSDAPI3 ; IHS/ITSC/LJF - ATTACH ANCILLARY ITEM TO APPT/VISIT;
 ;;5.3;PIMS;**1002,1009**;APR 26, 2002
 ;IHS/ITSC/LJF 12/23/2004 PATCH 1002 rewrote routine to call new BSDAPI4
 ;cmi/anch/maw 06/10/2008 PATCH 1009 added set of variable "SHOW VISITS" so that user can select visit if there, maybe in future release.
 ;
EN(DFN,BSDCLD,BSDREAS,BSDITEM) ;PEP; 
 ; CALLED BY ANICLLARY PACKAGES (LAB, RAD, PHR)
 ; Used in INTERACTIVE MODE to select an appt to attach ordered items
 ; If appt is already checked in, returns visit IEN
 ; If not, proceeds to check patient in and create visit
 ; If patient has more than one appt, list is displayed
 ; There will always be a final choice of adding an walkin appt/visit
 ;   to the ancillary service
 ;
 ; Called by using this approach:
 ;   S VISIT=$$EN^BSDAPI3(patient ien,default clinic,default reason,item)
 ;
 ; INPUT VARIABLES:
 ;      DFN     -  Patient IEN
 ;      BSDCLD  -  Clinic Default IEN for ancillary walkin visits
 ;      BSDREAS -  Default reason for appt ("lab draw", "radiology walk-in", etc.)
 ;      BSDITEM -  Item name ("test(s)", "exam", "prescription", "order")
 ;                  Phrasing up to calling routine
 ;
 ; OUTPUT VARIABLES:
 ;      Returns string - first piece is Visit IEN or zero if error occurred
 ;                       second piece set if error and is error message
 ;
 I '$G(DFN)!'$G(BSDCLD) Q 0_U_"Bad Input Parameters"
 I $$GET1^DIQ(9009017.2,BSDCLD,.09)'="YES" Q 0_U_"Default Clinic NOT set up to create visits"
 ;
 ;Get list of appts and their visits if any
 W !!,"Attaching "_BSDITEM_" to an Appointment and PCC Visit . . ."
 NEW BSDDT,BSDEND,APPT,BSDCNT,BSDARR,BSDCLDN,BSDVST
 S BSDCLDN=$$GET1^DIQ(44,BSDCLD,.01)   ;set name for default clinic
 S BSDDT=$$FMADD^XLFDT(DT,-1)_".24"    ;start just before today
 S BSDEND=DT+.24                       ;only look at today
 F  S BSDDT=$O(^DPT(DFN,"S",BSDDT)) Q:'BSDDT  Q:BSDDT>BSDEND  D
 . S APPT=$G(^DPT(DFN,"S",BSDDT,0)) Q:APPT=""
 . S BSDCNT=$G(BSDCNT)+1
 . S BSDARR(BSDCNT)=BSDDT_U_$P(APPT,U)_U_$$STATUS(DFN,BSDDT)
 ;
 ;
 ; if no appts found, tell user walk-in appt to their service is being added
 I '$G(BSDCNT) D  Q $G(BSDVST)
 . W !!,"No Appts Today for Patient; Adding Walk-in Appt to "_BSDCLDN
 . S BSDVST=$$CHECKIN(BSDCLD,$$NOW^XLFDT,BSDREAS)     ;add ancillary WALK-in and return visit ien
 ;
CHOOSE ; Otherwise, display list of appts so user can select one
 NEW COUNT,APPT,Y W !
 S COUNT=0 F  S COUNT=$O(BSDARR(COUNT)) Q:'COUNT  D
 . S APPT=BSDARR(COUNT)
 . W !,$J(COUNT,3),?5,$$FMTE^XLFDT(+APPT)
 . W ?20,$E($$GET1^DIQ(44,$P(APPT,U,2),.01),1,25),?50,$P(APPT,U,3)
 ;
 S COUNT=$O(BSDARR(99),-1)    ;get highest count
 W !,$J(COUNT+1,3),?5,"Add walk-in appointment to "_BSDCLDN
 S Y=$$READ^BDGF("N^1:"_(COUNT+1),"Select One from List")
 I Y<1 W !!,"You MUST select one from the list!" D CHOOSE Q
 ;
 ; if last choice selected, add walk-in for default clinic
 I Y=COUNT+1 W !!,"Adding Walk-in Appt and Visit to "_BSDCLDN Q $$CHECKIN(BSDCLD,$$NOW^XLFDT,BSDREAS)
 ;
 ; Take appt selected, and check if already has visit attached
 S APPT=BSDARR(+Y)
 S BSDVST=$$GETVST^BSDU2(DFN,+APPT)
 I BSDVST W !!,"PCC Visit found for checked in appointment." Q BSDVST  ;visit already made
 ;
 ; Otherwise perform check-in for appt
 W !!,"Checking in patient to appointment in "_$$GET1^DIQ(44,$P(APPT,U,2),.01)
 Q $$CHECKIN($P(APPT,U,2),$P(APPT,U))
 ;
 ;
 ; subroutines
STATUS(D0,D1) ; return appt's current status
 ; Call to SDAMU requries D0 and D1 set, returns X
 NEW X D CURRENT^SDAMU
 Q X
 ;
CHECKIN(CLN,APPT,OI) ; checkin appt OR create walkin for default clinic
 NEW BSDAR,BSDVST
 S BSDAR("HOS LOC")=CLN            ;clinic ien passed in
 S BSDAR("APPT DATE")=APPT         ;appt time passed in
 S BSDAR("OI")=$G(OI)              ;appt reason if passed in
 ;
 S BSDAR("PAT")=DFN
 S BSDAR("VISIT DATE")=$$NOW^XLFDT
 S BSDAR("LEN")=$$GET1^DIQ(44,CLN,1912)
 S BSDAR("USR")=DUZ
 S BSDAR("FORCE ADD")=1
 S BSDAR("OPT")="SD IHS ANCILLARY"
 S BSDAR("SITE")=$$GET1^DIQ(44,CLINIC,3,"I")
 S BSDAR("SRV CAT")="A"
 S BSDAR("VISIT TYPE")=$$GET1^DIQ(9001001.2,CLN,.11,"I")
 ;S BSDAR("SHOW VISITS")=1  ;cmi/maw 6/10/2008 pass variable to show visits, maybe in future release
 D GETVISIT^BSDAPI4(.BSDAR,.BSDVST)
 ;
 I BSDVST(0)=0 Q BSDVST(0)
 ;I $G(BSDR("VIEN")) Q BSDR("VIEN")  ;cmi/maw 6/10/2008 quit on visit variable if there, maybe in future release
 Q $O(BSDVST(0))
