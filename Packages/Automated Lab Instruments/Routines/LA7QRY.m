LA7QRY ;VA/DALOI/JMC - Lab HL7 Query Utility ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,69,1027**;NOV 01, 1997
 ;
 ; Reference to variable DIQUIET supported by DBIA #2098
 ; Reference to ^DPT("SSN") global supported by DBIA #10035
 ;
 Q
 ;
GCPR(LA7PTID,LA7SDT,LA7EDT,LA7SC,LA7SPEC,LA7ERR,LA7DEST,LA7HL7) ; Entry point for Government Computerized Patient Record query
 ;
 ; Call with LA7PTID = patient identifier, either SSN or MPI/ICN
 ;                     if MPI/ICN then should be full ICN (10 digit
 ;                     number followed by "V" and six digit checksum)
 ;                     For example: 1000720100V271387 
 ;            LA7SDT = start date of query (FileMan D/T,time optional)
 ;            LA7EDT = end date of query (FileMan D/T, time optional)
 ;                     (FileMan D/T^type of date ("CD" or "RAD")
 ;                     Both start and end date values can pass a
 ;                     parameter in the second piece to indicate that 
 ;                     the date values are for specimen collection
 ;                     date/time (CD) or results available date (RAD)
 ;                     Example: LA7SDT="2991001.1239^CD"
 ;                              LA7EDT="2991002.0331^CD"
 ;                              LA7SDT="3010201^RAD"
 ;                              LA7EDT="3010201^RAD"
 ;
 ;             LA7SC = Array of search codes, either NLT or LOINC
 ;                     (code^coding system ("NLT" or "LN");
 ;                     Example: LA7SC(1)="89628.0000^NLT"
 ;                              LA7SC(2)="84330.0000^NLT"
 ;                              LA7SC(3)="84295.0000^NLT"
 ;                              LA7SC(4)="14749-6^LN"
 ;
 ;                   = The "*" (wildcard) for any code;
 ;                     Example: LA7SC="*"
 ;
 ;                   = A list of subscripts (separated by commas) from
 ;                     where the results will be extracted ("CH", "MI"
 ;                     or "SP").
 ;                     Example: LA7SC="CH,MI" (CH and MI results only)
 ;
 ;           LA7SPEC = array of specimen types using HL7 source table
 ;                     0070 or "*" (wildcard) for any code
 ;                     Currently specimen type only supported for CH
 ;                     and MI subscripted tests.
 ;                     Example: LA7SPEC="*"
 ;                                or
 ;                              LA7SPEC(1)="UR"
 ;                              LA7SPEC(2)="SER"
 ;                              LA7SPEC(3)="PLAS"
 ;
 ;           LA7DEST = closed root global reference to return search
 ;                     results (optional). If this parameter is
 ;                     omitted or equals an empty string, then node
 ;                     ^TMP("HLS",$J) is used.
 ;                     Example: LA7DEST=$NA(^TMP("ZZTMP",$J))
 ;
 ;            LA7HL7 = HL7 field separator and encoding characters (4)
 ;                     to use to encode results (optional).
 ;                     If undefined or incomplete (length<5) then
 ;                     field separator = "|" and encoding characters =
 ;                     "^\~&"
 ;
 ; Returns    LA7DEST = contains global reference of search results
 ;            in HL7 message structure, usually ^TMP("HLS",$J)
 ;
 ;            LA7ERR = array (by reference) containing any errors
 ;
 N DFN,DIQUIET,LA76248,LA7CODE,LA7PTYP,LA7QUIT,LA7SCSRC,LRDFN,LRIDT,LRSS,LRSSLST,TMP
 ;
 D CLEANUP
 S U="^",DT=$$DT^XLFDT,DTIME=$$DTIME^XUP($G(DUZ))
 S GBL=$S($G(LA7DEST)'="":LA7DEST,1:"^TMP(""HLS"","_$J_")")
 K LA7ERR
 ; Prevent FileMan from issuing any unwanted WRITE(s).
 S DIQUIET=1
 ; Currently not using file #62.48 for configuration information.
 S LA76248=0
 ;
 ; Identify patient, quit if error
 D PATID^LA7QRY2
 I $D(LA7ERR)  Q ""
 ;
 ; Resolve search codes to lab datanames
 S LA7SCSRC=$G(LA7SC)
 S TMP=$$SCLIST^LA7QRY2(LA7SCSRC)
 Q:$D(LA7ERR) ""
 S LA7SC=TMP  D:LA7SC'="*" CHKSC^LA7QRY1
 ;
 ; Convert specimen codes to file #61 Topography entries
 S LA7SPEC=$G(LA7SPEC)
 I LA7SPEC'="*"  D SPEC^LA7QRY1
 ;
 ; Search by collection or results available date
 I $P(LA7SDT,"^",2)="" S $P(LA7SDT,"^",2)="CD"
 I $P(LA7SDT,"^",2)="RAD" D BRAD^LA7QRY2
 I $P(LA7SDT,"^",2)="CD" D BCD^LA7QRY2
 ;
 I '$D(^TMP("LA7-QRY",$J)) D
 . S LA7ERR(99)="No results found for requested parameters"
 . S GBL=""
 E  D BUILDMSG^LA7QRY1
 ;
 D CLEANUP  S LA7SC=LA7SCSRC
 ;
 Q GBL
 ;
 ;
CLEANUP ; Cleanup TMP nodes that are used.
 ;
 N I
 ;
 F I="LA7-61","LA7-DN","LA7-LN","LA7-NLT","LA7-QRY" K ^TMP(I,$J)
 D KVAR^LRX
 ;
 Q
