ABSPECZA ; IHS/FCS/DRS - JWS 04:27 PM 28 Sep 1995 ;   [ 09/12/2002  10:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
DISPLAY(SCRNTXT,IEN) ;EP - from ABSPECZ2 and ABSPECZ3
 ;Manage local variables
 N DIC,DR,DA,DIQ,DR,F1,F2,F3,F4,CFLDS,RFLDS,RDA,CDA
 N RJTCODE,RJTNEXT,RJTDA,RJTCOUNT,ANS
 ;
 ;Make sure input variables are defined
 Q:$G(SCRNTXT)=""
 Q:$G(IEN)=""
 ;
 ;G data from Claim Submission Record
 S CDA=$P(IEN,U,1)
 S F1=9002313.02,F2=9002313.0201
 S DIC="^ABSPC(" ; 03/12/2001
 S DR=".01;.02;.05;1.01;1.02;1.03;301;302;3004;400"
 S DA=$P(IEN,U,1)
 S DIQ="CFLDS"
 S DIQ(0)="E"
 S DR(F2)=".04;401:405;407;409:412"
 S DA(F2)=$P(IEN,U,2)
 D EN^DIQ1
 ;
 ;G data from Claim Response Record
 S RDA=$P(IEN,U,3)
 I RDA'="" D
 .S F3=9002313.03,F4=9002313.0301
 .S DIC="^ABSPR(" ; 03/12/2001
 .S DR=".02;1000"
 .S (RDA,DA)=$P(IEN,U,3)
 .S DIQ="RFLDS"
 .S DIQ(0)="E"
 .S DR(F4)="501;503;504;505;506;507;508;509;510;513"
 .S DA(F4)=$P(IEN,U,2)
 .D EN^DIQ1
 ;
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
 W "Claim ID:",?14,$G(CFLDS(F1,CDA,.01,"E"))
 W ?46,"Sent On:",?61,$P($G(CFLDS(F1,CDA,.05,"E")),"@",1),!
 W "PCN#:",?14,$G(CFLDS(F1,CDA,1.02,"E"))
 W ?46,"VCN#:",?61,$G(CFLDS(F1,CDA,1.03,"E")),!
 W $TR($J("",80)," ","-"),!
 ;
 W "Insurer:",?14,$G(CFLDS(F1,CDA,.02,"E"))
 W ?46,"Group #:",?61,$G(CFLDS(F1,CDA,301,"E")),!
 W "Patient:",?14,$G(CFLDS(F1,CDA,1.01,"E"))
 W ?46,"Card #:",?61,$G(CFLDS(F1,CDA,302,"E")),!
 ;
 W $TR($J("",80)," ","-"),!
 W "Medication:",?14,$G(CFLDS(F2,DA(F2),.04,"E")),!
 W "NDC #:",?14,$G(CFLDS(F2,DA(F2),407,"E"))
 W ?46,"Prescriber:",?61,$G(CFLDS(F2,DA(F2),411,"E")),!
 W "RX #:",?14,$G(CFLDS(F2,DA(F2),402,"E"))
 W ?46,"Date Filled:",?61,$G(CFLDS(F2,DA(F2),401,"E")),!
 W "N/Refill:",?14,$G(CFLDS(F2,DA(F2),403,"E"))
 W ?46,"Ingr Cost:",?61,$G(CFLDS(F2,DA(F2),409,"E")),!
 W "Quantity:",?14,$G(CFLDS(F2,DA(F2),404,"E"))
 W ?46,"Sales Tax:",?61,$G(CFLDS(F2,DA(F2),410,"E")),!
 W "Day Supply:",?14,$G(CFLDS(F2,DA(F2),405,"E"))
 W ?46,"Disp Fee:",?61,$G(CFLDS(F2,DA(F2),412,"E")),!
 ;
 I RDA="" D PRESSANY^ABSPOSU5(1,DTIME) Q
 ;
 W $TR($J("",80)," ","-"),!
 ;
 I $G(RFLDS(F4,DA(F4),501,"E"))="CLAIM PAYABLE" D
 .W "Resp Status:",?14,$G(RFLDS(F4,DA(F4),501,"E"))
 .W ?46,"Ingr Cost Pd:",?61,$G(RFLDS(F4,DA(F4),506,"E")),!
 .W "Patient Pay:",?14,$G(RFLDS(F4,DA(F4),505,"E"))
 .W ?46,"Sales Tax Pd:",?61,$G(RFLDS(F4,DA(F4),508,"E")),!
 .W "Rem Ded Amt:",?14,$G(RFLDS(F4,DA(F4),513,"E"))
 .W ?46,"Disp Fee Pd:",?61,$G(RFLDS(F4,DA(F4),507,"E")),!
 .W "Authoriz #:",?14,$G(RFLDS(F4,DA(F4),503,"E"))
 .W ?46,"Total Paid:",?61,$G(RFLDS(F4,DA(F4),509,"E")),!
 .W "Message:",?14,$E($G(RFLDS(F4,DA(F4),504,"E")),1,75),!
 .D PRESSANY^ABSPOSU5(1,DTIME)
 ;
 I $G(RFLDS(F4,DA(F4),501,"E"))="CLAIM CAPTURED" D
 .W "Resp Status:",?14,$G(RFLDS(F4,DA(F4),501,"E")),!
 .W "Authoriz #:",?14,$G(RFLDS(F4,DA(F4),503,"E")),!
 .W "Message:",?14,$E($G(RFLDS(F4,DA(F4),504,"E")),1,75),!
 .D PRESSANY^ABSPOSU5(1,DTIME)
 ;
 I $G(RFLDS(F4,DA(F4),501,"E"))="REJECTED CLAIM" D
 .W "Resp Status:",?14,$G(RFLDS(F4,DA(F4),501,"E"))
 .W ?46,"Reject COUNT:",?61,$G(RFLDS(F4,DA(F4),510,"E")),!
 .W "Message:",?14,$E($G(RFLDS(F4,DA(F4),504,"E")),1,75),!
 .S ANS=$$YESNO^ABSPOSU3("DISPLAY Reject CODEs","NO",0,DTIME)
 .Q:ANS'=1
 .D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 .W !
 .W "Claim ID:",?14,$G(CFLDS(F1,CDA,.01,"E"))
 .W ?46,"Sent On:",?61,$P($G(CFLDS(F1,CDA,.05,"E")),"@",1),!
 .W $TR($J("",80)," ","-"),!
 .S (RJTCOUNT,RJTNEXT)=0
 .F  D  Q:'+RJTNEXT
 ..S RJTNEXT=$O(^ABSPR(RDA,1000,DA(F4),511,RJTNEXT))
 ..Q:'RJTNEXT
 ..S RJTCODE=$P($G(^ABSPR(RDA,1000,DA(F4),511,RJTNEXT,0)),U,1)
 ..Q:RJTCODE=""
 ..Q:'$D(^ABSPF(9002313.93,"B",RJTCODE))
 ..S RJTDA=$O(^ABSPF(9002313.93,"B",RJTCODE,0))
 ..Q:RJTDA=""
 ..S RJTCOUNT=RJTCOUNT+1
 ..W "Reject "_$J(RJTCOUNT,2)_":",?14,$E($P($G(^ABSPF(9002313.93,RJTDA,0)),U,2),1,75),!
 .D PRESSANY^ABSPOSU5(1,DTIME)
 Q
