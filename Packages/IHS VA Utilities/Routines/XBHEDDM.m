XBHEDDM ;402,DJB,10/23/91,EDD - Menu Driver
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus ME
EN ;Entry Point
 D HD
 I FLAGP F I=1,8,2,9,3,10,4,11,5,12,6,13,7 S X=$T(OPT+I) Q:X=""  W @$S(I<8:"!?7",1:"?41"),$S(I=5:"*",I=9:"*",I=12:"*",1:" "),$J(I,2)_")  ",$P(X,";",3)
 ;I FLAGP F I=1,6,11,2,7,12,3,8,13,4,9,5,10 S X=$T(OPT+I) Q:X=""  W @$S(I<6:"!",I<11:"?29",1:"?58"),$S(I=5:"*",I=9:"*",I=12:"*",1:" "),$J(I,2)_") ",$P(X,";",3) ;3 Columns
 E  F I=1,8,2,9,3,10,4,11,5,12,6,13,7 S X=$T(OPT+I) Q:X=""  W @$S(I<8:"!?7",1:"?41"),$J(I,2)_")  ",$P(X,";",3)
 ;E  F I=1,6,11,2,7,12,3,8,13,4,9,5,10 S X=$T(OPT+I) Q:X=""  W @$S(I<6:"!",I<11:"?29",1:"?58"),$J(I,2)_") ",$P(X,";",3) ;3 Columns
 W !
B R !?8,"Select OPTION: ",O:DTIME S:'$T O="^^" I "^"[O S FLAGM=1 G EX
 I O="^^" S FLAGE=1 G EX
 I O?1.N,O>0,O<14,$T(OPT+O)'="" G C
 I O'?1.N D ALLCAPS F I=1:1 S X=$P($T(OPT+I),";",5) Q:X=""  I $E(X,1,$L(O))=O W $E(X,$L(O)+1,80) S O=I G C
 W *7,?30,"Enter Option number or name." G B
C S X=$T(OPT+O) D @$P(X,";",4) I FLAGG S FLAGG=0 G B ;FLAGG indicates no Groups or no Pointers.
EX K I,X,Y,ZHDR Q
ALLCAPS ;
 F %=1:1:$L(O) S:$E(O,%)?1L O=$E(O,0,%-1)_$C($A(O,%)-32)_$E(O,%+1,999)
 Q
HD ;
 S ZHDR="M A I N   M E N U" W !?(IOM-$L(ZHDR)\2),ZHDR W:FLAGP ?57,"[*=Opts not printable]"
 W ! Q
OPT ;MENU OPTIONS
 ;;Cross References;XREF^XBHEDD6;CROSS REFERENCES
 ;;Pointers TO This File;PT^XBHEDD6;POINTERS
 ;;Pointers FROM This File;PT^XBHEDD10;POINTERS FROM THIS FILE
 ;;Groups;GRP^XBHEDD6;GROUPS
 ;;Trace a Field;EN^XBHEDD8;TRACE A FIELD
 ;;Individual Fld Summary;^XBHEDD3;INDIVIDUAL FIELD SUMMARY
 ;;Field Global Location;EN^XBHEDD1;FIELD GLOBAL LOCATION
 ;;Templates;EN^XBHEDD11;TEMPLATES
 ;;File Description;DES^XBHEDD11;FILE DESCRIPTION
 ;;Globals in ASCII Order;GL^XBHEDD10;LIST GLOBALS IN ASCII ORDER
 ;;File Characteristics;CHAR^XBHEDD12;FILE CHARACTERISTICS
 ;;Printing-On/Off;PRINTM^XBHEDD7;PRINTING - ON/OFF
 ;;Help;^XBHEDDH1;HELP
