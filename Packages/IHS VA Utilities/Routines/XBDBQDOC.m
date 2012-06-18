XBDBQDOC ; IHS/ADC/GTH - DOUBLE QUEUING SHELL HANDLER DOCUMENTATION ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ;----------------------
 ;NOTES FOR PROGRAMMERS|
 ;----------------------
 ;
 ; %ZIS with "PQM" is called by XBDBQUE if '$D(XBIOP).
 ;
 ; The user will be asked to queue if queuing has not been
 ; selected.
 ;
 ; IO variables as necessary are automatically stored.
 ;
 ; XBxx variables are killed after loading into an XB array.
 ;
 ; XBDBQUE can be nested.
 ;
 ; The compute and print phases can call XBDBQUE individually
 ; (XBIOP is required).
 ;
 ; The appropriate %ZTSK node is killed.
 ;
 ;EX:
 ; S XBRC="C^AGTEST",XBRP="P^AGTEST",XBRX="END^AGTEST",XBNS="AG"
 ; D ^XBDBQUE ;handles foreground and tasking
 ; Q
 ;
 ; VARIABLES NEEDED FROM CALLING PROGRAM
 ;
 ;MANDATORY
 ;  EITHER XBRC-Compute Routine or XBRP-Print Routine.
 ;
 ;OPTIONAL
 ;  XBRC-Compute Routine.
 ;  XBRP-Print Routine.
 ;  XBRX-Exit Routine that cleans variables (HIGHLY SUGGESTED).
 ;  XBNS-name space of variables to auto load in
 ;       ZTSAVE("NS*")=""
 ;       ="DG;AUPN;PS;..." ; (will add '*'if missing).
 ;  XBNS("xxx")=""  -  ZTSAVE variable arrays where xxx is as
 ;      described for  ZTSAVE("xxxx")="".
 ;  XBFQ=1 Force Queing.
 ;  XBDTH=FM date time of computing/printing.
 ;  XBIOP=pre-selected printer device with constructed with
 ;       ION ; IOST ; IOSL ; IOM
 ;       (mandatory if the calling routine is a queued routine).
 ;  XBPAR= %ZIS("IOPAR") values for host file with XBIOP if
 ;         needed.
 ;
TEST ;
 ; TESTING CODE  the following  are KISS (keep it supper simple) test
 ; of double queing code including nesting.
 Q
 ;--------------------------------------------------------------------
TEST1 ; test of stacking a second call to XBDBQUE in the printing routine.
 S SD=1,DG=2
 S XBNS="SD;DG;AG;"
 S XBRP="PA^XBDBQDOC"
 D ^XBDBQUE
 KILL DG,JKL,SD
 Q
PA ;
 W !,"GOT HERE ON ONE",!
 X "ZW"
 S IOP=XB("IOP"),XBRP="PB^XBDBQDOC",XBNS("JKL")=""
 F I=1:1:10 S JKL(I)=I
 S XBIOP=XB("IOP")
 D ^XBDBQUE
 Q
PB ;
 W !,"GOT HERE ON TWO",!
 X "ZW"
 Q
TEST2 ; TEST FOR COMPUTING ONLY
 D DT^DICRW
 S XBRC="RC^XBDBQDOC"
 F XBI=1:1:20 KILL ^XBDBT(XBI)
 W !,"CREATES ^XBDBT(",!
 D ^XBDBQUE
 Q
RC S %H=$H D YX^%DTC F XBI=1:1:20 S ^PWDBT(XBI)=XBI_Y
 Q
