ACHSYFYD ; IHS/ITSC/PMF - DELETE DOCUMENTS FOR SELECTED FY ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;IHS/ITSC/PMF  1/12/01  changed manipulation of DUZ array
 ;to something less objectionable
 ;
 ;
 ;;This routine will call XBGSAVE to save the global that contains   
 ;;the CHS documents, ^ACHSF(, for the CHS FACILITY file.
 ;;
 ;;You will then be prompted for which FY docs to delete.
 ;;
 ;;Then, it will $ORDER thru the document cross reference for EACH
 ;;facility in your CHS FACILITY file, and *_DELETE_* all P.O.'s for
 ;;the selected FY, if the date of the order is more than 3 years ago.
 ;;The selected FY will also be deleted from the CHS DATA CONTROL file.
 ;;
 ;;Deletion is necessary because it will be impossible to enter
 ;;documents for a FY if you have documents for a previous FY
 ;;that ends in the same digit.  This is because of the design
 ;;limitations of the software, i.e., using only the last digit
 ;;of the fiscal year.  Be not disturbed:  current fiscal
 ;;authority does not extend to 10 years, anyway.
 ;;
 ;;If you have any doubts, please call the developer at 505-248-4191
 ;;prior to running this utility.
 ;;###
 ;
START ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." Q
 I '$G(DUZ(2)) W !,"DUZ(2) UNDEFINED OR 0." Q
 ;
 D HELP("ACHSYFYD")
 Q:'$$DIR^XBDIR("E")
 D ^ACHSVAR
 N ACHSFY
FY ;
 S ACHSFY=$$FYSEL^ACHS
 Q:$D(DUOUT)!$D(DTOUT)!('ACHSFY)
 I ACHSCFY-ACHSFY<7 W *7,!,"Must be more than 6 Fiscal Years ago." Q:'$$DIR^XBDIR("E")  G FY
 ;
 D HELP("SAVE")
 N XBFLG
 S XBGL="ACHSF"  ;name of global (mandatory, all others optional)
 S XBMED="F"     ;media to which to save global (user asked, if not exist)
 S XBFN="ACHSF.SAV"  ;output file name, default "<ns><asufac>.<JulianDate>"
 S XBTLE="Save of CHS FACILITY file, ^ACHSF(, for deletion of FY "_ACHSFY_" documents"     ;comment for dump header (facility name is concatenated)
 S XBQ="N" ;Y/N, to place file in uucp q, default "Y"
 D ^XBGSAVE
 I XBFLG W !?5,"GLOBAL SAVE FAILED!!",!!,"Reason :  '",$G(XBFLG(1)),"'." Q
 D HELP("SAVEOK")
 ;
 Q:'$$DIR^XBDIR("E")
 D HELP("DEL")
 ;
 N ACHS,ACHSDUZ2,ACHSY,DA,DIK,FAC
 S ACHSCTR=0
 S ACHSY=$E(ACHSFY,4)
 S FAC=0
 ;
 F  S FAC=$O(^ACHSF("B",FAC)) Q:'FAC  S DA(1)=FAC,ACHS="1"_ACHSY_"00000" F  S ACHS=$O(^ACHSF(FAC,"D","B",ACHS)) Q:'($E(ACHS,2)=ACHSY)  S DA=$O(^(ACHS,0)) D
 . I DA,$D(^ACHSF(FAC,"D",DA,0)),$P(^(0),U,2)<(DT-30000) S DIK="^ACHSF("_DA(1)_",""D""," D ^DIK W "." S ACHSCTR=ACHSCTR+1
 .Q
 ;
 ;10/30/00 pmf  - at this point, the "ES" cross reference survives
 ;the kill being done by the loop just above here.  So we will clean
 ;them up now.
 S G="" F  S G=$O(^ACHSF("B",G)) Q:G=""  S G1="" F  S G1=$O(^ACHSF(G,"ES",G1)) Q:G1=""  S G2="" F  S G2=$O(^ACHSF(G,"ES",G1,G2)) Q:G2=""  I '$D(^ACHSF(G,"D",G2)) K ^ACHSF(G,"ES",G1,G2) W "."
 ;
 W !,ACHSCTR," FY ",ACHSFY," documents permanently deleted.",!
 ;
 W !,"Deleting FY ",ACHSFY," from the CHS DATA CONTROL FILE."
 D WAIT^DICD
 ;
 ;RE-INDEX THE FILE
 S DIK="^ACHS(9,"_DUZ(2)_",""FY"","
 S DA(1)=DUZ(2)
 S DA=ACHSFY
 D ^DIK
 ;
 Q
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
SAVE ;
 ;;Saving the CHS FACILITY file global, ^ACHSF(.
 ;;This could take 'awhile'.
 ;;Why don't you go for coffee.....
 ;;###
 ;
SAVEOK ;
 ;;Remember that if you have to restore the global, the cross references
 ;;on the entire file will not be there because XBGSAVE stops when the
 ;;first subscript is not a numeric.  So, use FileMan to re-cross
 ;;index the entire CHS FACILITY file, if you really have to restore the
 ;;global.
 ;;###
 ;
DEL ;
 ;10/30/00  PMF  remove this line, replace it with the next line - ;;OK.  Here we go with the deletions of FY 86 docs.
 ;;OK.  Here we go with the deletion
 ;;This could take awhile.
 ;;Have another cup of coffee.....
 ;;###
 ;
