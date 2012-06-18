BVCONV ; IHS/ITSC/JDH - interface to PCC conversion routine   [ 03/29/2002  4:14 PM ]
 ;;2.0;IHS V FILES 200 CONVERSION;;MAR 29, 2002
 ;
 W !!,"This routine can't be called from the top" D EXIT Q
 ;
EN ;EP
 N BVCPRCP,BVCABRT,BVCRUN,BVCONV,BVCRCNT,BVCNCNT,BVCFCNT,X,X1,D,BVCDFDC,BVCQ,DIR,DIC,Y
 D ^XUP ; get DUZ and system variables
 ; prr conversion checks
 I '$G(DUZ) W !,"Your DUZ must be defined." D EXIT Q  ; check to see if the conversion can be run
 I DUZ(0)'["@" W !,"You must have fileman programmer access to run this routine." D EXIT Q
 I $D(^BVCONV(1,"RUNNING")) D ABORT("5^The conversion is already running.") G EXIT ; make sure no runs twice at a time
 S BVCPRCP=0
 I '$D(^BVCHK(1,"OK")) D ABORT("6^Routine EN^BVCHK must run clean before procedding.") G EXIT ; make sure navigation and fields are ok
 I '$L($T(^BVCONV1)) D ABORT("0^The conversion appears to have been run.") G EXIT ; the conversion routine is automatically deleted when conversion of all files is complete.
 D ELEMLST(1) ; check all fields, targeted for conversion, for file 200 pointers
 S X=$G(^BVCONV1(BVCPRCP,"RUN TIMES")) ; run time node of conversion control file
 I 'X,$D(BVCONV(1,1)) D ABORT("1^Some conversion fields do not use file 200 datatypes.") G EXIT ;The conversion may have been run
 I $P(X,U,2) D ABORT("2^The conversion stop flag is recorded") G EXIT
 ; not yet converted or the software has been reloaded
 S BVCRUN=X
 S X1=$G(^BVCHK(1,"PCC CONV FLAG")) ; flag to indicate one time load (set by package post-init)
 I X1'=887700,'X D ABORT("3^no 1 time load flag and no start time recorded for the conversion.") G EXIT
 ; end pre-lim checks
 D SPLASH
 ;
PR ;EP get a default provider
 W !!,"In case a provider file pointer can not be resolved to a file "
 W "200 pointer, a default provider must determined for use."
 S DIC(0)="AEQ",D="AK.PROVIDER",DIC=200,DIC("A")="Please enter a default provider: "
 S DIC("S")="I '$P($G(^(""PS"")),U,4)" D IX^DIC G:Y<0 EXIT
 S BVCDFDC=+Y
 ;
 S BVCABRT=0
 I 'BVCPRCP D  G:BVCABRT EXIT
 .W !!,"Taskman must be shutdown during the conversion process"
 .D:'$$TASKCHK STOP^ZTMKU
 .I '$$TASKCHK W !!,"TASKMAN AND SERVERS ARE NOT SHUT DOWN." S BVCABRT=1 Q:BVCABRT
 .W !!,"Install PCC data dictionaries with file 200 pointers"
 .I 'BVCRUN D ^BVCINIT ; load PCC data dictionaries changed to file 200 pointers and clear conversion control global
 .; check to be sure fields targeted for conversion are defined as file 200 pointers. and build conversion elements table
 .D ELEMLST(0)
 .I $D(BVCONV(1,0)) D ABORT("4^Not all conversion fields point to file 200.") S BVCABRT=1
 ;
 S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you want to put this conversion "_$S(BVCPRCP:"check ",1:"")_" into a seperate process?"
 D ^DIR G:$D(DIRUT) EXIT S BVCQ=Y
 ;
 G EXIT:$$ZIS ;get device;
 ; save variables for the new job
 K ^BVCONV(1,"VARS")
 I BVCQ D  D HOME^%ZIS
 .F I="BVCPRCP","BVCDFDC","BVCQ","IOT","IOP","DUZ","DUZ(0)","IOPAR" S ^BVCONV(1,"VARS",I)=@I
 .S:$D(DUZ(2)) ^BVCONV(1,"VARS","DUZ(2)")=DUZ(2)
 ;
 ; run the conversion and complete
