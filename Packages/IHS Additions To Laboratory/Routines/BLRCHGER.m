BLRCHGER ; IHS/OIT/MKK - CHANGE PROVIDER AND/OR LOCATION ERROR ROUTINES;  07/22/2005  8:05 AM ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;
 ; These subroutines were pulled from the BLRCHGPL routine because it
 ; became too large.
 ; 
 ; Failure -- Display arrays and set END Flag
BADSTUFF(LABEL) ; EP
 NEW MID,IMNOTE
 ; Setup NOTE string
 S MID=(IOM\2)-10
 S IMNOTE=$TR($J("",IOM)," ","*")
 S $E(IMNOTE,MID,MID+15)=" IMPORTANT NOTE "
 ;
 W !,IMNOTE,!
 W !,"Filing Failed at LABEL:",LABEL,!!
 W ?5,"LRDFN:",$G(LRDFN)
 W ?20," LRSS:",$G(LRSS)
 W ?35," LRAA:",$G(LRAA)
 W ?50,"LRIDT:",$G(LRIDT)
 W !
 W ?5,"  LRAD:",$G(LRAD)
 W ?20," LRAN:",$G(LRAN)
 W !
 W ?5,"    ON:",$G(ON)
 W ?20,"LRODT:",$G(LRODT)
 W ?35," LRSN:",$G(LRSN)
 W !
 ;
 D ARRYDUMP("ERRS")
 D ARRYDUMP("FDA")
 W !
 W !,IMNOTE,!!
 W "Program will now end",!!
 D BLRGPGR^BLRGMENU()
 S LREND=1                        ; Set END flag
 ;
 Q
 ;
 ; "Dump" the array -- written because SAC does not
 ; allow use of Z routines.  I wanted to use ZW.
ARRYDUMP(ARRY) ; EP
 NEW STR1
 ;
 S STR1=$Q(@ARRY@(""))
 W !,?5,ARRY,!
 W ?10,STR1,"=",@STR1,!
 F  S STR1=$Q(@STR1)  Q:STR1=""  D
 . W ?10,STR1,"=",@STR1,!
 Q
 ;
 ; Routine to display issue with IHS LAB TRANSACTION file not
 ; having the Accession Number being edited.  This should
 ; NEVER happen, but it will if users are trying to edit an
 ; order that is older than the retention days for the BLRTXLOG
 ; file.  This is NOT a fatal error.
BADJUJU(LABEL,BADACS,BADON) ; EP
 K STR
 S STR(1)=""
 S STR(2)=$TR($J("",65)," ","*")
 S STR(3)=""
 S STR(4)=$$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65)
 S STR(5)=""
 S STR(6)=$$CJ^XLFSTR(LABEL_" -- IHS LAB TRANSACTION LOG PROBLEM",65)
 S STR(7)=""
 S STR(8)=$$CJ^XLFSTR(">>> ACCESSION:"_BADACS_"     ORDER #:"_BADON_" <<<",65)
 S STR(9)=""
 S STR(10)=$$CJ^XLFSTR("Transaction NOT found.",65)
 S STR(11)=""
 S STR(12)=$G(STR(2))
 S STR(13)=""
 D BMES^XPDUTL(.STR)
 D BLRGPGR^BLRGMENU()
 Q
