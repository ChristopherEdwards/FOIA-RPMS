BLRHL7 ;cmi/anch/maw - Main Driver for incoming HL7 messages 12/3/1997 ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997
 ;
 ;;5.2;LAB MESSAGING;**17,27**;Sep 27, 1994
 ;this will be the GIS equivalent of LA7HL7
 ;This routine is not meant to be invoked by name
 QUIT
 ;This routine is called by the HL7 package V1.5 to process
 ;incoming HL7 messages.  Expected variables are those
 ;documented in the HL7 package documentation.  The line
 ;tag is called if it is entered into the PROCESSING ROUTINE
 ;field in the HL7 SEGMENT NAME file (771.3).  Each 'message
 ;type' is processed at the line tag of the same name.
 ;
ORU(HLDA) ;EP - Process incoming ORU
 N X,Y
 S LA7TYPE="HL7"
 S LA7MSH=$G(^INTHU(HLDA,3,1,0))
 I LA7MSH="" D REJECT("no MSH in 772") G EXIT
 S LA7FS=$E(LA7MSH,4)
 S LA7CFIG=""
 F LA7=3:1:6 S LA7CFIG=LA7CFIG_$P(LA7MSH,LA7FS,LA7)
 S LA7CFIG=$TR(LA7CFIG,"^")  ;cmi/maw 10/08/2007
 S X=LA7CFIG X ^%ZOSF("LPC")
 S LA76248=$O(^LAHM(62.48,"C",$E(LA7CFIG,1,27)_Y,0))
 I 'LA76248 D  GOTO EXIT
 . D CREATE^LA7LOG(1) D REJECT("no config in 62.48")
 I '$P($G(^LAHM(62.48,LA76248,0)),"^",3) D  GOTO EXIT
 . D CREATE^LA7LOG(3) D REJECT("config is inactive")
ORUPUT ;store incoming message in ^LAHM(62.49,
 S LA7DTIM=$$NOW^XLFDT
 ;create a new entry in the queue file
 L +^LAHM(62.49,0):99999 Q:'$T  ; Lock zeroth node of file.
 F X=$P(^LAHM(62.49,0),"^",3):1 Q:'$D(^LAHM(62.49,X))
 S LA76249=X
 L +^LAHM(62.49,LA76249):99999 I '$T L -^LAHM(62.49,0) Q  ; Lock entry in file 62.49.
 K DD,DO
 S DIC="^LAHM(62.49,",DIC(0)="LF"
 S DINUM=X
 S DIC("DR")="1////I;3////3;4////"_LA7DTIM_";.5////"_LA76248
 S DIC("DR")=DIC("DR")_";2////Q"
 DO FILE^DICN
 L -^LAHM(62.49,0) ; Release lock on zeroth node.
 ;convert field separators to up arrows so can store in fileman global
 I LA7FS'="^" S LA7MSH=$TR(LA7MSH,"^"," "),LA7MSH=$TR(LA7MSH,LA7FS,"^")
 S ^LAHM(62.49,LA76249,100)=LA7MSH ;each field in header is field in file
 ;move message from HL7 global to Lab global
 ;cmi/flag/maw modified to account for GIS Line Split 7/21/2004
 S LA71=0
 F LA7=0:0 S LA7=$O(^INTHU(HLDA,3,LA7)) Q:'LA7  D
 . S BLRSEG=$G(^INTHU(HLDA,3,LA7,0))
 . S BLRSEG=$TR(BLRSEG,$C(10))  ;cmi/anch/maw 8/15/2007 added due to UNILAB passing a $C(10) in at the beginning of each line
 . S BLRLEN=$L(BLRSEG)
 . I $E(BLRSEG,(BLRLEN-3),BLRLEN)="|CR|" D  Q
 .. I $L($G(BLRSEGF))>0 S BLRSEG=BLRSEGF_BLRSEG
 .. S LA71=LA71+1  ;number of records in multiple
 .. S ^LAHM(62.49,LA76249,150,LA71,0)=$S(BLRSEG="CR":" ",1:$P(BLRSEG,"|CR|",1))  ;3/3/2006 cmi/maw to make a null line have a blank line
 .. I $P($G(^LAHM(62.48,LA76248,0)),U,9)=10 S LA71=LA71+1  ;cmi/maw test for new LEDI filing 3/3/2010
 .. I $P($G(^LAHM(62.48,LA76248,0)),U,9)=10 S ^LAHM(62.49,LA76249,150,LA71,0)=""  ;test for new LEDI filing 3/3/2010
 .. S BLRSEGF=""
 . S BLRSEGF=BLRSEGF_BLRSEG
 S ^LAHM(62.49,LA76249,150,0)="^^"_LA71_"^"_LA71_"^"_DT
 L -^LAHM(62.49,LA76249) ; Release lock on entry in file 62.49 (used by LA7UIIN to know when message is complete).
 ;S HLSDATA(2)="MSA"_HLFS_"AA"_HLFS_HLMID ;HL7 returns this as ack
 ;
 I '$D(^LAHM(62.48,LA76248,1)) D CREATE^LA7LOG(5)
 I $D(^LAHM(62.48,LA76248,1)) X ^(1) ;run processing routine
 ;
EXIT K %,%H,%I,DIC,DINUM,DTOUT,DUOUT,LA7,LA71,LA76248,LA76249,LA7AR
 K LA7CFIG,LA7DTIM,LA7FS,LA7MSH,LA7TYPE,X,Y,BLRSEGF,BLRSEG
 QUIT  ;return control to HLCHK which will send MSA
 ;
REJECT(LA7AR) ;build a reject segment if the incoming message
 ;could not be processed.  After calling this line tag, the
 ;routine should quit and return control to HLCHK which will
 ;send the MSA to the sending system.  Setting HLSDATA(2)
 ;conforms to HL7 package rules for acknowledgements
 ;LA7AR is a free text string that is included in the reject
 ;message for debugging purposes.
 ;S HLSDATA(2)="MSA"_HLFS_"AR"_HLFS_HLMID_HLFS_LA7AR
 QUIT  ;quit REJECT
 ;
Z ;LA7HL7 ;DALISC/JRR - Main Driver for incoming HL7 message
