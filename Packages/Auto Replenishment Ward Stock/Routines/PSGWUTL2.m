PSGWUTL2 ;BIR/LDT-UTILITY ROUTINE FOR CLEANUP OF FILE 59.4 ;25 FEB 96 / 10:40AM
 ;;2.3; Automatic Replenishment/Ward Stock ;**14**;4 JAN 94
EN ; This routine will delete the data dictionary and the data from the
 ;subfile 59.41, PHARMACISTS field (#6) of the INPATIENT SITE file
 ;(#59.4).  This will cleanup the reference to the USER file (#3).
 W !,"This routine will delete the data dictionary and the data from the",!,"subfile 59.41, PHARMACISTS field (#6) of the INPATIENT SITE file",!,"(#59.4).  This will cleanup the reference to the USER file (#3).",!!
 S DIU=59.41,DIU(0)="DS" D EN^DIU2 K DIU
 W !,"DONE.",!!,"You can delete this routine now!"
 Q
