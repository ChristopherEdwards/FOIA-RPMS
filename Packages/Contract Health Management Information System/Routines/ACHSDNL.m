ACHSDNL ; IHS/ITSC/PMF - DENIAL LTR/FS (OPTS) (1/6) ;   [ 10/31/2003  11:44 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**4,6**;JUNE 11, 2001
 ;ACHS*3.1*4  allow different numbers of office copies
 ;
 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ VAR NOT SET PRIOR TO $O
 ;
 D SETCK^ACHSDF1    ;CHECK SITE PARAMETERS AND CLEAN INCOMPLETE DOCS
 Q:$G(ACHDXQT)
 K X2,X3
SEL ;
 D QSEL
 S Y=$$DIR^ACHS("N^1:2:0","Select",1,"","^D QSEL^ACHSDNL",2)
 ;
 G PAT:Y=1       ;PATIENT INPUT AND LOOKUP
 G BDT:+Y=2      ;DATE INPUT
 D END
 Q
 ;
PAT ; --- Select Denial
 S ACHDOCT="denial"
 K DFN
 D ^ACHSDLK                    ;PATIENT LOOKUP
 I $D(ACHDLKER) D END Q
 ;
 I $$DN^ACHS(0,8)="Y" W !!!,*7,*7,?15,"Document Cancelled",!! S %=$$DIR^ACHS("Y","Do You Want To Print It Anyway","NO","Enter 'YES' to print this CALCELLED document","",2) G END:$D(DTOUT),PAT:$D(DUOUT),PAT:'%
P4 ;
 ;
 I '$O(^ACHSDEN(DUZ(2),"D",ACHSA,200,0)),'$O(^ACHSDEN(DUZ(2),"D",ACHSA,210,0)) G CPY
 S %=$$DIR^ACHS("Y","Print For Specific Vendor","NO","Enter 'NO' to print all Vendors, 'YES' to select the vendor","",2)
 I $D(DTOUT) D END Q
 G PAT:$D(DUOUT)
 I '% G CPY
 S ACHDP=0
 W !
P5 ;
 S ACHDP=ACHDP+1
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,100)) W *7,!,"NO PRIMARY PROVIDER FOR THIS DENIAL" G P6
 ;
 I $$DN^ACHS(100,1)="Y" S ACHDPROV(ACHDP)=$P($G(^AUTTVNDR($$DN^ACHS(100,2),0)),U)_"^Y^"_$$DN^ACHS(100,2) G P5A
 S ACHDPROV(ACHDP)=$$DN^ACHS(100,3)_"^N"
P5A ;
 W !,ACHDP,".   ",$P(ACHDPROV(ACHDP),U)
 S ACHDX=0,ACHDP=ACHDP+1
P6 ;
 S X=0 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ WAS NOT DISPLAYING VND IN P7
 G P7:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,200))
 S ACHDX=$O(^ACHSDEN(DUZ(2),"D",ACHSA,200,ACHDX))
 G P6:ACHDX=0
 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ X IS NOW SET IN P6+1
 ;I +ACHDX=0 S X=0 G P7 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ
 G P7:+ACHDX=0 ;ACHS*3.1*6 3.27.03 IHS/SET/FCJ
 S ACHDPROV(ACHDP)=$P($G(^AUTTVNDR($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,200,ACHDX,0)),U),0)),U)_"^Y^"_$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,200,ACHDX,0)),U)
 W !,ACHDP,".   ",$P(ACHDPROV(ACHDP),U)
 S ACHDP=ACHDP+1
 G P6
 ;
P7 ;
 S X=$O(^ACHSDEN(DUZ(2),"D",ACHSA,210,X))
 I X=""&(ACHDP<2) W "NO SECONDARY PROVIDERS FOR THIS DENIAL",! G P8
 I (X="")!(+X=0) G P8
 S ACHDPROV(ACHDP)=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,210,X,0)),U)_"^N^"_X
 W !,ACHDP,".   ",$P(ACHDPROV(ACHDP),U)
 S ACHDP=ACHDP+1
 G P7
 ;
P8 ;
 S %=$$DIR^ACHS("N^1:"_(ACHDP-1),"PROVIDER TO PRINT LETTERS FOR","","Enter the number of the VENDOR from the list above..","",2)
 I $D(DTOUT) D END Q
 G PAT:$D(DUOUT)
 S ACHDPROZ=ACHDPROV(%)
 G CPY
 ;
BDT ; --- Input begin date
 K ACHDBDT,ACHDEDT
 S ACHDBDT=$$DATE^ACHS("B","DENIAL LTRS/FACE SHEET")
 I ACHDBDT<1 K ACHDBDT G SEL
 ;
