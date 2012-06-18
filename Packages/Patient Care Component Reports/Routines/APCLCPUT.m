APCLCPUT ; IHS/CMI/LAB - driver for chn report ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
NOTE ;ENTRY POINT
 W !!,"NOTE:  This report separates visits and time into individual staff member",!,"contacts.  If Staff Member A and Staff Member B participated on the same visit "
 W !,"for a patient and spent 20 minutes in that visit, that is displayed on this "
 W !,"report as a contact for each staff member."
 Q
NOTE2 ;ENTRY POINT
 W !!,"NOTE:  This report counts one visit regardless of the number of ",$P(^APCLACTG(APCLACTG,0),U)," staff ",!,"involved in that visit, and time represents total time reported regardless"
 W !,"of the number of staff reporting on a single PCC Encounter Form."
 Q
