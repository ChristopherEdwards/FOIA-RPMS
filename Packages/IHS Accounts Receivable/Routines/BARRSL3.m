BARRSL3 ; IHS/SD/LSL - PICK A X-REF ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19,20**;OCT 26, 2005
 ;
 ;;1.8*19 7/11/10 ADD ADJ TYPE INQUIRY
 ;
START ;START
 K BARXVL2
 I $G(BARY("DT"))="A" D  Q
 .S BARXRF="AP"
 .S BARXVL1=BARY("DT",1)
 .S BARXVL2=BARY("DT",2)
 I $G(BARY("DT"))="V" D  Q
 .S BARXRF="AD"
 .S BARXVL1=BARY("DT",1)
 .S BARXVL2=BARY("DT",2)
 I $G(BARY("DT"))="X" D  Q
 .S BARXRF="AX"
 .S BARXVL1=$O(^ABMDTXST(DUZ(2),"B",(BARY("DT",1)-.1),0))
 .S BARXVL2=$O(^ABMDTXST(DUZ(2),"B",(BARY("DT",2)+.1),0))
 I $G(BARY("INS")) D  Q
 .S BARXRF="AJ"
 .S BARXVL1=BARY("INS")
 I $G(BARY("PAT")) D  Q
 .S BARXRF="D"
 .S BARXVL1=BARY("PAT")
 S BARXRF="B"
 S BARXVL1=0
 Q
ADJTYPE  ; EP  IHS/SD/PKD 1.8*20 from BARTRANS
 ; Select ADJ TYPES to SELECT 
 K BARY("ADJ TYP")
 K DIC,DIE,DR,DA,DIR
 S DIC=90052.02
 S DIC(0)="AEMQ"
 S DIC("S")="I "",3,4,13,14,15,16,19,20,21,22,25,""[("",""_$P(^(0),U,2)_"","")"
 W !
 S DIC("A")="You may select ADJUSTMENT TYPE: ALL// "
 F  D  Q:+Y<0
 . I $D(BARY("ADJ TYP")) S DIC("A")="   Select Another ADJUSTMENT TYPE: "
 . D ^DIC
 . Q:+Y<0
 . S BARY("ADJ TYP",+Y)=$P(Y,U,2)
 I '$D(BARY("ADJ TYP")) D
 . I $D(DUOUT) K BARY("SORT") Q
 . W "ALL"
 K DIC
 Q
 ;IHS/SD/SDR Below commented out in patch20 since it wasn't in Paula's routine
 ;leaving code just in case
 ;IHS/SD/AR 1.8*19 07/11/2010 ADJ TYPE INQ
 ;ASKATYPE ;GET ADJUSTMENT TYPES
 ;K DIC
 ;S DIC=90052.02
 ;S DIC(0)="AEZ"
 ;S DIC("A")="Enter ADJUSTMENT TYPE (Reason): "
 ;S DIC("S")="I "",3,4,13,14,15,16,19,20,21,22,25,""[("",""_$P(^(0),U,2)_"","")"
 ;S DIC("W")="I "",3,4,13,14,15,16,19,20,21,22,25,""[("",""_$P(^(0),U,2)_"","")"
 ;D ^DIC
 ;K DIC
 ;W:(Y<1)&'$D(DUOUT)&'$D(BARATYP) "ALL"
 ;Q:$D(DTOUT)!$D(DUOUT)!(Y<1)
 ;S BARATYP($P(Y,U,2))=$P(Y,U,1)_U_Y(0)
 ;G ASKATYPE
