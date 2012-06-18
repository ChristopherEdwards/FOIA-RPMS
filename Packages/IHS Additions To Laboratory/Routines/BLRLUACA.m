BLRLUACA ; IHS/OIT/MKK - IHS LRUPAC A, purge of old data ; [ 05/15/11  7:50 AM ]
 ;;5.2;LR;**1030**;NOV 01, 1997
 ;;
 ;; Purges old data from ^BLRLUPAC global.
 ;;
EP ; EP - Menu of Reports
 NEW LAB60IEN,L60DESC,LOOPER,SPECTYPE,SPECNAME
 NEW HEADER,LINES,MAXLINES,PG,QFLG,HEDONE
 NEW LRLDT,LRSDT,SELRAAAB,XTMPNODE
 NEW DIRTRICK,ENDMSG
 NEW BLRMMENU,BLRVERN
 NEW DATETIME,PURGESTR
 NEW ARR,CNT,COL,DASHER,DTT,EXTDTT,LRAADESC,OUTARRAY
 NEW SELLRAA,SELSTR,SORTVAR,START,STOP,STR,VARIOUS,WIDE,WOT
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S (DTT,CNT,COL,WIDE)=0,ARR=1,SELSTR=""
 D SETARRAY^BLRLUAC2
 ;
 D OUTHEAD
 ;
 I $D(WOT)<1 D  Q 0
 . D HEADERDT^BLRGMENU
 . W !,?4,"No Compiled Data exists.",!
 . D PRESSKEY^BLRGMENU(9)
 . S DATETIME=0
 ;
 S DATETIME=-1,ATLEAST1=0
 F  Q:DATETIME>-1  D
 . D HEADERDT^BLRGMENU
 . D ^XBFMK
 . S DIR(0)=SELSTR
 . S DIR("A")="Enter Response (1-"_$O(WOT(""),-1)_")"
 . S ARR=0,CNT=5
 . F  S ARR=$O(VARIOUS(ARR))  Q:ARR=""  D
 .. S DIR("L",CNT)=$G(VARIOUS(ARR))
 .. S CNT=CNT+1
 . S DIR("L",1)="Select one of the Date/Time Compilations below to be purged:"
 . S DIR("L",2)=""
 . S DIR("L",3)="            Compiled          Acc Area                Begin Date     End Date"
 . S DIR("L",4)="         -------------------  "_DASHER_"----------     ----------"
 . S DIR("L")=""
 . D ^DIR
 . ;
 . I +$G(DIRUT) S DATETIME=0  Q
 . S ATLEAST1=ATLEAST1+1
 . ;
 . S DATETIME=+$G(WOT(+$G(Y)))
 . S PURGESTR=$G(VARIOUS(+$G(Y)+1))
 . ;
 . K HEADER(2)
 . S HEADER(2)="Report Selected To Be Purged"
 . D PURGHEAD("The Date/Time Compilation below has been selected to be purged.")
 . D ^XBFMK
 . S DIR(0)="YAO"
 . S DIR("A")="Purge the above compilation? "
 . S DIR("B")="NO"
 . D ^DIR
 . I +$G(Y)'=1 D  Q
 .. W !!,?4,"NO Purge selected.  Routine Ends.",!
 .. D PRESSKEY^BLRGMENU(9)
 . ;
 . K ^BLRLUPAC(DATETIME)
 . K HEADER(2)
 . S HEADER(2)="Report Purged"
 . D PURGHEAD("The Date/Time Compilation below has been purged.")
 . ;
 . D PRESSKEY^BLRGMENU(14)
 ;
 I ATLEAST1<1 D
 . W !!,?4,"No/Invalid Selection.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q
 ;
OUTHEAD ; EP -- Reset HEADER array & Display
 K HEADER
 S HEADER(1)="Lab Accession and Test Counts"
 S HEADER(2)="Report To Be Purged Selection"
 ;
 Q
 ;
PURGHEAD(HEDSTR) ; EP - Purge Header
 D HEADERDT^BLRGMENU
 W !,HEDSTR,!!
 W "            Compiled          Acc Area                Begin Date     End Date",!
 W "         -------------------  "_DASHER_"----------     ----------",!
 W PURGESTR,!
 Q
