XMZDOM4 ;(WASH ISC)/CAP - CONVERT MAILMAN HOST #'S TO IDCU ;5/21/90  13:35
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;1.0;
 W !!,"This procedure will convert your MailMan system to run across the Integrated",!,"Data Communications Utility (IDCU), which replaces VADATS.  It will also"
 W !,"reverse that process, loading a set of VADATS numbers that it has recorded,",!,"not those you had on line originally."
 W !!,"There are three basic parts to the conversion.",!!,"First the MailMan Host field in the Domain file (4.2) is converted to IDCU",!,"equivalents of the numbers that are filed there for use with VADATS."
 W !,"Then the appropriate scripts are loaded to replace your MINIENGINE and your",!,"AUSTIN entries in the Transmission Script file (4.6).  Your old scripts will",!,"be preserved in case you must go back to VADATS as OLDMINI and OLDAUSTIN."
 W !,"It is a good idea to run the 'P' option first and check the output before",!,"running the actual conversion.  It does checks that may make you want to",!,"do some things before the actual conversion."
0 W !!,"Enter 'P' for Pre-Conversion simulation of a conversion from VADATS to IDCU."
 W !,"Enter 'I' to convert current MailMan Host field entries to IDCU equivalents."
 W !,"Enter 'V' to enter VADATS numbers into the MailMan Host field."
 W !,"Keep this list at least until you are sure everything is running",!,"properly.  Good luck -- this will only take a few minutes !",!
 Q