EDT ; --- Input end date
 S ACHDEDT=$$DATE^ACHS("E","DENIAL LTRS/FACE SHEET")
 G:ACHDEDT<1 BDT
 I $$EBB^ACHS(ACHDBDT,ACHDEDT) G BDT
 ;
CPY ; --- Set default number of copies
 S (ACHDCPAT,ACHDCFAC,ACHDCVEN)=0
 F %=3:1:5 S ACHD("CPY",%)=+$P($G(^ACHSDENR(DUZ(2),0)),U,%)
 ;
 ;4/5/02  pmf  add choice and default for office copies
 S ACHD("CPY",8)=+$P($G(^ACHSDENR(DUZ(2),0)),U,8)  ; ACHS*3.1*4
 ;
C1 ;
 I $D(ACHDPROZ) G SEL:$D(DUOUT),C2
 S ACHDCPAT=$$DIR^ACHS("N^0:10:0","How many LETTERS for the patient? ",ACHD("CPY",3),"","^D Q1^ACHSDNL",2)
 G SEL:$D(DUOUT)
 I $D(DTOUT) D END Q
C2 ;
 S ACHDCVEN=$$DIR^ACHS("N^0:10:0","How many LETTERS for EACH vendor? ",ACHD("CPY",4),"","^D Q1^ACHSDNL",2)
 G C1:$D(DUOUT)
 I $D(DTOUT) D END Q
 ;
C2B ;
 ;ACHS*3.1*4  4/5/02  pmf  add choice and default for office copies.  whole tag new
 ;
 S ACHDCOFF=$$DIR^ACHS("N^0:10:0","How many OFFICE COPIES?           ",ACHD("CPY",8),"","^D Q1^ACHSDNL",2)
 G C2:$D(DUOUT)
 I $D(DTOUT) D END Q
 ;
C3 ;
 S ACHDCFAC=$$DIR^ACHS("N^0:10:0","How many copies of the FACT SHEET? ",ACHD("CPY",5),"","",2)
 ;4/5/02  pmf  add choice and default for office copies
 ;G C2:$D(DUOUT)  ; ACHS*3.1*4
 G C2B:$D(DUOUT)  ; ACHS*3.1*4
 ;
 I $D(DTOUT) D END Q
 S:'$D(ACHDBDT) (ACHDBDT,ACHDEDT)=0
 S:'$D(ACHSA) ACHSA=0
 ;
DEV ; --- Select print device
 W !!
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D HOME^%ZIS D END Q
 G:'$D(IO("Q")) ^ACHSDNL1
 K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 S ZTRTN="START^ACHSDNL1",ZTDESC="CHS Denial Letters and Fact Sheets"
 ;
 ;ACHS*3.1*4  4/5/02  pmf  add choice and default for office copies
 ;F %="ACHDBDT","ACHSA","ACHDEDT","ACHDCPAT","ACHDCFAC","ACHDCVEN" S ZTSAVE(%)=""  ; ACHS*3.1*4
 ;F %="ACHDBDT","ACHSA","ACHDEDT","ACHDCPAT","ACHDCFAC","ACHDCVEN","ACHSDCOFF" S ZTSAVE(%)=""  ;  ACHS*3.1*4
 ;
 F %="ACHDBDT","ACHSA","ACHDEDT","ACHDCPAT","ACHDCFAC","ACHDCVEN","ACHDCOFF" S ZTSAVE(%)=""  ;  ACHS*3.1*5 12/06/2002
 ;
 ;
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
 ;
END ;EP
 D ^%ZISC
 ;
 ;ACHS*3.1*4  04/05/02  pmf  add ACHDCOFF
 ;K ACHD,ACHDCFAC,ACHDCPAT,ACHDCVEN,ACHSA,ACHDP,ACHDPROZ,ACHSBPNO  ;  ACHS*3.1*4
 K ACHD,ACHDCFAC,ACHDCOFF,ACHDCPAT,ACHDCVEN,ACHSA,ACHDP,ACHDPROZ,ACHSBPNO  ;  ACHS*3.1*4
 K DTOUT,DUOUT,DIW,DIWL,DIWR,DIWT,ZTSK
 Q
 ;
Q1 ;EP - From DIR.
 W !!,"You may print any number of letters from 0 to 10.",!!
 Q
 ;
QSEL ;EP - From DIR.
 W !!?20,"1) Print individual ltrs & fact sheet",!!?20,"2) Print range by Issue Date"
 Q
 ;
NAMERR ;
 W !!,*7,"No valid PATIENT NAME in this file.",!,"No letter may be printed until a valid patient is entered.",!!
 G PAT
 ;