O W !!,"The conversion "_$S(BVCPRCP:"check ",1:"")_"process was "_$S('BVCRUN:"re",1:"")_" started at"_$$HTE^XLFDT($H)
 S ^BVCONV(1,"RUNNING")="" X:'BVCPRCP ^%ZOSF("NBRK") ; turn break off
 I 'BVCQ D
 .D EN^BVCONV1 ; run the conversion
 E  J EN^BVCONV1 ; IHS SAC exemption date 5/10/00
 X:BVCPRCP ^%ZOSF("BRK") ;turn break back on
 Q
 ;
TASKCHK() ; check if taskman and servers are down
 Q ('$D(^%ZTSCH("RUN"))&$D(^%ZTSCH("STOP")))
 ;
EXIT W !!,"EXITING" Q
 ;
XMD(BVCST,BVCCVTM) ;EP send a mail message of abort or completion
 N BVCONV,XMDUZ,XMTEXT,XMSUB,XMY,BVCNUMB
 S XMDUZ=.5,XMTEXT="BVCONV(",XMSUB="Notice of PCC 200 file conversion "_$S(BVCST=2:"check ",1:"")_$S(BVCST:"completion",1:"failure")
 S BVCONV(1)="The repointing of PCC data elements from file 6 to 200 "_$S(BVCST=1:"is complete",BVCST=2:"has been checked",1:"has aborted")_"."
 I BVCST D
 .S BVCONV(2)="",X=$G(^BVCONV1(BVCPRCP,"RUN TIMES"))
 .S BVCONV(3)="The conversion "_$S(BVCST=2:"check",1:"")_" started "_$$HTE^XLFDT($P(X,U))_" and completed "_$$HTE^XLFDT($P(X,U,2))
 .S BVCONV(3.1)=""
 .S BVCONV(3.2)="The compile "_$S(BVCST=2:"will take approximately ",1:"process took ")_BVCCVTM_" hours."
 .S BVCONV(4)=""
 .S BVCNUMB=90000
 .F I=5:1 S BVCNUMB=$O(^BVCONV1(BVCPRCP,BVCNUMB)) Q:'BVCNUMB  D
 ..S BVCONV(I)="",X=^BVCONV1(BVCPRCP,BVCNUMB)
 ..S BVCONV(I_.1)=$FN(+$P(X,U,4),",")_" pointers "_$S(BVCST=2:"will be",1:"were")_" repointed in the "_$P(^DIC(BVCNUMB,0),U)_" file, "
 ..S BVCONV(I_.2)=$FN(+$P(X,U,5),",")_" pointer fields "_$S(BVCST=2:"have",1:"had")_" no data to convert."
 ..S BVCONV(I_.3)=$FN(+$P(X,U,6),",")_" pointer fields "_$S(BVCST=2:"will be",1:"were")_" repointed to the chosen default provider "_$P(^VA(200,BVCDFDC,0),U)
 E  D
 .S BVCONV(1.1)="The error is recorded in the error trap and the FILE 200 CONVERSION ERROR file."
 .S BVCONV(1.2)="PLEASE CALL THE ITSC HELP DESK."
 S:$G(DUZ) XMY(DUZ)="" S XMY(.5)=""
 D ^XMD
 Q
ELEM ; conversion element records in the format
 ;    file number^file root^direct set (flag);field number;node;piece^..
 ;;9000001^AUPNPAT(^0;.14;0;14
 ;;9000007^AUPNFSE(^1;.06;0;6^1;.08;0;8
 ;;9000010.06^AUPNVPRV(^0;.01;0;1
 ;;9000010.08^AUPNVPRC(^0;.11;0;11^1;.12;0;12
 ;;9000010.09^AUPNVLAB(^1;.07;0;7^0;1202;12;2^1;1204;12;4
 ;;9000010.14^AUPNVMED(^1;1202;12;2^1;1204;12;4
 ;;9000010.15^AUPNVTRT(^1;.05;0;5
 ;;9000010.16^AUPNVPED(^1;.05;0;5
 ;;9000010.21^AUPNVDXP(^1;1202;12;2^1;1204;12;4
 ;;9000010.22^AUPNVRAD(^1;1202;12;2^1;1204;12;4
 ;;9000010.23^AUPNVHF(^1;.05;0;5
 ;;9000010.25^AUPNVMIC(^0;1202;12;2^1;1204;12;4
 ;;9000010.31^AUPNVBB(^0;1202;12;2^1;1204;12;4
 ;;END
 ;
FM(BVCNUMB,BVCFLD) ; function to determine whether fileman must be used
 ; must use fileman when field has cross references or an audit node not
 ; equal to n
 N X
 S X=$O(^DD(BVCNUMB,BVCFLD,1,0)) ; cross reference check
 I 'X S X=$G(^DD(BVCNUMB,BVCFLD,"AUDIT")) S:$L(X) X="ey"[X
 Q +X
 ;
ELEMLST(BVCFLG) ;EP get list of conversion elements 
 ; If BVCFLG=0 check to for file 200 pointers (an indication the 
 ;   conversion has been started or complete)
 ; If BVCFLG=1 build conversion table
 ;
 K BVCONV
 N BVCNUMB,BVCREC,BVCELM,BVCELMS,BVCFLD,BVCROOT
 S (BVCRCNT,BVCFCNT,BVCNCNT)=0
 F I=2:1 S BVCREC=$P($T(ELEM+I),";;",2) Q:BVCREC="END"  D
 .S BVCNUMB=+BVCREC,BVCELMS=""
 .F J=3:1 S BVCELM=$P(BVCREC,U,J) Q:'$L(BVCELM)  D
 ..S BVCFLD=$P(BVCELM,";",2),BVCFCNT=BVCFCNT+1 D  Q:'BVCFLG
 ...S BVCONV(1,$P(^DD(BVCNUMB,BVCFLD,0),U,3)="VA(200,",BVCNUMB,BVCFLD)="",BVCNCNT=BVCNCNT+1
 ..S $P(BVCELM,";")='$$FM(BVCNUMB,BVCFLD) S BVCELMS=BVCELMS_U_BVCELM ; tag FM may override direct set flag
 ..S BVCROOT=$P(BVCREC,U,2),BVCONV(BVCNUMB)=BVCROOT_BVCELMS,BVCRCNT=BVCRCNT+$P(@(U_BVCROOT_"0)"),U,4)
 Q
 ;
SPLASH ; splash screen message
 W !!,"This program will repoint field values, that currently point to file 6, to file",!,"200. and change targeted AUPN* file data dictionaries to file 200 versus 6"
 W !,"pointer datatypes. If a field value (provider pointer) can not be resolved to a",!,"corresponding file 200 entry, the default provider you supply will be used. "
 W !,"You have "_$FN(BVCRCNT,",")_" records to repoint, and this process will take between",!,"3 to 8 hours, depending on your system. It is imperative to permit this process"
 W !,"to complete. Please turn off journalling until you are notified the conversion",!,"is complete. A notification of completion will be sent to your's and the"
 W !,"postmaster's mailbox. Exceptions are recorded in the FILE 200 CONVERSION ERROR",!,"FILE file."
 W !!,"If you have any questions, please call the Help Desk desk",!
 Q
 ;
ZIS() ; get device variables
 N %ZIS S %ZIS="M" S:BVCQ %ZIS=%ZIS_"N" D ^%ZIS
 S:'POP IOP=ION_";"_IOM_";"_IOSL
 Q POP
 ;
ABORT(BVCFLG) ;
 N BVCNUMB,BVCFLD
 W !!,"The conversion of PCC data to file 200 pointers is being aborted."
 W:+BVCFLG<5 !,"The conversion appears to have been previously completed."
 W !,"Condition flag: "_$P(BVCFLG,U,2,99)
 I +BVCFLG=1!(+BVCFLG=4) D
 .F I=0:1:1 I $D(BVCONV(1,I)) D
 ..W !!,"The following fields are "_$S(I:"",1:"not ")_"defined to use file 200 datatypes.",!
 ..S (BVCNUMB,BVCFLD)=0
 ..F  S BVCNUMB=$O(BVCONV(1,I,BVCNUMB)) Q:'BVCNUMB  D
 ...F  S BVCFLD=$O(BVCONV(1,I,BVCNUMB,BVCFLD)) Q:'BVCFLD  D
 ....W !,"Field "_BVCFLD_" of file "_BVCNUMB_"."
 W !!,"If you need assistance, call the Help Desk."
 Q
 ;
 ;
DELETE ;EP delete conversion routine
 N BVCTMP,X,I
 F X="BVCONVT1","AUMCUTL","AUMCUTL1","AUMCUTL2","BVCENV","BVCINIS","BVCINIT" X ^%ZOSF("DEL") ; delete conversion routines  ;TASSC/MFD removed "BVCONV1", because generated NOROUTINE error with Cache, but added BVCONVT1 
 F I=1:1:5 S X="BVCINIT"_I X ^%ZOSF("DEL")  ;TASSC/MFD added T to BVCINI
 F I=1:1:9 S X="BVCIN00"_I X ^%ZOSF("DEL")  ;TASSC/MFD added N to BVCI00
 F I=65:1:77 S X="BVCIN00"_$C(I) X ^%ZOSF("DEL")  ;TASSC/MFD added N to BVCI00, changed 76 to 77 to catch M routine
 Q
 ;
RESTRT ;EP; call here to restart the conversion
 W !!,"*** RESTART OF THE PCC CONVERSION ***",!!
 N POP S POP=0
 I $D(^BVCONV(1,"RUNNING")) D  Q:POP'=1
 .W !!,"The conversion may already be running.","Are you sure you wish to continue with a",!,"restart?"
 .N % S %=2 D YN^DICN S POP=%
 K ^BVCONV(1,"RUNNING")
 G EN
 Q
 ;
EXEC ;EP; call here to see whether the completion is complete    
 W !,"The conversion is "_$S($L($T(^BVCONV1)):"not",1:"")_" complete.",!
 Q
