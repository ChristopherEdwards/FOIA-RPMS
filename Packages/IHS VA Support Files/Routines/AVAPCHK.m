AVAPCHK ;IHS/ORDC/LJF - CLEAN UP FILES 3,6,16&200 ; [ 10/03/95  7:57 AM ]
 ;;93.2;VA SUPPORT FILES;;SEPT 18, 1995
 ;
 ;This routine checks the status of your User, Person, Provider, and 
 ;New Person files.  It attempts to correct links, if possible. Those
 ;links this routine cannot fix are listed in the ^AVA global.
 ;
 ;To Area Offices: Please run this on each machine with these 4 files.
 ;  1. Run ^XBCOUNT on files 3, 6, 16, and 200.
 ;  2. Make sure the 3rd piece of the zero nodes of ^DIC(3
 ;     and ^VA(200 are the same.  If not, set them to the larger
 ;     number.
 ;  3. Run EN^AVAPCHK. There is no user interface.  Then run
 ;     RESULTS^AVAPCHK which displays to the screen the results.
 ;  4. If it did not run clean, call the Help Desk.  I will
 ;     need to hand fix those errors.
 ;
 ;To Developers: Use this routine to check the status of the 4 files
 ;  before running your New Person conversions.  To do so, call 
 ;  EN^AVAPCHK then check for the existence of ^AVA("OK"). Abort the
 ;  conversion if it does not exist.
 ;
 Q  ;no direct entry to rtn
 ;
EN ;EP; called by A9AVA8
 D DT^DICRW
 K ^AVA(3),^AVA(16),^AVA("OK"),^AVA("NOT OK")
 S X="AVAP7" X ^%ZOSF("TEST")
 I '$T S ^AVA("NOT OK")="NEED AVA PATCH 7" Q
 I $P($G(^DD(200,53.5,1,1,0)),U,2)'="AIHS" S ^AVA("NOT OK")="AVA PATCH 7 NOT INSTALLED" Q
 D LOOP3,LOOP16,EXIT Q
 ;
 ;
LOOP200 ; loop thru new person for missing zero nodes
 S X=0 F  S X=$O(^VA(200,X)) Q:'X  I '$D(^VA(200,X,0)) W !,X
 Q
 ;
LOOP3 ; loop thru user file
 K AVA3,AVAPER
 S AVA3=0
 F  S AVA3=$O(^DIC(3,AVA3)) Q:AVA3'=+AVA3  D
 . I '$D(^DIC(3,AVA3,0)) D ERR1
 . I '$D(^VA(200,AVA3,0)) D ERR2
 . S AVAPER=$P(^DIC(3,AVA3,0),U,16) I AVAPER="" D ERR3 Q:AVAPER=""
 . I '$D(^DIC(16,AVAPER,0)) D ERR4
 . I $G(^DIC(16,AVAPER,"A3"))="" D ERR5
 . I $G(^DIC(16,AVAPER,"A3"))'=AVA3 D ERR6
 Q
 ;
 ;
LOOP16 ; loop thru person files
 K AVA3,AVA16
 S AVA16=0
 F  S AVA16=$O(^DIC(16,AVA16)) Q:AVA16'=+AVA16  D
 . I '$D(^DIC(16,AVA16,0)) D ERR7
 . S AVA3=$G(^DIC(16,AVA16,"A3")) I AVA3="" D ERR8 Q:AVA3=""
 . I '$D(^DIC(3,AVA3,0)) D ERR9 Q
 . I $P(^DIC(3,AVA3,0),U,16)="" D ERR10
 . I $P(^DIC(3,AVA3,0),U,16)'=AVA16 D ERR11
 . ;
 . I '$D(^DIC(6,AVA16,0)),$P($G(^DIC(6,AVA16,9999999)),U,9)]"" D ERR12
 . I $P($G(^DIC(6,AVA16,0)),U,4)]"",$P($G(^VA(200,AVA3,"PS")),U,5)="" D ERR13
 Q
 ;
EXIT ;
 I '$D(^AVA(3)),'$D(^AVA(16)) S ^AVA("OK")=$H
 K AVA3,AVAPER,AVA16,DIE,DA,DR,DIC Q
 ;
 ;
ERR1 ;1=USER ENTRY MISSING 0 NODE
 NEW X
 I '$D(^VA(200,AVA3,0)) D SETERR(3,AVA3,"NO ZERO NODE FOR USER AND NO CORRESPONDING FILE 200 ENTRY") Q
 I $D(^VA(200,AVA3,0)) D  Q
 . S ^DIC(3,AVA3,0)=$P(^VA(200,AVA3,0),U,1,2)
 . S $P(^DIC(3,AVA3,0),U,16)=$P(^VA(200,AVA3,0),U,16)
 . S X=$P(^DIC(3,AVA3,0),U) I X]"" D
 .. S ^DIC(3,"B",X,AVA3)=""
 . S X=$P(^DIC(3,AVA3,0),U,2) I X]"" D
 .. S ^DIC(3,"C",X,AVA3)=""
 Q
 ;
