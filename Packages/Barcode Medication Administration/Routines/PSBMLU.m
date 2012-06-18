PSBMLU ;BIRMINGHAM/EFC-BCMA MEDICATION LOG FUNCTIONS ;Mar 2004
 ;;3.0;BAR CODE MED ADMIN;**6,11**;Mar 2004
 ;;
 ; Reference/IA
 ; ^XMD/10070
EN ;
 Q
 ;
AUDIT(IEN,TXT,PSBTRN) ; Append and Audit
 D NOW^%DTC
 S RDAT=%
 D:PSBTRN="ADD COMMENT"
 . N XA
 . S XA=$O(^PSB(53.79,IEN,.3,"A"),-1)
 . S RDAT=$P(^PSB(53.79,IEN,.3,XA,0),U,3)
 D:PSBTRN="PRN EFFECTIVENESS" 
 . S RDAT=$P(^PSB(53.79,IEN,.2),U,4)
 D:PSBTRN="UPDATE STATUS"
 . S RDAT=$P(^PSB(53.79,IEN,0),U,6)
 D:PSBTRN="MEDPASS"
 . S RDAT=$P(^PSB(53.79,IEN,0),U,6)
 S:'$D(^PSB(53.79,IEN,.9,0)) ^(0)="^53.799D^^"
 S PSBAD1=""
 S PSBAD1=$O(^PSB(53.79,IEN,.9,"A"),-1)+1
 S ^PSB(53.79,IEN,.9,PSBAD1,0)=RDAT_U_DUZ_U_TXT
 Q
 ;
ERROR(PSB1,PSB2,DFN,PSB3,PSB4,PSB5,PSB6,PSB7) ;
 ; PSB1 = order #
 ; PSB2 = orderable item
 ; PSB3 = message to be sent
 ; PSB4 = schedule
 ; PSB5 = action date/time
 ; PSB6 = med log ien #
 ; PSB7 = user identification
 ; Send Error Msg about problems
 S PSBMG=$$GET^XPAR("DIV","PSB MG DUE LIST ERROR",,"E")
 Q:PSBMG=""
 S PSBMSG(1)="  The following "_$S($G(PSBADMER):"administration",1:"order")_" was NOT displayed"
 S PSBMSG(2)="  on the Virtual Due List"
 S PSBMSG(3)=" "
 S PSBMSG(4)="  Order Number....: "_PSB1
 S PSBMSG(5)="  Orderable Item..: "_PSB2
 S PSBMSG(6)="  Patient.........: "_$$GET1^DIQ(2,DFN_",",.01)_" ("_$$GET1^DIQ(2,DFN_",",.09)_")"
 S PSBMSG(7)="  Ward/Bed........: "_$$GET1^DIQ(2,DFN_",",.1)_"/"_$$GET1^DIQ(2,DFN_",",.101)
 S PSBMSG(8)="  Reason..........: "_PSB3
 S PSBMSG(9)="  Schedule........: "_PSB4
 I $D(PSB5) S PSBMSG(10)="  Action Dt/Tm....: "_PSB5
 I $D(PSB6) S PSBMSG(11)="  BCMA Med Log IEN: "_PSB6
 I $D(PSB7) S PSBMSG(12)="  User............: "_PSB7
 S XMY("G."_PSBMG)="",XMTEXT="PSBMSG(",XMSUB="BCMA - "_$S($G(PSBADMER):"Admin "_$G(PSB6),1:"Order")_" Problem"
 K PSBADMER
 D ^XMD
 K PSB1,PSB2,PSB3,PSB4,PSBMSG,PSBMG,XMY,XMSUB,XMTEXT
 Q
 ;
