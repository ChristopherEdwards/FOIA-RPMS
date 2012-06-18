BDGPRE1 ; IHS//ANMC/LJF - PIMS PREINIT ADDENDUM;  [ 05/12/2003  3:26 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ; Changes that must be made BEFORE running install
 ;11/5/2002 IHS/ITSC/WAR - created this small rtn to correct a problem
 ;   with the Institution field not being populated in ^DG(40.8 and
 ;   for outpatient only sites.
 ;4/15/2003 IHS/ITSC/WAR - added code to handle mulitiple facilities
 ;   and/or no facility pointer values (this was found to be a problem
 ;   with some sites that may have bogus or incomplete entries).
 N A,D
 S D=0,U="^"
 F  S D=$O(^DG(40.8,D)) Q:'D  D   ;Handles single & multi Div
 .S A=$P($G(^DG(40.8,D,0)),U,7)   ;Need Institution file pointer
 .I +A=0 D                        ;Invalid pointer
 ..S A=$P($G(^DG(40.8,D,0)),U,2)  ;use Facility pointer value
 ..I +A=0 D                       ;If no pointer value, set it to
 ...S A=29                        ;  UNDESIG UNSPEC Div and
 ...S $P(^DG(40.8,D,0),U,2)=A     ;  set Pc2 in Med Cntr Div file
 ..S $P(^DG(40.8,D,0),U,7)=A      ;stuff Instit pointer
 S DIK="^DG(40.8," D IXALL^DIK    ;Reindex all records
DG43CK ;
 ;3/11/2003 IHS/ITSC/WAR
 ;  This section checks the MAS PARAMETERS file (#43) to see if it
 ;  exists and corrects the file if necessary. A problem could arise
 ;  if the ^DG(43,1,0) node does not exist - see the line of code
 ;  Q:'$D(^DG(43,1,0), found in the ^BSDPARM routine.
 ;
 ;
 I $D(^DG(43)) D         ;If the global exists and
 .I '$D(^DG(43,1,0)) D   ;If this record does not exist,
 ..S ^DG(43,1,0)=1       ;create it
 .K ^DG(43,"B")          ;Kill off ALL "B" xref
 .S ^DG(43,"B",1,1)=""   ;Create the ONE and ONLY "B" xref and
 .S ^DG(43,0)="MAS PARAMETERS^43^1^1"      ;reset the zero node
 .;
 .;Now remove any remaining records - only ONE record for this file is
 .;allowed - NOTE: All "B" xref were removed earlier.
 .S A=1
 .F  S A=$O(^DG(43,A)) Q:A'>0  D
 ..K ^DG(43,A)
 Q
