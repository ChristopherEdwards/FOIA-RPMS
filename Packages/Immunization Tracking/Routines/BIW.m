BIW ;IHS/CMI/MWR - WRITE LINES TO ^TMP.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  WRITE LINES TO ^TMP AND VALMHDR FOR LISTMAN DISPLAYS & REPORTS.
 ;
 ;
 ;----------
WH(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write a Header line to the VALMHDR array (Listman Header).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# in the Header array.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 S:$G(BIVAL)="" BIVAL=" "
 S BILINE=BILINE+1,VALMHDR(BILINE)=BIVAL
 ;
 ;---> Write as many blank line after as specified by parameter 3.
 N I F I=1:1:+$G(BIBLNK) S BILINE=BILINE+1,VALMHDR(BILINE)=" "
 Q
 ;
 ;
 ;----------
WL(BILINE,BINOD,BIVAL,BIBLNK,BIENT) ;EP
 ;---> Write a line to the ^TMP global for WP or Listman.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# in the WP ^TMP global.
 ;     2 - BINOD  (req) Node in ^TMP to store lines under.
 ;     3 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     4 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;     5 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 Q:$G(BINOD)=""
 S:'$G(BILINE) BILINE=0
 S:$G(BIVAL)="" BIVAL=" "
 ;
 S BILINE=BILINE+1
 S ^TMP(BINOD,$J,BILINE,0)=BIVAL
 S:$G(BIENT) ^TMP(BINOD,$J,"IDX",BILINE,BIENT)=""
 ;
 ;---> Write as many blank lines after as specified by parameter 4.
 N I F I=1:1:+$G(BIBLNK) D
 .S BILINE=BILINE+1,^TMP(BINOD,$J,BILINE,0)=" "
 .S:$G(BIENT) ^TMP(BINOD,$J,"IDX",BILINE,BIENT)=""
 Q
 ;
 ;
 ;;*** BELOW IS A STANDARD "WRITE" CALL THAT CAN BE PASTED INTO
 ;;*** A ROUTINE FOR MULTIPLE CALLS FROM THAT ROUTINE TO THE ABOVE
 ;;*** SUBROUTINE. NOTE: THE NODE PASSED MUST BE EDITED AS APPROPRIATE.
 ;----------
WRITE(BILINE,BIVAL,BIBLNK,BIENT) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;     4 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPA1",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
MARK(BILINE,BILNS,BINODE) ;EP
 ;---> Mark the top line of a record (or node in a Listman TMP global
 ;---> with the number of lines in that record.
 ;---> This utility enables one to avoid splitting records with
 ;---> formfeeds when printing.
 ;---> The number of lines in a record is stored by appending a number
 ;---> of $C(30)'s equal to the number of lines, delimited by $C(31).
 ;---> Note that $(30) and $C(31) are not visible characters on screen.
 ;---> This code is picked up by line label PRTLST, just below,
 ;---> when printing a Listman TMP global.
 ;---> Parameters:
 ;     1 - BILINE (ret) Top line of the record to be marked.
 ;     2 - BILNS  (req) Number of lines in the record.
 ;     3 - BINODE (req) The node in ^TMP storing the text,
 ;                      e.g., "BIDULV" in  ^TMP("BIDULV",$J,BILINE,0).
 ;
 Q:'$G(BILINE)  Q:'$G(BILNS)  Q:$G(BINODE)=""
 N BI31 S BI31=$C(31)_$C(31)
 N BILNS1,I S BILNS1=""
 F I=1:1:BILNS S BILNS1=BILNS1_$C(30)
 S $P(^TMP(BINODE,$J,BILINE,0),BI31,2)=BILNS1
 Q
