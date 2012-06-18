BLRESRNS ; IHS/OIT/MKK - Laboratory E-SIG Report: Not Signed ; [ 04/12/06  4:00 PM ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;
 ; NOTE:  The LRIDT variable in the LR("BLRA") index is stored as
 ;        as a negative number.  That is why, in several places,
 ;        the code does -(LRIDT).
 ;
EP ; "Ersatz" EP
 W $C(7),$C(7),$C(7),!
 W "Use Label Only",!
 W $C(7),$C(7),$C(7),!
 Q
 ;
 ; This routine prints a summary listing of all providers in the
 ; BLRA LAB PHYSICIANS file that have not signed E-SIG transactions.
NREVNSGN      ;             EP
 NEW RESP,STATUS,LRIDT,LRIIDT,LRDFN,LRAA
 NEW TOTAL,NVTOT,NSTOT
 NEW PHYNAME
 ;
 S RESP=0,STATUS=""
 F  S RESP=$O(^LR("BLRA",RESP))  Q:RESP=""  D
 . F  S STATUS=$O(^LR("BLRA",RESP,STATUS))  Q:STATUS=""  D
 .. I STATUS=2 Q                   ; If Signed, skip it
 .. ;
 .. S STATUS(STATUS)=""
 .. S LRIIDT=""
 .. F  S LRIIDT=$O(^LR("BLRA",RESP,STATUS,LRIIDT))  Q:LRIIDT=""  D
 ... S LRDFN=""
 ... F  S LRDFN=$O(^LR("BLRA",RESP,STATUS,LRIIDT,LRDFN))  Q:LRDFN=""  D
 .... S LRAA=$O(^LR("BLRA",RESP,STATUS,LRIIDT,LRDFN,""))
 .... I LRAA="" Q
 .... ;
 .... S TOTAL(RESP)=1+$G(TOTAL(RESP))
 .... S TOTAL(RESP,STATUS)=1+$G(TOTAL(RESP,STATUS))
 ;
 I $$GETDEV^BLRESIGR="Q" D  Q
 . W !,"Output Device Error",!!
 . D BLRGPGR^BLRGMENU()
 ;
 D NREVSUMH
 ;
 S (NSTOT,NVTOT,RESP,TOTAL)=0
 F  S RESP=$O(TOTAL(RESP))  Q:RESP=""!(QFLG="Q")  D
 . I LINES>MAXLINES D BLRGHWPN^BLRGMENU(.PG,.QFLG)  I QFLG="Q" Q
 . S PHYNAME=$P($G(^VA(200,RESP,0)),"^",1)
 . ;
 . W PHYNAME
 . W ?34,$J(+$G(TOTAL(RESP,0)),5)  ; Not viewed
 . W ?44,$J(+$G(TOTAL(RESP,1)),5)  ; Not signed
 . W ?54,$J(+$G(TOTAL(RESP)),5)    ; Total of both
 . W !
 . S LINES=LINES+1
 . S TOTAL=TOTAL+$G(TOTAL(RESP))
 . S NVTOT=NVTOT+$G(TOTAL(RESP,0))
 . S NSTOT=NSTOT+$G(TOTAL(RESP,1))
 ;
 W ?34,"-----"
 W ?44,"-----"
 W ?54,"-----"
 W !
 W "TOTAL"
 W ?34,$J(NVTOT,5)
 W ?44,$J(NSTOT,5)
 W ?54,$J(TOTAL,5)
 W !
 ;
 D ^%ZISC
 ;
 D BLRGPGR^BLRGMENU()
 ;
 Q
 ;
 ; NOT SIGNED Summary Report Header
NREVSUMH ;
 K HEADER
 S HEADER(1)="LAB E-SIG NOT SIGNED SUMMARY REPORT"
 S HEADER(2)="SORTED BY RESPONSIBLE PHYSICIAN"
 S HEADER(3)=" "
 S $E(HEADER(4),35)=$J("Not",5)
 S $E(HEADER(4),45)=$J("Not",5)
 ;
 S $E(HEADER(5),35)=$J("View",5)
 S $E(HEADER(5),45)=$J("Sign",5)
 ;
 S HEADER(6)="Physician Name"
 S $E(HEADER(6),35)="Count"
 S $E(HEADER(6),45)="Count"
 S $E(HEADER(6),55)="Total"
 ;
 Q
