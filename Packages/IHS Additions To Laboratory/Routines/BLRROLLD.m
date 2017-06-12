BLRROLLD ; IHS/OIT/MKK - Delete anything in ROLLOVER RUNNING field in File 69.9 ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS Laboratory;**1033**;NOV 01, 1997
 ;
 ; This routine was created to allow Laboratory personnel who do not have FileMan
 ; access the ability to clear the ROLLOVER RUNNING (#521) field in the
 ; LABORATORY SITE (#69.9) file.
 ;
EEP ; EP - Ersatz Entry
 D EEP^BLRGMENU
 Q
 ;
 ; Delete anything in Field 521 (ROLLOVER RUNNING) field in 69.9
PEP ; EP 
EP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S HEADER(1)="IHS RPMS Laboratory Module"
 S HEADER(2)="LABORATORY SITE (#69.9) File"
 S HEADER(3)=$$CJ^XLFSTR("ROLLOVER RUNNING (#521) field",IOM)
 D HEADERDT^BLRGMENU
 ;
 I $D(^XUSEC("LRSUPER",DUZ))<1 D  Q
 . S LINE1="*** User "_$P($G(^VA(200,DUZ,0)),"^")_" [DUZ:"_DUZ_"] ***"
 . S LINE2="*** does NOT have the LRSUPER Security Key. ***"
 . ;
 . S MAXLINE=$L(LINE1)
 . I $L(LINE2)>MAXLINE D
 .. S MAXLINE=$L(LINE2)
 .. S LINE1=$$LJ^XLFSTR("*** User "_$P($G(^VA(200,DUZ,0)),"^")_" [DUZ:"_DUZ_"]",MAXLINE-4)_" ***"
 . ;
 . W !,?14,$TR($J("",MAXLINE)," ","*"),!
 . W ?14,LINE1,!
 . W ?14,LINE2,!
 . W ?14,$$LJ^XLFSTR("*** ",MAXLINE-4)," ***",!
 . W ?14,$$LJ^XLFSTR("*** Routine Ends.",MAXLINE-4)," ***",!
 . W ?14,$TR($J("",MAXLINE)," ","*"),!
 . D PRESSKEY^BLRGMENU(9)
 ;
 S ROLLRUNF=$$GET1^DIQ(69.9,"1,",521)
 I ROLLRUNF="" D  Q
 . W ?4,"LABORATORY SITE (#69.9) file's ROLLOVER RUNNING (#521) field is Null.",!!
 . W ?4,"No need to delete anything.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 W ?4,"LABORATORY SITE (#69.9) file's ROLLOVER RUNNING (#521) field = ",ROLLRUNF,!
 ;
 W !,?4,"This routine will delete the ",ROLLRUNF," from the field.",!
 ;
 Q:$$YESDOIT("Are you certain you want to do this? ")="Q"
 ;
 Q:$$YESDOIT("Second Chance: Are you absolutely certain you want to do this? ")="Q"
 ;
 Q:$$YESDOIT("LAST CHANCE: Confirm you are certain you want to do this. ")="Q"
 ;
 S FDA(69.9,"1,",521)="@"
 K ERRS
 D FILE^DIE("K","FDA","ERRS")
 ;
 I $D(ERRS)>0 D  Q
 . W !,?4,"Errors trying to clear the ROLLOVER RUNNING field.",!
 . D ARRYDUMP("ERRS")
 . D PRESSKEY^BLRGMENU(4)
 ;
 W !,?14,"Deleting"
 F NUM=1:1:10 W "." H 1
 W !,?14,"Done."
 ;
 W !!,?4,"LABORATORY SITE (#69.9) file's ROLLOVER RUNNING (#521) field cleared."
 ;
 D PRESSKEY^BLRGMENU(14)
 Q
 ;
YESDOIT(MESSAGE) ; EP - YES/NO Call
 D ^XBFMK
 S DIR(0)="YAO"
 S DIR("A")=$J("",9)_MESSAGE
 S DIR("B")="NO"
 D ^DIR
 ;
 I +$G(Y)<1 D  Q "Q"
 . W !!,?14,"NO/Null/Invalid Entry.  Routine ends."
 . D PRESSKEY^BLRGMENU(19)
 ;
 W !
 Q "OK"
 ;
 ; "Dump" the array -- written because SAC does not
 ; allow use of Z routines.  ZW would have been better.
ARRYDUMP(ARRY) ; EP
  NEW STR1
 ;
 S STR1=$Q(@ARRY@(""))
 W !,?9,ARRY,!
 W ?14,STR1,"=",@STR1,!
 F  S STR1=$Q(@STR1)  Q:STR1=""  D
 . W ?14,STR1,"=",@STR1,!
 Q
 ;
TESTIT ; EP - Test of routine
 ; Force YES into the field
 S $P(^LAB(69.9,1,"RO"),"^",2)=1
 ;
 D EP^BLRROLLD
 Q
