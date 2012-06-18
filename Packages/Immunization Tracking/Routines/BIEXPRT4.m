BIEXPRT4 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: WRITE IMM HISTORIES OF PATIENTS
 ;;  STORED IN ^BITMP( TO SCREEN, HOST FILE, OR RETURN AS A STRING.
 ;;  PATCH 1: If string of patient data is too long, set error and quit.
 ;;           WRITE+72
 ;
 ;
 ;----------
WRITE(BIOUT,BIFMT,BIFLNM,BIPATH,BISTRING,BICSV) ;EP
 ;---> Write (export) data from ^BITMP( to Screen or to Host File.
 ;---> Parameters:
 ;     1 - BIOUT    (req) Export: 0=screen, 1=host file, 2=string
 ;     2 - BIFMT    (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     3 - BIFLNM   (opt) File name
 ;     4 - BIPATH   (opt) BI Path name for host files
 ;     5 - BISTRING (ret) Immunization History in "|"-delimited string
 ;     6 - BICSV    (opt) If BICSV=1 exported data to screen or host
 ;                        file will be Comma Separated Values; also
 ;                        first piece "I" for Imm or "S" for Skin Test
 ;                        will be removed.
 ;
 I '$D(^BITMP($J,2)) D  Q
 .I BIOUT=2 S BISTRING="NO RECORDS TO BE EXPORTED" Q
 .D ^%ZISC,IO^BIO("NO RECORDS TO BE EXPORTED.","!!?5")
 .D DIRZ^BIUTL3()
 ;
 N BIPOP S BIPOP=0
 ;
 ;---> Output to Screen.
 I 'BIOUT D  Q:BIPOP
 .D FULL^VALM1
 .N A S A="Turn on your screen capture now.  Data will follow..."
 .D IO^BIO(A,"!!?5")
 .D DIRZ^BIUTL3(.BIPOP) W !
 .I BIPOP D ^%ZISC,IO^BIO("NO RECORDS EXPORTED.","!?5"),DIRZ^BIUTL3()
 ;
 ;
 ;---> Use IO if output to either SCREEN or FILE (not STRING).
 U:BIOUT<2 IO
 N BICOUNT,I,N,M,P,Q,V
 S BICOUNT=0,BISTRING="",N=0,V=""""
 ;---> If format=1, ASCII, write field names in first record.
 I BIFMT=1&(BIOUT'=2) D  W !
 .F I=0:1 S N=$O(BIDE(N)) Q:'N  W:I "," W V,$P(^BIEXPDD(N,0),U),V
 ;
 S N=0
 F  S N=$O(^BITMP($J,2,N)) Q:'N  D
 .S M=0
 .F  S M=$O(^BITMP($J,2,N,M)) Q:'M  D
 ..;
 ..;---> Stop at this level subscript for HL7 format.
 ..I BIFMT=2 W ^BITMP($J,2,N,M),! S BICOUNT=BICOUNT+1 Q
 ..;
 ..S P=0
 ..F  S P=$O(^BITMP($J,2,N,M,P)) Q:'P  D
 ...S Q=0
 ...;---> Continue to this level subscript for ASCII and ImmS formats.
 ...F  S Q=$O(^BITMP($J,2,N,M,P,Q)) Q:'Q  D
 ....;
 ....N X
 ....S X=^BITMP($J,2,N,M,P,Q)
 ....;---> These additional nodes may be set in +170^BIEXPRT5
 ....;---> or in +182^BIEXPRT3.
 ....S:$D(^BITMP($J,2,N,M,P,Q,1)) X=X_^(1)
 ....S:$D(^BITMP($J,2,N,M,P,Q,2)) X=X_^(2)
 ....S:$D(^BITMP($J,2,N,M,P,Q,3)) X=X_^(3)
 ....S:$D(^BITMP($J,2,N,M,P,Q,4)) X=X_^(4)
 ....S:$D(^BITMP($J,2,N,M,P,Q,5)) X=X_^(5)
 ....S:$D(^BITMP($J,2,N,M,P,Q,6)) X=X_^(6)
 ....S:$D(^BITMP($J,2,N,M,P,Q,7)) X=X_^(7)
 ....;
 ....;---> If BICSV=1, translate to Comma Separated Values,
 ....;---> and remove first piece ("I" for Imm, "S" for Skin Test).
 ....I $G(BICSV)&(BIFMT=1) S X=$TR(X,"|",","),X=$P(X,",",2,99)
 ....;
 ....;---> If export is to a string; build string and quit.
 ....;
 ....;********** PATCH 1, v8.2.1, FEB 01,2008, IHS/CMI/MWR
 ....;---> If string of patient data is too long, set error and quit.
 ....;I BIOUT=2 S BISTRING=BISTRING_X_U Q
 ....I BIOUT=2 D  Q
 .....I ($L(BISTRING)+$L(X))>32760 D  Q
 ......S BISTRING="PATIENT HISTORY EXCEEDS MAXIMUM LENGTH"
 .....S BISTRING=BISTRING_X_U
 .....;**********
 ....;
 ....;---> Export is to host file or screen.
 ....W X,! S BICOUNT=BICOUNT+1
 ;
 I BIOUT=2 S BISTRING=$TR(BISTRING,"""","") Q
 D ^%ZISC
 I BIOUT D
 .N A S A="File "_BIPATH_BIFLNM_" saved to Host File Server."
 .D IO^BIO(A,"!!?5")
 D IO^BIO("Records exported: "_BICOUNT,"!!?5")
 D DIRZ^BIUTL3()
 Q