ERR2 ;2=USER ENTRY NOT HAVE MATCHING VA(200 ENTRY
 I $P(^DIC(3,AVA3,0),U)="" D ERR1 Q
 S DIC="^VA(200,",DLAYGO=200,DINUM=AVA3,X=$P(^DIC(3,AVA3,0),U)
 S DIC(0)="L",DIC("DR")=".02///"_$P(^DIC(3,AVA3,0),U,2)
 K DD,DO D FILE^DICN
 I '$D(^VA(200,AVA3,0)) D SETERR(3,AVA3,"NO COORESPONDING FILE 200 ENTRY FOR THIS USER")
 Q
 ;
ERR3 ;3=USER ENTRY HAS NO 16TH PIECE
 I $P($G(^VA(200,AVA3,0)),U,16)]"" D  Q
 . S AVAPER=$P(^VA(200,AVA3,0),U,16)
 . S $P(^DIC(3,AVA3,0),U,16)=AVAPER
 ;D SETERR(3,AVA3,"NO USER OR FILE 200 LINK TO PERSON FILE")
 Q
 ;
ERR4 ;4=USER ENTRY 16TH PIECE POINTS TO NON-EXISTING PERSON ENTRY
 I $D(^DIC(16,+$P(^VA(200,AVA3,0),U,16),0)) D  Q
 . S $P(^DIC(3,AVA3,0),U,16)=$P(^VA(200,AVA3,0),U,16)
 ;
 S $P(^DIC(3,AVA3,0),U,16)=""
 S DIE=3,DA=AVA3,DR=".01///"_$P(^DIC(3,AVA3,0),U) D ^DIE
 S DIE=200,DA=AVA3,DR="8980.16////"_$P(^DIC(3,AVA3,0),U,16) D ^DIE
 I '$D(^DIC(16,$P(^DIC(3,AVA3,0),U,16),0)) D SETERR(3,AVA3,"NO PERSON MATCHED TO USER ENTRY")
 Q
 ;
ERR5 ;5=USER ENTRY POINTS TO PERSON WITH NO A3 NODE
 S ^DIC(16,AVAPER,"A3")=AVA3
 Q
 ;
ERR6 ;6=USER ENTRY POINTS TO PERSON ENTRY WITH MISS-MATCHED A3 NODE
 D SETERR(3,AVA3,"MISMATCHED 'A3' NODE & USER LINK; PERSON #"_AVAPER)
 Q
 ;
ERR7 ;7=PERSON ENTRY HAS NO ZERO NODE
 NEW X
 S X=$G(^DIC(16,AVA16,"A3"))
 I X]"",$P($G(^VA(200,X,0)),U)]"" D  Q
 . S $P(^DIC(16,AVA16,0),U)=$P(^VA(200,X,0),U)
 . S ^DIC(16,"B",$P(^VA(200,X,0),U),AVA16)=""
 D SETERR(16,AVA16,"NO ZERO NODE FOR PERSON")
 Q
 ;
ERR8 ;8=PERSON ENTRY HAS NULL A3 NODE
 NEW X
 S X=$P(^DIC(16,AVA16,0),U,9)
 I X]"" S Y=$O(^VA(200,"SSN",X,0)) I Y]"" S (^DIC(16,AVA16,"A3"),AVA3)=Y
 I $G(^DIC(16,AVA16,"A3"))="" D SETERR(16,AVA16,"NULL OR NON-EXISTING A3 NODE")
 Q
 ;
ERR9 ;9=PERSON ENTRY A3 NODE POINTS TO NON-EXISITING USER ENTRY
 I $D(^VA(200,AVA3,0)) D  Q
 . D ERR1
 . S $P(^DIC(3,AVA3,0),U,16)=AVA16,$P(^VA(200,AVA3,0),U,16)=AVA16
 D SETERR(16,AVA16,"A3 POINTS TO NON-EXISTING USER ENTRY")
 Q
 ;
