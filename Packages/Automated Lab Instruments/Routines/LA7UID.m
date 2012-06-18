LA7UID ;DALOI/JMC - BUILD HL7 DOWNLOAD TO UI; 12/3/1997
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**17,57**;Sep 27, 1994
 Q
 ;
EN ;; This line tag is called from ^LADOWN when downloading
 ;  a load work list to the Auto Instrument.
 ;
 ; LRLL= IEN in 68.2 Load Worklist file, from field in 62.4
 ; LRINST= IEN IN 62.4 Auto Inst file
 ; LRAUTO= zero node of 62.4 entry
 ;
 S LA7INST=LRINST
 I '$G(LA7ADL) D BLDINST^LA7ADL1(LA7INST,LRLL)
 S LA76248=$P(^LAB(62.4,LA7INST,0),"^",8)
 I 'LA76248 D  Q
 . I '$D(ZTQUEUED) D
 . . W $C(7),!!,"You must have a MESSAGE CONFIGURATION defined in field 8 of"
 . . W !,"the AUTO INSTRUMENT file before downloading to this instrument!"
 . S XQAMSG="MESSAGE CONFIGURATION not defined in AUTO INSTRUMENT file for "_$P(LRAUTO,"^")
 . D ERROR
 . D EXIT
 ;
 I '$P(^LAHM(62.48,LA76248,0),"^",3) D  Q
 . I '$D(ZTQUEUED) D
 . . W $C(7),!!,"The STATUS field in the MESSAGE PARAMETER file must be "
 . . W !,"turned on before downloading to this instrument!"
 . S XQAMSG="STATUS field in the MESSAGE PARAMETER file not turned on for "_$P(LRAUTO,"^")
 . D ERROR
 . D EXIT
 ;
 S LA7MODE=$P(^LAHM(62.48,LA76248,0),"^",4)
 ;
 ;
CALL ; Call the routine specified in the PROCESS DOWNLOAD field
 ; in file 62.48
 X $G(^LAHM(62.48,LA76248,2))
 ;
 ;
EXIT ; Download for one whole load list is done
 I '$G(LA7ADL) K ^TMP("LA7-INST",$J),LA76248,LA7MODE
 Q
 ;
 ;
ERROR ; Send warning of error in Auto Instrument file configuration.
 ;
 S XQA("G.LAB MESSAGING")=""
 D SETUP^XQALERT
 Q
