ACMHLP1 ; IHS/TUCSON/TMJ - Help routine for Directories ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;EP;ENTRY POINT
 D ^XBCLS
 D RES^ACMMENU
 W !!
 W "     " FOR A=1:1:75 W "*"
 W "               These Options are provided for the purpose of developing a",!
 W "               directory of resources (IHS, state, private, tribal etc.)",!
 W "               used for patients on a particular Register.",!
 W "                 --A Resource Directory is NOT required for a Register--",!
 W "     " FOR B=1:1:75 W "*"
 W !
EXIT ;
 K A,B