ERR10 ;10=PERSON ENTRY A3 NODE POINTS TO USER ENTRY WITH NULL 16TH PIECE
 I $P($G(^VA(200,AVA3,0)),U,16)'=AVA16 D SETERR(16,AVA16,"A3 POINTER NOT MATCHING FILE 200 OR 3") Q
 S $P(^DIC(3,AVA3,0),U,16)=AVA16
 S $P(^VA(200,AVA3,0),U,16)=AVA16
 Q
 ;
ERR11 ;11=PERSON ENTRY A3 NODE POINTS TO USER ENTRY WITH MISMATCHED 16TH
 NEW X
 S X=$P(^DIC(3,AVA3,0),U,16)
 I X,$G(^DIC(16,+X,"A3"))=AVA3 Q
 D SETERR(16,AVA16,"A3 NODE POINTS TO MISMATCHED USER ENTRY")
 Q
 ;
ERR12 ;12=PROVIDER ENTRY HAS NO ZERO NODE BUT HAS 99999999 NODE
 K ^DIC(6,"GIHS",$P(^DIC(6,AVA16,9999999),U,9),AVA16)
 K ^DIC(6,AVA16)
 S AVA200=$P($G(^DIC(16,AVA16,"A3")),U) ;ifn in file 200
 S AVACLS=$P($G(^VA(200,AVA200,"PS")),U,5) Q:AVACLS=""
 ;
 S DIE="^VA(200,",DA=AVA200,DR="53.5///@" D ^DIE
 S DR="53.5////"_AVACLS D ^DIE
 I '$D(^DIC(6,AVA16,0)) D SETERR(16,AVA16,"NO PROVIDER ZERO NODE")
 Q
 ;
ERR13 ;13=IF PROVIDER HAS PROVIDER CLASS BUT FILE 200 DOESN'T: FIX IT
 S DIE="^VA(200,",DA=AVA3,DR="53.5////"_$P(^DIC(6,AVA16,0),U,4) D ^DIE
 I $P(^VA(200,AVA3,"PS"),U,5)="" D SETERR(16,AVA16,"NO CLASS IN FILE 200")
 Q
 ;
 ;
SETERR(FILE,IEN,MSG) ; -- SUBRTN to set entry into error file
 I FILE=3 S ^AVA(3,IEN)=MSG Q
 S ^AVA(16,IEN)=MSG Q
 ;
RESULTS ;EP; called to display results of run
 D DT^DICRW,^XBCLS
 W !!,"RESULTS OF AVA CHECK OF FILES 3, 6, 16, & 200",!
 ;
 I $D(^AVA("OK")) D  Q
 . W !!,"ALL FILES OKAY!  READY FOR CONVERSION."
 . S %H=^AVA("OK") D YX^%DTC W !,"Check completed at ",Y D READ
 ;
 I $D(^AVA("NOT OK")) D  Q
 . W !!,"FILE CHECK NOT RUN!  ",^AVA("NOT OK") D READ
 ;
 F AVAF=3,16 D
 . I $O(^AVA(AVAF,0)) W !!,"ERRORS FROM FILE ",AVAF
 . S AVAX=0 F  S AVAX=$O(^AVA(AVAF,AVAX)) Q:'AVAX  D
 .. W !,"Entry #",AVAX,?15,^AVA(AVAF,AVAX)
 .. I $Y>20 D READ,^XBCLS
 ;
 K DIR,AVAF,AVAX Q
 ;
READ ;
 K DIR S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR Q
 ;
ADD1(AVAX) ;EP; called to add new person & user entries for person entry
 NEW AVA3,X
 S AVA3=$P(^VA(200,0),U,3)+1
 Q:$D(^VA(200,AVA3))  Q:$D(^DIC(3,AVA3))
 S $P(^VA(200,0),U,3)=AVA3,$P(^DIC(3,0),U,3)=AVA3
 ;
 S ^VA(200,AVA3,0)=$P(^DIC(16,AVAX,0),U) ;name
 S ^VA(200,"B",$P(^VA(200,AVA3,0),U),AVA3)="" ;name xref
 S $P(^VA(200,AVA3,0),U,16)=AVAX ;person pointer
 S X=$P(^DIC(16,AVAX,0),U,9) I X]"" D
 . S $P(^VA(200,AVA3,1),U,9)=X
 . S ^VA(200,"SSN",X,AVA3)=""
 ;
 S ^DIC(3,AVA3,0)=$P(^DIC(16,AVAX,0),U)
 S ^DIC(3,"B",$P(^DIC(3,AVA3,0),U),AVA3)=""
 S $P(^DIC(3,AVA3,0),U,16)=AVAX
 ;
 S ^DIC(16,AVAX,"A3")=AVA3
 Q
